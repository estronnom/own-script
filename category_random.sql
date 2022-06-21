CREATE OR REPLACE procedure populate_category(a INTEGER)
AS $$
BEGIN
    FOR x in 1..a LOOP
        WITH random_id AS (
            SELECT random() * (SELECT MAX(category_id) FROM category)::INTEGER + 1 id
        )

        INSERT INTO category(parent_id, path, name)
        SELECT
            random_id.id,
            COALESCE(
                    ((SELECT path FROM category WHERE category_id = random_id.id) ||
                    (SELECT COUNT(path) FROM category WHERE parent_id = random_id.id) + 1),
                ARRAY[random_id.id]),
            encode(gen_random_bytes(18), 'base64')
        FROM random_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


