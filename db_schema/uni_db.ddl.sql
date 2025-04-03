DROP SCHEMA public CASCADE;
CREATE SCHEMA public;


CREATE TABLE advisor
(
  id               varchar(20)    NOT NULL,
  faculty_short_id varchar(20) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE course
(
  course_id       varchar(20)     NOT NULL,
  title           varchar(256) NOT NULL,
  cradit          numeric      NOT NULL,
  dept_short_name varchar(20)   NOT NULL,
  need_cradit     numeric     ,
  amount          numeric      NOT NULL,
  PRIMARY KEY (course_id)
);

CREATE TABLE department
(
  dept_short_name varchar(20)  NOT NULL,
  long_name       varchar(256) NOT NULL,
  PRIMARY KEY (dept_short_name)
);

CREATE TABLE faculty
(
  faculty_short_id varchar(20)  NOT NULL UNIQUE,
  first_name       varchar(128) NOT NULL,
  last_name        varchar(128),
  dept_short_name  varchar(20)   NOT NULL,
  PRIMARY KEY (faculty_short_id)
);

CREATE TABLE prereq
(
  course_id varchar(20) NOT NULL,
  prereq_id varchar(20) NOT NULL,
  PRIMARY KEY (course_id)
);

CREATE TABLE room
(
  room_no  varchar(20)  NOT NULL,
  building varchar(256) NOT NULL,
  PRIMARY KEY (room_no)
);

CREATE TABLE section
(
  section_no int         NOT NULL,
  course_id  varchar(20)     NOT NULL,
  room_no    varchar(20) NOT NULL,
  capacity   int        ,
  day        varchar(20)  NOT NULL,
  start_time time        NOT NULL,
  end_time   time        NOT NULL,
  year       varchar(20)    NOT NULL,
  season     varchar(20) NOT NULL,
  PRIMARY KEY (section_no, course_id, year, season)
);

CREATE TABLE semester
(
  year   varchar(20)     NOT NULL,
  season varchar(20) NOT NULL,
  PRIMARY KEY (year, season)
);

CREATE TABLE student
(
  id              varchar(20)    NOT NULL UNIQUE,
  first_name      varchar(128) NOT NULL,
  last_name       varchar(128),
  mobile_no       varchar(20)  NOT NULL UNIQUE,
  email           varchar(128) NOT NULL UNIQUE,
  dept_short_name varchar(20)   NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE student_login
(
  password     varchar(512) DEFAULT 123456789,
  id           varchar(20)     NOT NULL,
  is_active    boolean      NOT NULL DEFAULT FALSE,
  is_dismissed boolean      NOT NULL DEFAULT FALSE,
  PRIMARY KEY (id)
);

CREATE TABLE student_token
(
  created_date date     NOT NULL,
  expired_date date     NOT NULL,
  id           varchar(20) NOT NULL,
  token        varchar(512) ,
  PRIMARY KEY (id)
);

CREATE TABLE takes
(
  id         varchar(20)    NOT NULL,
  grade      numeric    ,
  is_dropped boolean    ,
  section_no int         NOT NULL,
  course_id  varchar(20)     NOT NULL,
  year       varchar(20)     NOT NULL,
  season     varchar(16) NOT NULL,
  PRIMARY KEY (id, section_no, course_id, year, season)
);

CREATE TABLE teaches
(
  faculty_short_id varchar(20) NOT NULL,
  section_no       int         NOT NULL,
  course_id        varchar(20)    NOT NULL,
  year             varchar(20)    NOT NULL,
  season           varchar(20) NOT NULL,
  PRIMARY KEY (faculty_short_id, section_no, course_id, year, season)
);

CREATE TABLE timeslot
(
  day        varchar(20) NOT NULL,
  start_time time       NOT NULL,
  end_time   time       NOT NULL,
  PRIMARY KEY (day, start_time, end_time)
);

ALTER TABLE student_login
  ADD CONSTRAINT FK_student_TO_student_login
    FOREIGN KEY (id)
    REFERENCES student (id);

ALTER TABLE advisor
  ADD CONSTRAINT FK_student_TO_advisor
    FOREIGN KEY (id)
    REFERENCES student (id);

ALTER TABLE advisor
  ADD CONSTRAINT FK_faculty_TO_advisor
    FOREIGN KEY (faculty_short_id)
    REFERENCES faculty (faculty_short_id);

ALTER TABLE student
  ADD CONSTRAINT FK_department_TO_student
    FOREIGN KEY (dept_short_name)
    REFERENCES department (dept_short_name);

ALTER TABLE faculty
  ADD CONSTRAINT FK_department_TO_faculty
    FOREIGN KEY (dept_short_name)
    REFERENCES department (dept_short_name);

ALTER TABLE course
  ADD CONSTRAINT FK_department_TO_course
    FOREIGN KEY (dept_short_name)
    REFERENCES department (dept_short_name);

ALTER TABLE prereq
  ADD CONSTRAINT FK_course_TO_prereq
    FOREIGN KEY (course_id)
    REFERENCES course (course_id);

ALTER TABLE prereq
  ADD CONSTRAINT FK_course_TO_prereq1
    FOREIGN KEY (prereq_id)
    REFERENCES course (course_id);

ALTER TABLE section
  ADD CONSTRAINT FK_course_TO_section
    FOREIGN KEY (course_id)
    REFERENCES course (course_id);

ALTER TABLE section
  ADD CONSTRAINT FK_room_TO_section
    FOREIGN KEY (room_no)
    REFERENCES room (room_no);

ALTER TABLE section
  ADD CONSTRAINT FK_timeslot_TO_section
    FOREIGN KEY (day, start_time, end_time)
    REFERENCES timeslot (day, start_time, end_time);

ALTER TABLE takes
  ADD CONSTRAINT FK_student_TO_takes
    FOREIGN KEY (id)
    REFERENCES student (id);

ALTER TABLE teaches
  ADD CONSTRAINT FK_faculty_TO_teaches
    FOREIGN KEY (faculty_short_id)
    REFERENCES faculty (faculty_short_id);

ALTER TABLE section
  ADD CONSTRAINT FK_semester_TO_section
    FOREIGN KEY (year, season)
    REFERENCES semester (year, season);

ALTER TABLE takes
  ADD CONSTRAINT FK_section_TO_takes
    FOREIGN KEY (section_no, course_id, year, season)
    REFERENCES section (section_no, course_id, year, season);

ALTER TABLE teaches
  ADD CONSTRAINT FK_section_TO_teaches
    FOREIGN KEY (section_no, course_id, year, season)
    REFERENCES section (section_no, course_id, year, season);

ALTER TABLE student_token
  ADD CONSTRAINT FK_student_login_TO_student_token
    FOREIGN KEY (id)
    REFERENCES student_login (id);

-- Insert into department
INSERT INTO public.department (dept_short_name, long_name) VALUES ('CSE', 'Computer Science and Engineering');
INSERT INTO public.department (dept_short_name, long_name) VALUES ('EEE', 'Electrical and Electronic Engineering');
INSERT INTO public.department (dept_short_name, long_name) VALUES ('BBA', 'Business Administration');
INSERT INTO public.department (dept_short_name, long_name) VALUES ('MATH', 'Mathematics');

-- Insert into faculty
INSERT INTO public.faculty (faculty_short_id, first_name, last_name, dept_short_name) VALUES ('FAC001', 'John', 'Doe', 'CSE');
INSERT INTO public.faculty (faculty_short_id, first_name, last_name, dept_short_name) VALUES ('FAC002', 'Jane', 'Smith', 'EEE');
INSERT INTO public.faculty (faculty_short_id, first_name, last_name, dept_short_name) VALUES ('FAC003', 'Emily', 'Davis', 'BBA');
INSERT INTO public.faculty (faculty_short_id, first_name, last_name, dept_short_name) VALUES ('FAC004', 'Michael', 'Brown', 'MATH');

-- Insert into student
INSERT INTO public.student (id, first_name, last_name, mobile_no, email, dept_short_name) VALUES ('2023000000001', 'Alice', 'Johnson', '01700000001', 'alice@example.com', 'CSE');
INSERT INTO public.student (id, first_name, last_name, mobile_no, email, dept_short_name) VALUES ('2023000000002', 'Bob', 'Williams', '01800000002', 'bob@example.com', 'EEE');
INSERT INTO public.student (id, first_name, last_name, mobile_no, email, dept_short_name) VALUES ('2023000000003', 'Charlie', 'Taylor', '01900000003', 'charlie@example.com', 'BBA');
INSERT INTO public.student (id, first_name, last_name, mobile_no, email, dept_short_name) VALUES ('2023000000004', 'David', 'Anderson', '01600000004', 'david@example.com', 'MATH');

-- Insert into advisor
INSERT INTO public.advisor (id, faculty_short_id) VALUES ('2023000000001', 'FAC001');
INSERT INTO public.advisor (id, faculty_short_id) VALUES ('2023000000002', 'FAC002');
INSERT INTO public.advisor (id, faculty_short_id) VALUES ('2023000000003', 'FAC003');
INSERT INTO public.advisor (id, faculty_short_id) VALUES ('2023000000004', 'FAC004');

-- Insert into course
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) VALUES ('CSE101', 'Intro to Programming', 3, 'CSE', NULL, 10000);
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) VALUES ('EEE101', 'Basic Electrical Engineering', 3, 'EEE', NULL, 12000);
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) VALUES ('BBA101', 'Intro to Business', 3, 'BBA', NULL, 9000);
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) VALUES ('MATH101', 'Calculus I', 4, 'MATH', NULL, 11000);
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) 
VALUES ('CSE100', 'Fundamentals of Programming', 3, 'CSE', NULL, 8000);
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) 
VALUES ('EEE100', 'Introduction to Electrical Engineering', 3, 'EEE', NULL, 8500);
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) 
VALUES ('BBA100', 'Principles of Business', 3, 'BBA', NULL, 7500);
INSERT INTO public.course (course_id, title, cradit, dept_short_name, need_cradit, amount) 
VALUES ('MATH100', 'Pre-Calculus', 3, 'MATH', NULL, 8200);

