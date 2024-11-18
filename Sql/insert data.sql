-- Insert data into EmployeeTerritories table

--1
BULK INSERT dbo.EmployeeTerritories
FROM 'E:\DEPI\project\archive\employee_territories.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--2
BULK INSERT dbo.OrderDetails
FROM 'E:\DEPI\project\archive\orders_details.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--3
BULK INSERT dbo.Regions
FROM 'E:\DEPI\project\archive\regions.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--4
BULK INSERT dbo.Products
FROM 'E:\DEPI\project\archive\products.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--5
BULK INSERT dbo.Suppliers
FROM 'E:\DEPI\project\archive\suppliers.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--6
BULK INSERT dbo.Shippers
FROM 'E:\DEPI\project\archive\shippers.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--7
BULK INSERT dbo.Territories
FROM 'E:\DEPI\project\archive\territories.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO


--Inser Categories

BULK INSERT dbo.Categories
FROM 'E:\DEPI\project\archive\categories.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--Inser Customers
BULK INSERT dbo.Customers
FROM 'E:\DEPI\project\archive\customers.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO

--Inser Orders
BULK INSERT dbo.Orders
FROM 'E:\DEPI\project\archive\orders.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO
--Inset Employees
BULK INSERT dbo.Employees
FROM 'E:\DEPI\project\archive\employees.csv'
WITH (
    FORMAT = 'csv',
	FIRSTROW = 2
);
GO


