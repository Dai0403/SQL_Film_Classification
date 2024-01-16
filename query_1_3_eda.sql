SELECT 
    cat.name AS category, 
    COUNT(*) AS num_films
FROM 
    film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS cat ON fc.category_id = cat.category_id
GROUP BY 
    cat.name
ORDER BY 
    num_films DESC;