-- Insert into prereq
INSERT INTO public.prereq (course_id, prereq_id) VALUES ('CSE101', 'CSE100');
INSERT INTO public.prereq (course_id, prereq_id) VALUES ('EEE101', 'EEE100');
INSERT INTO public.prereq (course_id, prereq_id) VALUES ('BBA101', 'BBA100');
INSERT INTO public.prereq (course_id, prereq_id) VALUES ('MATH101', 'MATH100');

-- Insert into room
INSERT INTO public.room (room_no, building) VALUES ('101', 'Main Building');
INSERT INTO public.room (room_no, building) VALUES ('102', 'Science Block');
INSERT INTO public.room (room_no, building) VALUES ('103', 'Business Block');
INSERT INTO public.room (room_no, building) VALUES ('104', 'Math Building');

-- Insert into timeslot
INSERT INTO public.timeslot (day, start_time, end_time) VALUES ('Mon', '08:00:00', '09:30:00');
INSERT INTO public.timeslot (day, start_time, end_time) VALUES ('Wed', '10:00:00', '11:30:00');
INSERT INTO public.timeslot (day, start_time, end_time) VALUES ('Tue', '09:00:00', '10:30:00');
INSERT INTO public.timeslot (day, start_time, end_time) VALUES ('Thu', '11:00:00', '12:30:00');

