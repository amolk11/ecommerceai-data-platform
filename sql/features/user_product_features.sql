DROP TABLE IF EXISTS features.user_product_features;

CREATE TABLE features.user_product_features AS

SELECT
    user_id,

    product_id,

    COUNT(*) AS purchase_count,

    SUM(reordered) AS reorder_count,

    AVG(reordered::FLOAT) AS reorder_rate,

    MIN(order_number) AS first_order,

    MAX(order_number) AS last_order,

    MAX(order_number) -
    MIN(order_number) AS purchase_span,

    AVG(add_to_cart_order) AS avg_cart_position,

    COUNT(DISTINCT order_id) AS unique_orders

FROM staging.order_items

GROUP BY
    user_id,
    product_id;

CREATE INDEX idx_user_product_user
ON features.user_product_features(user_id);

CREATE INDEX idx_user_product_product
ON features.user_product_features(product_id);

ANALYZE features.user_product_features;