CREATE INDEX IF NOT EXISTS idx_raw_orders_order_id
ON raw.orders(order_id);

CREATE INDEX IF NOT EXISTS idx_raw_orders_user_id
ON raw.orders(user_id);

CREATE INDEX IF NOT EXISTS idx_raw_orders_eval_set
ON raw.orders(eval_set);

CREATE INDEX IF NOT EXISTS idx_raw_products_product_id
ON raw.products(product_id);

CREATE INDEX IF NOT EXISTS idx_raw_products_aisle_id
ON raw.products(aisle_id);

CREATE INDEX IF NOT EXISTS idx_raw_products_department_id
ON raw.products(department_id);

CREATE INDEX IF NOT EXISTS idx_raw_aisles_aisle_id
ON raw.aisles(aisle_id);

CREATE INDEX IF NOT EXISTS idx_raw_departments_department_id
ON raw.departments(department_id);

CREATE INDEX IF NOT EXISTS idx_raw_order_products_prior_order_id
ON raw.order_products_prior(order_id);

CREATE INDEX IF NOT EXISTS idx_raw_order_products_prior_product_id
ON raw.order_products_prior(product_id);

CREATE INDEX IF NOT EXISTS idx_raw_order_products_train_order_id
ON raw.order_products_train(order_id);

CREATE INDEX IF NOT EXISTS idx_raw_order_products_train_product_id
ON raw.order_products_train(product_id);

ANALYZE raw.aisles;
ANALYZE raw.departments;
ANALYZE raw.orders;
ANALYZE raw.products;
ANALYZE raw.order_products_prior;
ANALYZE raw.order_products_train;