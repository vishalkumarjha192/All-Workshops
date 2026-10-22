-- STEP 3: BRONZE -> SILVER -> GOLD (SQLite)
-- Run only AFTER loading all four Bronze tables.
DROP TABLE IF EXISTS silver_appointments;
CREATE TABLE silver_appointments AS
WITH normalized AS (
 SELECT TRIM(appointment_id) appointment_id, TRIM(patient_id) patient_id,
 TRIM(doctor_id) doctor_id, appointment_date,
 CASE WHEN LOWER(TRIM(status)) IN ('complete','completed') THEN 'Completed'
 WHEN LOWER(TRIM(status))='cancelled' THEN 'Cancelled'
 WHEN LOWER(TRIM(status)) IN ('no-show','no show') THEN 'No-show'
 ELSE NULL END status,
 ROW_NUMBER() OVER(PARTITION BY TRIM(appointment_id) ORDER BY rowid) rn
 FROM bronze_appointments
)
SELECT n.appointment_id,n.patient_id,n.doctor_id,n.appointment_date,n.status,
 d.specialization,p.city
FROM normalized n
JOIN bronze_doctors d ON n.doctor_id=d.doctor_id
JOIN bronze_patients p ON n.patient_id=p.patient_id
WHERE n.rn=1 AND n.status IS NOT NULL;
-- Silver billing: normalize currency characters and payment labels.
DROP TABLE IF EXISTS silver_billing;
CREATE TABLE silver_billing AS
SELECT b.bill_id,b.appointment_id,
 CAST(REPLACE(REPLACE(TRIM(b.amount),'₹',''),',','') AS REAL) amount,
 CASE WHEN LOWER(TRIM(b.payment_status))='paid' THEN 'Paid' ELSE 'Pending' END payment_status
FROM bronze_billing b JOIN silver_appointments a ON a.appointment_id=b.appointment_id
WHERE CAST(REPLACE(REPLACE(TRIM(b.amount),'₹',''),',','') AS REAL)>0;
-- GOLD 1: appointment summary
DROP TABLE IF EXISTS gold_summary;
CREATE TABLE gold_summary AS
SELECT COUNT(*) total_appointments,
 SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) completed,
 SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END) cancelled,
 SUM(CASE WHEN status='No-show' THEN 1 ELSE 0 END) no_shows,
 ROUND(100.0*SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0),1) completion_rate_pct
FROM silver_appointments;
-- GOLD 2: daily trend
DROP TABLE IF EXISTS gold_daily;
CREATE TABLE gold_daily AS SELECT appointment_date,COUNT(*) appointments,
 SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) completed
 FROM silver_appointments GROUP BY appointment_date;
-- GOLD 3: specialization comparison
DROP TABLE IF EXISTS gold_specialization;
CREATE TABLE gold_specialization AS SELECT specialization,COUNT(*) appointments,
 SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END) completed
 FROM silver_appointments GROUP BY specialization;
-- GOLD 4: billing summary (one row per appointment before joining, prevents fanout)
DROP TABLE IF EXISTS gold_billing;
CREATE TABLE gold_billing AS SELECT payment_status,COUNT(*) bills,SUM(amount) amount
 FROM silver_billing GROUP BY payment_status;
-- FINAL EXPORTS: use SELECT * FROM gold_summary / gold_daily / gold_specialization / gold_billing.
