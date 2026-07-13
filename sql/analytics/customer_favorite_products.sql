DROP TABLE IF EXISTS analytics.customer_favorite_products;

CREATE TABLE analytics.customer_favorite_products AS

WITH ranked_products AS (

    SELECT

        upf.user_id,

        upf.product_id,

        p.product_name,

        upf.purchase_count,

        upf.reorder_rate,

        upf.unique_orders,

        PERCENT_RANK() OVER (
            ORDER BY purchase_count
        ) * 100 AS preference_score,

        ROW_NUMBER() OVER (
            PARTITION BY upf.user_id
            ORDER BY
                upf.purchase_count DESC,
                upf.reorder_rate DESC,
                upf.unique_orders DESC,
                upf.product_id
        ) AS product_rank

    FROM features.user_product_features upf

    JOIN raw.products p
    ON upf.product_id = p.product_id

)

SELECT

    user_id,

    product_rank,

    product_id,

    product_name,

    ROUND(preference_score::numeric,2) AS preference_score,

    purchase_count,

    ROUND(reorder_rate::numeric,4) AS reorder_rate,

    unique_orders

FROM ranked_products

WHERE product_rank <= 10;

CREATE INDEX idx_cfp_user
ON analytics.customer_favorite_products(user_id);

CREATE INDEX idx_cfp_product
ON analytics.customer_favorite_products(product_id);

ANALYZE analytics.customer_favorite_products;