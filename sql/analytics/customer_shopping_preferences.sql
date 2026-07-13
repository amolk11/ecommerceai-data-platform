DROP TABLE IF EXISTS analytics.customer_shopping_preferences;

CREATE TABLE analytics.customer_shopping_preferences AS

SELECT

    user_id,

    favorite_day AS preferred_shopping_day,

    favorite_hour AS preferred_shopping_hour

FROM features.customer_features;

CREATE INDEX idx_csp_user
ON analytics.customer_shopping_preferences(user_id);

ANALYZE analytics.customer_shopping_preferences;