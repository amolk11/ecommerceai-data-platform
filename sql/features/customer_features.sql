DROP TABLE IF EXISTS features.customer_features;

CREATE TABLE features.customer_features AS

WITH
------------------------------------------------------------
-- Order-Level Features
------------------------------------------------------------
customer_order_features AS (

    SELECT
        user_id,

        COUNT(DISTINCT order_id) AS total_orders,

        COUNT(*) AS total_items,

        COUNT(DISTINCT product_id) AS unique_products,

        COUNT(*)::FLOAT
        / COUNT(DISTINCT order_id) AS avg_basket_size,

        AVG(days_since_prior_order) AS avg_days_between_orders,

        STDDEV(days_since_prior_order) AS std_days_between_orders,

        MAX(order_number) AS customer_tenure

    FROM staging.order_items

    GROUP BY user_id
),

------------------------------------------------------------
-- Reorder Features
------------------------------------------------------------
customer_reorder_features AS (

    SELECT
        user_id,

        AVG(reordered::FLOAT) AS reorder_rate,

        SUM(reordered) AS total_reorders

    FROM staging.order_items

    GROUP BY user_id
),

------------------------------------------------------------
-- Diversity Features
------------------------------------------------------------
customer_diversity_features AS (

    SELECT
        user_id,

        COUNT(DISTINCT department) AS unique_departments,

        COUNT(DISTINCT aisle) AS unique_aisles

    FROM staging.order_items

    GROUP BY user_id
),

------------------------------------------------------------
-- Time Features
------------------------------------------------------------
favorite_hour AS (

    SELECT DISTINCT ON (user_id)
        user_id,
        order_hour_of_day AS favorite_hour

    FROM staging.order_items

    GROUP BY user_id, order_hour_of_day

    ORDER BY
        user_id,
        COUNT(*) DESC
),

favorite_day AS (

    SELECT DISTINCT ON (user_id)
        user_id,
        order_dow AS favorite_day

    FROM staging.order_items

    GROUP BY user_id, order_dow

    ORDER BY
        user_id,
        COUNT(*) DESC
),

customer_time_features AS (

    SELECT
        fh.user_id,
        fh.favorite_hour,
        fd.favorite_day

    FROM favorite_hour fh

    JOIN favorite_day fd
        ON fh.user_id = fd.user_id
)

------------------------------------------------------------
-- Final Feature Table
------------------------------------------------------------
SELECT

    cof.user_id,

    cof.total_orders,
    cof.total_items,
    cof.unique_products,

    cof.avg_basket_size,

    cof.avg_days_between_orders,
    cof.std_days_between_orders,

    cof.customer_tenure,

    crf.reorder_rate,
    crf.total_reorders,

    cdf.unique_departments,
    cdf.unique_aisles,

    ctf.favorite_hour,
    ctf.favorite_day

FROM customer_order_features cof

LEFT JOIN customer_reorder_features crf
    ON cof.user_id = crf.user_id

LEFT JOIN customer_diversity_features cdf
    ON cof.user_id = cdf.user_id

LEFT JOIN customer_time_features ctf
    ON cof.user_id = ctf.user_id;

ANALYZE features.customer_features;