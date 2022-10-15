select count(count_id) from orders;
select count(order_id), order_status from orders
group by order_status;
select count(order_id), year(order_purchase_timestamp)as years, month(order_purchase_timestamp) as months from orders
group by years, months
order by years, months;
select count(distinct product_id)as no_of_products from products;
select count(distinct product_id), product_category_name from products
group by product_category_name
order by count(product_id) desc;
select count(p.product_id) from products p
left join order_items o
on p.product_id= o.product_id; #or i have a doubt
select count(distinct product_id) from order_items;
select max(price)as exp_price, min(price) as cheap_price from order_items;
select min(payment_value) as lowest, max(payment_value) as highest from order_payments; 
