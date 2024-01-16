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
scores AS (
  SELECT 
      film_id,
      NTILE(3) OVER (ORDER BY COUNT(rental_id)ASC) AS f_score,
      NTILE(3) OVER (ORDER BY MIN(CURRENT_DATE - most_recent) DESC) AS r_score,
      NTILE(3) OVER (ORDER BY SUM(rental_rate) ASC) AS m_score
 FROM 
      joined
 GROUP BY 
      film_id
),
frm AS (
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
)
SELECT 
     j.film_id,
     j.title,
     frm.frm_score,
     case 
         WHEN frm_score IN (333, 332, 323, 322, 233) THEN 'Blockbusting'
         WHEN frm_score IN (313, 311, 312, 223, 222, 213,212) THEN 'Regular Hit'
         WHEN frm_score IN (331, 321, 232, 221) THEN 'Niche Pop'
         WHEN frm_score IN (231, 133, 132, 131, 123) THEN 'Emerging Trend'
         ELSE  'Promo Focus' END AS classification,
     cat.name AS category,
     j.rental_rate,
     SUM(j.rental_rate) AS total_rate,
     COUNT(DISTINCT(j.rental_id)) AS total_rentals,
     COUNT(DISTINCT(j.inventory_id)) AS inventory,
     j.rental_duration AS set_duration,
     ROUND(AVG(j.rental_period),2)AS avg_actual_rental_period,
     CASE 
         WHEN j.rental_duration - AVG(j.rental_period) <=0 THEN 'yes'
         ELSE 'no' END AS likely_late
FROM 
     frm 
INNER JOIN joined AS j ON frm.film_id = j.film_id
INNER JOIN film_category AS fc ON j.film_id = fc.film_id
INNER JOIN category AS cat ON fc.category_id = cat.category_id
GROUP BY  
    j.film_id,
    j.title,
    frm.frm_score,
    cat.name,
    j.rental_rate,
    j.rental_duration
ORDER BY 
    frm_score DESC