-- Insert into semester
INSERT INTO public.semester (year, season) VALUES ('2024', 'Spring');
INSERT INTO public.semester (year, season) VALUES ('2024', 'Fall');
INSERT INTO public.semester (year, season) VALUES ('2025', 'Spring');
INSERT INTO public.semester (year, season) VALUES ('2025', 'Fall');

-- Insert into section
INSERT INTO public.section (section_no, course_id, room_no, capacity, day, start_time, end_time, year, season) 
VALUES (1, 'CSE101', '101', 30, 'Mon', '08:00:00', '09:30:00', '2024', 'Spring');
INSERT INTO public.section (section_no, course_id, room_no, capacity, day, start_time, end_time, year, season) 
VALUES (2, 'EEE101', '102', 35, 'Wed', '10:00:00', '11:30:00', '2024', 'Spring');
INSERT INTO public.section (section_no, course_id, room_no, capacity, day, start_time, end_time, year, season) 
VALUES (3, 'BBA101', '103', 40, 'Tue', '09:00:00', '10:30:00', '2024', 'Fall');
INSERT INTO public.section (section_no, course_id, room_no, capacity, day, start_time, end_time, year, season) 
VALUES (4, 'MATH101', '104', 35, 'Thu', '11:00:00', '12:30:00', '2024', 'Fall');

