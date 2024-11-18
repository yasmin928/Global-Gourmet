-- Create the database
CREATE DATABASE GlobalGourmet;
GO

USE GlobalGourmet;
GO

SET NOCOUNT ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Set DATEFORMAT so that the date strings are interpreted correctly regardless of the default DATEFORMAT on the server.
SET DATEFORMAT mdy
GO

-- Drop any existing stored procedures, views, or tables
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Employee Sales by Country') AND sysstat & 0xf = 4)
    DROP PROCEDURE "dbo"."Employee Sales by Country"
GO
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Sales by Year') AND sysstat & 0xf = 4)
    DROP PROCEDURE "dbo"."Sales by Year"
GO
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID('dbo.Ten Most Expensive Products') AND sysstat & 0xf = 4)
    DROP PROCEDURE "dbo"."Ten Most Expensive Products"
GO

-- Additional drops for views and tables
-- (Add all your necessary drop statements here as done above)

-- Create Employees table with 1NF, 2NF, and 3NF
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1, 1) NOT NULL,
    LastName NVARCHAR(20) NOT NULL,
    FirstName NVARCHAR(15) NOT NULL,
    Title NVARCHAR(30) NULL,
    TitleOfCourtesy NVARCHAR(25) NULL,
    BirthDate DATETIME NULL,
    HireDate DATETIME NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    PostalCode NVARCHAR(10) NULL,
    Country NVARCHAR(15) NULL,
    HomePhone NVARCHAR(24) NULL,
    Extension NVARCHAR(4) NULL,
    Photo IMAGE NULL,
    Notes NTEXT NULL,
    ReportsTo INT NULL,
    PhotoPath NVARCHAR(255) NULL,

    CONSTRAINT PK_Employees PRIMARY KEY CLUSTERED (EmployeeID),
    CONSTRAINT FK_Employees_ReportsTo FOREIGN KEY (ReportsTo) REFERENCES Employees(EmployeeID),
    CONSTRAINT CK_BirthDate CHECK (BirthDate < GETDATE())
)
GO

CREATE INDEX IDX_LastName ON dbo.Employees(LastName)
GO
CREATE INDEX IDX_PostalCode ON dbo.Employees(PostalCode)
GO

-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1, 1) NOT NULL,
    CategoryName NVARCHAR(15) NOT NULL,
    Description NTEXT NULL,
    Picture IMAGE NULL,
    CONSTRAINT PK_Categories PRIMARY KEY CLUSTERED (CategoryID)
)
GO
CREATE INDEX IDX_CategoryName ON dbo.Categories(CategoryName)
GO

-- Create Customers table
CREATE TABLE Customers (
    CustomerID NCHAR(5) NOT NULL,
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30) NULL,
    ContactTitle NVARCHAR(30) NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    PostalCode NVARCHAR(10) NULL,
    Country NVARCHAR(15) NULL,
    Phone NVARCHAR(24) NULL,
    Fax NVARCHAR(24) NULL,
    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerID)
)
GO
CREATE INDEX IDX_City ON dbo.Customers(City)
GO
CREATE INDEX IDX_CompanyName ON dbo.Customers(CompanyName)
GO
CREATE INDEX IDX_PostalCode ON dbo.Customers(PostalCode)
GO
CREATE INDEX IDX_Region ON dbo.Customers(Region)
GO

-- Create Shippers table
CREATE TABLE Shippers (
    ShipperID INT IDENTITY(1, 1) NOT NULL,
    CompanyName NVARCHAR(40) NOT NULL,
    Phone NVARCHAR(24) NULL,
    CONSTRAINT PK_Shippers PRIMARY KEY CLUSTERED (ShipperID)
)
GO

