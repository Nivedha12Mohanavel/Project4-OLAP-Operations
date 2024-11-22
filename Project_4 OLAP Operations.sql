--PROJECT 4: OLAP Operations

-- Task 1: Database Creation

CREATE DATABASE SalesAnalysis;
USE SalesAnalysis;

-- Create the "sales_sample" table
CREATE TABLE sales_sample (
    Product_Id INT,
    Region NVARCHAR(50),
    Date DATE,
    Sales_Amount NUMERIC(10, 2)
);

-- Task 2: Data Creation

-- Insert sample sales data
INSERT INTO sales_sample (Product_Id, Region, Date, Sales_Amount)
VALUES 
    (101, 'East', '2024-11-01', 1200.00),
    (102, 'West', '2024-11-01', 1500.00),
    (103, 'North', '2024-11-02', 800.00),
    (104, 'South', '2024-11-02', 1100.00),
    (105, 'East', '2024-11-03', 1000.00),
    (106, 'West', '2024-11-03', 1300.00),
    (107, 'North', '2024-11-04', 900.00),
    (108, 'South', '2024-11-04', 1400.00),
    (109, 'East', '2024-11-05', 700.00),
    (110, 'West', '2024-11-05', 1250.00);

SELECT * FROM sales_sample;

-- Task 3: Perform OLAP operations

-- To perform drill down from region to product level to understand sales performance

SELECT Region, Product_Id, SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
GROUP BY Region, Product_Id
ORDER BY Region, Product_Id;

-- To perform roll up from product to region level to view total sales by region

SELECT Region, COALESCE(CAST(Product_Id AS NVARCHAR(10)), 'Total') AS Product_Level, SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
GROUP BY ROLLUP (Region, Product_Id)
ORDER BY Region, Product_Level;

-- To slice the data to view sales for a particular region or date range

SELECT * FROM sales_sample
WHERE Region = 'East';

SELECT * FROM sales_sample
WHERE Date BETWEEN '2024-11-02' AND '2024-11-04';

-- To view sales for specific combinations of product, region, and date

SELECT * FROM sales_sample
WHERE Product_Id IN (101, 102) 
	AND Region IN ('East', 'West') 
    AND Date BETWEEN '2024-11-01' AND '2024-11-03';

-- To Explore sales data from different perspectives, such as product, region, and date

SELECT 
    COALESCE(CAST(Product_Id AS NVARCHAR(10)), 'All Products') AS Product_Level,
    COALESCE(Region, 'All Regions') AS Region_Level,
    COALESCE(CAST(Date AS NVARCHAR(10)), 'All Dates') AS Date_Level,
    SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
GROUP BY CUBE (Product_Id, Region, Date)
ORDER BY Product_Level, Region_Level, Date_Level;
