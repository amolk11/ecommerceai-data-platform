DROP TABLE IF EXISTS serving.customer_favorite_aisles;

CREATE TABLE serving.customer_favorite_aisles AS

SELECT *

FROM analytics.customer_favorite_aisles;

CREATE INDEX idx_customer_favorite_aisles_user
ON serving.customer_favorite_aisles(user_id);

ANALYZE serving.customer_favorite_aisles;