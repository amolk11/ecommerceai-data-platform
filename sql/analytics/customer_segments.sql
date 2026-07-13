DROP TABLE IF EXISTS analytics.customer_segments;

CREATE TABLE analytics.customer_segments AS

WITH customer_segments AS (

    SELECT

        cf.user_id,

        cf.total_orders,

        cf.total_items,

        cf.reorder_rate,

        cb.purchase_depth,

        cb.purchase_regularity,

        cb.purchase_loyalty,

        cb.purchase_exploration,

        ------------------------------------------------------------------
        -- Lifecycle Percentile
        ------------------------------------------------------------------

        PERCENT_RANK() OVER (
            ORDER BY LN(cf.total_orders + 1)
        ) * 100 AS lifecycle_score,

        ------------------------------------------------------------------
        -- Value Index
        ------------------------------------------------------------------

        (
            0.40 *
            (
                PERCENT_RANK() OVER (
                    ORDER BY LN(cf.total_orders + 1)
                ) * 100
            )

            +

            0.40 *
            (
                PERCENT_RANK() OVER (
                    ORDER BY LN(cf.total_items + 1)
                ) * 100
            )

            +

            0.20 *
            (
                PERCENT_RANK() OVER (
                    ORDER BY cf.reorder_rate
                ) * 100
            )

        ) AS value_score

    FROM features.customer_features cf

    JOIN analytics.customer_behavior cb
        ON cf.user_id = cb.user_id

)

SELECT

    user_id,

    ------------------------------------------------------------------
    -- Lifecycle Segment
    ------------------------------------------------------------------

    CASE

        WHEN lifecycle_score < 20 THEN 'New Customer'

        WHEN lifecycle_score < 40 THEN 'Growing Customer'

        WHEN lifecycle_score < 60 THEN 'Regular Customer'

        WHEN lifecycle_score < 80 THEN 'Loyal Customer'

        ELSE 'Power Customer'

    END AS lifecycle_segment,

    ------------------------------------------------------------------
    -- Value Segment
    ------------------------------------------------------------------

    CASE

        WHEN value_score < 25 THEN 'Low Value Customer'

        WHEN value_score < 50 THEN 'Medium Value Customer'

        WHEN value_score < 75 THEN 'High Value Customer'

        ELSE 'Elite Customer'

    END AS value_segment,

    ------------------------------------------------------------------
    -- Behavior Segment
    ------------------------------------------------------------------

    CASE

        WHEN purchase_depth = 'Large Basket Buyer'
             AND purchase_regularity = 'Highly Regular'
        THEN 'Routine Shopper'

        WHEN purchase_depth = 'Large Basket Buyer'
        THEN 'Bulk Shopper'

        WHEN purchase_depth = 'Small Basket Buyer'
             AND purchase_regularity = 'Irregular'
        THEN 'Occasional Shopper'

        WHEN purchase_exploration = 'Explorer'
        THEN 'Explorer'

        ELSE 'Regular Shopper'

    END AS behavior_segment,

    1.0 AS confidence

FROM customer_segments;

CREATE INDEX idx_cs_user
ON analytics.customer_segments(user_id);

ANALYZE analytics.customer_segments;
