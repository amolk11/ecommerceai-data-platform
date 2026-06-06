DROP TABLE IF EXISTS features.product_features;

CREATE TABLE features.product_features AS

SELECT
    product_id,

    MIN(product_name) AS product_name,

    MIN(department) AS department,

    MIN(aisle) AS aisle,

    COUNT(*) AS purchase_count,

    COUNT(DISTINCT user_id) AS unique_customers,

    COUNT(DISTINCT order_id) AS unique_orders,

    AVG(reordered::FLOAT) AS reorder_rate,

    SUM(reordered) AS total_reorders,

    AVG(add_to_cart_order) AS avg_cart_position,

    STDDEV(add_to_cart_order) AS std_cart_position,

    AVG(order_hour_of_day) AS avg_purchase_hour

FROM staging.order_items

GROUP BY product_id;

CREATE INDEX idx_product_features_product
ON features.product_features(product_id);

ANALYZE features.product_features;