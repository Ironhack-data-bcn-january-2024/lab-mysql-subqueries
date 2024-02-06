-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

SELECT * from inventory WHERE film_id = 439;

-- 2. List all films whose length is longer than the average of all the films.

SELECT * FROM film;
	SELECT title
	FROM film
	WHERE length > 
(SELECT AVG(length) from film);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

SELECT 
    first_name, last_name, 
    film.film_id, 
    title
FROM actor
JOIN film_actor 
	ON film_actor.actor_id = actor.actor_id
JOIN film 
	ON film.film_id = film_actor.film_id
WHERE title = "Alone Trip";

SELECT 
    first_name, last_name
FROM actor

WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = ( SELECT film_id FROM film WHERE title = "Alone Trip")
);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT * FROM category
WHERE name Like "Family";

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT 
    first_name, email,
    country
FROM customer
JOIN address
	ON address.address_id = customer.customer_id
JOIN city
	ON city.city_id = address.city_id
JOIN country 
	ON country.country_id = city.country_id
WHERE country = "Canada";

-- Now it works.....!

SELECT 
    first_name, email
FROM customer

WHERE address_id IN 
(SELECT address_id FROM address WHERE city_id IN 
(SELECT city_id FROM city WHERE country_id = 
(SELECT country_id FROM country WHERE country = "Canada")));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT 
    first_name, last_name, COUNT(film_actor.actor_id) AS film_count
FROM actor
JOIN film_actor ON film_actor.actor_id = actor.actor_id
GROUP BY actor.actor_id, first_name, last_name
ORDER BY film_count DESC;


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT 
    customer.first_name, customer.last_name, customer.customer_id, SUM(amount) AS total_spent
FROM customer
JOIN payment
	ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_spent DESC;


SELECT customer.first_name, customer.last_name, customer.customer_id, SUM(amount) AS total_spent 
FROM customer
	JOIN payment ON payment.customer_id = customer.customer_id
WHERE customer.customer_id IN (SELECT DISTINCT customer.customer_id FROM payment)
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_spent DESC;

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

SELECT
    customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id

HAVING total_amount_spent > (SELECT AVG(total_amount_spent)
    FROM (SELECT customer_id, SUM(amount) AS total_amount_spent
	FROM payment
	GROUP BY customer_id) AS avg_table);
