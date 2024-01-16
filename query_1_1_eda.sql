SELECT 
    COUNT(*) AS total_rentals,
    COUNT(DISTINCT(inventory_id)) AS total_inventories,
    COUNT(DISTINCT(customer_id)) AS total_customers
FROM 
    rental;