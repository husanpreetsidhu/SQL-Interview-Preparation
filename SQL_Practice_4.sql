#constraints ------> to restrict the type of data 
# not null constraint ---> not accept null values 

create table company_data(emp_id int not null , emp_name varchar(20), age int);
insert into company_data values(101,"alice",23);
insert into company_data values("david",24 );  #error
describe company_data; 

# how to add not null constraint to existing table
alter table company_data modify column 
emp_name varchar(20) not null ;
describe company_data;
insert into company_data values(102,24 );


#how to drop not null constraint 
alter table company_data modify column
emp_name varchar(20);

#unique--->it will not except duplicate values
create table order_record(order_id int,product_name varchar(20),city varchar(20),
constraint order_uni unique(order_id));
describe order_record;
insert into order_record values(11,"laptop","delhi");
insert into order_record values(11,"mobile","noida");
select*from order_record;



alter table order_record add constraint 
uni_product unique(product_name);
insert into order_record values(12,"mobile","noida");


#how to drop unique constraint
alter table order_record drop index uni_product;



#check constraint---> limit the value range range that can be placed in a column .

create table record(person_name varchar(20),age int , city varchar(20),constraint 
check_age_1 check (age>=21));
insert into record values("rohan",20,"delhi"),("alice",24,"delhi");


alter table record add constraint 
check_city check(city="delhi");

#drop check
alter table record drop check check_city;



create table sql_practice(stu_name varchar(20) ,stu_uid int not null , stu_marks int,
constraint sql_practice unique(stu_name));

insert into sql_practice values("alice",23132010,89),("rohan",23132011,87),("prince",23132011,84);


alter table sql_practice modify column
stu_uid int;
describe sql_practice;








