EXPLAIN ANALYZE SELECT * FROM category WHERE parent_id = 619;

EXPLAIN ANALYZE SELECT * FROM category WHERE path[:4] = ARRAY[3, 2, 1, 5] AND cardinality(path) = 5;

EXPLAIN ANALYZE SELECT * FROM category WHERE path[:3] = ARRAY[1, 1, 1] AND cardinality(path) > 3;

EXPLAIN ANALYZE WITH RECURSIVE nodes(id, parent_id, path, name) AS (
    SELECT s1.category_id, s1.name, s1.parent_id, s1.path
    FROM category s1 WHERE parent_id = 42
        UNION
    SELECT s2.category_id, s2.name, s2.parent_id, s2.path
    FROM category s2, nodes s1 WHERE s2.parent_id = s1.id
)
SELECT * FROM nodes
order by parent_id;