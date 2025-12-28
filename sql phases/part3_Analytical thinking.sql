use online_learning_platform;


-- 1.students enrolled in exactly one course --

select distinct s.full_name as student_name,count(e.enrollment_id) as courses_enrolled
 from students s join  enrollments e on s.student_id=e.student_id join
 courses c on e.course_id=c.course_id
group by s.full_name,c.course_name
having count(e.enrollment_id)=1; 



-- 2.list courses priced below the avg price--


select course_name,price from courses
where price<(select avg(price) from courses);





-- 3.students whose first enrollment was after 2024-06-01--



select distinct s.full_name,e.enroll_date from students s join  enrollments e
on s.student_id=e.student_id
where e.enroll_date >'2024-06-01'
order by e.enroll_date asc;



-- 4.show students who completed atleast one course fully--
select s.full_name,count(e.enrollment_id) as enrolls,cp.completed_percent
from students s join enrollments e on s.student_id=e.student_id
join course_progress cp on e.enrollment_id=cp.enrollment_id where
completed_percent='100'group by s.full_name order by enrolls desc;


-- 5.find cheapest course in each category--



select distinct category,course_name,price from courses
where price= (select min(price) from courses)
order by category asc;




-- 6.display students whose highest course price is higher than 3000 --


select s.full_name,c.price from students s join enrollments e on 
s.student_id=e.student_id join courses c on e.course_id=c.course_id
where price>3000;




-- 7.show courses whose enrollment count is below avg



select c.course_name,count(e.enrollment_id) as enrollments
from courses c join enrollments e on c.course_id=e.course_id
group by c.course_name
having count(enrollment_id)<(select avg(enrollment_id) from enrollments);




-- 8. students enrolled in atleast 2 different categories--
select s.full_name,count(c.category) as categories_enrolled 
from students s join enrollments e on s.student_id=
e.student_id join courses c on e.course_id=c.course_id
group by s.full_name having  count(c.category)>2;




-- 9.list courses where no student completed more than 50%--


select distinct c.course_name
from courses c join enrollments e on c.course_id=e.course_id
join course_progress cp on e.enrollment_id=cp.enrollment_id
group by c.course_name,c.course_id
having max(cp.completed_percent)<=50;




-- 10.find students whose total spending is below average

select s.full_name,sum(c.price) as amount_spent
from students s join enrollments e on s.student_id=e.student_id 
join courses c on e.course_id=c.course_id
group by s.full_name
having sum(c.price)<=avg(c.price);



-- 11.students enrolled but never completed any course--

select s.student_id,s.full_name,c.completed_percent from 
students s join enrollments e on s.student_id=e.student_id
join course_progress c on e.enrollment_id=c.enrollment_id
group by s.student_id,s.full_name,c.completed_percent
having max(c.completed_percent)<100;


-- 12. categories with more than 3 courses


select category,count(course_id) as total_courses
from courses where (select count(course_id) from courses)>3 
group by category;



-- 13.show students whose avg completion is above overall average completion


select s.student_id,s.full_name from students s
join enrollments e on s.student_id=e.student_id join 
course_progress cp on e.enrollment_id=cp.enrollment_id
group by s.student_id,s.full_name
having avg(cp.completed_percent)>(select avg(completed_percent) from course_progress);




-- 14.students who enrolled in least expensive courses




select s.student_id,s.full_name from students s
join enrollments e on s.student_id=e.student_id
join courses c on e.course_id=c.course_id
where price=(select min(price) from courses);




-- 15.find courses whose price is lower than the avg price of their own category
select c1.course_name,c1.price from courses c1
where c1.price<(select avg(c2.price) from courses c2
where c2.category=c1.category);




-- 16 find students who enrolled only in free courses--


select s.student_id,s.full_name from students s join enrollments e on s.student_id=e.student_id
join courses c on e.course_id=c.course_id 
where price=0;



-- 17.show courses whose completion<70%--


select c.course_id,c.course_name,cp.completed_percent from courses c join
enrollments e on c.course_id=e.course_id join course_progress cp on e.enrollment_id=
cp.enrollment_id where cp.completed_percent<70;




-- 18.find students who enrolled in second most expensive course--
select s.student_id,s.full_name,c.price as course_price from students s
join enrollments e on s.student_id=e.student_id join courses c on 
e.course_id=c.course_id where c.price in ( select price from(select
price,dense_rank() over (order by price desc) as rnk from courses)t
where rnk=2);



-- 19.display courses with enrollments greater than median--
select c.course_id,c.course_name,count(e.enrollment_id) as 
enrollments from courses c join enrollments e on c.course_id=
e.course_id group by c.course_id,c.course_name having count
(e.enrollment_id)>(select avg(enrollments) from (select 
count(enrollment_id) as enrollments from enrollments group by 
course_id) t);



-- 20.students who exactly completed 1 course--



select distinct s.student_id,s.full_name from students s join enrollments e
on s.student_id=e.student_id join course_progress cp on e.enrollment_id = cp.enrollment_id
where cp.completed_percent = 100 
group by s.student_id,s.full_name
having count(e.course_id)=1;
