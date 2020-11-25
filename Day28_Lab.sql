# Instructions

# Write the SQL queries to answer the following questions:


# Select the first name, last name, and email address of all the customers who have rented a movie.
select c.first_name, c.last_name, c.email, count(r.rental_id) as rentals
from customer c
inner join rental r on r.customer_id = c.customer_id
group by c.first_name, c.last_name, c.email
having count(r.rental_id) > 0
order by count(r.rental_id) desc;


# What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select c.customer_id, concat(c.first_name, " ", c.last_name) as customer_name, round(avg(p.amount),2) as avg_payment
from customer c
left join payment p on p.customer_id = c.customer_id
group by c.customer_id, concat(c.first_name, " ", c.last_name);


# Select the name and email address of all the customers who have rented the "Action" movies.

# Write the query using multiple join statements
select c.first_name, c.last_name, c.email
from customer c
left join rental r on r.customer_id = c.customer_id
left join inventory i on i.inventory_id = r.inventory_id
left join film_category fc on fc.film_id = i.film_id
left join category cat on cat.category_id = fc.category_id
where cat.name = "Action"
group by c.first_name, c.last_name, c.email
# having count(r.rental_id) > 0
order by last_name asc;


# Write the query using sub queries with multiple WHERE clause and IN condition
select c.first_name, c.last_name, c.email
from customer c
where customer_id in (
	select customer_id from rental
	where inventory_id in (
		select inventory_id from inventory
		where film_id in (
			select film_id from film_category
			where category_id in (
				select category_id from category
				where name = "Action"
))))
order by last_name asc;


# Verify if the above two queries produce the same results or not
same result


# Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select *,
case
when amount >=0 and amount <2 then 'low'
when amount >=2 and amount <4 then 'medium'
when amount >=4 then 'high'
else 'Check'
end as transaction_value
from payment;


select *,
case
when amount between 0 and 2 then 'low'
when amount between 2 and 4 then 'medium'
when amount >=4 then 'high'
else 'Check'
end as transaction_value
from payment;





