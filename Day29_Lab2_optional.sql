# Instructions

# Write queries to answer the following questions:

# Write a query to find what is the total business done by each store.
select s.store_id, round(sum(p.amount),0) as 'sales_amount'
from store s
join inventory i on i.store_id = s.store_id
join rental r on r.inventory_id = i.inventory_id
join payment p on  p.rental_id = r.rental_id
group by s.store_id;



# Convert the previous query into a stored procedure.
drop procedure if exists proc_sales_store

delimiter //
create procedure proc_sales_store()
begin 
  	select s.store_id, round(sum(p.amount),0) as 'sales_amount'
	from store s
	join inventory i on i.store_id = s.store_id
	join rental r on r.inventory_id = i.inventory_id
	join payment p on  p.rental_id = r.rental_id
	group by s.store_id;
end
// delimiter;

call proc_sales_store();


# Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists proc_sales_store

delimiter //
create procedure proc_sales_store(In param_store int (1))
begin 
  	select s.store_id, round(sum(p.amount),0) as 'sales_amount'
	from store s
	join inventory i on i.store_id = s.store_id
	join rental r on r.inventory_id = i.inventory_id
	join payment p on  p.rental_id = r.rental_id
	where s.store_id = param_store
	group by s.store_id;
end
// delimiter;

call proc_sales_store(2);


# Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

#### NOT SURE OF WHAT IS NEEDED HERE. TO ASK FOR EXPLANATIONS




# In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
drop procedure if exists proc_sales_store

delimiter //
create procedure proc_sales_store(In param_store int (1))
begin
  	select s.store_id, round(sum(p.amount),0) as 'sales_amount'
  	case
  	when sum(p.amount) > 30000 then "green_flag"
  	else "red_flag"
  	end as sales_flag
	from store s
	join inventory i on i.store_id = s.store_id
	join rental r on r.inventory_id = i.inventory_id
	join payment p on  p.rental_id = r.rental_id
	where s.store_id = param_store
	group by s.store_id;
end
// delimiter;

call proc_sales_store(2);



