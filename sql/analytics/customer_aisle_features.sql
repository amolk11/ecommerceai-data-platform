DROP TABLE IF EXISTS analytics.customer_aisle_features;

CREATE TABLE analytics.customer_aisle_features AS

SELECT
    user_id,
    aisle,

    COUNT(*) AS purchase_count,

    COUNT(DISTINCT product_id) AS unique_products,

    SUM(reordered) AS reorder_count,

    ROUND(AVG(add_to_cart_order),2) AS avg_cart_position,

    ROUND(
        SUM(COUNT(*)) OVER (PARTITION BY user_id)::numeric,
        0
    ) AS customer_total_purchases,

    ROUND(
        COUNT(*)::numeric
        /
        SUM(COUNT(*)) OVER (PARTITION BY user_id),
        4
    ) AS aisle_share

FROM staging.order_items

GROUP BY
    user_id,
    aisle;

CREATE INDEX idx_caf_user
ON analytics.customer_aisle_features(user_id);

CREATE INDEX idx_caf_aisle
ON analytics.customer_aisle_features(aisle);

ANALYZE analytics.customer_aisle_features;
