CREATE DATABASE join_practice;
USE join_practice;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(30),
    membership VARCHAR(20)
);
INSERT INTO customers VALUES
(1, 'Aman', 'Delhi', 'Gold'),
(2, 'Riya', 'Mumbai', 'Silver'),
(3, 'Rahul', 'Pune', 'Gold'),
(4, 'Neha', 'Delhi', 'Bronze'),
(5, 'Karan', 'Chandigarh', 'Gold'),
(6, 'Simran', 'Mumbai', 'Silver'),
(7, 'Vikas', 'Delhi', 'Bronze');
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50),
    amount INT,
    order_date DATE
);
INSERT INTO orders VALUES
(101, 1, 'Laptop', 60000, '2025-01-10'),
(102, 2, 'Phone', 30000, '2025-01-15'),
(103, 1, 'Headphones', 5000, '2025-02-05'),
(104, 3, 'Laptop', 55000, '2025-02-20'),
(105, 4, 'Mouse', 2000, '2025-03-01'),
(106, 2, 'Tablet', 25000, '2025-03-15'),
(107, 5, 'Laptop', 65000, '2025-04-10'),
(108, 3, 'Keyboard', 4000, '2025-04-18'),
(109, 1, 'Monitor', 20000, '2025-05-05'),
(110, 6, 'Phone', 35000, '2025-05-20');


CREATE DATABASE window_practice;
USE window_practice;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT
);
INSERT INTO employees (emp_id, emp_name, department, salary)
VALUES
(1, 'Aman', 'IT', 70000),
(2, 'Riya', 'HR', 60000),
(3, 'Rahul', 'IT', 85000),
(4, 'Neha', 'Finance', 75000),
(5, 'Karan', 'IT', 90000),
(6, 'Simran', 'HR', 65000),
(7, 'Vikas', 'Finance', 80000),
(8, 'Priya', 'IT', 75000);
SELECT * FROM employees;

select emp_name, salary,
row_number() over( order by salary desc) as row_num
from employees;

select emp_name, department,salary,
row_number() over( partition by department order by salary desc ) as row_num
from employees;

select emp_name,department,salary
from (select emp_name, department, salary,
row_number() over(
partition by department order by salary desc ) as row_num 
from employees) as ranked 
where row_num=1;  

select emp_name, salary, 
rank() over(
order by salary desc ) as salary_rank 
from employees;

select emp_name, salary, 
dense_rank() over(
order by salary desc) from employees;

select emp_name,department, salary ,
dense_rank() over(
partition by department order by salary desc ) as salary_rank 
from employees;

select emp_name, department, salary ,
rank() over(
partition by department order by salary desc) as salary_rank
from employees;

select emp_name, department, salary
from (select emp_name, department,salary,
rank() over( partition by department 
order by salary desc ) as row_num
from employees ) as rank_row
where row_num<=2;

select emp_name, salary,
lag(salary) over (
order by salary desc ) as previous_salary 
from employees ;

select emp_name, department, salary, 
lag(salary) over(
partition by department order by salary desc) from employees;

select emp_name, salary,
lead(salary) over(
order by salary desc) from employees;

select emp_name, department, salary ,
lead(salary) over(
partition by department order by salary desc ) from employees;

select emp_name, department, salary, 
lag(salary) over(
partition by department order by salary desc ) as previous_salary, 
salary- lag(salary) over(partition by department order by salary desc ) as salary_diff
from employees ;

select emp_name,department,salary ,
sum(salary) over ( partition by department
order by salary ) as running_salary 
from employees;

select emp_name, department, salary, 
avg(salary) over(partition by department 
order by salary desc ) as running_salary
from employees;


select emp_name, salary, 
avg(salary) over(
order by salary desc 
rows between 2 preceding and current row ) from employees;


select emp_name, salary, 
first_value(salary) over (
order by salary desc) from employees;


select emp_name, salary, 
last_value(salary) over(
order by salary desc) from employees;


SELECT emp_name,
       salary,
       LAST_VALUE(salary) OVER(
           ORDER BY salary DESC
           ROWS BETWEEN UNBOUNDED PRECEDING
                AND UNBOUNDED FOLLOWING
       ) AS lowest_salary
FROM employees;


select emp_name, salary, 
ntile(4) over(
order by salary ) from employees;


