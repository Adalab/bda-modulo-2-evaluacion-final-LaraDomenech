# Evaluación Final Módulo 2 Lara Domènech 

USE sakila;

SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;
SELECT * FROM rental;
SELECT * FROM customer;
SELECT * FROM category;
SELECT * FROM inventory;
SELECT * FROM film_category;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title
FROM film
WHERE length > 120;

-- 5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.
SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name nombre, last_name apellido
FROM actor
WHERE last_name LIKE '%gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name nombre_actor
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
SELECT title pelicula
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT COUNT(*) total_peliculas, rating clasificacion
FROM film
GROUP BY clasificacion;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id ID_cliente, c.first_name nombre, c.last_name apellido, COUNT(r.rental_id) peliculas_alquiladas
FROM customer c 
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY ID_cliente
ORDER BY ID_cliente;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT ca.name categoria, COUNT(r.rental_id) peliculas_alquiladas
FROM rental r 
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category fc ON fc.film_id = i.film_id
JOIN category ca ON ca.category_id = fc.category_id
GROUP BY categoria
ORDER BY peliculas_alquiladas DESC;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating clasificacion, AVG(length) promedio_duracion
FROM film
GROUP BY clasificacion;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT a.first_name nombre, a.last_name apellido
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
WHERE f.title = 'Indian Love';

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title pelicula
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT a.first_name nombre, a.last_name apellido
FROM actor a 
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title pelicula
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title pelicula
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
WHERE name = 'Family';

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name nombre, a.last_name apellido, COUNT(f.title) numero_peliculas
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON f.film_id = fa.film_id
GROUP BY nombre, apellido
HAVING COUNT(f.title) > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title pelicula, rating clasificacion, length duracion
FROM film
WHERE rating = 'R' AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT ca.name categoria, AVG(f.length) promedio_duracion
FROM category ca
JOIN film_category fc ON ca.category_id = fc.Category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY categoria
HAVING promedio_duracion > 120
ORDER BY promedio_duracion;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT a.first_name nombre, COUNT(fa.film_id) numero_peliculas
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas 
-- correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)
SELECT DISTINCT f.title pelicula
FROM film f 
JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IN (
	SELECT r.inventory_id
	FROM rental r
	WHERE DATEDIFF(r.return_date, r.rental_date) > 5);
   
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría 
-- "Horror" y luego exclúyelos de la lista de actores.
SELECT a.first_name nombre, a.last_name apellido
FROM actor a 
WHERE a.actor_id NOT IN (
	SELECT DISTINCT fa.actor_id
	FROM film_actor fa
	JOIN film_category fc ON fa.film_id = fc.film_id
	JOIN category ca ON fc.category_id = ca.category_id
	WHERE name = 'Horror');

# BONUS
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.
SELECT f.title pelicula
FROM film f 
WHERE length > 180 AND f.film_id IN (
	SELECT fc.film_id
	FROM film_category fc
	WHERE fc.category_id IN (
		SELECT ca.category_id
		FROM category ca
		WHERE name = 'Comedy'));

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. 
-- Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un alias diferente.

SELECT a1.first_name nombre1, a1.last_name apellido1, a2.first_name nombre2, a2.last_name apellido2, COUNT(DISTINCT fa1.film_id) numero_peliculas
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE fa1.actor_id < fa2.actor_id
GROUP BY fa1.actor_id, fa2.actor_id;



