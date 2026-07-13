DROP TABLE IF EXISTS serving.customer_favorite_products;

CREATE TABLE serving.customer_favorite_products AS

SELECT *

FROM analytics.customer_favorite_products;

CREATE INDEX idx_customer_favorite_products_user
ON serving.customer_favorite_products(user_id);

ANALYZE serving.customer_favorite_products;