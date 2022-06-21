--Найти количество дочерних элементов первого уровня вложенности для категорий номенклатуры
--Adjacency List, id=619
SELECT * FROM category WHERE parent_id = 619;

--Найти количество дочерних элементов первого уровня вложенности для категорий номенклатуры
--Materialized Path, id=619
SELECT * FROM category WHERE path[:4] = ARRAY[3, 2, 1, 5] AND cardinality(path) = 5;

--Найти все древо подкатегорий для категории
--Adjacency List, id=42
WITH RECURSIVE nodes(id, parent_id, path, name) AS (
    SELECT s1.category_id, s1.name, s1.parent_id, s1.path
    FROM category s1 WHERE parent_id = 42
        UNION
    SELECT s2.category_id, s2.name, s2.parent_id, s2.path
    FROM category s2, nodes s1 WHERE s2.parent_id = s1.id
)
SELECT * FROM nodes
ORDER BY parent_id;

--Найти все древо подкатегорий для категории
--Materialized Path, id=42
SELECT * FROM category WHERE path[:3] = ARRAY[1, 1, 1] AND cardinality(path) > 3;

--Получение информации о сумме товаров заказанных под каждого клиента
SELECT c.name, SUM(o.order_sum)
FROM client c
JOIN "order" o USING(client_id)
GROUP BY c.name
ORDER BY 2 DESC;