-- Create Suppliers table
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1, 1) NOT NULL,
    CompanyName NVARCHAR(40) NOT NULL,
    ContactName NVARCHAR(30) NULL,
    ContactTitle NVARCHAR(30) NULL,
    Address NVARCHAR(60) NULL,
    City NVARCHAR(15) NULL,
    Region NVARCHAR(15) NULL,
    PostalCode NVARCHAR(10) NULL,
    Country NVARCHAR(15) NULL,
    Phone NVARCHAR(24) NULL,
    Fax NVARCHAR(24) NULL,
    HomePage NTEXT NULL,
    CONSTRAINT PK_Suppliers PRIMARY KEY CLUSTERED (SupplierID)
)
GO
CREATE INDEX IDX_Suppliers_CompanyName ON dbo.Suppliers(CompanyName)
GO
CREATE INDEX IDX_Suppliers_PostalCode ON dbo.Suppliers(PostalCode)
GO

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1, 1) NOT NULL,
    CustomerID NCHAR(5) NULL,
    EmployeeID INT NULL,
    OrderDate DATETIME NULL,
    RequiredDate DATETIME NULL,
    ShippedDate DATETIME NULL,
    ShipVia INT NULL,
    Freight MONEY NULL CONSTRAINT DF_Orders_Freight DEFAULT(0),
    ShipName NVARCHAR(40) NULL,
    ShipAddress NVARCHAR(60) NULL,
    ShipCity NVARCHAR(15) NULL,
    ShipRegion NVARCHAR(15) NULL,
    ShipPostalCode NVARCHAR(10) NULL,
    ShipCountry NVARCHAR(15) NULL,

    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (OrderID),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID),
    CONSTRAINT FK_Orders_Shippers FOREIGN KEY (ShipVia) REFERENCES dbo.Shippers(ShipperID)
)
GO
CREATE INDEX IDX_Orders_CustomerID ON dbo.Orders(CustomerID)
GO
CREATE INDEX IDX_Orders_EmployeeID ON dbo.Orders(EmployeeID)
GO
CREATE INDEX IDX_Orders_OrderDate ON dbo.Orders(OrderDate)
GO
CREATE INDEX IDX_Orders_ShippedDate ON dbo.Orders(ShippedDate)
GO

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(1, 1) NOT NULL,
    ProductName NVARCHAR(40) NOT NULL,
    SupplierID INT NULL,
    CategoryID INT NULL,
    QuantityPerUnit NVARCHAR(20) NULL,
    UnitPrice MONEY NULL CONSTRAINT DF_Products_UnitPrice DEFAULT(0),
    UnitsInStock SMALLINT NULL CONSTRAINT DF_Products_UnitsInStock DEFAULT(0),
    UnitsOnOrder SMALLINT NULL CONSTRAINT DF_Products_UnitsOnOrder DEFAULT(0),
    ReorderLevel SMALLINT NULL CONSTRAINT DF_Products_ReorderLevel DEFAULT(0),
    Discontinued BIT NOT NULL CONSTRAINT DF_Products_Discontinued DEFAULT(0),

    CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (ProductID),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID),
    CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID),
    CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT CK_ReorderLevel CHECK (ReorderLevel >= 0),
    CONSTRAINT CK_UnitsInStock CHECK (UnitsInStock >= 0),
    CONSTRAINT CK_UnitsOnOrder CHECK (UnitsOnOrder >= 0)
)
GO
CREATE INDEX IDX_Products_CategoryID ON dbo.Products(CategoryID)
GO
CREATE INDEX IDX_Products_SupplierID ON dbo.Products(SupplierID)
GO
CREATE INDEX IDX_Products_ProductName ON dbo.Products(ProductName)
GO

-- Create Order Details table
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice MONEY NOT NULL CONSTRAINT DF_Order_Details_UnitPrice DEFAULT(0),
    Quantity SMALLINT NOT NULL CONSTRAINT DF_Order_Details_Quantity DEFAULT(1),
    Discount REAL NOT NULL CONSTRAINT DF_Order_Details_Discount DEFAULT(0),

    CONSTRAINT PK_Order_Details PRIMARY KEY CLUSTERED (OrderID, ProductID),
    CONSTRAINT FK_Order_Details_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_Order_Details_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
    CONSTRAINT CK_Discount CHECK (Discount >= 0 AND Discount <= 1),
    CONSTRAINT CK_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_UnitPrice CHECK (UnitPrice >= 0)
)
GO
CREATE INDEX IDX_OrderID ON dbo.OrderDetails(OrderID)
GO
CREATE INDEX IDX_ProductID ON dbo.OrderDetails(ProductID)
GO

-- Create Territories table
CREATE TABLE Territories (
    TerritoryID INT IDENTITY(1, 1) NOT NULL,
    TerritoryDescription NVARCHAR(50) NOT NULL,
    RegionID INT NOT NULL,

    CONSTRAINT PK_Territories PRIMARY KEY CLUSTERED (TerritoryID)
);
GO

-- Create EmployeeTerritories table
CREATE TABLE EmployeeTerritories (
    EmployeeID INT NOT NULL,
    TerritoryID INT NOT NULL,

    CONSTRAINT PK_EmployeeTerritories PRIMARY KEY CLUSTERED (EmployeeID, TerritoryID),
    CONSTRAINT FK_EmployeeTerritories_Employees FOREIGN KEY (EmployeeID) REFERENCES dbo.Employees(EmployeeID),
    CONSTRAINT FK_EmployeeTerritories_Territories FOREIGN KEY (TerritoryID) REFERENCES dbo.Territories(TerritoryID)
);
GO

CREATE TABLE Regions (
    RegionID INT IDENTITY(1, 1) NOT NULL,
    RegionDescription NVARCHAR(50) NOT NULL,

    CONSTRAINT PK_Regions PRIMARY KEY CLUSTERED (RegionID)
);