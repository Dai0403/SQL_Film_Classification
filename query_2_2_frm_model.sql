WITH 
joined AS(
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
   INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
),
scores AS(
SELECT 
    film_id, 
    NTILE(3) OVER (ORDER BY MIN(CURRENT_DATE - most_recent) DESC) AS r_score,
    NTILE(3) OVER (ORDER BY COUNT(rental_id)ASC) AS f_score,
    NTILE(3) OVER (ORDER BY SUM(rental_rate) ASC) AS m_score
FROM 
    joined
GROUP BY 
    film_id
)
SELECT 
    s.film_id,
    s.f_score,
    s.r_score,
    s.m_score,
    CAST(CONCAT(s.f_score, s.r_score, s.m_score) AS INT) AS frm_score
 FROM
    scores AS s
 ORDER BY
    frm_score DESC