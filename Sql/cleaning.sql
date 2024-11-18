-- Check for missing values in the Employees table
SELECT *
FROM Employees
WHERE FirstName IS NULL OR LastName IS NULL OR BirthDate IS NULL;


-- Remove Duplicates
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY FirstName, LastName, BirthDate ORDER BY EmployeeID) AS row_num
    FROM Employees
)
DELETE FROM CTE
WHERE row_num > 1;

-- Delete duplicates from Categories
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY CategoryName ORDER BY (SELECT NULL)) AS rn
    FROM dbo.Categories
)
DELETE FROM CTE WHERE rn > 1;

-- Delete duplicates from Shippers
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY CompanyName ORDER BY (SELECT NULL)) AS rn
    FROM dbo.Shippers
)
DELETE FROM CTE WHERE rn > 1;

-- Deleting orders with no order details
DELETE FROM Orders
WHERE OrderID NOT IN (SELECT DISTINCT OrderID FROM OrderDetails);


-- Check for invalid dates
SELECT *
FROM Orders
WHERE OrderDate < '1990-01-01' OR OrderDate > GETDATE();

-- Find orders where the shipped date is before the order date
SELECT *
FROM Orders
WHERE ShippedDate < OrderDate;

-- Deleting orders with no order details
DELETE FROM Orders
WHERE OrderID NOT IN (SELECT DISTINCT OrderID FROM OrderDetails);

--Filling missing values for the City column in Customers with 'Unknown'
UPDATE Customers
SET City = 'Unknown'
WHERE City IS NULL;