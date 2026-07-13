DROP TABLE IF EXISTS analytics.customer_business_scores;

CREATE TABLE analytics.customer_business_scores AS

WITH normalized_features AS (

    SELECT
        user_id,

        PERCENT_RANK() OVER (
            ORDER BY LN(total_orders + 1)
        ) * 100 AS total_orders_score,

        PERCENT_RANK() OVER (
            ORDER BY reorder_rate
        ) * 100 AS reorder_rate_score,

        PERCENT_RANK() OVER (
            ORDER BY LN(total_items + 1)
        ) * 100 AS total_items_score,

        PERCENT_RANK() OVER (
            ORDER BY avg_basket_size
        ) * 100 AS basket_size_score,

        100 -
        (
            PERCENT_RANK() OVER (
                ORDER BY std_days_between_orders
            ) * 100
        ) AS consistency_score,

        PERCENT_RANK() OVER (
            ORDER BY unique_products
        ) * 100 AS product_diversity_score,

        PERCENT_RANK() OVER (
            ORDER BY unique_departments
        ) * 100 AS department_diversity_score

    FROM features.customer_features

)

SELECT

    user_id,

    ROUND(
        (
            0.50 * total_orders_score +
            0.50 * reorder_rate_score
        )::numeric,
        2
    ) AS loyalty_score,

    ROUND(
        (
            0.60 * total_items_score +
            0.40 * basket_size_score
        )::numeric,
        2
    ) AS engagement_score,

    ROUND(
        consistency_score::numeric,
        2
    ) AS consistency_score,

    ROUND(
        (
            0.70 * product_diversity_score +
            0.30 * department_diversity_score
        )::numeric,
        2
    ) AS diversity_score,

    ROUND(
        (
            0.40 *
            (
                0.50 * total_orders_score +
                0.50 * reorder_rate_score
            )

            +

            0.30 *
            (
                0.60 * total_items_score +
                0.40 * basket_size_score
            )

            +

            0.20 *
            consistency_score

            +

            0.10 *
            (
                0.70 * product_diversity_score +
                0.30 * department_diversity_score
            )
        )::numeric,
        2
    ) AS customer_health_score

FROM normalized_features;

CREATE INDEX idx_cbs_user
ON analytics.customer_business_scores(user_id);

ANALYZE analytics.customer_business_scores;
