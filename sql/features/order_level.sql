DROP TABLE IF EXISTS features.order_level;

CREATE TABLE features.order_level AS

SELECT
    order_id,
    user_id,

    MAX(order_number) AS order_number,
    MAX(order_dow) AS order_dow,
    MAX(order_hour_of_day) AS order_hour_of_day,
    MAX(days_since_prior_order) AS days_since_prior_order,

    COUNT(*) AS basket_size,

    COUNT(DISTINCT product_id) AS unique_products,

    COUNT(DISTINCT department) AS unique_departments,

    COUNT(DISTINCT aisle) AS unique_aisles,

    SUM(reordered) AS reorder_count,

    AVG(reordered::FLOAT) AS reorder_ratio

FROM staging.order_items

GROUP BY
    order_id,
    user_id;

CREATE INDEX idx_order_level_user
ON features.order_level(user_id);

CREATE INDEX idx_order_level_order
ON features.order_level(order_id);

ANALYZE features.order_level;