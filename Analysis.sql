/*(1) What are the top 10 countries, majority of the customers are from?*/

select co.country_name as Country, count(c.customer_id) as Number_of_Customers
from customer c 
     join
     customer_address cad on c.customer_id = cad.customer_id
     join
     address ad on cad.address_id = ad.address_id
     join
     country co on ad.country_id = co.country_id
group by 1
order by 2 desc
limit 10;  

/*(2) Top 5 countries that ordered books with pages less than 100.*/  



select coun.country_name, count(*) as Number_of_Orders
from
	address addr
    join
    country coun on addr.country_id = coun.country_id
where addr.address_id in     
(select co.dest_address_id
from cust_order co
     join
     order_line ol on co.order_id = ol.order_id
where ol.book_id in     
					(select book_id
					from book
					where num_pages <=100))
group by 1
order by 2 Desc
limit 5;     

/*(3) */