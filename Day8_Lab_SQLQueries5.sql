#How many rentals were in the last month of activity?

SELECT
count(rental_id) as 'rentalslastmonthactivity'
FROM sakila.rental
WHERE rental_date > (select Date_sub(convert(max(rental_date), date),interval 1 MONTH) from sakila.rental);


SELECT
max(rental_date),
convert(max(SUBSTRING_INDEX(rental_date, ' ', 1)), date) as 'maxrentaldate_formated',
Date_sub(convert(max(SUBSTRING_INDEX(rental_date, ' ', 1)), date),interval 1 month) as 'lastmonthcutoff'
FROM sakila.rental;




SELECT
count(*),
max(r2.rental_date),
convert(max(SUBSTRING_INDEX(r2.rental_date, ' ', 1)), date) as 'maxrentaldate_formated',
Date_sub(convert(max(SUBSTRING_INDEX(r2.rental_date, ' ', 1)), date),interval 1 month) as 'lastmonthcutoff'
FROM sakila.rental r1
JOIN sakila.rental r2 on  r1.rental_id = r2.rental_id
#where r1.rental_date > (Date_sub(convert(max(SUBSTRING_INDEX(r2.rental_date, ' ', 1)), date),interval 1 month))
#where r1.rental_date > convert(max(SUBSTRING_INDEX(r2.rental_date, ' ', 1)), date)
having date(r1.rental_date) > lastmonthcutoff
WHERE r1.rental_date  > '2006-02-14';


select date(max(rental_date)) - INTERVAL 30 DAY, date(max(rental_date))
from sakila.rental;

select count(*)
from rental
where date(rental_date) between date(max(rental_date)) - INTERVAL 30 DAY and date(max(rental_date));

select count(*)
from rental
where date(rental_date) between date('2006-01-15') and date('2006-02-14');




#Drop column picture from staff.
alter table sakila.staff
drop column picture;



#A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
select * from STAFF;
select * from customer having last_name in ('Sanders');

insert into sakila.staff(first_name, last_name, email, address_id, store_id, username)
values ('Tammy','Sanders','TAMMY.SANDERS@sakilacustomer.org',79,2,'Tammy');



#Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.
insert into sakila.rental(rental_date, inventory_id, customer_id,staff_id)
values(CURDATE(),1,130,1);

/*

select *,
rental_id, rental_date, inventory_id, customer_id, return_date, last_update
from rental
having customer_id  = 130
order by last_update desc;

select *  from film having title = "Academy Dinosaur"; 
select *  from inventory having film_id = "1";
select * from customer where last_name = 'Hunter';

*/


#Deleted non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date the user was deleted.
drop table if exists sakila.deleted_users;

select * from sakila.deleted_users;
select * from customer;

CREATE TABLE sakila.deleted_users(
  customer_id smallint UNIQUE NOT NULL,
  email varchar(50) DEFAULT NULL,
  delete_date datetime DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (customer_id)  
);

#customer_id, email, deletion_date
insert into sakila.deleted_users(customer_id, email, delete_date)
select customer_id,email,curdate() from sakila.customer where active = 0
;

select *, curdate() from sakila.customer where active = 0;

