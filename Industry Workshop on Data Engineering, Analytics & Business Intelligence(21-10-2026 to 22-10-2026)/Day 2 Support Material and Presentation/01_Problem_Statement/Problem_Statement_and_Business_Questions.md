# ClinicPulse: Hospital Appointment Performance
**Level:** Beginner | **Time:** 3–4 hours | **Data:** Fully synthetic

## Scenario
ClinicPulse Hospital needs a simple management dashboard. Reception, doctor rosters, patient records and billing live in separate files. The hospital wants to understand appointment volume, completion, cancellations and which departments are busiest.

## Student challenge
1. Load four Bronze CSV datasets (each has 6,200 records).
2. Inspect duplicates, missing statuses, inconsistent capitalization, broken doctor references and billing currency formatting.
3. Create Silver data by cleaning and joining using `patient_id`, `doctor_id`, and `appointment_id`.
4. Create Gold KPI summaries for Tableau.
5. Build ONE dashboard from the three editable examples. Explain two business recommendations.

## Business questions
- How many appointments were scheduled, completed, cancelled or no-show?
- What is the completion rate?
- How does appointment volume change by date?
- Which specializations are busiest?
- Optional: how much has been billed and how much is pending?

## Minimum deliverables
Three KPI cards, two charts, one status distribution, two actionable recommendations. SQL or Python may be used for ETL; Tableau is used for the final dashboard.

## Join guide
appointments.patient_id → patients.patient_id
appointments.doctor_id → doctors.doctor_id
billing.appointment_id → appointments.appointment_id

## Important
All records are invented. Each file has 6,200 rows. A deliberately duplicated appointment ID, one blank status and one invalid doctor ID are included. SQL scripts target **SQLite** mode, not every SQL dialect; other servers require syntax adjustments. SQL insertion scripts are split into 100-row batches to support online editors, but some editors impose execution-size/time limits. Use the provided SQLite database or Python path when those limits apply.
