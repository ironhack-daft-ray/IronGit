######################### SQL JOIN LAB #########################

#List number of films per category.
select fc.category_id, c.name, count(fc.film_id) as count_film
from film_category fc
join category c on c.category_id = fc.category_id
group by c.category_id, c.name;

#Display the first and last names, as well as the address, of each staff member.
select s.first_name, s.last_name, ad.address
from staff s
join address ad on s.address_id = ad.address_id;

#Display the total amount rung up by each staff member in August of 2005.
select r.staff_id, count(rental_id) as count_sales
from rental r
where r.rental_date between '2005-05-01' and '2005-05-31'
group by r.staff_id;


#List each film and the number of actors who are listed for that film.
select fa.film_id, count(fa.actor_id) as count_actor
from film_actor fa
group by fa.film_id;


#Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
select c.customer_id, c.last_name, sum(p.amount) as total_amount
from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id, c.last_name;


######################### SQL JOINS ON MULTIPLE TABLES #########################


#Write a query to display for each store its store ID, city, and country.
select  st.store_id, ct.city, co.country
from store st
left join address ad on st.address_id = ad.address_id
left join city ct on ad.city_id = ct.city_id
left join country co on ct.country_id = co.country_id
group by st.store_id, ct.city, co.country;

#Write a query to display how much business, in dollars, each store brought in.
select  st.store_id, ct.city, co.country, sum(p.amount) as total_income
from store st
left join address ad on st.address_id = ad.address_id
left join city ct on ad.city_id = ct.city_id
left join country co on ct.country_id = co.country_id

left join staff s on st.store_id = s.staff_id
left join payment p on s.staff_id = p.staff_id

group by st.store_id, ct.city, co.country;



#What is the average running time of films by category?
select fc.category_id, c.name, round(avg(f.length),0) as avg_filmlength
from film_category fc
join category c on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.category_id, c.name;



#Which film categories are longest?
select fc.category_id, c.name, round(avg(f.length),0) as avg_filmlength
from film_category fc
join category c on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.category_id, c.name
order by avg_filmlength desc;

#Display the most frequently rented movies in descending order.
select f.title, count(rental_id) as rentals
from film f
left join inventory i on i.film_id = f.film_id
left join rental r on r.inventory_id = i.inventory_id
group by f.title
order by rentals desc;



#List the top five genres in gross revenue in descending order.
select c.category_id, c.name, sum(p.amount) as total_income
from payment p
left join rental r on p.rental_id = r.rental_id
left join inventory i on i.inventory_id = r.inventory_id
left join film_category fc on fc.film_id = i.film_id
left join category c on c.category_id = fc.category_id
group by c.category_id, c.name
order by total_income desc;




#Is "Academy Dinosaur" available for rent from Store 1?
select c.category_id, c.name, f.title, i.store_id
from payment p
left join rental r on p.rental_id = r.rental_id
left join inventory i on i.inventory_id = r.inventory_id
left join film_category fc on fc.film_id = i.film_id
left join category c on c.category_id = fc.category_id
left join film f on f.film_id = fc.film_id
where f.title = 'Academy Dinosaur'
group by c.category_id, c.name, f.title, i.store_id;









