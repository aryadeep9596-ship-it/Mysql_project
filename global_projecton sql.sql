create database Globalstore;

use globalstore;

select * from global_superstore3;

select * from global_superstore3
where Sales is null
or Profit is null;

-- Remove duplicates
select Row_ID, count(*)
from global_superstore3
group by Row_ID
having count(*)>1;


-- EDA
-- total sales & profit analysis

select sum(Sales) as total_sales,
sum(profit) as total_profit
from global_superstore3;

select Region, sum(Sales) as total_Sales
from global_superstore3
group by Region
order by total_sales;

select Category, sum(Sales) as total_sales
from global_superstore3
group by Category
order by total_sales;

-- top 10 customer
select Customer_Name, sum(Sales) as Total_spent
from global_superstore3
group by Customer_Name
order by Total_spent desc limit 10;

-- top 10 product
select Product_Name, sum(Sales) as total_sales
from global_superstore3
group by Product_Name
order by total_Sales desc limit 10;

-- Monthly sales
select date_format(Order_Date,"%Y-%m") as Month,
sum(Sales) as Monthly_sales from global_superstore3
group by Order_Date
order by Month;

-- Loss making product
select Product_Name, sum(Profit) as total_profit
from global_superstore3
group by Product_Name
having total_profit <0
order by total_profit;

-- discount impact on profit
select Discount, avg(Profit) as avg_profit
from global_superstore3
group by Discount
order by Discount;

-- ship mode analysis
select Ship_Mode, sum(Sales) as sale,
sum(profit) as profit from global_superstore3
group by Ship_Mode;

-- window function
select Category,Product_Name,
row_number() over(partition by Category) as row_num
from global_superstore3;

-- ranking top prodcuts
select Product_Name, sum(Sales) as total_sales,
rank() over(partition by sum(Sales)) as rank_no
from global_superstore3
group by Product_Name;

select order_date,
sum(Sales) as daily_sales,
sum(sum(Sales)) over(order by Order_Date) as Running_total
from global_superstore3
group by Order_Date;

-- profit percentage

select round(sum(Profit)/sum(Sales) 
*100) as profit_percentage
from global_superstore3;

-- Above average sales orders
select * from global_superstore3
where Sales > (select avg(Sales)
from global_superstore3);

-- top selling product
select Product_Name from global_superstore3
group by Product_Name
having sum(Sales) = (select max(total_Sales) from(select Product_Name, sum(Sales) as total_Sales
from global_superstore3
group by Product_Name) as whole_sale );

-- Customers Who Spent More Than Average Customer Spending

select Customer_Name from
global_superstore3
group by Customer_Name
having sum(Sales) > (select avg(customer_total) from
(select sum(Sales) as customer_total
from  global_superstore3 
group by Customer_Name) as avg_table);

-- product making loss
select Product_Name from global_superstore3
where Product_Name in (select Product_Name from global_superstore3
group by Product_Name
having sum(Profit)<0);

-- Region with highest sales

select Region from global_superstore3
group by Region
having sum(Sales) = (select max(region_sales) from
(select sum(Sales) as region_sales
from global_superstore3
group by Region) as all_region);

-- Orders Placed After Customer's First Order
select * from
global_superstore3 as s1
where Order_Date >(select min(Order_date) from global_superstore3 as s2
where s1.Customer_ID = s2.Customer_ID);

-- Find Customers Who Bought Same Product Multiple Times
select Customer_Name, Product_Name
from global_superstore3
group by Customer_Name,Product_Name
having count(Order_ID)>1;






-- West region generated highest sales.
-- Technology category most profitable.
-- High discount products show lower profit margin.
-- Few products consistently generate losses.
-- Top 10 customers contribute major revenue share.

-- I analyzed a retail global_superstore dataset using SQL. I performed sales and profit analysis, identified top customers and products, 
-- analyzed regional performance, and used window functions for ranking and running totals to generate business insights.










