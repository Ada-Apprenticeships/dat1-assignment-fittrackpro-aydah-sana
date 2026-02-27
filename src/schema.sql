.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS locations;

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone_number TEXT,
    email TEXT,
    opening_hours VARCHAR
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    phone_number TEXT,
    date_of_birth DATE CHECK (DATE(date_of_birth) IS NOT NULL),
    join_date DATE CHECK (DATE(join_date) IS NOT NULL),
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    phone_number TEXT,
    position TEXT NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE CHECK (DATE(hire_date) IS NOT NULL),
    location_id INTEGER NOT NULL,

    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE CHECK (DATE(purchase_date) IS NOT NULL),
    last_maintenance_date DATE CHECK (DATE(last_maintenance_date) IS NOT NULL),
    next_maintenance_date DATE CHECK (DATE(next_maintenance_date) IS NOT NULL),
    location_id INTEGER NOT NULL,

    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description VARCHAR,
    capacity INTEGER, 
    duration INTEGER,
    location_id INTEGER NOT NULL,
    
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    start_time DATETIME CHECK (DATETIME(start_time) IS NOT NULL),
    end_time DATETIME CHECK (DATETIME(end_time) IS NOT NULL),
    class_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,

    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    type TEXT  NOT NULL,
    start_date DATE CHECK (DATE(start_date) IS NOT NULL),
    end_date DATE CHECK (DATE(end_date) IS NOT NULL),
    status TEXT NOT NULL CHECK (status IN ('Active', 'Inactive')),
    member_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    check_in_time DATETIME CHECK (DATETIME(check_in_time)),
    check_out_time DATETIME CHECK (DATETIME(check_out_time)),
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    attendance_status TEXT NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,

    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    amount REAL NOT NULL CHECK (amount > 0),
    payment_date DATETIME CHECK (DATETIME(payment_date) IS NOT NULL),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type TEXT NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    member_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    session_date DATE CHECK (DATE(session_date) IS NOT NULL),
    start_time TIME CHECK (TIME(start_time) IS NOT NULL),
    end_time TIME CHECK (TIME(end_time) IS NOT NULL),
    notes VARCHAR,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    measurement_date DATE CHECK (DATE(measurement_date) IS NOT NULL),
    weight REAL NOT NULL CHECK (weight > 0),
    body_fat_percentage REAL NOT NULL CHECK (body_fat_percentage BETWEEN 0 AND 100),
    muscle_mass REAL NOT NULL CHECK (muscle_mass > 0),
    bmi REAL NOT NULL CHECK (bmi > 0),
    member_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    maintenance_date DATE CHECK (DATE(maintenance_date) IS NOT NULL),
    description VARCHAR,
    equipment_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,

    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);