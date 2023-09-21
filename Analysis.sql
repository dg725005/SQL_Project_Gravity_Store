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

/*(3) What is the percentage of every languages of total number of books?*/

select bl.language_name as Language,
       (count(bk.book_id)*100)/(select count(*) from book) as Percentage_of_Total
from 
book bk
join
book_language bl on bk.language_id = bl.language_id
group by 1
order by 2 desc;
 
 /*(4) Top 10 countries with highest revenue? Display revenue as well.*/

with cte as
(select cou.country_name as Country, ol.price as price
from
	order_line ol
    join
    cust_order co on ol.order_id = co.order_id
    join
    address ad on co.dest_address_id = ad.address_id
    join
    country cou on ad.country_id = cou.country_id)
select Country,sum(price) as Revenue
from cte
group by 1
order by 2 desc
limit 10;

/*(5) Who is the best selling author in terms of revenue?*/

select author_name, sum(price) as Total
from order_line ol
     join
     book bk on ol.book_id = bk.book_id
     join
     book_author ba on bk.book_id = ba.book_id
     join
     author aut on ba.author_id= aut.author_id
group by author_name
order by 2 desc
limit 1;

/*(6) Who is the best selling author in terms of unit sales?*/

select author_name, count(*) as Total
from order_line ol
     join
     book bk on ol.book_id = bk.book_id
     join
     book_author ba on bk.book_id = ba.book_id
     join
     author aut on ba.author_id= aut.author_id
group by author_name
order by 2 desc
limit 1;

/*(7) Top 3 authors by revenue of each country*/

select Country,Top_Author,total_rev,rnk as Rank_Number
from
(select country_name as Country,author_name as Top_Author,total_rev,dense_rank() over(partition by country_name order by total_rev desc) as rnk
from
(select c.country_name,aut.author_name,sum(ol.price) as total_rev
from country c
     join
     address ad on c.country_id = ad.country_id
     join
     cust_order co on ad.address_id = co.dest_address_id
     join
     order_line ol on co.order_id = ol.order_id
     join
     book bk on ol.book_id = bk.book_id
     join
     book_author ba on bk.book_id = ba.book_id
     join
     author aut on ba.author_id = aut.author_id
group by 1,2
order by 1,3 Desc)as t1)as t2
where rnk <=3;
     
/*(8) Which shipping methods mostly employed in decreasing order?*/     

select method_name as Method,
	   (count(order_id)*100)/(select count(*) from cust_order) as Percentage
from
	cust_order co
    join
    shipping_method sm on co.shipping_method_id = sm.method_id
group by Method
order by Percentage desc;    


