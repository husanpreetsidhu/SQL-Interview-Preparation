create database techjobs;
use techjobs;
CREATE TABLE tech_jobs (
    job_id INT PRIMARY KEY,
    job_title VARCHAR(150),
    company_name VARCHAR(150),
    company_rating DECIMAL(2,1),
    location VARCHAR(200),
    scraped_city VARCHAR(50),
    role_category VARCHAR(100),
    experience_raw VARCHAR(50),
    experience_min_yrs DECIMAL(5,1),
    experience_max_yrs DECIMAL(5,1)
);
select * from tech_jobs;

select scraped_city, count(job_id) as total_jobs
from tech_jobs 
where role_category="Data Scientist"
group by scraped_city
order by total_jobs desc limit 1;

select company_name,count(job_id) as total_jobs 
from tech_jobs 
where role_category='Data Scientist'
group by company_name 
having total_jobs>=50
order by total_jobs desc;

select company_name, avg(experience_min_yrs) as avg_exp
from tech_jobs 
where role_category='Data Scientist'
group by company_name
having avg_exp>5
order by avg_exp desc;

with city as (select scraped_city,company_name, count(job_id) as total_jobs, 
rank() over(partition by scraped_city order by count(job_id) desc) as rn
from tech_jobs
where role_category='Data Scientist' 
group by scraped_city,company_name)
select * from city 
where rn=1 ;

with city as (select scraped_city,company_name, count(job_id),
dense_rank() over(partition by scraped_city order by count(job_id)desc)as rn 
from tech_jobs
where role_category='Data Scientist'
group by scraped_city,company_name)
select * from city 
where rn<=3;

select scraped_city,company_name, avg(experience_min_yrs) from tech_jobs
where role_category='Data Scientist'
group by scraped_city,company_name 
having avg(experience_min_yrs)>(select avg(experience_min_yrs) from tech_jobs
where role_category='Data Scientist');

select company_name,count(job_id) as total_jobs, avg(experience_min_yrs) from tech_jobs 
where role_category='Data Scientist' 
group by company_name
having count(job_id)>=10 and avg(experience_min_yrs)>(select avg(experience_min_yrs) from tech_jobs
where role_category='Data Scientist');


with total as (select scraped_city,company_name,count(job_id) as total_jobs,
dense_rank() over(partition by scraped_city order by count(job_id) desc) as rn from tech_jobs
where  role_category='Data Scientist'
group by scraped_city,company_name)
select * from total 
where rn<=2 ;


select company_name, count(job_id)as total_jobs, avg(company_rating) from tech_jobs
where role_category='Data Scientist'
group by company_name 
having count(job_id)>=5 and avg(company_rating)>4 ;


#-------------------------------------------------------------------------------------------------------------------
