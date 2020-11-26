  #using the right database
  
  use sakila;
  
  
  #convert to stored procedure 
  
  drop procedure if exists proc_cust_action;
  
  delimiter //
  create procedure proc_cust_action()
  begin 
  	select first_name, last_name, email
  	from customer
  	join rental on customer.customer_id = rental.customer_id
  	join inventory on rental.inventory_id = inventory.inventory_id
  	join film on film.film_id = inventory.film_id
  	join film_category on film_category.film_id = film.film_id
  	join category on category.category_id = film_category.category_id
  	where category.name = "Action"
  	group by first_name, last_name, email;
  end;
  // delimiter;

  call proc_cust_action();

  
  
  #make it more dynamic - replace inactive with either active or inactive 


  drop procedure if exists proc_cust_action;
  
  delimiter //
  create procedure proc_cust_action(IN param2 varchar(25))
  begin 
  	select first_name, last_name, email, category.name
  	from customer
  	join rental on customer.customer_id = rental.customer_id
  	join inventory on rental.inventory_id = inventory.inventory_id
  	join film on film.film_id = inventory.film_id
  	join film_category on film_category.film_id = film.film_id
  	join category on category.category_id = film_category.category_id
  	where category.name = param2 
  	group by first_name, last_name, email, category.name;
  end;
  // delimiter;

  call proc_cust_action('Animation');
  
  
  
 #create a query with a count of films per category - we will later use this with a quantifiable parameter
  
drop procedure if exists proc_categorycount;

delimiter //
create procedure proc_categorycount(In param3 INT)  
begin
	select category.name, count(count_of_category) as category_counts
	from film
	join film_category using (film_id)
	join category using (category_id)
	join (select count(*) as count_of_category, category_id
	from film_category fc
	group by category_id)sub using (category_id)
	group by category.name
	having category_counts > param3;
 end;
 // #delimiter end
 
 call proc_categorycount(69)
