--Найти количество дочерних элементов первого уровня вложенности для категорий номенклатуры
--Adjacency List
SELECT COUNT(*) FROM category WHERE parent_id = :id;

--Найти количество дочерних элементов первого уровня вложенности для категорий номенклатуры
--Materialized Path
SELECT COUNT(*) FROM category WHERE path[:14] = ARRAY[1,1,3,1,1,2,1,1,2,2,1,1,1,1] AND cardinality(path) = 15;

--Найти все древо подкатегорий для категории
--Adjacency List
WITH RECURSIVE nodes(id, parent_id, path, name) AS (
    SELECT s1.category_id, s1.name, s1.parent_id, s1.path
    FROM category s1 WHERE parent_id = :id
        UNION
    SELECT s2.category_id, s2.name, s2.parent_id, s2.path
    FROM category s2, nodes s1 WHERE s2.parent_id = s1.id
)
SELECT * FROM nodes
ORDER BY path;

--Найти все древо подкатегорий для категории
--Materialized Path
EXPLAIN ANALYZE SELECT * FROM category WHERE path[:2] = ARRAY[1, 1] AND cardinality(path) > 2;

--Получение информации о сумме товаров заказанных под каждого клиента
SELECT c.name, SUM(o.order_sum)
FROM client c
JOIN "order" o USING(client_id)
GROUP BY c.name
ORDER BY 2 DESC;