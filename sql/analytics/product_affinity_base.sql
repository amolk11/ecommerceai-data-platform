DROP TABLE IF EXISTS analytics.product_affinity_base;

CREATE TABLE analytics.product_affinity_base AS

WITH order_products AS (

    SELECT DISTINCT
        order_id,
        product_id
    FROM staging.order_items

),

product_pairs AS (

    SELECT
        a.product_id AS product_id_a,
        b.product_id AS product_id_b,
        COUNT(*) AS co_purchase_count

    FROM order_products a

    INNER JOIN order_products b
        ON a.order_id = b.order_id
       AND a.product_id < b.product_id

    GROUP BY
        a.product_id,
        b.product_id

    HAVING COUNT(*) >= 10

)

SELECT *
FROM product_pairs;

CREATE INDEX idx_affinity_base_product_a
ON analytics.product_affinity_base(product_id_a);

CREATE INDEX idx_affinity_base_product_b
ON analytics.product_affinity_base(product_id_b);

CREATE INDEX idx_affinity_base_count
ON analytics.product_affinity_base(co_purchase_count DESC);

ANALYZE analytics.product_affinity_base;
