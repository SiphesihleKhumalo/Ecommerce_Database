
create database myES;
use myES;
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(50) NOT NULL UNIQUE,
    logo_url VARCHAR(255),
    description TEXT,
    founded_year INT,
    website_url VARCHAR(255)
);

CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    parent_category_id INT NULL,
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
);

-- Phone-specific categories
INSERT INTO product_category (category_name, parent_category_id, description) VALUES
('Electronics', NULL, 'All electronic devices'),
('Mobile Phones', 1, 'Smartphones and feature phones'),
('Smartphones', 2, 'Advanced mobile devices with OS'),
('iOS Phones', 3, 'Apple iPhones'),
('Android Phones', 3, 'Phones running Android OS'),
('Refurbished Phones', 2, 'Certified pre-owned devices');

CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    description TEXT,
    release_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL UNIQUE,
    hex_code VARCHAR(7),
    material VARCHAR(50) -- e.g., "Matte", "Glossy"
);

-- Common phone colors
INSERT INTO color (color_name, hex_code) VALUES
('Midnight Black', '#000000'),
('Arctic White', '#FFFFFF'),
('Rose Gold', '#B76E79'),
('Space Gray', '#53565A'),
('Ocean Blue', '#005F8C');

CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- Phone storage categories
INSERT INTO size_category (category_name, description) VALUES
('Storage Capacity', 'Available storage options for phones');

CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_value VARCHAR(20) NOT NULL,
    display_order INT DEFAULT 0,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Common phone storage options
INSERT INTO size_option (size_category_id, size_value, display_order) VALUES
(1, '64GB', 1),
(1, '128GB', 2),
(1, '256GB', 3),
(1, '512GB', 4),
(1, '1TB', 5);

CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    color_id INT,
    size_id INT, -- Represents storage capacity for phones
    sku VARCHAR(50) UNIQUE,
    price_adjustment DECIMAL(10,2) DEFAULT 0.00,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
);

CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    variation_id INT NOT NULL,
    imei_number VARCHAR(15) UNIQUE,
    item_condition VARCHAR(20) DEFAULT 'new', -- Better column name
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id)
);

CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(100),
    color_id INT NULL, -- If image is color-specific
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id)
);

CREATE TABLE attribute_category (
    attr_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    display_order INT DEFAULT 0
);

-- Phone attribute categories
INSERT INTO attribute_category (category_name, display_order) VALUES
('Display', 1),
('Performance', 2),
('Camera', 3),
('Battery', 4),
('Connectivity', 5);

CREATE TABLE attribute_type (
    attr_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    data_type ENUM('text', 'number', 'boolean', 'date') NOT NULL
);

-- Phone attribute types
INSERT INTO attribute_type (type_name, data_type) VALUES
('Screen Size', 'number'),
('Resolution', 'text'),
('Processor', 'text'),
('RAM', 'number'),
('Storage', 'number'),
('OS Version', 'text'),
('Battery Capacity', 'number'),
('5G Support', 'boolean');

CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attr_category_id INT NOT NULL,
    attr_type_id INT NOT NULL,
    attribute_value TEXT NOT NULL,
    display_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attr_category_id) REFERENCES attribute_category(attr_category_id),
    FOREIGN KEY (attr_type_id) REFERENCES attribute_type(attr_type_id)
);


-- Insert phone brands
INSERT INTO brand (name, description, founded_year) VALUES 
('Apple', 'American multinational technology company', 1976),
('Samsung', 'South Korean multinational electronics company', 1938),
('Huawei', 'Chinese multinational technology company', 1987);

-- Insert phone categories
INSERT INTO product_category (name, description) VALUES 
('Smartphones', 'Mobile phones with advanced computing capabilities'),
('Feature Phones', 'Basic mobile phones with limited functionality');

-- Insert size categories for phones
INSERT INTO size_category (name, description) VALUES 
('Storage', 'Internal storage capacity'),
('RAM', 'Random Access Memory capacity'),
('Screen Size', 'Display size in inches');

-- Insert size options
INSERT INTO size_option (size_category_id, value, description) VALUES 
(1, '64GB', '64 Gigabytes storage'),
(1, '128GB', '128 Gigabytes storage'),
(1, '256GB', '256 Gigabytes storage'),
(2, '4GB', '4 Gigabytes RAM'),
(2, '6GB', '6 Gigabytes RAM'),
(2, '8GB', '8 Gigabytes RAM'),
(3, '6.1"', '6.1 inch display'),
(3, '6.7"', '6.7 inch display');

-- Insert colors
INSERT INTO color (name, hex_code) VALUES 
('Midnight Black', '#000000'),
('Silver', '#C0C0C0'),
('Gold', '#FFD700'),
('Pacific Blue', '#1CA3EC'),
('Phantom Black', '#2D2926');

-- Insert attribute categories
INSERT INTO attribute_category (name, description) VALUES 
('Display', 'Screen specifications'),
('Camera', 'Camera specifications'),
('Battery', 'Battery specifications'),
('Performance', 'Processor and performance specs');

-- Insert attribute types
INSERT INTO attribute_type (name, data_type) VALUES 
('Resolution', 'TEXT'),
('Refresh Rate', 'NUMBER'),
('Megapixels', 'NUMBER'),
('Capacity', 'NUMBER'),
('Processor', 'TEXT'),
('Water Resistance', 'BOOLEAN');

-- Insert sample products
INSERT INTO product (name, description, brand_id, category_id, base_price) VALUES 
('iPhone 13 Pro', 'Apple iPhone 13 Pro with A15 Bionic chip', 1, 1, 999.00),
('Galaxy S22 Ultra', 'Samsung Galaxy S22 Ultra with S Pen', 2, 1, 1199.99),
('Mate 50 Pro', 'Huawei Mate 50 Pro with Leica cameras', 3, 1, 1099.00);


ADDITIONAL TABLES:

CREATE TABLE customer (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Address table for shipping/billing
CREATE TABLE address (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_type ENUM('SHIPPING', 'BILLING') NOT NULL,
    street_address1 VARCHAR(100) NOT NULL,
    street_address2 VARCHAR(100),
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

-- Orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    shipping_address_id INT,
    billing_address_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(id),
    FOREIGN KEY (billing_address_id) REFERENCES address(id)
);

-- Order items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_item_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(id)
);