-- Insert into takes
INSERT INTO public.takes (id, grade, is_dropped, section_no, course_id, year, season) VALUES ('2023000000001', NULL, FALSE, 1, 'CSE101', '2024', 'Spring');
INSERT INTO public.takes (id, grade, is_dropped, section_no, course_id, year, season) VALUES ('2023000000002', NULL, FALSE, 2, 'EEE101', '2024', 'Spring');
INSERT INTO public.takes (id, grade, is_dropped, section_no, course_id, year, season) VALUES ('2023000000003', NULL, FALSE, 3, 'BBA101', '2024', 'Fall');
INSERT INTO public.takes (id, grade, is_dropped, section_no, course_id, year, season) VALUES ('2023000000004', NULL, FALSE, 4, 'MATH101', '2024', 'Fall');

-- Insert into teaches
INSERT INTO public.teaches (faculty_short_id, section_no, course_id, year, season) VALUES ('FAC001', 1, 'CSE101', '2024', 'Spring');
INSERT INTO public.teaches (faculty_short_id, section_no, course_id, year, season) VALUES ('FAC002', 2, 'EEE101', '2024', 'Spring');
INSERT INTO public.teaches (faculty_short_id, section_no, course_id, year, season) VALUES ('FAC003', 3, 'BBA101', '2024', 'Fall');
INSERT INTO public.teaches (faculty_short_id, section_no, course_id, year, season) VALUES ('FAC004', 4, 'MATH101', '2024', 'Fall');

-- Insert into student_login
INSERT INTO public.student_login (password, id, is_active, is_dismissed) VALUES ('123456789', '2023000000001', TRUE, FALSE);
INSERT INTO public.student_login (password, id, is_active, is_dismissed) VALUES ('987654321', '2023000000002', TRUE, FALSE);
INSERT INTO public.student_login (password, id, is_active, is_dismissed) VALUES ('456789123', '2023000000003', TRUE, FALSE);
INSERT INTO public.student_login (password, id, is_active, is_dismissed) VALUES ('789123456', '2023000000004', TRUE, FALSE);


-- Select all records from advisor table
SELECT * FROM advisor;

-- Select all records from course table
SELECT * FROM course;

-- Select all records from department table
SELECT * FROM department;

-- Select all records from faculty table
SELECT * FROM faculty;

-- Select all records from prereq table
SELECT * FROM prereq;

-- Select all records from room table
SELECT * FROM room;

-- Select all records from section table
SELECT * FROM section;

-- Select all records from semester table
SELECT * FROM semester;

-- Select all records from student table
SELECT * FROM student;

-- Select all records from student_login table
SELECT * FROM student_login;

-- Select all records from student_token table
SELECT * FROM student_token;

-- Select all records from takes table
SELECT * FROM takes;

-- Select all records from teaches table
SELECT * FROM teaches;

-- Select all records from timeslot table
SELECT * FROM timeslot;

