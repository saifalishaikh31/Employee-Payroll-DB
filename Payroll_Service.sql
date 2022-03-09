--UC1 Start
--Ability to create a payroll service database

create database payroll_service;

use payroll_service;

--UC1 End


--UC2 Start
--Ability to create a employee payroll table in the payroll service database to manage employee payrolls

create table employee_payroll
(
id int primary key identity(1,1),
name varchar(100),
salary decimal,
startdate Date,
);
--UC2 End


--UC3 Start
--Ability to create employee payroll data in the payroll service database as part of CURD Operation

insert into employee_payroll(name,salary,startdate)
values('John',50000,'2022-01-01'),
('Rachel',70000,'2022-03-03'),
('Terissa',40000,'2022-02-01'),
('Bill',60000,'2021-05-01'),
('Charlie',55000,'2021-07-01');

--UC3 End


--UC4 Start
--Ability to retrieve all the employee payroll data that is added to payroll service database

select * from employee_payroll;

--UC4 End


--UC5 Start
--Ability to retrieve salary data for a particular employee as well as all employees who have joined in a particular data range from the payroll service database

select salary from employee_payroll where name='Bill';

select * from employee_payroll where startdate between cast('2022-02-01' as date) AND cast(SYSDATETIME() as date);

--UC5 End

--UC6 Start
--Ability to add Gender to Employee Payroll Table and Update the Rows to reflect the correct Employee Gender

alter table employee_payroll add gender varchar(20);

update employee_payroll set gender='M' where name='Bill' or name='Charlie';

update employee_payroll set gender='F' where name='Rachel' or name='Terissa';

update employee_payroll set gender='M' where name='John';

--UC6 End


--UC7 Start
--Ability to find sum, average, min, max and number of male and female employees

select sum(salary) from employee_payroll where gender='F' group by gender; 
select sum(salary) from employee_payroll where gender='M' group by gender;

select avg(salary) from employee_payroll where gender='F' group by gender;
select avg(salary) from employee_payroll where gender='M' group by gender;

select max(salary) from employee_payroll where gender='F' group by gender;
select max(salary) from employee_payroll where gender='M' group by gender;

select min(salary) from employee_payroll where gender='F' group by gender;
select min(salary) from employee_payroll where gender='M' group by gender;

select count(salary) from employee_payroll where gender='F' group by gender;
select count(salary) from employee_payroll where gender='M' group by gender;

--UC7 End


--UC8 Start
--Ability to extend employee_payroll data to store employee information like employee phone, address and department

alter table employee_payroll add phonenumber varchar(50),address varchar(200) not null default 'Maharashtra',department varchar(50);

update employee_payroll set phonenumber='8756985643', department='Sales' where name='John';
update employee_payroll set phonenumber='9056923643', department='Marketing' where name='Rachel';
update employee_payroll set phonenumber='7756985643', department='Sales' where name='Terissa';
update employee_payroll set phonenumber='9956985643', department='HR' where name='Bill';
update employee_payroll set phonenumber='9156985643', department='Marketing' where name='Charlie';

select * from employee_payroll;
--UC8 End


--UC9 Start
--Ability to extend employee_payroll table to have Basic Pay, Deductions, Taxable Pay, Income Tax, Net Pay

alter table employee_payroll add BasicPay decimal, Deductions decimal, TaxablePay decimal, IncomeTax decimal, NetPay decimal;
 
 update employee_payroll set BasicPay=salary;

 alter table employee_payroll drop column salary;

 update employee_payroll set Deductions=2000 where name='John' or name='Charlie';
 update employee_payroll set Deductions=1500 where name='Rachel' or name='Terissa' or name='Bill';
 
 update employee_payroll set IncomeTax=250;
 update employee_payroll set TaxablePay=500;

 update employee_payroll set NetPay = (BasicPay-Deductions);

select * from employee_payroll;
--UC9 End

--UC10 Start
--Ability to make Terissa as part of Sales and Marketing Department

