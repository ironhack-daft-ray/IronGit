################ Day 14 Labs #################

## Lab | SQL Rolling calculations

;
#1. Get number of monthly active customers.

DROP TEMPORARY TABLE IF EXISTS temp_currentcount; 

CREATE TEMPORARY TABLE temp_currentcount

select
#r.customer_id, r.rental_date,
date_format(convert(r.rental_date, date),'%y-%m') as "rentaldate_y_m",
count(distinct r.customer_id) as 'count_customers'
from rental r
group by date_format(convert(r.rental_date, date),'%y-%m') 
order by date_format(convert(r.rental_date, date),'%y-%m')  asc

;

select * from temp_currentcount;



#2. Active users in the previous month.


#Temp table to populate active customers from previous month for later join on same month
DROP TEMPORARY TABLE IF EXISTS temp_previouscount; 

CREATE TEMPORARY TABLE temp_previouscount

select
#r.customer_id, r.rental_date,
date_format(convert(r.rental_date + interval 1 Month, date),'%y-%m') as "rentaldate_y_m",
count(distinct r.customer_id) as 'count_customers_previous'
from rental r
group by date_format(convert(r.rental_date + interval 1 Month, date),'%y-%m')
order by date_format(convert(r.rental_date + interval 1 Month, date),'%y-%m')  asc

;

select * from temp_previouscount;

# joining the two temp tables 



select tmp1.rentaldate_y_m, tmp1.count_customers, tmp2.count_customers_previous
from temp_currentcount tmp1
left join temp_previouscount tmp2 on tmp2.rentaldate_y_m = tmp1.rentaldate_y_m
where tmp2.count_customers_previous is not null
;



#3. Percentage change in the number of active customers.

select tmp1.rentaldate_y_m, tmp1.count_customers, tmp2.count_customers_previous,
round((tmp1.count_customers-tmp2.count_customers_previous)/tmp2.count_customers_previous,2) as "% change"
from temp_currentcount tmp1
left join temp_previouscount tmp2 on tmp2.rentaldate_y_m = tmp1.rentaldate_y_m
where tmp2.count_customers_previous is not null;


#4. Retained customers every month.

select tmp1.rentaldate_y_m, tmp1.count_customers, tmp2.count_customers_previous,
round((tmp1.count_customers-tmp2.count_customers_previous)/tmp2.count_customers_previous,2) as "% change",
tmp1.count_customers-tmp2.count_customers_previous as "customer diff"
from temp_currentcount tmp1
left join temp_previouscount tmp2 on tmp2.rentaldate_y_m = tmp1.rentaldate_y_m
where tmp2.count_customers_previous is not null;