/*

INTRODUCTION TO SQL

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
SELECT
**************************/
-- https://www.w3schools.com/sql/sql_select.asp

-- 1. Select everything from the table authors


-- 2. Select the authors first and last name


-- 3. Select the first name and the last name and merge them in one column by using the CONCAT() function 
-- https://www.w3schools.com/sql/func_mysql_concat.asp
-- remember that you have to separate the two columns by adding space 


-- 4. Select the distinct first names in authors
-- https://www.w3schools.com/sql/sql_distinct.asp
select * from authors;
select au_fname, au_lname from authors;
select concat(au_fname,' ',  au_lname) as full_name from authors;
select distinct au_fname from authors;

/**************************
WHERE
**************************/
-- https://www.w3schools.com/sql/sql_where.asp

-- 5. Select first and last name from authors who have the last name "Ringer"


-- 6. Select first and last name from authors whose last name is "Ringer" and fist name is "Anne"
-- https://www.w3schools.com/sql/sql_and_or.asp


-- 7. Select first name, last name, and city from authors whose city is "Oakland" or "Berkeley", and first name is "Dean"
-- HINT: parenthesis "()" can help


-- 8. Select first, last name, and city from authors whose city is "Oakland" or "Berkeley", and last name is NOT "Straight"

select au_fname, au_lname from authors where au_lname = "Ringer";
select au_fname, au_lname from authors where au_lname = "Ringer" and au_fname= 'Anne';
select au_fname, au_lname, city from authors where (city = 'Oakland' or city = 'Berkeley')and au_fname= "Dean";
select au_fname, au_lname, city from authors where (city = 'Oakland' or city = 'Berkeley')and au_lname != "Straight";

/**************************
ORDER BY
**************************/
-- https://www.w3schools.com/sql/sql_orderby.asp

-- 9. Select the title and ytd_sales from the table titles. Order them by the year to date sales in descending order

select title, ytd_sales from titles order by ytd_sales desc;
/**************************
LIMIT
**************************/
-- https://www.w3schools.com/mysql/mysql_limit.asp

-- 10. Select the top 5 titles with the most ytd_sales from the table titles
select title, ytd_sales from titles order by ytd_sales desc limit 5;

/**************************
MIN and MAX
**************************/
-- https://www.w3schools.com/sql/sql_min_max.asp

-- 11. Select the minimum and maximum quantity in table sales. 
select min(qty),max(qty) from sales;


/**************************
COUNT, AVG, and SUM
**************************/
-- https://www.w3schools.com/sql/sql_count_avg_sum.asp

-- 12. Select the count, average and sum of quantity in the table sales
select count(qty), avg(qty), sum(qty) from sales;


/**************************
LIKE
**************************/
-- https://www.w3schools.com/sql/sql_like.asp

/*
Here we will also learn to use some wild card characters
https://www.w3schools.com/sql/sql_wildcards.asp
You can ignore 'Wildcard Characters in MS Access'
You need to look at the section 'Wildcard Characters in SQL Server'
*/

-- 13. Select all books from the table title that contains the word "cooking"


-- 14. Select all books that have an "ing" in the title, with at least 4 other characters preceding it
-- for example 'cooking' has 4 characters before the 'ing', so this should be included
-- 'sewing' has only 3 characters before the 'ing', so this shouldn't be included
select * from titles 
where title like '%cooking%';
select * from titles 
where title like "%____ing%";

/**************************
IN
**************************/
-- https://www.w3schools.com/sql/sql_in.asp

-- 15. Select all the authors from the author table that do not come from the cities Salt Lake City, Ann Arbor, and Oakland.
select * from authors where city not in ('salt lake city', 'Ann Arbor',  'Oakland');


/*
The differences between IN, LIKE, and =

IN : takes many values to look for, such as a list of values, and does not work with the wildcards.
= : takes only one value to look for and does not work with wildcards.
LIKE: takes only one value to look for and works with wildcards. It is also case insentsitive
*/

/**************************
BETWEEN
**************************/
-- https://www.w3schools.com/sql/sql_between.asp

-- 16. Select all the order numbers with a quantity sold between 25 and 45 from the table sales
select ord_num, qty from sales where qty between '25' and '45';


-- 17. Select all the orders between 1993-03-11 and 1994-09-13
select * from sales where ord_date between '1993-03-11' and '1994-09-13';


/**************************
GROUP BY
**************************/
--  https://www.w3schools.com/sql/sql_groupby.asp

-- 18. Find the total amound of authors for each state 
select count(*), state from authors group by state;


-- 19. Find the total amount of authors by each state and order them in descending order
select count(*), state from authors group by state order by count(*) desc;

-- 20. Select the maximum price for each publisher id in the table titles.
select max(price), pub_id from titles group by pub_id;

-- 21. Find out the top 3 stores with the most sales
select stor_id, sum(qty) from sales 
group by stor_id order by sum(qty) desc 
limit 3;

/**************************
HAVING
**************************/
-- https://www.w3schools.com/sql/sql_having.asp

-- 22. Select, for each publisher, the total number of titles from each book type, with an average price higher than 12
select pub_id, count(title), type from titles group by pub_id,type having avg(price)>12; 

-- 23. Select, from each publisher, the total number of titles for each book type, with an average price higher than 12 and order them by the average price
select pub_id, count(title), type from titles group by pub_id,type having avg(price)>12 order by avg(price); 


-- 24. Select all the states and cities that have more than 1 contract
select sum(contract), state, city from authors group by state, city having sum(contract) >1 order by city;


/* 
The main difference between WHERE and HAVING is that:
the WHERE clause is used to specify a condition for filtering most records,
the HAVING clause is used to specify a condition for filtering values from an aggregate (such as MAX(), AVG(), COUNT() etc...)
 */

/**************************
FINAL CHALLENGES
**************************/

-- 25. Select the top 5 orders with most quantity sold between 1993-03-11 and 1994-09-13 from the table sales
select * from sales where ord_date between '1993-03-11' and '1994-09-13' order by qty desc limit 5;



-- 26. How many authors have an "i" in their first name, and have the state UT, MD, or KS
select count(*) from authors where au_fname like '%i%' and state in ('UT','MD', 'KS') ;

-- 27. In California, how many authors are there in cities that contain an "o" in the name?
-- Show only results for cities with more than 1 author.
--  Sort the cities ascendingly by author count.
select count(au_fname),city from authors where city like '%o%' and state = 'CA'  group by  city having count(au_fname)>1 order by count(au_fname) asc ;