select emp_name, department, salary , 
ntile(2) over(
partition by department order by salary ) from employees;

select emp_name, salary, 
rank() over( order by salary desc) as ranked_salary,
lag(salary) over(order by salary ) as previous_salary ,
lead(salary) over(order by salary) as next_salary from employees;


select emp_name, salary, salary_rank,
case when salary_rank=1 then 'top performer'
when salary_rank=2 then 'second'
else 'others'
end as category 
from ( select emp_name, salary,
rank() over(order by salary desc ) as salary_rank from employees ) as ranked; 



select emp_name, department, salary
from (select  emp_name, department, salary ,
dense_rank() over(
partition by department order by salary desc )as ranked_rank from employees ) as ranked
where ranked_rank=2;  

with it_employees as (
select emp_name, department, salary from employees 
having department='it')
select * from it_employees;

with avg_salary as (select department, avg(salary) from employees 
group by department )
select * from avg_salary;

with avg_salary as (select department, avg(salary) from employees 
group by department 
having avg(salary)>75000) 
select * from avg_salary;


with highest_emp as (select emp_name, department, salary, 
 row_number() over (partition by department order by salary desc) as rn from employees)
 select * from highest_emp
 where rn=2;
 
 
with highest_avg as (select department, avg(salary) from employees 
group by department 
order by avg(salary) desc limit 1)
select * from highest_avg;

with highest_emp as (select department, avg(salary) as avg_salary from employees
group by department )
select e.emp_name, e.department, e.salary from employees e 
join highest_emp d 
on d.department=e.department
where e.salary> d.avg_salary;

with highest as (select emp_name, salary, department,
dense_rank() over(partition by department order by salary desc ) as rn from employees )
select * from highest
where rn<3;

with it_emp as (select emp_name, department, salary from employees 
where salary>70000 and department='it' )
select * from it_emp;

with highest as (select emp_name, department, salary,
dense_rank() over(partition by department order by salary desc) as rn from employees)
select * from highest
where rn=1;

with total_salary as (select department, sum(salary) from employees 
group by department
having sum(salary)>20000)
select * from total_salary;

with avg_salary as (select department, avg(salary) as avg_pay from employees
group by department )
select e.emp_name, e.department, e.salary from employees e
join avg_salary a
on e.department= a.department
where a.avg_pay<e.salary;

with highest_total as (select department, sum(salary) from employees
group by department
order by sum(salary) desc limit 1)
select * from highest_total; 

with highest_emp as (select emp_name,salary from employees
where salary>(select avg(salary) from employees))
select * from highest_emp;

with third_salary as (select emp_name, salary,
dense_rank() over(order by salary desc ) as rn from employees )
select * from third_salary 
where rn=3;

with high_dept as (select department, max(salary) as max_salary from employees
group by department)
select e.emp_name,e.department,e.salary from employees e 
join high_dept h 
on h.department=e.department
where h.max_salary=e.salary and h.max_salary>80000;


with new_salary as (select department, avg(salary)as avg_salary from employees 
group by department)
select e.emp_name, e.salary, e.department from employees e 
join new_salary n
on e.department=n.department 
where abs(e.salary-n.avg_salary)<=10000;

with low_avg as (select department, avg(salary) from employees 
group by department 
order by avg(salary) asc limit 1 ) 
select * from low_avg ;

with high_emp as (select department, max(salary) as salary from employees
group by department )
select e.emp_name, e.department, e.salary  from employees e
join high_emp h
on e.department= h.department 
where e.salary=h.salary ;


with three_emp as (select emp_name, salary,
dense_rank() over(order by salary desc ) as rn from employees)
select * from three_emp 
where rn<=3;

CREATE TABLE employee_manager (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    manager_id INT
);

INSERT INTO employee_manager VALUES
(1, 'Aman', 'IT', NULL),
(2, 'Riya', 'IT', 1),
(3, 'Rahul', 'IT', 1),
(4, 'Neha', 'HR', 2),
(5, 'Karan', 'Finance', 6),
(6, 'Simran', 'Finance', NULL);

use employee_manager;


select e.emp_name as employee_name, m.emp_name as manager_name
from employee_manager e
left join employee_manager m
on e.manager_id=m.emp_id;

