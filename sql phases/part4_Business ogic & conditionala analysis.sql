use online_learning_platform;

-- 1. categorize courses as cheap, medium, premium baesd on their price--


select course_name,
case
 when price<500 then 'Cheap(<500)'
 when price<1500 then 'Medium(<1500)'
 when price>1500 then 'Premium(>1500)'
 else 'NAN'
 end as Price_category,price from courses;
 
 
 
 
 -- 2.label students as old or new based on signup_date
 select student_id,full_name,case 
 when year(signup_date)>=2024 then "New"
 when year(signup_date)<2024 then "Old"
 else "NAN" 
 end as student_catgory,signup_date from students;
 
 
 -- 3.classify instructors based on experience(years since joining)--
 
 
 select instructor_id,instructor_name,case
 when 2025-year(join_date) =0 then 'Not Experienced'
 when 2025-year(join_date) <3 then 'Partially experienced'
 when 2025-year(join_date) <7 then 'Medium Experienced'
 when 2025-year(join_date) >=7 then 'Highly Experienced'
 else "NoExperience"
 end as experience_category from instructors;
 
 
 
 -- 4.find total_enrollments yearwise
select year(enroll_date) as Year,count
(enrollment_id) as num_of_enrolls
from enrollments group by year(enroll_date);
 
 
 
 -- 5.month wise course enrollments
 
 
 select  distinct monthname(enroll_date) as month,count(enrollment_id) as course_enrolls
 from enrollments group by monthname(enroll_date);
 
 
 -- 6.identify inactive students
 
 
 select  distinct s.student_id,s.full_name from students s  left join enrollments e
 on s.student_id=e.student_id 
 where e.course_id is null;
 
 
 
 -- 7.classify course completion status
 
 select c.course_id,c.course_name,case
 when cp.completed_percent=0 then 'not started'
 when cp.completed_percent<25 then 'poor'
 when cp.completed_percent<50 then 'Average'
 when cp.completed_percent<75 then 'Medium'
 when cp.completed_percent<99 then 'above medium'
 when cp.completed_percent=100 then 'completed'
 else 'not registered'
 end as completion_status,cp.completed_percent from courses c join enrollments e on c.course_id=e.course_id
 join course_progress cp on e.enrollment_id=cp.enrollment_id; 
 
 
 -- 8.find courses enrolled in during last 6 months --
 
 select c.course_id,c.course_name,e.enroll_date from courses c 
 join enrollments e on c.course_id=e.course_id
 join course_progress cp on e.enrollment_id=cp.enrollment_id 
 where e.enroll_date>=date_sub(curdate(),interval 6 month);

 
 
 
 -- 9.show students with total courses enrolled--
 
 
 select s.student_id,s.full_name,count(e.course_id) as courses_enrolled
 from students s join enrollments e on s.student_id=e.student_id
group by s.student_id,s.full_name; 





-- 10.identify high-value students based on total course value--

select s.student_id,s.full_name as high_value_students,
count(e.course_id) as total_enrolled, sum(c.price) as course_value
from students s join enrollments e on s.student_id=e.student_id join courses c on
e.course_id=c.course_id group by s.student_id,s.full_name
having sum(c.price)>15000;




-- 11. display courses and their demand level--

select c.course_id,c.course_name,count(e.enrollment_id) as enrollments,case
when count(e.enrollment_id)>30 then "High Demand"
when count(e.enrollment_id)<30 then "Moderate Demand"
when count(e.enrollment_id)<20 then "Less Demand"
when count(e.enrollment_id)<10 then "Poor Demand"
else "Not in demand"
end as Demand_Level from 
courses c join enrollments e on c.course_id=e.course_id
group by c.course_id,c.course_name;


-- 12. find average completion % month-wise--

select distinct monthname(last_accessed_date) as month,round(avg(completed_percent),2)
as avg_completion from course_progress
group by monthname(last_accessed_date);



-- 13. students enrolled but not started learning


select s.student_id,s.full_name
 from students s join enrollments e on s.student_id=e.student_id
join course_progress cp on e.enrollment_id=cp.enrollment_id
where cp.completed_percent=0;



-- 14.show course value contribution category wise--

select c.category,
count(e.course_id) as total_enrolled, sum(c.price) as course_value
from enrollments e join courses c on
e.course_id=c.course_id group by c.category;



-- 15.find busiest enrollment date
SELECT enroll_date, COUNT(enrollment_id) 
AS enrolls FROM enrollments GROUP BY 
enroll_date HAVING COUNT(enrollment_id)
 = (SELECT MAX(daily_count) FROM (
SELECT COUNT(enrollment_id) AS daily_count
FROM enrollments GROUP BY enroll_date) t);


-- 16.rank students based on total course value--
select s.student_id,s.full_name as high_value_students,rank()
over(order by sum(c.price) desc) as ranking from students s 
join enrollments e on s.student_id=e.student_id join 
courses c on e.course_id=c.course_id group by s.student_id,
s.full_name order by ranking asc;



-- 17. identify courses with poor engagement--

select c.course_id,c.course_name,avg(cp.completed_percent) as Engagement
from courses c join enrollments e on c.course_id=e.course_id
join course_progress cp on e.enrollment_id=cp.enrollment_id
group by c.course_id,c.course_name
having avg(cp.completed_percent) < 40;


-- 18.label students as active or inactive learners

SELECT s.student_id,s.full_name,MAX(cp.last_accessed_date) AS last_activity_date,
    CASE 
	WHEN MAX(cp.last_accessed_date) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 'Active Learner'
        ELSE 'Inactive Learner'
    END AS learner_status
FROM students s LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN course_progress cp ON e.enrollment_id = cp.enrollment_id
GROUP BY s.student_id, s.full_name;

-- 19.students who enrolled but dropped out early(<30 completion)


select s.student_id,s.full_name
from students s join enrollments e on s.student_id=e.student_id
join course_progress cp on e.enrollment_id=cp.enrollment_id
where cp.completed_percent<30;


-- 20.identify top 3 most enrolled courses


select c.course_id,c.course_name,count(e.enrollment_id) as enrollments
from courses c join enrollments e on c.course_id=e.course_id
group by c.course_name,c.course_id
order by count(e.enrollment_id) desc
limit 3;