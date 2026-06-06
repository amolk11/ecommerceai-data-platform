DROP TABLE IF EXISTS analytics.customer_department_features;

CREATE TABLE analytics.customer_department_features AS

SELECT
    user_id,
    department,

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
    ) AS department_share

FROM staging.order_items

GROUP BY
    user_id,
    department;

CREATE INDEX idx_cdf_user
ON analytics.customer_department_features(user_id);

CREATE INDEX idx_cdf_department
ON analytics.customer_department_features(department);

ANALYZE analytics.customer_department_features;