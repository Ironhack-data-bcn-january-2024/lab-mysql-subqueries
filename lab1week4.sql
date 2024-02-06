USE sakila;

-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT * FROM inventory
WHERE film_id in

(SELECT film_id FROM film
WHERE title = 'Hunchback Impossible');

-- 2.List all films whose length is longer than the average of all the films.

SELECT * FROM film

WHERE length > (SELECT AVG(length) FROM film);

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.

SELECT CONCAT(first_name, " ", last_name) FROM actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor
	WHERE film_id in
		(SELECT film_id FROM film
		WHERE title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT *
FROM film
WHERE film_id IN
  (SELECT film_id
   FROM film_category
   WHERE category_id IN
     (SELECT category_id
      FROM category
      WHERE name = 'Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email FROM customer
WHERE address_id in
	(SELECT address_id FROM address
    WHERE city_id in
		(SELECT city_id FROM city
		WHERE country_id in
			(SELECT country_id FROM country
            WHERE country = 'Canada')));
            
SELECT first_name, last_name, email 
FROM customer
JOIN 
address
ON
customer.address_id = address.address_id
JOIN
city
ON
address.city_id = city.city_id
JOIN
country
ON
city.country_id = country.country_id
WHERE country = 'Canada';            
            
            
            
            
            
-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT title FROM film
WHERE film_id IN 
	(SELECT actor_id FROM film_actor
    WHERE actor_id IN
			
            
            (SELECT COUNT(actor_id) AS actor_id
			FROM film_actor
			WHERE actor_id = actor_id
			GROUP BY actor_id
			ORDER BY actor_count DESC LIMIT 1));

-- 7.Films rented by most profitable customer.
--  You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT title FROM film
WHERE film_id IN
	(SELECT film_id FROM inventory
    WHERE inventory_id in
		(SELECT inventory_id FROM rental
        WHERE customer_id IN
			(SELECT customer_id FROM customer
            WHERE customer_id IN

			(select customer_id from
				(SELECT sum(amount) AS total, customer_id
				FROM payment
				group by customer_id
				order by customer_id DESC LIMIT 1) as ola))));
                
-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT customer_id, SUM(amount) AS total_amount_spent

 