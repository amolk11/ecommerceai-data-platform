DROP TABLE IF EXISTS analytics.customer_favorite_aisles;

CREATE TABLE analytics.customer_favorite_aisles AS

WITH ranked_aisles AS (

    SELECT

        user_id,

        aisle,

        purchase_count,

        aisle_share,

        PERCENT_RANK() OVER (
            ORDER BY purchase_count
        ) * 100 AS preference_score,

        ROW_NUMBER() OVER (

            PARTITION BY user_id

            ORDER BY
                purchase_count DESC,
                aisle_share DESC,
                aisle

        ) AS aisle_rank

    FROM analytics.customer_aisle_features

)

SELECT

    user_id,

    aisle_rank,

    aisle,

    ROUND(preference_score::numeric,2) AS preference_score,

    purchase_count,

    ROUND(aisle_share::numeric,4) AS aisle_share

FROM ranked_aisles

WHERE aisle_rank <= 5;

CREATE INDEX idx_cfa_user
ON analytics.customer_favorite_aisles(user_id);

CREATE INDEX idx_cfa_aisle
ON analytics.customer_favorite_aisles(aisle);

ANALYZE analytics.customer_favorite_aisles;