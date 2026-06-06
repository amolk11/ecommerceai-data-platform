DROP TABLE IF EXISTS analytics.product_affinity_features;

CREATE TABLE analytics.product_affinity_features AS

WITH product_orders AS (

    SELECT
        product_id,
        COUNT(DISTINCT order_id) AS product_orders
    FROM staging.order_items
    GROUP BY product_id

),

total_orders AS (

    SELECT COUNT(DISTINCT order_id) AS total_orders
    FROM staging.order_items

)

SELECT

    pab.product_id_a,
    pab.product_id_b,

    pab.co_purchase_count,

    ROUND(
        pab.co_purchase_count::numeric
        /
        t.total_orders,
        8
    ) AS support,

    ROUND(
        pab.co_purchase_count::numeric
        /
        poa.product_orders,
        8
    ) AS confidence,

    ROUND(
        (
            pab.co_purchase_count::numeric
            /
            poa.product_orders
        )
        /
        (
            pob.product_orders::numeric
            /
            t.total_orders
        ),
        8
    ) AS lift

FROM analytics.product_affinity_base pab

JOIN product_orders poa
    ON pab.product_id_a = poa.product_id

JOIN product_orders pob
    ON pab.product_id_b = pob.product_id

CROSS JOIN total_orders t;
