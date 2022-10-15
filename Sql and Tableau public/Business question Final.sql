-- the company has two main concerns.
-- 1. Is Magist a good fit for high-end tech products? 2. Are orders delivered on time?

USE magist;

-- 1. In relation to the products.
-- 1.1 What categories of tech products does Magist have?

select distinct product_category_name_english as pro_cat from product_category_name_translation 
where product_category_name_english 
in ('audio', 'computers','computers_accessories','consoles_games', 'pc_gamer', 'telephony', 'tablets_printing_image');
-- Creat TECH_IF categories. 
SELECT 
    p.product_category_name,
    CASE
        WHEN p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem') THEN 'TECH'
        ELSE 'NON_TECH'
    END AS 'TECH_IF'
FROM
    order_items oi
        JOIN
    products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name;

# How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products so

 #final tech products sold
select count(order_item_id)
from product_category_name_translation pc
join 
products p on pc.product_category_name= p.product_category_name
join order_items oi
on p.product_id= oi.product_id
join order_payments op
on oi.order_id= op.order_id
where product_category_name_english in ('audio', 'computers','computers_accessories','consoles_games', 'pc_gamer', 'telephony', 'tablets_printing_image');  
#o/p: 14691 tech products being sold
 SELECT
    COUNT(order_item_id)
FROM
    order_items oi
        JOIN
    products p ON oi.product_id = p.product_id
WHERE
    p.product_category_name IN
     (
    'informatica_acessorios',
    'telefonia',
    'consoles_games',
    'audio',
    'pc_gamer', 
    'pcs',
    'tablets_impressao_imagem'

);

#total products
select count(order_item_id) from order_items;
#112650 total order


#percentage
# tech_products/ total products*100= 14691/112650*100= 13.04%


-- 1.3 What’s the average price of the products being sold?
#final this too
select avg(price) as avg_price from order_items o
right join 
products p on o.product_id= p.product_id
right join product_category_name_translation pc
on p.product_category_name= pc.product_category_name;
#120.65373


-- 1.4 Are expensive tech products popular
select price, 
case 
when price<=50 then 'low price'
when price>50 and price<=100 then 'medium'
else 'expensive'
end as price_categories
from order_items o
right join products p on o.product_id= p.product_id
right join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where product_category_name_english in ('audio', 'computers','computers_accessories','consoles_games', 'pc_gamer', 'telephony', 'tablets_printing_image')
and price > 100;
#hence expensive products are popular(median of price is 98

select price from order_items o
inner join 
products p on o.product_id= p.product_id
inner join product_category_name_translation pc
on p.product_category_name= pc.product_category_name
where product_category_name_english in ('audio', 'computers','computers_accessories','consoles_games', 'pc_gamer', 'telephony', 'tablets_printing_image');

-- 2. In relation to the sellers:
-- 2.1 How many months of data are included in the magist database?

select month(order_estimated_delivery_date)as month_,year(order_estimated_delivery_date) as year_
from orders
group by month_,year_
order by year_; #27 months are included in the magist database

-- 2.2 How many sellers are there?
select count(distinct seller_id) from sellers; #3095 sellers
-- 2.2 How many Tech sellers are there?

select count(distinct s.seller_id)
from sellers s 
left join order_items oi on  s.seller_id =oi.seller_id
left join products p on oi.product_id= p.product_id
left join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where pc.product_category_name_english in ('audio', 'computers','computers_accessories','consoles_games', 'pc_gamer', 'telephony', 'tablets_printing_image');
#415

-- 2.2 What percentage of overall sellers are Tech sellers?
#415/3095= 13.408

-- 2.3 What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
select sum(payment_value) from order_payments;
#16008872.139586091

select sum(op.payment_value) from order_payments op 
right join order_items oi on op.order_id= oi.order_id
right join sellers s on oi.seller_id= s.seller_id
right join products p on oi.product_id= p.product_id
right join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where pc.product_category_name_english in ('audio', 'computers','computers_accessories','consoles_games', 'pc_gamer', 'telephony', 'tablets_printing_image');
#2619356.4055730924
-- 2.4 Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
-- 2.4 Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
SELECT
    SUM(op.payment_value)/(25*3095)
