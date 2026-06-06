DROP TABLE IF EXISTS features.aisle_features;

CREATE TABLE features.aisle_features AS

SELECT
    aisle,

    COUNT(*) AS purchase_count,

    COUNT(DISTINCT user_id) AS unique_customers,

    COUNT(DISTINCT product_id) AS unique_products,

    AVG(reordered::FLOAT) AS reorder_rate

FROM staging.order_items

GROUP BY aisle;

ANALYZE features.aisle_features;