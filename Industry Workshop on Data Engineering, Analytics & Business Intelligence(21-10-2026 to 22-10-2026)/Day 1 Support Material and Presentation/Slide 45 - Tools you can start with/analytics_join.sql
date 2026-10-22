-- ClinicPulse teaching example: run on the included SQLite database
SELECT d.specialization,
       COUNT(*) AS appointments,
       SUM(CASE WHEN a.status = 'completed' THEN 1 ELSE 0 END) AS completed
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.specialization
ORDER BY appointments DESC;