FROM
    order_payments op;-- ANSWER: Average monthly income of all sellers caculated: 206.8998014809188. 

SELECT
    SUM(op.payment_value)/(25*415)
FROM
    order_payments op
        JOIN
    orders o ON op.order_id = o.order_id
        JOIN
    order_items oi ON o.order_id = oi.order_id
        JOIN
    products p ON oi.product_id = p.product_id
WHERE 
p.product_category_name IN ('audio', 'consoles_games', 'informatica_acessorios', 'pc_gamer', 'pcs', 'telefonia', 'tablets_impressao_imagem');
-- ANSWER: Average monthly income of TECH sellers caculated: 252.47. 
-- ANSWER: the average time between the order being placed and the product being delivered is 300.9438h.
select avg(payment_value)from order_payments;
#154.527147 avg salary of all sellers

select avg(payment_value) from order_payments op
join order_items oi on op.order_id= oi.order_id
join products p on oi.product_id= p.product_id
right join product_category_name_translation pc on p.product_category_name= pc.product_category_name
where pc.product_category_name_english in ('audio', 'computers','computers_accessories','consoles_games', 'pc_gamer', 'telephony', 'tablets_printing_image');
#178.296671


-- 3. In relation to the delivery time:
-- 3.1 What’s the average time between the order being placed and the product being delivered?
select 
avg(timestampdiff(day, order_purchase_timestamp, order_delivered_customer_date)) as avg_time
from orders;
#300 hours ->12.09 days
-- 3.2 How many orders are delivered on time vs orders delivered with a delay?
select count(order_delivered_customer_date),
case 
when date(order_delivered_customer_date) <= date(order_estimated_delivery_date) then 'delivered_ontime'
when date(order_delivered_customer_date) > date(order_estimated_delivery_date) then 'not_delivered_ontime'
end as delivery_status
from orders
group by delivery_status;
#89810 delivered on time  6666 not delivered on time

-- 3.3 Is there any pattern for delayed orders, e.g. big products being delayed more often?
select distinct pc.product_category_name_english, round(avg(timestampdiff(day, order_purchase_timestamp, order_delivered_customer_date))) as diff_deliver from orders o
right join order_payments op on o.order_id= op.order_id
right join order_items oi on o.order_id= oi.order_id
right join products p on oi.product_id= p.product_id
right join product_category_name_translation pc on p.product_category_name= pc.product_category_name
group by pc.product_category_name_english 
order by pc.product_category_name_english;



select distinct count(*),
case 
when date(order_delivered_customer_date) <= date(order_estimated_delivery_date) then 'delivered_ontime'
when date(order_delivered_customer_date) > date(order_estimated_delivery_date) then 'not_delivered_ontime'
end as delivery_status, pc.product_category_name_english
from orders o
join order_payments op on o.order_id= op.order_id
join order_items oi on o.order_id= oi.order_id
join products p on oi.product_id= p.product_id
join product_category_name_translation pc on p.product_category_name= pc.product_category_name
group by delivery_status, pc.product_category_name_english 
order by delivery_status;

#other way
SELECT DISTINCT
    AVG(TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date)),
    COUNT(TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date)),
    pt.product_category_name_english,
    AVG(p.product_weight_g),
    AVG(p.product_length_cm),
    AVG(p.product_height_cm),
    AVG(p.product_width_cm)
FROM
    orders o 
        JOIN
    order_items oi ON o.order_id = oi.order_id
        JOIN
    products p ON oi.product_id = p.product_id
        JOIN
    product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE TIMESTAMPDIFF(DAY, order_delivered_customer_date, order_estimated_delivery_date) < 0
GROUP BY 3
ORDER BY 2 DESC;
-- ANSWER: pattern for delayed orders calculated.

