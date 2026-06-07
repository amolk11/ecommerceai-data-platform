DROP TABLE IF EXISTS serving.product_recommendations;

CREATE SCHEMA IF NOT EXISTS serving;

CREATE TABLE serving.product_recommendations AS

SELECT
    product_id_a,
    product_id_b,
    co_purchase_count,
    support,
    confidence,
    lift,

    (
        confidence * 0.6 +
        LEAST(lift / 5.0, 1.0) * 0.4
    ) AS recommendation_score

FROM analytics.product_affinity_features

WHERE
    co_purchase_count >= 20
    AND lift > 1;


CREATE INDEX IF NOT EXISTS idx_product_recommendations_product
ON serving.product_recommendations(product_id_a);


CREATE INDEX IF NOT EXISTS idx_product_recommendations_score
ON serving.product_recommendations(
    product_id_a,
    recommendation_score DESC
);
