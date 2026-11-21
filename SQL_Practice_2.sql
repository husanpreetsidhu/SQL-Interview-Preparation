CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    city VARCHAR(50),
    salary INT
);

INSERT INTO employees
(employee_id, employee_name, department, city, salary)
VALUES
(101, 'Rahul', 'IT', 'Delhi', 60000),
(102, 'Priya', 'Finance', 'Mumbai', 75000),
(103, 'Aman', 'IT', 'Delhi', 55000),
(104, 'Neha', 'HR', 'Bangalore', 90000),
(105, 'Arjun', 'Finance', 'Mumbai', 65000),
(106, 'Simran', 'HR', 'Pune', 50000),
(107, 'Karan', 'IT', 'Delhi', 80000),
(108, 'Anjali', 'Finance', 'Pune', 70000);

CREATE TABLE performance (
    employee_id INT,
    rating DECIMAL(3,1),
    review_year INT
);

INSERT INTO performance
(employee_id, rating, review_year)
VALUES
(101, 4.2, 2025),
(102, 4.5, 2025),
(103, 3.8, 2025),
(104, 4.7, 2025),
(105, 4.0, 2025),
(106, 3.5, 2025),
(107, 4.8, 2025),
(108, 4.1, 2025);


select department, avg(salary) from employees 
group by department;

with highest_salary as (select employee_name, department,salary, 
rank() over(partition by department order by salary desc) as rn from employees)
select * from highest_salary
where rn=1;


with high_avg as (select department, avg(salary) as dept_avg from employees 
group by department )
select employee_name, e.department,e.salary, d.dept_avg
from employees e 
join high_avg d
on e.department=d.department
where e.salary>d.dept_avg;

with ranked_emp as (select employee_name, salary, 
rank() over(order by salary desc ) as rn from employees)
select * from ranked_emp 
where rn=1;

with ranked_salary as (select employee_name, salary, 
dense_rank() over (order by salary desc ) as rn from employees)
select * from ranked_salary 
where rn=2;


select department, avg(salary) as avg_salary from employees 
group by department
order by avg_salary desc limit 1
;

with second_high as (select employee_name, salary,
dense_rank()over(partition by department order by salary desc) as rn from employees)
select * from second_high 
where rn=2;

select e.employee_name, e.department, e.salary from employees e 
where salary >(select avg(salary) from employees e2 
where e2.department=e.department );


CREATE DATABASE InterviewSQL;

USE InterviewSQL;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    city VARCHAR(50),
    salary INT
);
INSERT INTO employees
(employee_id, employee_name, department, city, salary)
VALUES
(101, 'Rahul', 'IT', 'Delhi', 60000),
(102, 'Aman', 'IT', 'Delhi', 60000),
(103, 'Karan', 'IT', 'Delhi', 80000),
(104, 'Priya', 'Finance', 'Mumbai', 75000),
(105, 'Arjun', 'Finance', 'Mumbai', 65000),
(106, 'Neha', 'HR', 'Bangalore', 90000),
(107, 'Simran', 'HR', 'Pune', 50000),
(108, 'Anjali', 'Finance', 'Pune', 75000);
CREATE TABLE performance (
    performance_id INT PRIMARY KEY,
    employee_id INT,
    rating DECIMAL(3,1),
    review_year INT,
    bonus INT
);
INSERT INTO performance
(performance_id, employee_id, rating, review_year, bonus)
VALUES
(1, 101, 4.2, 2025, 5000),
(2, 102, 4.5, 2025, 6000),
(3, 103, 4.8, 2025, 10000),
(4, 104, 4.7, 2025, 9000),
(5, 105, 4.0, 2025, 4000),
(6, 106, 4.9, 2025, 12000),
(7, 107, 3.5, 2025, 2000),
(8, 108, 4.6, 2025, 8000);

with dept_avg as (select department, avg(salary) as avg_salary from employees 
group by department) 
select e.employee_name, e.salary, p.rating from employees e 
join performance p 
on e.employee_id=p.employee_id 
join dept_avg d
on e.department=d.department
where rating>4.5 and e.salary>d.avg_salary ;


with finance_emp as (select employee_name,max(salary) as greater_salary from employees 
where department = "finance")
select e.employee_name, e.salary, e.department from employees e 
join finance_emp f 
on f.employee_name=e.employee_name 
where e.salary>greater_slaary;

select e.employee_name, e.department, e.salary from employees e
where e.salary> (select max(salary) from employees
where department="finance" 
);


select e.employee_name, e.department,e.salary from employees e
where e.salary>
(select avg(d.salary) from employees d
where e.department=d.department) ;

select e.employee_name, e.department,e.salary from employees e 
where e.salary=(select max(d.salary) from employees d
where d.department=e.department and 
d.salary<
(select max(x.salary) from employees x
where x.department=d.department));

select e.employee_name,e.department, e.salary,p.rating from employees e
join performance p 
on e.employee_id=p.employee_id
where e.salary>(
select avg(d.salary) from employees d
where d.department=e.department)
and p.rating>(select avg(p2.rating)from performance p2
join employees e2 
on p2.employee_id=e2.employee_id
where e2.department=e.department);



























































