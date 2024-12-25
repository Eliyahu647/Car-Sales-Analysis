-- **Sales Analysis by Cars**

-- **Number of Orders from Each Car**
SELECT 
    Product_Type AS [Car],
    SUM(Quantity) AS [Quantity_Orders]
FROM Sales s
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY Product_Type;

/* Description: Total number of orders for each car type */

-- **Total Margin by Each Car**
SELECT 
    Product_Type AS [Car],
    SUM(s.Total_Margin) AS [Total_Margin]
FROM Sales s
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY Product_Type;

/* Description: Total profit margin for each car type */

-- **Average Delivery Time by Car**
SELECT 
    im.Product_Type AS [Car],
    AVG(s.Delivery_Time) AS [Avg_Delivery_Time]
FROM Sales s
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY im.Product_Type;

/* Description: Average delivery time for each car type */

-- **Sales by Year**

-- **Quantity Sold Per Year**
SELECT 
    YEAR(order_date) AS [Year],
    SUM(Quantity) AS [Total_Quantity]
FROM Sales
GROUP BY YEAR(order_date);

/* Description: Total quantity of cars sold per year */

-- **Number of Orders Per Year**
SELECT 
    YEAR(order_date) AS [Year],
    COUNT(*) AS [Total_Orders]
FROM Sales
GROUP BY YEAR(order_date);

/* Description: Total number of orders per year */

-- **Orders Per Year for Each Car**
SELECT 
    YEAR(s.Order_date) AS [Year],
    im.Product_Type AS [Car],
    COUNT(*) AS [Yearly_Orders],
    COUNT(*) - LAG(COUNT(*)) OVER (PARTITION BY im.Product_Type ORDER BY YEAR(s.Order_date)) AS [Yearly_Difference]
FROM Sales s
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY YEAR(s.Order_date), im.Product_Type;

/* Description: Number of orders per year for each car and yearly difference */

-- **Sales Per Year for Each Car**
SELECT 
    YEAR(s.Order_date) AS [Year],
    im.Product_Type AS [Car],
    SUM(Quantity) AS [Yearly_Orders],
    SUM(Quantity) - LAG(SUM(Quantity)) OVER (PARTITION BY im.Product_Type ORDER BY YEAR(s.Order_date)) AS [Yearly_Difference]
FROM Sales s
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY YEAR(s.Order_date), im.Product_Type;

/* Description: Total sales per year for each car and yearly difference */

-- **Most Expensive Cars (Average Price)**
SELECT 
    im.Product_Type AS [Car],
    CAST(AVG(s.Sales) AS INT) AS [Avg_Price]
FROM Sales s
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY im.Product_Type;

/* Description: Average price of cars */

-- **Sales by Location**

-- **Total Orders Per Country**
SELECT 
    Region AS [Country],
    COUNT(*) AS [Total_Orders]
FROM City_Master cm
INNER JOIN Customers_Master cma ON cm.City_Code = cma.City_Code
INNER JOIN Sales s ON s.Customer_No = cma.Customer_Number
GROUP BY Region;

/* Description: Total number of orders per country */

-- **Orders for Each Car Per Country**
SELECT 
    Region AS [Country],
    im.Product_Type AS [Car],
    COUNT(*) AS [Total_Orders]
FROM City_Master cm
INNER JOIN Customers_Master cma ON cm.City_Code = cma.City_Code
INNER JOIN Sales s ON s.Customer_No = cma.Customer_Number
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY cm.Region, im.Product_Type;

/* Description: Number of orders for each car type per country */

-- **Most Ordered Car by Country**
WITH Cars_Ranking AS (
    SELECT 
        cm.Region AS [Country],
        im.Product_Type AS [Car],
        SUM(s.Quantity) AS [Total_Orders],
        RANK() OVER (PARTITION BY cm.Region ORDER BY SUM(s.Quantity) DESC) AS [Rank]
    FROM City_Master cm
    INNER JOIN Customers_Master cma ON cm.City_Code = cma.City_Code
    INNER JOIN Sales s ON s.Customer_No = cma.Customer_Number
    INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
    GROUP BY cm.Region, im.Product_Type
)
SELECT 
    Country, 
    Car, 
    Total_Orders
FROM Cars_Ranking
WHERE [Rank] = 1;

/* Description: Most ordered car type in each country */

-- **Sales by Customers**

-- **Total Orders by Customers**
SELECT 
    cm.Customer AS [Customer],
    cma.Region AS [Region],
    COUNT(*) AS [Total_Orders]
FROM Sales s
INNER JOIN Customers_Master cm ON s.Customer_No = cm.Customer_Number
INNER JOIN City_Master cma ON cma.City_Code = cm.City_Code
GROUP BY cm.Customer, cma.Region;

/* Description: Total number of orders by customers */

-- **Most Common Car by Customer**
WITH CarRanking_ByCustomer AS (
    SELECT 
        cm.Customer AS [Customer],
        im.Product_Type AS [Car],
        COUNT(*) AS [Total_Orders],
        RANK() OVER (PARTITION BY cm.Customer ORDER BY COUNT(*) DESC) AS [Rank]
    FROM Sales s
    INNER JOIN Customers_Master cm ON s.Customer_No = cm.Customer_Number
    INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
    GROUP BY cm.Customer, im.Product_Type
)
SELECT 
    Customer, 
    Car, 
    Total_Orders
FROM CarRanking_ByCustomer
WHERE [Rank] = 1;

/* Description: Most commonly ordered car for each customer */

-- **Profit Margin (%)**
SELECT 
    im.Product_Type AS [Car],
    SUM(s.Margin) / SUM(s.Sales) AS [Profit_Margin]
FROM Sales s
INNER JOIN Item_Master im ON s.Item_No = im.Item_Number
GROUP BY im.Product_Type;

/* Description: Profit margin percentage for each car type */

-- **Distributions by Quarter and Month**
SELECT 
    YEAR(order_date) AS [Year],
    MONTH(order_date) AS [Month],
    COUNT(*) AS [Total_Orders]
FROM Sales
WHERE YEAR(order_date) != 2020
GROUP BY YEAR(order_date), MONTH(order_date);

/* Description: Order distribution by year and month, excluding 2020 */
