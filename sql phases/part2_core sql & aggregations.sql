use online_learning_platform;

-- 1.show students who signed up after 2024-01-01--

select student_id,full_name,signup_date from students
where signup_date>'2024-01-01'
order by signup_date asc;




-- 2.courses whose prices>2000--

select course_name,category,price from courses
where price >2000
order by price desc;






-- 3.total num of students city wise--

select distinct city,count(*) as total_students from students
group by city;






-- 4.total enrollments per course--
select c.course_name,count(e.enrollment_id) 
as num_of_enrollments from courses c join enrollments
 e on c.course_id=e.course_id group by c.course_name;








-- 5.stu_names along with courses they enrolled-- 

select distinct s.full_name,count(e.enrollment_id) as enrolled,
c.course_name from students s join enrollments e
on s.student_id=e.student_id join courses c on e.course_id=c.course_id
group by s.full_name,c.course_name;





-- 6.total revenue generated from courses
create view Rev as
(select c.course_name,c.price,count(e.enrollment_id) as total_enrolls,
c.price*count(e.enrollment_id) as Revenue
 from courses c join enrollments e
on c.course_id=e.course_id
group by c.course_name,c.price);
select sum(Revenue) as Total_revenue from Rev;







-- 7.total amount spent by each student--
select s.full_name,sum(c.price) as amount_spent
from students s join enrollments e on s.student_id
=e.student_id  join courses c on 
e.course_id=c.course_id group by s.full_name;







-- 8.list students who enrolled in paid courses (price>0)--

select s.full_name,sum(c.price) as amount_spent
from students s join enrollments e on s.student_id=e.student_id 
join courses c on e.course_id=c.course_id
group by s.full_name
having sum(c.price)>0;







-- 9.avg course price category_wise--
select distinct category ,round(avg(price),2)
 as avg_price from courses group by category;




-- 10.students who enrolled in more than 1 course --




select distinct s.full_name,count(e.enrollment_id) as enrolled_num_of_courses 
from students s join enrollments e
on s.student_id=e.student_id 
group by s.full_name
having enrolled_num_of_courses>1;





-- 11.display  courses with zero enrollments 
select c.course_name,count(e.enrollment_id) 
enrollments from courses c left join enrollments e
on c.course_id=e.course_id group by c.course_name
having enrollments =0;


-- 12.students never enrolled in courses--





select s.full_name,count(e.enrollment_id) enrollments from students s left join enrollments e
on s.student_id=e.student_id
group by s.full_name
having enrollments =0;


-- 13.show highest priced course --





select distinct course_id,course_name,price from courses
group by course_id,course_name
having price = (select max(price) from courses);



-- 14.total enrollments month wise--







select distinct monthname(enroll_date) as enrolled_month,
count(enrollment_id) as total_enrollments
from enrollments
group by enrolled_month
order by total_enrollments desc;



-- 15.students with course_completion above 80%--






select s.full_name,c.completed_percent from 
students s join enrollments e on s.student_id=e.student_id
join course_progress c on e.enrollment_id=c.enrollment_id
where c.completed_percent>80;



-- 16.total num of courses per category --





select category,count(course_id) as total_num_of_courses from courses
group by category order by total_num_of_courses desc;



-- 17.show students who have enrolled but have 0 progress--
select s.full_name,e.enrollment_id,c.completed_percent from 
students s join enrollments e on s.student_id=e.student_id
join course_progress c on e.enrollment_id=c.enrollment_id
where c.completed_percent=0;



-- 18.top 3 students who spent highest total amount--
select s.full_name as student_name,sum(c.price) as amount_spent
from students s join enrollments e on s.student_id=e.student_id 
join courses c on e.course_id=c.course_id group by s.full_name
order by amount_spent desc limit 3;


-- 19. course_wse avg completion %--





select c.course_name,round(avg(cp.completed_percent),2) as avg_completion
from courses c join enrollments e on c.course_id=e.course_id
join course_progress cp on e.enrollment_id=cp.enrollment_id
group by c.course_name;



-- 20. students who enrolled in courses costing more than 2000--






select s.full_name as student_name,c.course_name,c.price from students s join 
enrollments e on s.student_id=e.student_id join courses c on e.course_id=c.course_id
where c.price>2000;