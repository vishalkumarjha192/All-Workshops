-- STEP 1: Run first. SQLite-compatible SQL; use SQLite mode in an online editor.
CREATE TABLE bronze_doctors (doctor_id TEXT, doctor_name TEXT, specialization TEXT);
CREATE TABLE bronze_patients (patient_id TEXT, patient_name TEXT, age INTEGER, city TEXT);
CREATE TABLE bronze_appointments (appointment_id TEXT, patient_id TEXT, doctor_id TEXT, appointment_date TEXT, status TEXT);
CREATE TABLE bronze_billing (bill_id TEXT, appointment_id TEXT, amount TEXT, payment_status TEXT);
