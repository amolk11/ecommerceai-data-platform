DROP TABLE IF EXISTS analytics.customer_favorite_departments;

CREATE TABLE analytics.customer_favorite_departments AS

WITH ranked_departments AS (

    SELECT

        user_id,

        department,

        purchase_count,

        department_share,

        PERCENT_RANK() OVER (
            ORDER BY purchase_count
        ) * 100 AS preference_score,

        ROW_NUMBER() OVER (

            PARTITION BY user_id

            ORDER BY
                purchase_count DESC,
                department_share DESC,
                department

        ) AS department_rank

    FROM analytics.customer_department_features

)

SELECT

    user_id,

    department_rank,

    department,

    ROUND(preference_score::numeric,2) AS preference_score,

    purchase_count,

    ROUND(department_share::numeric,4) AS department_share

FROM ranked_departments

WHERE department_rank <= 5;

CREATE INDEX idx_cfd_user
ON analytics.customer_favorite_departments(user_id);

CREATE INDEX idx_cfd_department
ON analytics.customer_favorite_departments(department);

ANALYZE analytics.customer_favorite_departments;