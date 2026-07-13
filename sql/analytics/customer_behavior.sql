DROP TABLE IF EXISTS analytics.customer_behavior;

CREATE TABLE analytics.customer_behavior AS

WITH normalized_features AS (

    SELECT

        user_id,

        PERCENT_RANK() OVER (
            ORDER BY avg_basket_size
        ) * 100 AS purchase_depth_score,

        100 -
        (
            PERCENT_RANK() OVER (
                ORDER BY std_days_between_orders
            ) * 100
        ) AS purchase_regularity_score,

        PERCENT_RANK() OVER (
            ORDER BY reorder_rate
        ) * 100 AS purchase_loyalty_score,

        (
            0.70 *
            (
                PERCENT_RANK() OVER (
                    ORDER BY unique_products
                ) * 100
            )
            +
            0.30 *
            (
                PERCENT_RANK() OVER (
                    ORDER BY unique_departments
                ) * 100
            )
        ) AS purchase_exploration_score

    FROM features.customer_features

)

SELECT

    user_id,

    ROUND(purchase_depth_score::numeric,2) AS purchase_depth_score,

    CASE
        WHEN purchase_depth_score < 33 THEN 'Small Basket Buyer'
        WHEN purchase_depth_score < 66 THEN 'Medium Basket Buyer'
        ELSE 'Large Basket Buyer'
    END AS purchase_depth,

    ROUND(purchase_regularity_score::numeric,2) AS purchase_regularity_score,

    CASE
        WHEN purchase_regularity_score >= 66 THEN 'Highly Regular'
        WHEN purchase_regularity_score >= 33 THEN 'Regular'
        ELSE 'Irregular'
    END AS purchase_regularity,

    ROUND(purchase_loyalty_score::numeric,2) AS purchase_loyalty_score,

    CASE
        WHEN purchase_loyalty_score < 33 THEN 'Explorer'
        WHEN purchase_loyalty_score < 66 THEN 'Balanced Buyer'
        ELSE 'Repeat Buyer'
    END AS purchase_loyalty,

    ROUND(purchase_exploration_score::numeric,2) AS purchase_exploration_score,

    CASE
        WHEN purchase_exploration_score < 33 THEN 'Focused Shopper'
        WHEN purchase_exploration_score < 66 THEN 'Balanced Shopper'
        ELSE 'Explorer'
    END AS purchase_exploration

FROM normalized_features;

CREATE INDEX idx_cb_user
ON analytics.customer_behavior(user_id);

ANALYZE analytics.customer_behavior;