
############# Lab SQL 7 #############

#In the table actor, which are the actors whose last names are not repeated? For example if you would sort the data in the table actor by last_name, you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name. So we do not want to include this last name in our output. Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.
SELECT
first_name,last_name
FROM sakila.actor
group by last_name, first_name
Having last_name in (
	SELECT last_name
	FROM sakila.actor
	group by last_name
	having count(last_name) = 1
	)
ORDER BY last_name, first_name;




#Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
SELECT
first_name,last_name
FROM sakila.actor
group by last_name, first_name
Having last_name in (
	SELECT last_name
	FROM sakila.actor
	group by last_name
	having count(last_name) > 1
	)
ORDER BY last_name, first_name;


#Using the rental table, find out how many rentals were processed by each employee.
select staff_id, count(rental_id) as rentals_processed
from sakila.rental
group by staff_id
order by staff_id;


#Using the film table, find out how many films were released each year.
select release_year, count(film_id) as count_film
from sakila.film
group by release_year
order by release_year;


#Using the film table, find out for each rating how many films were there.
select rating, count(film_id) as count_rating
from sakila.film
group by rating
order by rating;


#What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
select rating, round(avg(length),2) as avg_filmlength
from sakila.film
group by rating
order by rating;


#Which kind of movies (rating) have a mean duration of more than two hours?
select rating, round(avg(length),2) as avg_filmlength
from sakila.film
group by rating
having avg_filmlength > 120
order by rating;



############# Lab SQL 8 #############


#Rank films by length (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, and the rank.
select title, length, rank() over (order by length desc) as 'rank'
from sakila.film
where length is not NULL and length <> 0;

#Rank films by length within the rating category (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, rating and the rank.
select title, length, rating, rank() over (partition by rating order by length desc) as 'rank'
from sakila.film
where length is not NULL and length <> 0;


#How many films are there for each of the categories in the category table. Use appropriate join to write this query
select * from film_category;

select c.category_id, c.name, count(fc.film_id) as count_film
from category c
inner join film_category fc on fc.category_id = c.category_id
group by c.category_id, c.name;



#Which actor has appeared in the most films?
select a.actor_id,a.first_name, a.last_name, count(fa.film_id) as count_film
from actor a
inner join film_actor fa on fa.actor_id = a.actor_id
group by a.actor_id, a.first_name, a.last_name
order by count_film desc;


#Most active customer (the customer that has rented the most number of films)
#Bonus: Which is the most rented film? The answer is Bucket Brotherhood This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.


