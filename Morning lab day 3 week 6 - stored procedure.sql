use sakila;

select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
  
  drop procedure if exists action_customers;
​
delimiter //
create procedure action_customers () -- Modifiying the arguments to INPUT parameters.
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
//
delimiter ;

call action_customers();

# Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string 
# argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action,
# animation, children, classics, etc.

drop procedure if exists action_customers;
​
delimiter //
create procedure action_customers (in param1 char(50)) 
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = param1
  group by first_name, last_name, email;
  
end;
//
delimiter ;

call action_customers('Action');

# Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories 
# that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

select count(film_id) from sakila.film_category group by category_id;

drop procedure if exists film_by_category;
​
delimiter //
create procedure film_by_category (in param1 tinyint) 
begin
  select count(film_id) from sakila.film_category 
  where category_id COLLATE utf8mb4_general_ci = param1
  group by category_id;
  
end;
//
delimiter ;

call film_by_category(3);

select category_id from sakila.film_category group by category_id;

select category_id from sakila.film_category where film_by_category>70;
select category_id from sakila.film_category group by category_id having count(film_id)>70;
select category_id from sakila.film_category group by category_id having film_by_category>70;

show procedure status;
show function status;

show procedure status where Db = 'sakila';

drop procedure if exists category_customer_param;

delimiter //
create procedure category_customer_param(in param1 int)
begin

select name, count(name) as n_movies
from film f 
join film_category fc using(film_id)
join category using(category_id)
group by name
having n_movies > param1;

end;
//
delimiter ;

call category_customer_param(60);


