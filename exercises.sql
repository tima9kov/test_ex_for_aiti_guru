-- 2.1. Сумма по клиентам

SELECT
    c.name AS client_name,
    SUM(oi.quantity * p.price) AS total_amount
FROM clients c
LEFT JOIN orders o ON o.client_id = c.id
LEFT JOIN order_items oi ON oi.order_id = o.id
LEFT JOIN products p ON oi.product_id = p.id
GROUP BY c.id, c.name
ORDER BY total_amount DESC;


--2.1. Найти количество дочерних элементов первого уровня вложенности для категорий номенклатуры.

WITH RECURSIVE all_categories AS (
    SELECT 
        id,
        name,
        parent_id,
        0 as level
    FROM categories 
    WHERE parent_id IS NULL
    
    UNION ALL

    SELECT 
        c.id,
        c.name,
        c.parent_id,
        ac.level + 1
    FROM categories c
    JOIN all_categories ac ON c.parent_id = ac.id
)
SELECT 
    name as category_name,
    (SELECT COUNT(*) FROM categories WHERE parent_id = all_categories.id) as children_count
FROM all_categories
ORDER BY level, name;
