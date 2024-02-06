-- 1.

SELECT film_id
FROM film
WHERE title = "Hunchback Impossible";

SELECT COUNT(film_id) AS num_copies
FROM inventory
WHERE film_id =
(SELECT film_id
FROM film
WHERE title = "Hunchback Impossible");

-- 2.

SELECT title, length
FROM film
WHERE length > (
SELECT AVG(length)
FROM film);

-- 3.

SELECT CONCAT(first_name, " ", last_name) AS alone_trip_actors
FROM actor
WHERE actor_id IN (
SELECT actor_id
FROM film_actor
WHERE film_id IN (
SELECT film_id
FROM film
WHERE title = "Alone Trip"
));

-- 4.

SELECT title
FROM film
WHERE film_id IN 
(SELECT film_id
FROM film_category
WHERE category_id IN 
(SELECT category_id
FROM category 
WHERE name = "Family"
));

-- 5.

SELECT CONCAT(first_name, " ", last_name) AS name, email
FROM customer
WHERE address_id IN
(SELECT address_id
FROM address
WHERE city_id IN
(SELECT city_id
FROM city
WHERE country_id IN
(SELECT country_id
FROM country
WHERE country = "Canada")));


SELECT CONCAT(first_name, " ", last_name) AS name, email
FROM customer
JOIN address 
ON customer.address_id = address.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id;

-- 6.

SELECT title
FROM film
WHERE film_id IN (
SELECT film_id
FROM film_actor
WHERE actor_id = (
SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1));

-- 7.

SELECT title
FROM film
WHERE film_id IN (
SELECT film_id
FROM inventory
WHERE inventory_id IN (
SELECT inventory_id
FROM rental
WHERE customer_id = (
SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1)));

-- 8. 

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
(SELECT COUNT(DISTINCT(customer_id)) FROM PAYMENT) / (SELECT SUM(amount) FROM PAYMENT));
 
