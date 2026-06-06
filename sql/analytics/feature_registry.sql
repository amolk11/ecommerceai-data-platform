CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS analytics.feature_registry (
    entity_name TEXT PRIMARY KEY,
    feature_table TEXT NOT NULL,
    row_count BIGINT,
    grain TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO analytics.feature_registry
(
    entity_name,
    feature_table,
    row_count,
    grain,
    description
)
VALUES

(
    'customer',
    'customer_features',
    (SELECT COUNT(*) FROM features.customer_features),
    'one row per customer',
    'Customer behavioral, loyalty and purchasing features'
),

(
    'order',
    'order_level',
    (SELECT COUNT(*) FROM features.order_level),
    'one row per order',
    'Order level basket and purchase metrics'
),

(
    'product',
    'product_features',
    (SELECT COUNT(*) FROM features.product_features),
    'one row per product',
    'Product popularity, reorder and purchasing metrics'
),

(
    'user_product',
    'user_product_features',
    (SELECT COUNT(*) FROM features.user_product_features),
    'one row per user-product pair',
    'Customer-product affinity and recommendation features'
),

(
    'department',
    'department_features',
    (SELECT COUNT(*) FROM features.department_features),
    'one row per department',
    'Department level purchasing metrics'
),

(
    'aisle',
    'aisle_features',
    (SELECT COUNT(*) FROM features.aisle_features),
    'one row per aisle',
    'Aisle level purchasing metrics'
)

ON CONFLICT (entity_name)
DO UPDATE SET

    feature_table = EXCLUDED.feature_table,
    row_count = EXCLUDED.row_count,
    grain = EXCLUDED.grain,
    description = EXCLUDED.description,
    created_at = CURRENT_TIMESTAMP;

SELECT *
FROM analytics.feature_registry
ORDER BY entity_name;