############# Lab SQL Day 12 #############

##### Lab | SQL Subqueries


#How many copies of the film Hunchback Impossible exist in the inventory system?

select * from (
select f.title, count(i.inventory_id) as count_movies
from film f
join inventory i using (film_id)
where f.title like "%Hunchback Impossible%"
group by f.title) tb1;


#List all films whose length is longer than the average of all the films.

select * from(
select f.title, f.length
from film f
join inventory i using (film_id)
where f.length > (select avg(length) from film)
group by f.title, f.length
) tb2
limit 10;



#Use subqueries to display all actors who appear in the film Alone Trip.
select f.title, concat(a.first_name," ",a.last_name) as actor_name
from film f
left join inventory i using (film_id)
left join film_actor fa on fa.film_id = f.film_id
left join actor a on a.actor_id = fa.actor_id
where f.title in ('Alone Trip')
group by f.title, actor_name;

select concat(first_name , ' ' , last_name) as Actor
from sakila.actor
where actor_id in (
-- Grab the actor_ids for actors in Alone Trip
	select actor_id
	from sakila.film_actor
		where film_id = (
-- Grab the film_id for Alone Trip
			select film_id
			from sakila.film
			where title = 'ALONE TRIP'
)
);

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title
from film
where film_id in (
		select film_id
		from film_category
		where category_id = (
			select category_id
			from category
			where name in ('Family')
			)
		)
group by title
;


select f.title
from film f
left join inventory i on i.film_id = f.film_id
left join film_actor fa on fa.film_id = f.film_id
left join actor a on a.actor_id = fa.actor_id
left join film_category fc on fc.film_id = f.film_id
left join category c on c.category_id = fc.category_id
where c.name in ('Family')
group by f.title
;



#Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select first_name, last_name, email
from customer
where address_id in (
		select address_id
		from address
		where city_id in (
			select city_id
			from city
			where country_id in (
				select country_id
				from country
				where country = 'Canada'
				)
			)
		)
;


select cust.first_name, cust.last_name, cust.email
from film f
left join inventory i on i.film_id = f.film_id
left join film_actor fa on fa.film_id = f.film_id
left join actor a on a.actor_id = fa.actor_id
left join film_category fc on fc.film_id = f.film_id
left join category c on c.category_id = fc.category_id
left join rental r on r.inventory_id = i.inventory_id
left join customer cust on cust.customer_id = r.customer_id
left join address ad on ad.address_id = cust.address_id
left join country cntr on cntr.country_id = ad.address_id
where cntr.country in ('Canada')
group by cust.first_name, cust.last_name, cust.email
;





#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select title
from film
where film_id in (
	select film_id
	from film_actor
	where actor_id = (
		select actor_id
		from film_actor
		group by actor_id
		order by count(film_id) desc
		limit 1
		)
	)
;
	


#Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select title
from film
where film_id in (
	select film_id
	from inventory
	where inventory_id in (
		select inventory_id
		from rental
		where customer_id = (
			select customer_id
			from payment
			group by customer_id
			order by sum(amount) DESC
			limit 1
			)
		)
	)		
;





#Customers who spent more than the average payments.

select first_name, c.last_name, sum(p.amount) total_payments
from customer c
left join payment p on p.customer_id = c.customer_id
group by c.first_name, c.last_name
having total_payments > (
	select avg(amount)
	from payment
	)
;

