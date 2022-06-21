CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE procedure populate_category(a INTEGER)
AS $$
DECLARE
    random_id INTEGER;
BEGIN
    INSERT INTO category(path, name) VALUES
    (ARRAY[1], 'FIRST'),
    (ARRAY[2], 'SECOND'),
    (ARRAY[3], 'THIRD');
    FOR x in 1..a LOOP
        SELECT random() * (SELECT MAX(category_id) FROM category)::INTEGER + 1 id
        INTO random_id;
        INSERT INTO category(parent_id, path, name)
            SELECT
                random_id,
                array_append((SELECT path FROM category WHERE category_id = random_id),
                    (SELECT COUNT(path) FROM category WHERE parent_id = random_id) + 1),
                encode(gen_random_bytes(18), 'base64');
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL populate_category(100);
