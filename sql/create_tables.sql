CREATE DATABASE instacart_market_basket_analysis;

USE instacart_market_basket_analysis;

-- Create the Aisles table
CREATE TABLE Aisles (
    aisle_id INT PRIMARY KEY,
    aisle VARCHAR(255)
);

-- Create the Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department VARCHAR(255)
);

-- Create the Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    aisle_id INT,
    department_id INT,
    FOREIGN KEY (aisle_id) REFERENCES Aisles(aisle_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Create the Order_products_prior table
CREATE TABLE Order_products_prior (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered TINYINT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create the Order_products_train table
CREATE TABLE Order_products_train (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered TINYINT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create the Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    eval_set VARCHAR(255),
    order_number INT,
    order_dow INT,
    order_hour_of_day INT,
    days_since_prior_order INT
);


