DROP TABLE IF EXISTS serving.customer_favorite_departments;

CREATE TABLE serving.customer_favorite_departments AS

SELECT *

FROM analytics.customer_favorite_departments;

CREATE INDEX idx_customer_favorite_departments_user
ON serving.customer_favorite_departments(user_id);

ANALYZE serving.customer_favorite_departments;