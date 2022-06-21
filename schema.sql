CREATE TABLE category(
    category_id SERIAL,
    parent_id INTEGER REFERENCES category(category_id),
    path INTEGER[],
    name VARCHAR(128),
    PRIMARY KEY(category_id)
)