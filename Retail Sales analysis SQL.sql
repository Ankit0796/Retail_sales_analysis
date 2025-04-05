--Sql retail sales analysis - P1
create database Project_p1

use Project_p1


select * from retail_sales

--Data Cleaning

select * from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

select count(age) [Number] from retail_sales

select sum(age) [Sum] from retail_sales

select * into #1 from retail_sales


update #1 set age = (select AVG(age) from #1 where age is not null)
where age is null 

select * from #1

update retail_sales set age = (select AVG(age) from retail_sales where age is not null)
where age is null


delete from retail_sales 
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

select count(*) from retail_sales

--Data Exploration

select * from retail_sales

--How many sales we have

select COUNT(*) as Total_sales from retail_sales

--How many customers we have
select COUNT(distinct customer_id) as unique_Customers from retail_sales

select distinct category as unique_category from retail_sales

-- Data Analysis and Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales where sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales where category = 'Clothing' and quantiy >= 4 
and sale_date >= '2022-11-01' and sale_date < '2022-12-01'

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy < 10
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';


--Q.3 Write a SQL query to calculate the total sales (total_sale) and total orders for each category.

select category,sum(total_sale) [Sale], count (*) [Total Orders] from retail_sales group by category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) [Average age] from retail_sales where category = 'Beauty' 

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select transactions_id from retail_sales where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender,count(transactions_id) [Total Transaction] from retail_sales group by gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select FORMAT(Sale_date,'MMMM'), avg(total_sale) [Avg Total Sales] from retail_sales group by FORMAT(Sale_date,'MMMM') 

select year,month,avg_sales from (
select YEAR(sale_date) as year,MONTH(sale_Date) as month, avg(total_sale) as avg_sales,
DENSE_RANK() over (partition by YEAR(sale_date) order by avg(total_sale) desc) as DR 
from retail_sales 
group by YEAR(sale_date),MONTH(sale_Date)
--order by year,avg_sales desc
) as t1
where DR = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select * from
(
select customer_id,sum(total_sale) [Total Sale], DENSE_RANK() over (order by sum(total_sale) desc) as DR
from retail_sales group by customer_id
) as t2 where DR <=5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category, count( distinct customer_id) [Distinct Count] from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and 
--number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select * from retail_sales

with hourly_sales as(
select *,
	case
		when DATEPART(hour,sale_time)<12 then 'Morning'
		when DATEPART(hour,sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
) 
select 
	shift,
	count(*) as total_orders
from hourly_sales
group by shift

--End of Project