
-- Day 6 Assignment: School Database
PRAGMA foreign_keys = ON;

-- 1. Create the students table
CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

-- 2. Create the courses table
CREATE TABLE courses (
    id INTEGER PRIMARY KEY,
    course_name TEXT NOT NULL,
    course_code TEXT NOT NULL UNIQUE
);

-- 3. Create the enrolments table
-- This join table connects students and courses.
CREATE TABLE enrolments (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade TEXT,

    FOREIGN KEY (student_id)
        REFERENCES students(id) ON DELETE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES courses(id) ON DELETE CASCADE,

    -- Prevent the same student enrolling twice
    -- on the same course.
    UNIQUE (student_id, course_id)
);

-- Insert at least 3 students
INSERT INTO students (id, name, email) VALUES
(1, 'Amina Otieno', 'amina@example.com'),
(2, 'Brian Kamau', 'brian@example.com'),
(3, 'Carol Wanjiku', 'carol@example.com');

-- Insert at least 3 courses
INSERT INTO courses (id, course_name, course_code) VALUES
(1, 'Web Development', 'WEB101'),
(2, 'Database Systems', 'DB102'),
(3, 'Computer Networks', 'NET103');

-- Insert at least 5 enrolments
INSERT INTO enrolments (student_id, course_id, grade) VALUES
(1, 1, 'A'),
(1, 2, 'B'),
(2, 1, 'B'),
(2, 3, 'A'),
(3, 2, 'A');

-- QUERY 1:
-- Find all courses taken by one student, using their name.
SELECT
    students.name AS student_name,
    courses.course_name,
    courses.course_code,
    enrolments.grade
FROM students
JOIN enrolments ON enrolments.student_id = students.id
JOIN courses ON courses.id = enrolments.course_id
WHERE students.name = 'Amina Otieno';

-- QUERY 2:
-- Find all students enrolled in one course.
SELECT
    courses.course_name,
    students.name AS student_name,
    students.email,
    enrolments.grade
FROM courses
JOIN enrolments ON enrolments.course_id = courses.id
JOIN students ON students.id = enrolments.student_id
WHERE courses.course_name = 'Web Development';

-- QUERY 3:
-- Count the students enrolled in each course.
-- LEFT JOIN includes courses with zero enrolments.
SELECT
    courses.course_name,
    COUNT(enrolments.student_id) AS student_count
FROM courses
LEFT JOIN enrolments ON enrolments.course_id = courses.id
GROUP BY courses.id, courses.course_name
ORDER BY courses.course_name;

-- QUERY 4:
-- Find students who have no enrolments.
SELECT
    students.id,
    students.name,
    students.email
FROM students
LEFT JOIN enrolments ON enrolments.student_id = students.id
WHERE enrolments.student_id IS NULL;

-- QUERY 5:
-- Update one enrolment's grade.
UPDATE enrolments
SET grade = 'A'
WHERE student_id = 1 AND course_id = 2;

-- Display the updated grade to verify the change.
SELECT
    students.name AS student_name,
    courses.course_name,
    enrolments.grade
FROM enrolments
JOIN students ON students.id = enrolments.student_id
JOIN courses ON courses.id = enrolments.course_id
WHERE enrolments.student_id = 1
  AND enrolments.course_id = 2;

-- Add an index to speed up searches for a student's enrolments.
CREATE INDEX idx_enrolments_student_id
ON enrolments(student_id);
