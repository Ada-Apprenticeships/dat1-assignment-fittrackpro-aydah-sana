.open fittrackpro.db
.mode column

-- 6.1 
INSERT INTO attendance (
    member_id,
    location_id,
    check_in_time
)
VALUES (
    7,
    1,
    '2025-02-14 16:30:00'
);

-- 6.2 
SELECT
date(check_in_time) AS visit_date,
check_in_time,
check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time;

-- 6.3 
SELECT
CASE strftime('%w', check_in_time)
WHEN '0' THEN 'Sunday'
WHEN '1' THEN 'Monday'
WHEN '2' THEN 'Tuesday'
WHEN '3' THEN 'Wednesday'
WHEN '4' THEN 'Thursday' 
WHEN '5' THEN 'Friday'
WHEN '6' THEN 'Saturday' 
END AS day_of_week,
COUNT(*) AS visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC
LIMIT 1;

-- 6.4
-- Adjusts the totals by active days in order to compare the locations fairly
SELECT
l.name AS location_name,
ROUND(COUNT(a.attendance_id) * 1.0 /
COUNT(DISTINCT date(a.check_in_time)), 2) AS avg_daily_attendance
FROM locations l
LEFT JOIN attendance a
ON l.location_id = a.location_id 
GROUP BY l.location_id;
