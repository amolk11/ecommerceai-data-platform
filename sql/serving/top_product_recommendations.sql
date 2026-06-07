DROP TABLE IF EXISTS serving.product_recommendations_top20;

CREATE TABLE serving.product_recommendations_top20 AS

WITH ranked_recommendations AS (

    SELECT
        product_id_a,
        product_id_b,
        co_purchase_count,
        support,
        confidence,
        lift,
        recommendation_score,

        ROW_NUMBER() OVER (
            PARTITION BY product_id_a
            ORDER BY recommendation_score DESC
        ) AS recommendation_rank

    FROM serving.product_recommendations

)

SELECT
    product_id_a,
    product_id_b,
    co_purchase_count,
    support,
    confidence,
    lift,
    recommendation_score,
    recommendation_rank

FROM ranked_recommendations

WHERE recommendation_rank <= 20;


CREATE INDEX IF NOT EXISTS idx_product_recommendations_top20_product
ON serving.product_recommendations_top20(product_id_a);
