-- the company has two main concerns.
-- 1. Is Magist a good fit for high-end tech products? 2. Are orders delivered on time?

USE magist;

-- 1. In relation to the products.
-- 1.1 What categories of tech products does Magist have?
select distinct product_category_name_english as pro_cat from product_category_name_translation 
where product_category_name_english 
in ('audio', 'computers','computers_accessories','cds_dvds_musicals','consoles_games', 'dvds_blu_ray', 'electronics','home_appliances', 'home_appliances_2', 'housewares','music','others', 'pc_gamer','pcs', 'small_appliances','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','telephony','fixed_telephony');


-- 1.2 How many products of these tech categories have been sold? What percentage does that represent from the overall?
-- Count the number of TECH products which were sold by product_category_name.
-- How many products of these tech categories have been sold? 
select count(*), pc.product_category_name_english
from product_category_name_translation pc
right join 
products p on pc.product_category_name= p.product_category_name
right join order_items oi
on p.product_id= oi.product_id
right join order_payments op
on oi.order_id= op.order_id
group by pc.product_category_name_english having product_category_name_english in ('audio', 'computers','computers_accessories','cds_dvds_musicals','consoles_games', 'dvds_blu_ray', 'electronics','home_appliances', 'home_appliances_2', 'housewares','music','others', 'pc_gamer', 'small_appliances','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','telephony','fixed_telephony')
order by pc.product_category_name_english;  
-- 1.2 What percentage does that represent from the overall?

-- 1.3 What’s the average price of the products being sold?
select avg(price) as avg_price from order_items o
right join 
products p on o.product_id= p.product_id
right join product_category_name_translation pc
on p.product_category_name= pc.product_category_name;


-- 1.4 Are expensive tech products popular? 
select price, 
case 
when price<=50 then 'low price'
when price>50 and price<=100 then 'medium'
else 'expensive'
end as price_categories
from order_items o
right join products p on o.product_id= p.product_id
right join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where product_category_name_english in ('audio', 'computers','computers_accessories','cds_dvds_musicals','consoles_games', 'dvds_blu_ray', 'electronics','home_appliances', 'home_appliances_2', 'housewares','music','others', 'pc_gamer', 'small_appliances','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','telephony','fixed_telephony')
and price > 100;
#hence expensive products are popular(median of price is 98)

-- 2. In relation to the sellers:
-- 2.1 How many months of data are included in the magist database?
select month(order_estimated_delivery_date) as month_, year(order_estimated_delivery_date) as year_
from orders
group by month_,year_
order by year_; #27 months are included in the magist database

-- 2.2 How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
-- 2.2 How many sellers are there?
select count(distinct seller_id) from sellers; #3095 sellers
-- 2.2 How many Tech sellers are there?

select count(distinct s.seller_id)
from sellers s 
left join order_items oi on  s.seller_id =oi.seller_id
left join products p on oi.product_id= p.product_id
left join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where pc.product_category_name_english in ('audio', 'computers','computers_accessories','cds_dvds_musicals','consoles_games', 'dvds_blu_ray', 'electronics','home_appliances', 'home_appliances_2', 'housewares','music','others', 'pc_gamer', 'small_appliances','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','telephony','fixed_telephony'); 
#1149

-- 2.2 What percentage of overall sellers are Tech sellers?
#1149/3095=37.12

-- 2.3 What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
select sum(payment_value) from order_payments;
#16008872.139586091
-- 2.3 What is the total amount earned by all Tech sellers?
select sum(op.payment_value) from order_payments op 
right join order_items oi on op.order_id= oi.order_id
right join sellers s on oi.seller_id= s.seller_id
right join products p on oi.product_id= p.product_id
right join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where pc.product_category_name_english in ('audio', 'computers','computers_accessories','cds_dvds_musicals','consoles_games', 'dvds_blu_ray', 'electronics','home_appliances', 'home_appliances_2', 'housewares','music','others', 'pc_gamer', 'small_appliances','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','telephony','fixed_telephony'); 
#4941022.05263485


-- 2.4 Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
select avg(payment_value),month(o.order_delivered_customer_date) as month_ from order_payments op
join orders o on op.order_id= o.order_id
group by month_
order by avg(payment_value);
#154.527147 avg salary
-- 2.4 Can you work out the average monthly income of Tech sellers?
select avg(op.payment_value) as avg_salary,month(o.order_delivered_customer_date) as month_ from orders o
right join order_payments op on o.order_id= op.order_id
right join order_items oi on o.order_id= oi.order_id
right join products p on oi.product_id= p.product_id
right join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where pc.product_category_name_english in ('audio', 'computers','computers_accessories','cds_dvds_musicals','consoles_games', 'dvds_blu_ray', 'electronics','home_appliances', 'home_appliances_2', 'housewares','music','others', 'pc_gamer', 'small_appliances','small_appliances_home_oven_and_coffee','portable_kitchen_food_processors','telephony','fixed_telephony') 
group by month_
order by avg_salary;
#167.7682983 
-- 3. In relation to the delivery time:
-- 3.1 What’s the average time between the order being placed and the product being delivered?
select 
avg(timestampdiff(hour, order_purchase_timestamp, order_delivered_customer_date)) as avg_time
from orders;


-- 3.2 How many orders are delivered on time vs orders delivered with a delay?
select distinct count(*),
case 
when date(order_delivered_customer_date) <= date(order_estimated_delivery_date) then 'delivered_ontime'
when date(order_delivered_customer_date) > date(order_estimated_delivery_date) then 'not_delivered_ontime'
end as delivery_status
from orders
group by delivery_status;
#89810 delivered on time  6666 not delivered on time

-- 3.3 Is there any pattern for delayed orders, e.g. big products being delayed more often?

