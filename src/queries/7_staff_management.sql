.open fittrackpro.db
.mode column

-- 7.1 
SELECT
staff_id,
first_name,
last_name,
position AS role
FROM staff
ORDER BY 
position;

-- 7.2 
SELECT
s.staff_id AS trainer_id,
CONCAT(s.first_name, ' ', s.last_name) AS trainer_name,
COUNT(pts.session_id) AS session_count
FROM personal_training_sessions pts
JOIN staff s
ON pts.staff_id = s.staff_id
WHERE s.position = 'Trainer'
AND pts.session_date
BETWEEN '2025-01-20' 
AND date('2025-01-20', '+30 days')
GROUP BY s.staff_id
HAVING COUNT(pts.session_id) >= 1;
