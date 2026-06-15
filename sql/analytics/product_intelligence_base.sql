DROP TABLE IF EXISTS analytics.product_intelligence_base;

CREATE TABLE analytics.product_intelligence_base AS

WITH basket_a AS (

    SELECT
        product_id_a AS product_id,

        COUNT(product_id_b) AS relationship_count,

        SUM(co_purchase_count) AS total_co_purchase_count,

        AVG(confidence) AS avg_confidence,

        AVG(lift) AS avg_lift,

        PERCENTILE_CONT(0.95)
        WITHIN GROUP (ORDER BY lift) AS p95_lift

    FROM analytics.product_affinity_features

    GROUP BY product_id_a
),

basket_b AS (

    SELECT
        product_id_b AS product_id,

        COUNT(product_id_a) AS relationship_count,

        SUM(co_purchase_count) AS total_co_purchase_count,

        AVG(confidence) AS avg_confidence,

        AVG(lift) AS avg_lift,

        PERCENTILE_CONT(0.95)
        WITHIN GROUP (ORDER BY lift) AS p95_lift

    FROM analytics.product_affinity_features

    GROUP BY product_id_b
),

basket_union AS (

    SELECT * FROM basket_a

    UNION ALL

    SELECT * FROM basket_b
),

basket_features AS (

    SELECT
        product_id,

        SUM(relationship_count) AS relationship_count,

        SUM(total_co_purchase_count) AS total_co_purchase_count,

        AVG(avg_confidence) AS avg_confidence,

        AVG(avg_lift) AS avg_lift,

        AVG(p95_lift) AS p95_lift

    FROM basket_union

    GROUP BY product_id
),

base AS (

    SELECT

        pf.product_id,
        pf.product_name,
        pf.department,
        pf.aisle,

        pf.purchase_count,
        pf.unique_customers,
        pf.unique_orders,

        pf.reorder_rate,
        pf.total_reorders,

        pf.avg_cart_position,
        pf.std_cart_position,

        pf.avg_purchase_hour,

        (
            pf.total_reorders +
            (100 * 0.5896974667922161)
        )::NUMERIC
        /
        (
            pf.purchase_count + 100
        ) AS smoothed_reorder_rate,

        (
            (pf.purchase_count * pf.avg_cart_position)
            +
            (100 * 9.09756808901078)
        )
        /
        (
            pf.purchase_count + 100
        ) AS smoothed_avg_cart_position,

        (
            (pf.purchase_count * pf.std_cart_position)
            +
            (100 * 7.2688253370464055)
        )
        /
        (
            pf.purchase_count + 100
        ) AS smoothed_std_position,

        COALESCE(bf.relationship_count, 0) AS relationship_count,

        COALESCE(bf.total_co_purchase_count, 0) AS total_co_purchase_count,

        COALESCE(bf.avg_confidence, 0) AS avg_confidence,

        COALESCE(bf.avg_lift, 0) AS avg_lift,

        COALESCE(bf.p95_lift, 0) AS p95_lift

    FROM features.product_features pf

    LEFT JOIN basket_features bf
        ON pf.product_id = bf.product_id
),

scored AS (

    SELECT

        *,

        (
            (
                100 * PERCENT_RANK()
                OVER (ORDER BY LN(purchase_count + 1))
            )
            +
            (
                100 * PERCENT_RANK()
                OVER (ORDER BY purchase_count)
            )
        ) / 2
        AS global_popularity_score,

        (
            (
                100 * PERCENT_RANK()
                OVER (ORDER BY smoothed_reorder_rate)
            )
            +
            (
                100 * PERCENT_RANK()
                OVER (ORDER BY LN(total_reorders + 1))
            )
        ) / 2
        AS global_loyalty_score,

        (
            100 * PERCENT_RANK()
            OVER (ORDER BY unique_customers)
        )
        AS global_reach_score,

        (
            (
                100 * PERCENT_RANK()
                OVER (ORDER BY relationship_count)
            ) * 0.70
            +
            (
                100 * PERCENT_RANK()
                OVER (ORDER BY avg_confidence)
            ) * 0.30
        )
        AS global_basket_influence_score,

        (
            (
                100 -
                (
                    100 * PERCENT_RANK()
                    OVER (ORDER BY smoothed_avg_cart_position)
                )
            )
            +
            (
                100 -
                (
                    100 * PERCENT_RANK()
                    OVER (ORDER BY smoothed_std_position)
                )
            )
        ) / 2
        AS global_purchase_intent_score

    FROM base
)

