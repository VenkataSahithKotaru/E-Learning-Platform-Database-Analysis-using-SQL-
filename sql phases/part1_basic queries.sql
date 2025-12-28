



-- 1.list all students from students table --
select student_id,full_name from students;






-- 2.display stu_id,name,city of all students--
select student_id,full_name,city from students;






-- 3. fetch the first 15 students based on stu_id(asc)--

select student_id,full_name from students
order by student_id asc
limit 15;






-- 4.courses whose prices>1000--

select course_name,category,price from courses
where price >1000
order by price desc;







-- 5.coursebelonging to AI--

select course_name,category from courses
where category="AI";









-- 6.distinct cities from students coming--

select distinct city from students;


-- 7.top10 most expensive courses(higher first)
select course_name,category,price from courses
order by price desc
limit 10;







-- 8.students name start with "A"--

select full_name as student_name from students
where full_name like "A%";








-- 9.fetch courses whose category containing "data"-- 
select course_name,category from courses
where category regexp "data";





-- 10.totalstudents present in platform--

select distinct count(student_id) as Total_Students from students;







-- 11. count total num of courses in each category --
select distinct category,count(*) 
as num_of_courses from courses group by category
order by num_of_courses desc;






-- 12. instructors who joined in 2024--

select instructor_id,instructor_name,join_date from instructors
where year(join_date)=2024;








-- 13.enrollments made on 2024-08-01--

select * from enrollments
where enroll_date = '2024-08-01';









-- 14.students who are not from mumbai--

select student_id,full_name,city from students
where city != "mumbai";








-- 15.display 5 cheap courses(price in asc)
select course_id,course_name,category,price 
from courses order by price asc limit 5;








-- 16. display course name along with length of each coursename
select course_name,length(course_name)as len_of_course_name from courses;






-- 17.show students who signed up after 2023-01-01--
select student_id,full_name,signup_date from students
where signup_date>'2023-01-01'
order by signup_date asc;







-- 18.courses with price = 999

select * from courses
where price = 999;







-- 19.list latest 20 enrollments based on enroll_date
select *  from enrollments
order by enroll_date desc
limit 20;






-- 20.show student emails sorted alphabatically--

select email from students
order by email asc;