.open fittrackpro.db
.mode column

-- 4.1 
SELECT
c.class_id, 
c.name AS class_name,
CONCAT(s.first_name, ' ', s.last_name) AS instructor_name 
FROM class_schedule cs
JOIN classes c 
ON cs.class_id = c.class_id
JOIN staff s 
ON cs.staff_id = s.staff_id
GROUP BY c.class_id;

-- 4.2 
-- Calculates the remaining spots based on the current registrations
SELECT
c.class_id,
c.name,
cs.start_time,
cs.end_time,
(c.capacity - COUNT(ca.class_attendance_id)) AS available_spots
FROM class_schedule cs
JOIN classes c 
ON cs.class_id = c.class_id
LEFT JOIN class_attendance ca
ON cs.schedule_id = ca.schedule_id
WHERE date(cs.start_time) = '2025-02-01'
GROUP BY cs.schedule_id;

-- 4.3 
INSERT INTO class_attendance(
    schedule_id,
    member_id,
    attendance_status
    )
VALUES(1, 11, 'Registered');

-- 4.4 
DELETE FROM class_attendance
WHERE schedule_id = 7
AND member_id = 3;

-- 4.5 
SELECT 
    c.class_id,
    c.name AS class_name,
    COUNT(ca.class_attendance_id) AS registration_count
FROM class_attendance ca
JOIN class_schedule cs 
ON ca.schedule_id = cs.schedule_id
JOIN classes c 
ON cs.class_id = c.class_id
WHERE ca.attendance_status = 'Registered'
GROUP BY c.class_id
ORDER BY registration_count DESC
LIMIT 1;


-- 4.6 
-- Finds the average at the member level before doing the overall average calculation
SELECT
ROUND(AVG(class_count), 2) AS avg_classes_per_member
FROM (
    SELECT
    member_id,
    COUNT(*) AS class_count
    FROM class_attendance
    WHERE attendance_status IN ('Registered', 'Attended')
    GROUP BY member_id
);