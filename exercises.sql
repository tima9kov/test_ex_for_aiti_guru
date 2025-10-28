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

-- Вариант 1.
SELECT
    parent.name AS category_name,
    COUNT(child.id) AS children_count
FROM categories parent
LEFT JOIN categories child ON child.parent_id = parent.id
GROUP BY parent.id, parent.name
ORDER BY parent.name;

-- Вариант 2.

WITH RECURSIVE category_tree AS (
    SELECT 
        id,
        name,
        parent_id,
        0 as level
    FROM categories 
    
    UNION ALL
    
    SELECT 
        c.id,
        c.name,
        c.parent_id,
        ct.level + 1
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT 
    name as category_name,
    (SELECT COUNT(*) FROM categories WHERE parent_id = category_tree.id) as children_count
FROM category_tree
WHERE level = 0
ORDER BY name;
