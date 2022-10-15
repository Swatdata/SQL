/*

More advanced SQL

------------------------------------------------------------------------------------------------

HOW TO GET THE SCHEMA OF A DATABASE: 
* Windows/Linux: Ctrl + r
* MacOS: Cmd + r

*/

/**************************
***************************
CHALLENGES
***************************
**************************/

-- In SQL we can have many databases, they will show up in the schemas list
-- We must first define which database we will be working with
USE publications; 
 
/**************************
ALIAS
**************************/
-- https://www.w3schools.com/sql/sql_alias.asp

-- 1. From the sales table, change the column name qty to Quantity
Select qty as Quantity from sales;

-- 2. Assign a new name into the table sales. Select the column order number using the table alias
select ord_num from sales as sales_1;


/**************************
JOINS
**************************/
-- https://www.w3schools.com/sql/sql_join.asp

/* We will only use LEFT, RIGHT, and INNER joins this week
You do not need to worry about the other types for now */

-- LEFT JOIN example
-- https://www.w3schools.com/sql/sql_join_left.asp
SELECT *
FROM stores s
LEFT JOIN discounts d 
ON d.stor_id = s.stor_id;

-- RIGHT JOIN example
-- https://www.w3schools.com/sql/sql_join_right.asp
SELECT *
FROM stores s
RIGHT JOIN discounts d
ON d.stor_id = s.stor_id;

-- INNER JOIN example
-- https://www.w3schools.com/sql/sql_join_inner.asp
SELECT *
FROM stores s
INNER JOIN discounts d 
ON d.stor_id = s.stor_id;

-- 3. Using LEFT JOIN: in which cities has "Is Anger the Enemy?" been sold?
-- HINT: you can add WHERE function after the joins                         
select distinct(st.city) 
from titles as t 
left join 
sales as s on t.title_id= s.title_id
left join 
stores as st on s.stor_id= st.stor_id 
where t.title= "Is Anger the Enemy?";

-- 4. Using RIGHT JOIN: select all the books (and show their titles) that have a link to the employee Howard Snyder.
select t.title, e.fname, e.lname
from employee e right join titles t 
on e.pub_id= t.pub_id
where e.fname= 'Howard' and e.lname= 'Snyder';
-- 5. Using INNER JOIN: select all the authors that have a link (directly or indirectly) with the employee Howard Snyder
select a.au_lname, a.au_fname, e.fname, e.lname from 
authors as a 
inner join 
titleauthor as ta
on a.au_id = ta.au_id
inner join 
titles as t on ta.title_id = t.title_id
inner join 
publishers as p on t.pub_id= p.pub_id
inner join
employee as e on p.pub_id= e.pub_id
where e.fname= 'Howard' and e.lname= 'Snyder';

-- 6. Using the JOIN of your choice: Select the book title with higher number of sales (qty)
select t.title, sum(qty) from sales as s
join titles as t on t.title_id= s.title_id
group by t.title
order by sum(qty) desc
limit 1;
/**************************
CASE
**************************/
-- https://www.w3schools.com/sql/sql_case.asp

-- 7. Select everything from the sales table and create a new column called "sales_category" with case conditions to categorise qty
--  * qty >= 50 high sales
--  * 20 <= qty < 50 medium sales
--  * qty < 20 low sales
select 
*,
   case 
 when qty >= 50 then 'high sales'
 when qty<=20 and qty< 50 then 'medium sales'
 when qty<20 then 'low Sales'
 else 'nothing'
end as Sales_category
from sales;



-- 8. Adding to your answer from question 7. Find out the total amount of books sold (qty) in each sales category
-- i.e. How many books had high sales, how many had medium sales, and how many had low sales
select 
case 
when qty >= 50 then 'high sales'
when qty<20 then 'low Sales'
else 'medium sales'
end as Sales_category,
sum(qty)
from sales
group by Sales_category;

-- 9. Adding to your answer from question 8. Output only those sales categories that have a SUM(qty) greater than 100, and order them in descending order
select 
case 
when qty >= 50 then 'high sales'
when qty<20 then 'low Sales'
else 'medium sales'
end as Sales_category,
sum(qty)
from sales
group by Sales_category
having sum(qty)>100
order by sum(qty) desc;

-- 10. Find out thesum average book price, per publisher, for the following book types and price categories:
-- book types: business, traditional cook and psychology
-- price categories: <= 5 super low, <= 10 low, <= 15 medium, > 15 high
select pub_id,
case
when price<= 5 then 'super low'
when price<= 10 then 'low'
when price<= 15 then 'medium'
else 'high'
end as price_categories
from titles
where type in('business', 'traditional cook', 'psychology')
group by pub_id, price_categories;


