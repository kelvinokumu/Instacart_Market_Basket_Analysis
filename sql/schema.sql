CREATE TABLE aisles (
    aisle_id INTEGER,
    aisle TEXT
);

CREATE TABLE departments (
    department_id INTEGER,
    department TEXT
);

CREATE TABLE orders (
    order_id INTEGER,
    user_id INTEGER,
    eval_set TEXT,
    order_number INTEGER,
    order_dow INTEGER,
    order_hour_of_day INTEGER,
    days_since_prior_order FLOAT
);

CREATE TABLE order_products__prior (
    order_id INTEGER,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered INTEGER
);

CREATE TABLE order_products__train (
    order_id INTEGER,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered INTEGER
);

CREATE TABLE products (
    product_id INTEGER,
    product_name TEXT,
    aisle_id INTEGER,
    department_id INTEGER
);