select e.emp_name as employee_name, m.emp_name as manager_name from employee_manager e 
left join employee_manager m 
on e.manager_id=m.emp_id
where m.emp_name is not null 
;

select e.emp_name as employee_name, m.emp_name as manager_name from employee_manager e 
join employee_manager m 
on e.manager_id=m.manager_id 
where e.emp_id<>m.emp_id;

select e.emp_name as employee_name, m.emp_name as manager_name from employee_manager e
join employee_manager m 
on e.department=m.department 
where e.emp_id<> m.emp_id;

select e.emp_name, m.emp_name from employee_manager e 
join employee_manager m
on e.emp_id= m.manager_id 
where e.department=m.department ;

select e.emp_name, e.salary as emp_salary , m.emp_name, m.salary as manager_salary  from employee_manager e
join employee_manager m 
on e.manager_id=m.emp_id 
where e.salary > m.salary;

select e.emp_name, m.emp_name ,e.department from employee_manager e
join employee_manager m 
on e.department=m.department and e.emp_id > m.emp_id ;


select e.emp_name, m.emp_name from employee_manager e
join employee_manager m 
on e.manager_id=m.manager_id 
where e.emp_id>m.emp_id ;

select e.emp_name, m.emp_name, m.department from employee_manager e
join employee_manager m 
on e.emp_id = m.manager_id
where e.department=m.department;

select count(e.emp_name), m.emp_name from employee_manager e 
join employee_manager m 
on m.emp_id=e.manager_id 
group by m.emp_name
having count(e.emp_id)>1;

select count(e.emp_name) as emp_count, m.emp_name from employee_manager e
join employee_manager m 
on m.emp_id=e.manager_id 
group by m.emp_name 
order by emp_count desc limit 1;

select e.emp_name, m.emp_name, m.department from employee_manager e
join employee_manager m 
on m.manager_id=e.manager_id 
where e.department=m.department
and e.emp_id<m.emp_id;

select e.emp_name, m.emp_name from employee_manager e
join employee_manager m 
on m.emp_id=e.manager_id 
where e.department != m.department;


select e.emp_name as emp, m.emp_name from employee_manager e
join employee_manager m 
on m.emp_id=e.manager_id
where e.manager_id in (select manager_id from employee_manager
where manager_id is not null 
group by manager_id
having count(*)>=2);

select e.emp_name, m.emp_name, m.department from employee_manager e
join employee_manager m 
on m.emp_id= e.manager_id 
where e.department=m.department
and (e.manager_id in (select manager_id from employee_manager 
where manager_id is not null 
group by manager_id 
having count(*)>=2 ));


CREATE TABLE employee_salary (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT,
    manager_id INT
);
INSERT INTO employee_salary VALUES
(1, 'Aman', 'IT', 90000, NULL),
(2, 'Riya', 'IT', 60000, 1),
(3, 'Rahul', 'IT', 80000, 1),
(4, 'Neha', 'HR', 70000, 2),
(5, 'Karan', 'HR', 50000, 2),
(6, 'Simran', 'Finance', 85000, NULL),
(7, 'Vikas', 'Finance', 65000, 6),
(8, 'Pooja', 'Finance', 75000, 6);

select e.emp_name,e.department, e.salary from employee_salary e
where e.salary>(select avg(e2.salary) from employee_salary e2
where e.department=e2.department);

select e.emp_name,e.department, e.salary from employee_salary e 
where e.salary in (select max(e2.salary) from employee_salary e2 
where e.department=e2.department);

select e.emp_name, e.department, e.salary from employee_salary e 
where e.salary <(select avg(salary) from employee_salary e2 
where e.department=e2.department);

select * from employee_salary 
where salary>(select avg(salary) from employee_salary);


select e.emp_name, e.salary, e.manager_id from employee_salary e 
where e.salary>(select avg(salary) from employee_salary e2
where e.manager_id=e2.manager_id);

select e.emp_name, e.salary, e.department from employee_salary e 
where e.salary in (select min(salary) from employee_salary e2
where e.department=e2.department);

select e.emp_name, e.salary, e.department from employee_salary e 
where e.salary in (select max(e2.salary) from employee_salary e2 
where e.department=e2.department);


CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    salesperson VARCHAR(50),
    department VARCHAR(30),
    product VARCHAR(50),
    city VARCHAR(30),
    quantity INT,
    price INT,
    sale_date DATE
);
INSERT INTO sales_data VALUES
(1, 'Aman', 'Electronics', 'Laptop', 'Delhi', 2, 60000, '2025-01-10'),
(2, 'Riya', 'Electronics', 'Phone', 'Mumbai', 3, 30000, '2025-01-12'),
(3, 'Rahul', 'Furniture', 'Chair', 'Pune', 5, 5000, '2025-01-15'),
(4, 'Neha', 'Electronics', 'Laptop', 'Delhi', 1, 65000, '2025-02-05'),
(5, 'Karan', 'Furniture', 'Table', 'Chandigarh', 2, 12000, '2025-02-10'),
(6, 'Simran', 'Electronics', 'Phone', 'Mumbai', 4, 28000, '2025-02-18'),
(7, 'Vikas', 'Furniture', 'Chair', 'Delhi', 6, 4500, '2025-03-01'),
(8, 'Pooja', 'Electronics', 'Tablet', 'Pune', 2, 25000, '2025-03-10'),
(9, 'Aman', 'Electronics', 'Phone', 'Delhi', 2, 32000, '2025-03-15'),
(10, 'Riya', 'Furniture', 'Table', 'Mumbai', 3, 11000, '2025-03-20');

select salesperson, sum(quantity*price) from sales_data 
group by salesperson;

select department, sum(quantity*price) from sales_data 
group by department;

select salesperson, sum(quantity*price) as total_sales from sales_data
group by salesperson 
order by total_sales desc limit 1;

select city, sum(price*quantity) from sales_data 
group by city;

select department, avg(price) from sales_data 
group by department;

select department, max(quantity*price) from sales_data 
group by department;

select salesperson, department, total_sales 
from (select salesperson, department, sum(quantity*price) as total_sales from sales_data 
group by department, salesperson ) as s
where total_sales in (select max(total_sales) from 
(select department, salesperson,sum(quantity*price) as total_sales from sales_data 
group by salesperson, department ) as x 
where x.department=s.department 
group by department);


with sales as (select department, salesperson, sum(quantity*price ) as total_sales from sales_data 
group by department, salesperson ),
ranked as (select department,salesperson, total_sales ,
row_number() over(
partition by department
order by total_sales desc ) as rn from sales)
select department,salesperson,total_sales from ranked 
where rn=1;

WITH sales AS (SELECT department, salesperson, SUM(quantity * price) AS total_sales FROM sales_data
GROUP BY department, salesperson)
SELECT department, salesperson, total_sales FROM sales
WHERE (department, total_sales) IN (SELECT department, MAX(total_sales) FROM sales
GROUP BY department);

with sales as (select salesperson, sum(quantity*price) as total_sales from sales_data 
group by salesperson)
(select salesperson, total_sales from sales
where total_sales> (select avg(total_sales) from sales));

select city, sum(quantity*price) as total_sales from sales_data 
group by city
order by total_sales desc limit 1;

select city, sum(quantity*price) as total from sales_data 
group by city 
order by total desc limit 1 offset 1;

select salesperson, sum(quantity*price) as total from sales_data 
group by salesperson 
order by total desc limit 1 offset 1;

WITH sales AS (SELECT salesperson,SUM(quantity * price) AS total FROM sales_data
GROUP BY salesperson)
SELECT salesperson, total FROM ( SELECT *,DENSE_RANK() OVER(ORDER BY total DESC) AS rn FROM sales
) x
WHERE rn = 2;

select product, sum(quantity*price) as total from sales_data 
group by product 
order by total desc limit 1;

select salesperson,sum(quantity) as total from sales_data 
group by salesperson 
order by total desc limit 1;

select city, sum(quantity) as total from sales_data 
group by city 
order by total desc limit 1;

select salesperson, sum(quantity) as total from sales_data 
where department="electronics"
group by salesperson 
order by total desc limit 1;

select department, sum(quantity) as total from sales_data 
group by department 
order by total desc limit 1;

WITH sales AS (SELECT salesperson,city, SUM(quantity * price) AS total FROM sales_data
GROUP BY salesperson,city)
SELECT salesperson,city, total FROM ( SELECT *,DENSE_RANK() OVER(partition by city ORDER BY total DESC) 
AS rn FROM sales
) x
WHERE rn = 1;
















































































