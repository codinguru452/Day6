
# School Database Design

## 1. Tables

### Students

The students table stores information about each student.

- `id`: Primary key that uniquely identifies each student.
- `name`: Student's full name. It cannot be empty.
- `email`: Student's email address. It cannot be empty or duplicated.

### Courses

The courses table stores information about courses offered by the school.

- `id`: Primary key that uniquely identifies each course.
- `course_name`: Name of the course. It cannot be empty.
- `course_code`: Unique code assigned to each course.

### Enrolments

The enrolments table records which students take which courses and the grades they receive.

- `id`: Primary key that identifies each enrolment.
- `student_id`: Foreign key referencing `students.id`.
- `course_id`: Foreign key referencing `courses.id`.
- `grade`: Grade received by the student. It may be empty until a grade is assigned.

The combination of `student_id` and `course_id` is UNIQUE. This prevents a student from enrolling in the same course more than once.

## 2. Relationships

### One-to-many

One student can have many enrolment records, but each enrolment belongs to one student.

One course can also have many enrolment records, but each enrolment belongs to one course.

### Many-to-many

Students and courses have a many-to-many relationship. One student can take several courses, and one course can have several students.

The `enrolments` table acts as a join table between `students` and `courses`. It also stores the grade for each student-course combination.

Without the join table, it would be difficult to represent multiple courses per student and multiple students per course without repeating data or storing lists inside individual columns.

## 3. Index

I would add an index on `enrolments.student_id`.

```sql
CREATE INDEX idx_enrolments_student_id
ON enrolments(student_id);
```

This index helps the database find a student's enrolments faster, especially when the database contains many records. It uses extra storage and may slightly slow down changes to indexed data.

## 4. Choosing SQL or NoSQL

I would choose a relational SQL database such as SQLite, MySQL, or PostgreSQL for this school system. The data has a clear structure, and students and courses have a many-to-many relationship that is handled well by a join table. SQL supports foreign keys, unique constraints, joins, and queries that help maintain accurate records. NoSQL could also work, but a relational database is a natural fit for this system.
