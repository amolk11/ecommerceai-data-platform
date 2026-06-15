DROP TABLE IF EXISTS serving.product_intelligence;

CREATE TABLE serving.product_intelligence AS

SELECT

    product_id,
    product_name,
    department,
    aisle,

    purchase_count,
    unique_customers,
    unique_orders,

    global_popularity_score,
    global_loyalty_score,
    global_reach_score,
    global_basket_influence_score,
    global_purchase_intent_score,
    global_health_score,

    department_popularity_score,
    department_loyalty_score,
    department_reach_score,
    department_basket_influence_score,
    department_purchase_intent_score,
    department_health_score,

    relationship_count,
    avg_confidence,

    ------------------------------------------------------------------
    -- Popularity Segment
    ------------------------------------------------------------------

    CASE
        WHEN global_popularity_score >= 90 THEN 'Top Seller'
        WHEN global_popularity_score >= 70 THEN 'Popular'
        WHEN global_popularity_score >= 40 THEN 'Average'
        ELSE 'Niche'
    END AS popularity_segment,

    ------------------------------------------------------------------
    -- Loyalty Segment
    ------------------------------------------------------------------

    CASE
        WHEN global_loyalty_score >= 90 THEN 'Highly Loyal'
        WHEN global_loyalty_score >= 70 THEN 'Loyal'
        WHEN global_loyalty_score >= 40 THEN 'Moderate'
        ELSE 'Low Loyalty'
    END AS loyalty_segment,

    ------------------------------------------------------------------
    -- Reach Segment
    ------------------------------------------------------------------

    CASE
        WHEN global_reach_score >= 90 THEN 'Mass Market'
        WHEN global_reach_score >= 70 THEN 'Broad Reach'
        WHEN global_reach_score >= 40 THEN 'Focused Audience'
        ELSE 'Specialized Product'
    END AS reach_segment,

    ------------------------------------------------------------------
    -- Basket Segment
    ------------------------------------------------------------------

    CASE
        WHEN global_basket_influence_score >= 90 THEN 'Basket Driver'
        WHEN global_basket_influence_score >= 70 THEN 'Basket Builder'
        WHEN global_basket_influence_score >= 40 THEN 'Companion Product'
        ELSE 'Standalone Product'
    END AS basket_segment,

    ------------------------------------------------------------------
    -- Purchase Intent Segment
    ------------------------------------------------------------------

    CASE
        WHEN global_purchase_intent_score >= 90 THEN 'Essential Purchase'
        WHEN global_purchase_intent_score >= 70 THEN 'Planned Purchase'
        WHEN global_purchase_intent_score >= 40 THEN 'Mixed Intent'
        ELSE 'Impulse Product'
    END AS purchase_intent_segment,

    ------------------------------------------------------------------
    -- Health Segment
    ------------------------------------------------------------------

    CASE
        WHEN global_health_score >= 90 THEN 'Star Product'
        WHEN global_health_score >= 75 THEN 'Strong Product'
        WHEN global_health_score >= 50 THEN 'Stable Product'
        ELSE 'Weak Product'
    END AS health_segment,

    ------------------------------------------------------------------
    -- Primary Strength
    ------------------------------------------------------------------

    CASE

        WHEN global_popularity_score >= global_loyalty_score
         AND global_popularity_score >= global_reach_score
         AND global_popularity_score >= global_basket_influence_score
         AND global_popularity_score >= global_purchase_intent_score

            THEN 'High Demand'

        WHEN global_loyalty_score >= global_popularity_score
         AND global_loyalty_score >= global_reach_score
         AND global_loyalty_score >= global_basket_influence_score
         AND global_loyalty_score >= global_purchase_intent_score

            THEN 'Customer Loyalty'

        WHEN global_reach_score >= global_popularity_score
         AND global_reach_score >= global_loyalty_score
         AND global_reach_score >= global_basket_influence_score
         AND global_reach_score >= global_purchase_intent_score

            THEN 'Broad Customer Reach'

        WHEN global_basket_influence_score >= global_popularity_score
         AND global_basket_influence_score >= global_loyalty_score
         AND global_basket_influence_score >= global_reach_score
         AND global_basket_influence_score >= global_purchase_intent_score

            THEN 'Basket Influence'

        ELSE 'Purchase Intent'

    END AS primary_strength,

    ------------------------------------------------------------------
    -- Primary Weakness
    ------------------------------------------------------------------

    CASE

        WHEN LEAST(
            global_popularity_score,
            global_loyalty_score,
            global_reach_score,
            global_basket_influence_score,
            global_purchase_intent_score
        ) >= 70

            THEN 'No Significant Weakness'

        WHEN global_popularity_score <= global_loyalty_score
         AND global_popularity_score <= global_reach_score
         AND global_popularity_score <= global_basket_influence_score
         AND global_popularity_score <= global_purchase_intent_score

            THEN 'Limited Demand'

        WHEN global_loyalty_score <= global_popularity_score
         AND global_loyalty_score <= global_reach_score
         AND global_loyalty_score <= global_basket_influence_score
         AND global_loyalty_score <= global_purchase_intent_score

            THEN 'Low Loyalty'

        WHEN global_reach_score <= global_popularity_score
         AND global_reach_score <= global_loyalty_score
         AND global_reach_score <= global_basket_influence_score
         AND global_reach_score <= global_purchase_intent_score

            THEN 'Limited Reach'

        WHEN global_basket_influence_score <= global_popularity_score
         AND global_basket_influence_score <= global_loyalty_score
         AND global_basket_influence_score <= global_reach_score
         AND global_basket_influence_score <= global_purchase_intent_score

            THEN 'Weak Basket Influence'

        ELSE 'Low Purchase Intent'

    END AS primary_weakness,

    ------------------------------------------------------------------
    -- Recommended Action
    ------------------------------------------------------------------

    CASE

        ------------------------------------------------------------------
        -- Elite Products
        ------------------------------------------------------------------

        WHEN global_health_score >= 90

            THEN 'Maintain performance and protect market position'

        ------------------------------------------------------------------
        -- Loyalty Opportunity
        ------------------------------------------------------------------

        WHEN global_loyalty_score >= 80
         AND global_reach_score < 50

            THEN 'Promote to a broader customer audience'

        ------------------------------------------------------------------
        -- Cross-Sell Opportunity
        ------------------------------------------------------------------

        WHEN global_popularity_score >= 80
         AND global_basket_influence_score < 50

            THEN 'Improve cross-sell opportunities'

        ------------------------------------------------------------------
        -- Retention Opportunity
        ------------------------------------------------------------------

        WHEN global_reach_score >= 80
         AND global_loyalty_score < 50

            THEN 'Focus on customer retention'

        ------------------------------------------------------------------
        -- Weak Products
        ------------------------------------------------------------------

        WHEN global_health_score < 50

            THEN 'Investigate product performance and positioning'

        ------------------------------------------------------------------
        -- Default
        ------------------------------------------------------------------

        ELSE 'Monitor performance and optimize growth opportunities'

    END AS recommended_action

FROM analytics.product_intelligence_base;

ANALYZE serving.product_intelligence;
