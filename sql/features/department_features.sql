DROP TABLE IF EXISTS features.department_features;

CREATE TABLE features.department_features AS

SELECT
    department,

    COUNT(*) AS purchase_count,

    COUNT(DISTINCT user_id) AS unique_customers,

    COUNT(DISTINCT product_id) AS unique_products,

    AVG(reordered::FLOAT) AS reorder_rate

FROM staging.order_items

GROUP BY department;

ANALYZE features.department_features;