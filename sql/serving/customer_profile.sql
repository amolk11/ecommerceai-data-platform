DROP TABLE IF EXISTS serving.customer_profile;

CREATE TABLE serving.customer_profile AS

SELECT

    bs.user_id,

    ------------------------------------------------------------
    -- Business Scores
    ------------------------------------------------------------

    bs.loyalty_score,
    bs.engagement_score,
    bs.consistency_score,
    bs.diversity_score,
    bs.customer_health_score,

    ------------------------------------------------------------
    -- Customer Segments
    ------------------------------------------------------------

    cs.lifecycle_segment,
    cs.value_segment,
    cs.behavior_segment,

    ------------------------------------------------------------
    -- Behavioral Intelligence
    ------------------------------------------------------------

    cb.purchase_depth_score,
    cb.purchase_depth,

    cb.purchase_regularity_score,
    cb.purchase_regularity,

    cb.purchase_loyalty_score,
    cb.purchase_loyalty,

    cb.purchase_exploration_score,
    cb.purchase_exploration,

    ------------------------------------------------------------
    -- Shopping Preferences
    ------------------------------------------------------------

    sp.preferred_shopping_day,
    sp.preferred_shopping_hour,

    ------------------------------------------------------------
    -- Metadata
    ------------------------------------------------------------

    cs.confidence

FROM analytics.customer_business_scores bs

JOIN analytics.customer_behavior cb
ON bs.user_id = cb.user_id

JOIN analytics.customer_segments cs
ON bs.user_id = cs.user_id

JOIN analytics.customer_shopping_preferences sp
ON bs.user_id = sp.user_id;

CREATE INDEX idx_customer_profile_user
ON serving.customer_profile(user_id);

ANALYZE serving.customer_profile;