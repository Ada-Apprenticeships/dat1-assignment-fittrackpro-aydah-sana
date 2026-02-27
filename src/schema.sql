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
    date_of_birth DATE CHECK (date_of_birth GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    join_date DATE CHECK (join_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
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
    hire_date DATE CHECK (hire_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    location_id INTEGER NOT NULL,

    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE CHECK (purchase_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    last_maintenance_date DATE CHECK (last_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    next_maintenance_date DATE CHECK (next_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
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
    start_time DATE TIME CHECK (start_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    end_time DATE TIME CHECK (end_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    class_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,

    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    type TEXT  NOT NULL,
    start_date DATE CHECK (start_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    end_date DATE CHECK (end_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'),
    status TEXT NOT NULL CHECK (status IN ('Active', 'Inactive')),
    member_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    check_in_time DATE TIME CHECK (check_in_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    check_out_time DATE TIME CHECK (check_out_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
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
    payment_date DATE TIME CHECK (payment_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type TEXT NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    member_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    session_date DATE CHECK (session_date GLOB '[0-9][0-9][0-9][0-9]-[0-2][0-9]-[0-9][0-9]'),
    start_time TIME CHECK (start_time GLOB '[0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    end_time TIME CHECK (end_time GLOB '[0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    notes VARCHAR,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    measurement_date DATE CHECK (measurement_date GLOB '[0-9][0-9][0-9][0-9]-[0-2][0-9]-[0-9][0-9]'),
    weight REAL NOT NULL CHECK (weight > 0),
    body_fat_percentage REAL NOT NULL CHECK (body_fat_percentage BETWEEN 0 AND 100),
    muscle_mass REAL NOT NULL CHECK (muscle_mass > 0),
    bmi REAL NOT NULL CHECK (bmi > 0),
    member_id INTEGER NOT NULL,

    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    maintenance_date DATE CHECK (maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-2][0-9]-[0-9][0-9]'),
    description VARCHAR,
    equipment_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,

    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);