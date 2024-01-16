SELECT 
    COUNT(film_id) AS total_titles,
     MIN(rental_rate) AS min_rental_rate,
     MAX(rental_rate) AS max_rental_rate,
     ROUND(AVG(rental_rate),2) AS avg_rental_rate,
     MIN(rental_duration) AS min_rental_duration,
     MAX(rental_duration) AS max_rental_duration,
     ROUND(AVG(rental_duration), 2) AS avg_rental_duration
FROM
    film;