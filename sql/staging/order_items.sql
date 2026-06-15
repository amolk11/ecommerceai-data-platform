DROP TABLE IF EXISTS staging.order_items;

CREATE TABLE IF NOT EXISTS staging.order_items AS
SELECT
    o.order_id,
    o.user_id,
    o.order_number,
    o.order_dow,
    o.order_hour_of_day,
    o.days_since_prior_order,

    op.product_id,
    op.add_to_cart_order,
    op.reordered,

    p.product_name,
    a.aisle,
    d.department
FROM raw.orders o
JOIN raw.order_products_prior op
    ON o.order_id = op.order_id
JOIN raw.products p
    ON op.product_id = p.product_id
JOIN raw.aisles a
    ON p.aisle_id = a.aisle_id
JOIN raw.departments d
    ON p.department_id = d.department_id
WHERE o.eval_set = 'prior';