insert into employee_payroll(name,startdate,gender,phonenumber,department,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay)
values('Terissa','2021-08-02','F','7687653523','Marketing',50000,2000,500,250,47250);

select * from employee_payroll where name='Terissa';

--Normalization

create table employee_payroll_table
(
id int primary key identity(1,1),
name varchar(100),
startdate Date,
gender varchar(10),
phonenumber varchar(20),
address varchar(200)
);

select * from employee_payroll_table;

insert into employee_payroll_table(name,startdate,gender,phonenumber,address)
values('John','2022-01-01','M','9876543456','Pune'),
('Rachel','2022-03-03','F','7890876556','Mumbai'),
('Terissa','2022-02-01','F','8890987667','Kolhapur'),
('Bill','2021-05-01','M','7878654567','Pune'),
('Charlie','2021-07-01','M','9987654545','Nagpur');

insert into employee_payroll_table(name,startdate,gender,phonenumber,address)
values('Terissa','2021-05-01','F','8890987667','Kolhapur');



create table departmentdeatils(
DeptId int primary key identity(1,1),
DepartmentName Varchar(100),
id int FOREIGN KEY REFERENCES employee_payroll_table(id)
);

select * from departmentdeatils;

insert into departmentdeatils(DepartmentName,id)
values('Marketing',1);

insert into departmentdeatils(DepartmentName,id)
values('HR',2);

insert into departmentdeatils(DepartmentName,id)
values('Sales',3);

insert into departmentdeatils(DepartmentName,id)
values('Quality Analysis',4);

insert into departmentdeatils(DepartmentName,id)
values('HR',5);

insert into departmentdeatils(DepartmentName,id)
values('Marketing',6);

select name,startdate,gender,phonenumber,address,DepartmentName from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id;




create table SalaryDetails(
SalaryId int primary key identity(1,1),
BasicPay decimal,
Deductions decimal,
TaxablePay decimal,
IncomeTax decimal,
NetPay decimal,
id int FOREIGN KEY REFERENCES employee_payroll_table(id)
);

insert into SalaryDetails(BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,id)
values(50000,2000,200,500,48000,1);

insert into SalaryDetails(BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,id)
values(50000,500,200,500,49500,2);

insert into SalaryDetails(BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,id)
values(80000,3000,200,500,77000,3);

insert into SalaryDetails(BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,id)
values(50000,1000,200,500,49000,4);

insert into SalaryDetails(BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,id)
values(60000,500,200,500,59500,5);

insert into SalaryDetails(BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,id)
values(55000,1000,200,500,54000,6);


select employee_payroll_table.id,name,phonenumber,address,DepartmentName,gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,startdate from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id;

select * from SalaryDetails;
--UC10 End

--UC11 Start
--Implement the ER Diagram into Payroll Service DB

select sum(BasicPay) as Sum, gender from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id group by gender;

select avg(BasicPay) as AveragePay, gender from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id group by gender;

select max(BasicPay) as MaxPay, gender from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id group by gender;

select min(BasicPay) as MinPay, gender from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id group by gender;

select count(BasicPay) as Count, gender from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id group by gender;


--UC11 End


--UC12 Start
--Ensure all retrieve queries done especially in UC 4, UC 5 and UC 7 are working with new table structure

--UC4
select employee_payroll_table.id,name,phonenumber,address,DepartmentName,gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,startdate from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id;

--UC5
select BasicPay,name from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id where name='Bill';

select employee_payroll_table.id,name,phonenumber,address,DepartmentName,gender,BasicPay,Deductions,TaxablePay,IncomeTax,NetPay,startdate from employee_payroll_table inner join departmentdeatils on employee_payroll_table.id=departmentdeatils.id inner join SalaryDetails on employee_payroll_table.id=SalaryDetails.id where startdate between cast('2022-02-01' as date) AND cast(SYSDATETIME() as date);

--UC12 End