SELECT 
    f.film_id, 
    f.title, 
    MAX(r.rental_date) OVER (PARTITION BY r.rental_date) AS most_recent, 
    r.rental_id, 
    f.rental_rate,
    i.inventory_id,
    f.rental_duration,
    date(r.return_date) - date(r.rental_date) AS rental_period
FROM 
    film AS f
 INNER JOIN inventory AS i ON i.film_id = f.film_id
 INNER JOIN rental AS r ON i.inventory_id = r.inventory_id;