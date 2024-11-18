USE GlobalGourmet;
GO
--1 Get the price of an order from order details
select ProductID, UnitPrice*Quantity as price from OrderDetails;


--2 find complete name of all employees sorted from the oldest to newest employee
select firstName + ' ' + lastname as fullname, HireDate
from Employees
order by HireDate;

--3 display data of all employees those working as sales represntative 
select * from Employees where Title = 'Sales Representative';

--4 get product list where current product cost less than 20$
select ProductName,ProductID,UnitPrice from Products where UnitPrice < 20
order by UnitPrice asc;

--5 get discounted product list 
select ProductID, ProductName, Discontinued from Products 
where Discontinued = 0 ;

--6 get most expensive and least expensive products 
select ProductName,UnitPrice from Products
where UnitPrice in 
(select min(UnitPrice) from products)
or UnitPrice in 
(select max (UnitPrice) from products);

--7 get product list of above average price 
  select ProductName,UnitPrice from Products
where UnitPrice > (select avg (UnitPrice) from products); 

--8 get product list of ten most expensive products 
select top 10 ProductName,UnitPrice from Products
order by UnitPrice desc;

--9 count current and discounted products 
select Discontinued, count (*) as count_products from products
group by Discontinued;

--10 show Category Information
select CategoryName, Description from Categories
order by CategoryName;

--11 Show the category_name and the average product unit price for each category 
select CategoryName, round(avg(UnitPrice), 2) as avg_unit_price
from Categories
join Products on Products.CategoryID = Categories.CategoryID
group by CategoryName;
 
 --12 show the Employee Shipping Performance
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
 
 --13 Get the count of all Orders made during specific year like 1997  
SELECT COUNT(*) AS [Number of Orders During 1997]
FROM Orders
where YEAR(OrderDate) = 1997
 
 --14 show all the orders of 1996 and their Customers
 SELECT *
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = '1996';

--15 show the number of employees and customers from each city that has employees in it:
SELECT e.City AS City, COUNT(DISTINCT e.EmployeeID) AS [Number of Employees], COUNT(DISTINCT c.CustomerID) AS [Number of Customers]
FROM Employees e 
LEFT JOIN Customers c ON e.City = c.City
GROUP BY e.City
ORDER BY City;

--16 show records for products for which the quantity ordered is fewer than 300
 SELECT o.ProductID, p.ProductName, SUM(o.Quantity) AS [Total Quantity]
FROM [OrderDetails] o
JOIN Products p ON p.ProductID = o.ProductID
GROUP BY o.ProductID, p.ProductName
HAVING SUM(o.Quantity) < 300
ORDER BY [Total Quantity] DESC;

--17 show  total revenues in 1997
SELECT SUM(([OrderDetails].UnitPrice)* [OrderDetails].Quantity * (1.0-[OrderDetails].Discount)) AS [1997 Total Revenues]
FROM [OrderDetails]
INNER JOIN (SELECT OrderID FROM Orders WHERE YEAR(OrderDate) = '1997') AS Ord 
ON Ord.OrderID = [OrderDetails].OrderID

--18  Find the 10 top selling products
SELECT Products.ProductName, SUM([OrderDetails].UnitPrice * [OrderDetails].Quantity * (1.0- [OrderDetails].Discount)) AS [Sales]
FROM Products
INNER JOIN [OrderDetails]
ON [OrderDetails].ProductID = Products.ProductID
GROUP BY Products.ProductName
ORDER BY [Sales] DESC;
GO

--19 show total revenues per customer
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
GO

--20 