DELETE FROM analytics.feature_registry
WHERE entity_name IN (
    'customer_department',
    'customer_aisle',
    'product_affinity_base',
    'product_affinity_features'
);

INSERT INTO analytics.feature_registry
(
    entity_name,
    feature_table,
    row_count,
    grain,
    description
)

SELECT
    'customer_department',
    'customer_department_features',
    COUNT(*),
    'one row per customer-department',
    'Customer purchasing behavior aggregated by department'
FROM analytics.customer_department_features

UNION ALL

SELECT
    'customer_aisle',
    'customer_aisle_features',
    COUNT(*),
    'one row per customer-aisle',
    'Customer purchasing behavior aggregated by aisle'
FROM analytics.customer_aisle_features

UNION ALL

SELECT
    'product_affinity_base',
    'product_affinity_base',
    COUNT(*),
    'one row per product pair',
    'Market basket co-purchase relationships'
FROM analytics.product_affinity_base

UNION ALL

SELECT
    'product_affinity_features',
    'product_affinity_features',
    COUNT(*),
    'one row per product pair',
    'Association metrics including support confidence and lift'
FROM analytics.product_affinity_features;