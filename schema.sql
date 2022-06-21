CREATE TABLE IF NOT EXISTS category(
    category_id SERIAL,
    parent_id INTEGER REFERENCES category(category_id),
    path INTEGER[],
    name VARCHAR(128),
    PRIMARY KEY(category_id)
);

CREATE INDEX parent_id_btree ON category USING btree(parent_id);
--CREATE INDEX path_gin ON category USING gin(path);
