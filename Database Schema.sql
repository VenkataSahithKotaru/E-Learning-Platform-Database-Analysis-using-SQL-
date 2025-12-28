create database Online_Learning_Platform;

use Online_Learning_Platform;

create table Students
(
student_id int primary key,
full_name varchar(100),
email varchar(100),
city varchar(100),
signup_date date);


create table Instructors 
(
instructor_id int primary key,
instructor_name varchar(100),
expertise varchar(100),
join_date date,
city varchar(100));

create table Courses
(
course_id int primary key,
course_name varchar(100),
category varchar(100),
instructor_id int,
price int,
foreign key (instructor_id) references instructors(instructor_id));

create table Enrollments
(
enrollment_id int primary key,
student_id int,
course_id int,
enroll_date date,
foreign key (student_id) references students(student_id),
foreign key (course_id) references courses(course_id));

create table course_progress 
(
progress_id int primary key,
enrollment_id int,
completed_percent int,
last_accessed_date date,
foreign key (enrollment_id) references enrollments(enrollment_id));
