USE GlobalGourmet;
GO

--1 find complete name of all employees sorted from the oldest to newest employee
select firstName + ' ' + lastname as fullname, HireDate
from Employees
order by HireDate;

--2 show  discounted product list 
select ProductID, ProductName, Discontinued from Products 
where Discontinued = 0;

--3 get most expensive and least expensive products 
select ProductName,UnitPrice from Products
where UnitPrice in 
(select min(UnitPrice) from products)
or UnitPrice in 
(select max (UnitPrice) from products);

--4 get product list of above average price 
  select ProductName,UnitPrice from Products
where UnitPrice > (select avg (UnitPrice) from products); 

--5 get product list of ten most expensive products 
select top 10 ProductName,UnitPrice from Products
order by UnitPrice desc;

--6 count current and discounted products 
select Discontinued, count (*) as count_products from products
group by Discontinued;

--7 show Category Information
select CategoryName, Description from Categories
order by CategoryName;

--8 Show the category_name and the average product unit price for each category 
select CategoryName, round(avg(UnitPrice), 2) as avg_unit_price
from Categories
join Products on Products.CategoryID = Categories.CategoryID
group by CategoryName;

--9 show the Employee Shipping Performance
SELECT Employees.FirstName,
       Employees.LastName,
       COUNT(Orders.OrderID) AS num_orders,
       CASE
           WHEN MAX(Orders.RequiredDate) > MAX(Orders.ShippedDate) THEN 'On Time'
           ELSE 'Late'
       END AS shipped
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.FirstName, Employees.LastName
ORDER BY Employees.FirstName, num_orders DESC;

--10  Get the count of all Orders made during years 
SELECT YEAR(OrderDate) AS OrderYear,
       COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

--11 show all the orders of 1997 and their Customers
 SELECT *
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = '1997';

--12 show the number of employees and customers from each city that has employees in it:
SELECT e.City AS City, COUNT(DISTINCT e.EmployeeID) AS [Number of Employees], COUNT(DISTINCT c.CustomerID) AS [Number of Customers]
FROM Employees e 
LEFT JOIN Customers c ON e.City = c.City
GROUP BY e.City
ORDER BY City;

--13 show records for products for which the quantity ordered is fewer than 300
   SELECT o.ProductID, p.ProductName, SUM(o.Quantity) AS [Total Quantity]
FROM [OrderDetails] o
JOIN Products p ON p.ProductID = o.ProductID
GROUP BY o.ProductID, p.ProductName
HAVING SUM(o.Quantity) < 300
ORDER BY [Total Quantity] DESC;

--14 show  total revenues in 1997
SELECT SUM(([OrderDetails].UnitPrice)* [OrderDetails].Quantity * (1.0-[OrderDetails].Discount)) AS [1997 Total Revenues]
FROM [OrderDetails]
INNER JOIN (SELECT OrderID FROM Orders WHERE YEAR(OrderDate) = '1997') AS Ord 
ON Ord.OrderID = [OrderDetails].OrderID;

--15 Find the 10 top selling products:
SELECT Products.ProductName, SUM([OrderDetails].UnitPrice * [OrderDetails].Quantity * (1.0- [OrderDetails].Discount)) AS [Sales]
FROM Products
INNER JOIN [OrderDetails]
ON [OrderDetails].ProductID = Products.ProductID
GROUP BY Products.ProductName
ORDER BY [Sales] DESC;

--16 show total revenues per customer
DROP VIEW IF EXISTS [Total Revenues Per Customer];
GO
CREATE VIEW [Total Revenues Per Customer] AS
	SELECT c.CustomerID, c.ContactName, ISNULL(CAST(CONVERT(money, SUM(od.UnitPrice * od.Quantity * (1.0-od.Discount)*100)/100) AS DECIMAL(11,2)),0) AS [Revenue]
	FROM Customers c
	FULL JOIN Orders o ON c.CustomerID = o.CustomerID
	FULL JOIN [OrderDetails] od ON od.OrderID = o.OrderID
	GROUP BY c.CustomerID, c.ContactName;
GO
SELECT *
FROM [Total Revenues Per Customer]
ORDER BY Revenue DESC;

--17 Select the name of customers who have not purchased any product
SELECT DISTINCT ContactName
FROM Customers 
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);

--18 show the name of the categories and the average price of products in each category
SELECT c.CategoryName, AVG(p.UnitPrice) AS [Average Price]
FROM Categories c
JOIN Products p ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY [Average Price];

--19  show the name of the companies that provide more than 3 products
SELECT s.SupplierID, s.CompanyName
FROM Suppliers s
JOIN Products p ON p.SupplierID = s.SupplierID
GROUP BY s.SupplierID, s.CompanyName
HAVING COUNT(p.ProductID) > 3;

-- -- stored procedures: 
--1  Get Suppliers for a Product:
CREATE procedure GetSuppliersForProduct
    @ProductID INT
AS
BEGIN
    SELECT s.SupplierID, s.CompanyName
    FROM Suppliers s
    JOIN Products p ON s.SupplierID = p.SupplierID
    WHERE p.ProductID = @ProductID;
END;
EXEC GetSuppliersForProduct @ProductID = 1;

--4 Trigger: Preventing Deletion of Managers

CREATE TRIGGER trg_PreventManagerDeletion
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM Employees WHERE EmployeeID IN (SELECT EmployeeID FROM deleted) AND EmployeeID IN (SELECT DISTINCT ReportsTo FROM Employees))
    BEGIN
        RAISERROR('Cannot delete an employee who is a manager.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Employees WHERE EmployeeID IN (SELECT EmployeeID FROM deleted);
    END
END;
------------------------------------------------------------------------------------------
-- Sales Analysis by Discount Status
	SELECT 
    CASE 
        WHEN Discount > 0 THEN 'With Discount'
        ELSE 'Without Discount'
    END AS DiscountStatus,
    SUM(UnitPrice * Quantity * (1 - Discount)) AS TotalSales,
    COUNT(OrderID) AS TotalOrders
FROM OrderDetails
GROUP BY 
    CASE 
        WHEN Discount > 0 THEN 'With Discount'
        ELSE 'Without Discount'
    END;
-- 23-	Analysis of Customer Behavior by Number of Orders and Average Order Value
SELECT c.CustomerID,
       c.CompanyName,
       COUNT(o.OrderID) AS TotalOrders,
       AVG(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS AvgOrderValue
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalOrders DESC;
	
--24 Product Sales Analysis:
SELECT p.ProductID,
       p.ProductName,
       SUM(od.Quantity) AS TotalUnitsSold,
       SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales,
       p.UnitsInStock
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.UnitsInStock
ORDER BY TotalSales DESC;
--25 
SELECT 
    CASE 
        WHEN ShippedDate IS NULL THEN 'Pending'
        WHEN ShippedDate <= RequiredDate THEN 'On Time'
        ELSE 'Late'
    END AS FulfillmentStatus,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY 
    CASE 
        WHEN ShippedDate IS NULL THEN 'Pending'
        WHEN ShippedDate <= RequiredDate THEN 'On Time'
        ELSE 'Late'
    END;