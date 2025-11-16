CREATE DATABASE IF NOT EXISTS shopping_Module;

USE shopping__Module;


CREATE TABLE shopping_trends (
    `Customer ID`                INT,
    `Age`                        INT,
    `Gender`                     VARCHAR(10),
    `Item Purchased`             VARCHAR(100),
    `Category`                   VARCHAR(50),
    `Purchase Amount (USD)`      INT,
    `Location`                   VARCHAR(100),
    `Size`                       VARCHAR(10),
    `Color`                      VARCHAR(50),
    `Season`                     VARCHAR(20),
    `Review Rating`              DECIMAL(3,1),
    `Subscription Status`        VARCHAR(10),
    `Payment Method`             VARCHAR(50),
    `Shipping Type`              VARCHAR(50),
    `Discount Applied`           VARCHAR(10),
    `Promo Code Used`            VARCHAR(10),
    `Previous Purchases`         INT,
    `Preferred Payment Method`   VARCHAR(50),
    `Frequency of Purchases`     VARCHAR(50),
    `Purchase_Date`              DATE NULL,
    PRIMARY KEY (`Customer ID`)
);

LOAD DATA INFILE 'C:/path/to/shopping_trends.csv'
INTO TABLE shopping_trends
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    `Customer ID`,
    `Age`,
    `Gender`,
    `Item Purchased`,
    `Category`,
    `Purchase Amount (USD)`,
    `Location`,
    `Size`,
    `Color`,
    `Season`,
    `Review Rating`,
    `Subscription Status`,
    `Payment Method`,
    `Shipping Type`,
    `Discount Applied`,
    `Promo Code Used`,
    `Previous Purchases`,
    `Preferred Payment Method`,
    `Frequency of Purchases`
  
);

SELECT * FROM shopping_trends LIMIT 10;


SELECT COUNT(*) AS total_rows
FROM shopping_trends;

-
SELECT `Customer ID`, COUNT(*) AS cnt
FROM shopping_trends
GROUP BY `Customer ID`
HAVING COUNT(*) > 1;


SELECT 
    SUM(CASE WHEN `Age` IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN `Gender` IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN `Item Purchased` IS NULL THEN 1 ELSE 0 END) AS missing_item,
    SUM(CASE WHEN `Purchase Amount (USD)` IS NULL THEN 1 ELSE 0 END) AS missing_amount
FROM shopping_trends;



SELECT 
    `Age`,
    AVG(`Purchase Amount (USD)`) AS avg_spend
FROM shopping_trends
GROUP BY `Age`
ORDER BY `Age`;


SELECT 
    `Gender`,
    AVG(`Purchase Amount (USD)`) AS avg_spend
FROM shopping_trends
GROUP BY `Gender`;


SELECT
    `Frequency of Purchases`,
    AVG(`Purchase Amount (USD)`) AS avg_spend
FROM shopping_trends
GROUP BY `Frequency of Purchases`
ORDER BY avg_spend DESC;


SELECT
    `Item Purchased`,
    COUNT(*) AS total_orders,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM shopping_trends
GROUP BY `Item Purchased`
ORDER BY total_revenue DESC
LIMIT 10;


SELECT
    `Category`,
    COUNT(*) AS total_orders,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM shopping_trends
GROUP BY `Category`
ORDER BY total_revenue DESC;


SELECT
    `Location`,
    COUNT(*) AS total_orders,
    SUM(`Purchase Amount (USD)`) AS total_revenue,
    AVG(`Purchase Amount (USD)`) AS avg_order_value
FROM shopping_trends
GROUP BY `Location`
ORDER BY total_revenue DESC;


SELECT
    `Location`,
    `Season`,
    SUM(`Purchase Amount (USD)`) AS total_revenue
FROM shopping_trends
GROUP BY `Location`, `Season`
ORDER BY total_revenue DESC;

-- Summary per customer: total orders and total spend
CREATE OR REPLACE VIEW customer_summary AS
SELECT
    `Customer ID` AS customer_id,
    -- number of orders from this table + previous purchases column
    (COUNT(*) + MAX(`Previous Purchases`)) AS total_orders,
    SUM(`Purchase Amount (USD)`) AS total_spent
FROM shopping_trends
GROUP BY `Customer ID`;

-- Simple segmentation using only Frequency (total_orders) and Money (total_spent)
CREATE OR REPLACE VIEW customer_segments AS
SELECT
    customer_id,
    total_orders,
    total_spent,
    CASE
        WHEN total_spent >= 500 AND total_orders >= 10
            THEN 'Champion'
        WHEN total_spent >= 500 AND total_orders < 10
            THEN 'Big Spender'
        WHEN total_spent < 500 AND total_orders >= 10
            THEN 'Frequent Loyal'
        ELSE 'Low Value'
    END AS segment
FROM customer_summary;

-- how many customers in each segment
SELECT
    segment,
    COUNT(*) AS num_customers
FROM customer_segments
GROUP BY segment;

-- Revenue by segment
SELECT
    cs.segment,
    SUM(st.`Purchase Amount (USD)`) AS total_revenue,
    AVG(st.`Purchase Amount (USD)`) AS avg_order_value
FROM shopping_trends st
JOIN customer_segments cs
    ON st.`Customer ID` = cs.customer_id
GROUP BY cs.segment
ORDER BY total_revenue DESC;

-- Top products bought by Champions
SELECT
    st.`Item Purchased`,
    COUNT(*) AS total_orders,
    SUM(st.`Purchase Amount (USD)`) AS total_revenue
FROM shopping_trends st
JOIN customer_segments cs
    ON st.`Customer ID` = cs.customer_id
WHERE cs.segment = 'Champion'
GROUP BY st.`Item Purchased`
ORDER BY total_revenue DESC
LIMIT 10;

-- Locations with many Big Spenders
SELECT
    st.`Location`,
    COUNT(DISTINCT cs.customer_id) AS big_spender_customers,
    SUM(st.`Purchase Amount (USD)`) AS total_revenue
FROM shopping_trends st
JOIN customer_segments cs
    ON st.`Customer ID` = cs.customer_id
WHERE cs.segment = 'Big Spender'
GROUP BY st.`Location`
ORDER BY total_revenue DESC;
