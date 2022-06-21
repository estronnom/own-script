CREATE TABLE IF NOT EXISTS category(
    category_id SERIAL,
    parent_id INTEGER REFERENCES category(category_id),
    path INTEGER[],
    name VARCHAR(128),
    PRIMARY KEY(category_id)
);

CREATE INDEX IF NOT EXISTS parent_id_btree ON category USING btree(parent_id);
--CREATE INDEX path_gin ON category USING gin(path);

CREATE TABLE IF NOT EXISTS good(
  good_id SERIAL,
  category_id INTEGER REFERENCES category(category_id) NOT NULL,
  name VARCHAR(255) NOT NULL,
  price REAL,
  quantity INTEGER,
  PRIMARY KEY(good_id)
);

CREATE TABLE IF NOT EXISTS client(
  client_id SERIAL,
  name VARCHAR(64) NOT NULL,
  client_address VARCHAR(512),
  client_phone VARCHAR(16),
  PRIMARY KEY(client_id)
);

CREATE TABLE IF NOT EXISTS "order"(
  order_id SERIAL,
  client_id INTEGER REFERENCES client(client_id) NOT NULL,
  order_sum REAL,
  order_address VARCHAR(512),
  order_phone VARCHAR(16),
  PRIMARY KEY(order_id)
);

CREATE TABLE IF NOT EXISTS good_order(
    good_order_id SERIAL,
    good_id INTEGER REFERENCES good(good_id) NOT NULL,
    order_id INTEGER REFERENCES "order"(order_id) NOT NULL,
    PRIMARY KEY(good_order_id)
);