SELECT

    *,

    (
        global_popularity_score
        +
        global_loyalty_score
        +
        global_basket_influence_score
        +
        global_purchase_intent_score
    ) / 4
    AS global_health_score,

    (
        (
            100 * PERCENT_RANK()
            OVER (
                PARTITION BY department
                ORDER BY LN(purchase_count + 1)
            )
        )
        +
        (
            100 * PERCENT_RANK()
            OVER (
                PARTITION BY department
                ORDER BY purchase_count
            )
        )
    ) / 2
    AS department_popularity_score,

    (
        (
            100 * PERCENT_RANK()
            OVER (
                PARTITION BY department
                ORDER BY smoothed_reorder_rate
            )
        )
        +
        (
            100 * PERCENT_RANK()
            OVER (
                PARTITION BY department
                ORDER BY LN(total_reorders + 1)
            )
        )
    ) / 2
    AS department_loyalty_score,

    (
        100 * PERCENT_RANK()
        OVER (
            PARTITION BY department
            ORDER BY unique_customers
        )
    )
    AS department_reach_score,

    (
        (
            100 * PERCENT_RANK()
            OVER (
                PARTITION BY department
                ORDER BY relationship_count
            )
        ) * 0.70
        +
        (
            100 * PERCENT_RANK()
            OVER (
                PARTITION BY department
                ORDER BY avg_confidence
            )
        ) * 0.30
    )
    AS department_basket_influence_score,

    (
        (
            100 -
            (
                100 * PERCENT_RANK()
                OVER (
                    PARTITION BY department
                    ORDER BY smoothed_avg_cart_position
                )
            )
        )
        +
        (
            100 -
            (
                100 * PERCENT_RANK()
                OVER (
                    PARTITION BY department
                    ORDER BY smoothed_std_position
                )
            )
        )
    ) / 2
    AS department_purchase_intent_score,

    (
        (
            (
                (
                    100 * PERCENT_RANK()
                    OVER (
                        PARTITION BY department
                        ORDER BY LN(purchase_count + 1)
                    )
                )
                +
                (
                    100 * PERCENT_RANK()
                    OVER (
                        PARTITION BY department
                        ORDER BY purchase_count
                    )
                )
            ) / 2
        )
        +
        (
            (
                (
                    100 * PERCENT_RANK()
                    OVER (
                        PARTITION BY department
                        ORDER BY smoothed_reorder_rate
                    )
                )
                +
                (
                    100 * PERCENT_RANK()
                    OVER (
                        PARTITION BY department
                        ORDER BY LN(total_reorders + 1)
                    )
                )
            ) / 2
        )
        +
        (
            (
                100 * PERCENT_RANK()
                OVER (
                    PARTITION BY department
                    ORDER BY relationship_count
                )
            ) * 0.70
            +
            (
                100 * PERCENT_RANK()
                OVER (
                    PARTITION BY department
                    ORDER BY avg_confidence
                )
            ) * 0.30
        )
        +
        (
            (
                100 -
                (
                    100 * PERCENT_RANK()
                    OVER (
                        PARTITION BY department
                        ORDER BY smoothed_avg_cart_position
                    )
                )
            )
            +
            (
                100 -
                (
                    100 * PERCENT_RANK()
                    OVER (
                        PARTITION BY department
                        ORDER BY smoothed_std_position
                    )
                )
            )
        ) / 2
    ) / 4
    AS department_health_score

FROM scored;

ANALYZE analytics.product_intelligence_base;