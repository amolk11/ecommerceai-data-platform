CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.aisles;
CREATE TABLE raw.aisles (
    aisle_id INTEGER,
    aisle TEXT
);

DROP TABLE IF EXISTS raw.departments;
CREATE TABLE raw.departments (
    department_id INTEGER,
    department TEXT
);

DROP TABLE IF EXISTS raw.orders;
CREATE TABLE raw.orders (
    order_id BIGINT,
    user_id BIGINT,
    eval_set VARCHAR,
    order_number INTEGER,
    order_dow INTEGER,
    order_hour_of_day INTEGER,
    days_since_prior_order DOUBLE PRECISION
);

DROP TABLE IF EXISTS raw.products;
CREATE TABLE raw.products (
    product_id INTEGER,
    product_name TEXT,
    aisle_id INTEGER,
    department_id INTEGER
);

DROP TABLE IF EXISTS raw.order_products_prior;
CREATE TABLE raw.order_products_prior (
    order_id BIGINT,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered INTEGER
);

DROP TABLE IF EXISTS raw.order_products_train;
CREATE TABLE raw.order_products_train (
    order_id BIGINT,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered INTEGER
);
