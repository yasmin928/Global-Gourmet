SET IDENTITY_INSERT Orders ON;
DECLARE @i INT = 1;

WHILE @i <= 10000
BEGIN
    DECLARE @OrderDate DATETIME = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());
    DECLARE @RequiredDate DATETIME = DATEADD(DAY, 5 + ABS(CHECKSUM(NEWID())) % 10, @OrderDate); -- RequiredDate is 5 to 15 days after OrderDate
    DECLARE @ShippedDate DATETIME = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 5, @OrderDate) ELSE NULL END; -- Randomly assign a ShippedDate or NULL
    DECLARE @ShipVia INT = (SELECT TOP 1 EmployeeID FROM Employees ORDER BY NEWID()); -- Use EmployeeID as ShipVia
    DECLARE @Freight DECIMAL(10, 2) = CAST(ROUND(RAND() * 100, 2) AS DECIMAL(10, 2)); -- Random Freight value

    INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry)
    VALUES (
        @i, 
        (SELECT TOP 1 CustomerID FROM Customers ORDER BY NEWID()), -- Randomly select a CustomerID
        (SELECT TOP 1 EmployeeID FROM Employees ORDER BY NEWID()), -- Randomly select an EmployeeID
        @OrderDate,
        @RequiredDate,
        @ShippedDate,
        @ShipVia,
        @Freight,
        'Company ' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR(10)), -- Sample ShipName as a company name
        CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR(10)) + ' Example St', -- Sample ShipAddress
        CASE 
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 0 THEN 'New York'
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 1 THEN 'Los Angeles'
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 2 THEN 'Chicago'
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 3 THEN 'Houston'
            ELSE 'Phoenix'
        END, -- Sample ShipCity
        CASE 
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 0 THEN 'NY'
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 1 THEN 'CA'
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 2 THEN 'IL'
            WHEN ABS(CHECKSUM(NEWID())) % 5 = 3 THEN 'TX'
            ELSE 'AZ'
        END, -- Sample ShipRegion
        CAST(ABS(CHECKSUM(NEWID())) % 90000 + 10000 AS VARCHAR(10)), -- Sample ShipPostalCode
        'USA' -- Sample ShipCountry
    );

    SET @i = @i + 1;
END

--ORDER DETAILS

DECLARE @MaxOrders INT = 10000; -- Number of Orders to process
DECLARE @MaxProducts INT = (SELECT COUNT(*) FROM Products); -- Count of Products for random selection

DECLARE @OrderID INT = 1; -- Start with the first OrderID

-- Loop through each OrderID
WHILE @OrderID <= @MaxOrders
BEGIN
    DECLARE @NumDetails INT = 1 + ABS(CHECKSUM(NEWID())) % 5; -- Randomly generate 1 to 5 OrderDetails for each OrderID
    DECLARE @DetailCount INT = 1;

    -- Inner loop to insert multiple details for the current OrderID
    WHILE @DetailCount <= @NumDetails
    BEGIN
        DECLARE @ProductID INT = (SELECT TOP 1 ProductID FROM Products ORDER BY NEWID()); -- Randomly select a ProductID
        DECLARE @UnitPrice MONEY = CAST(ROUND(RAND() * 100, 2) AS MONEY); -- Random UnitPrice between 0 and 100
        DECLARE @Quantity SMALLINT = 1 + ABS(CHECKSUM(NEWID())) % 10; -- Random Quantity between 1 and 10
        DECLARE @Discount REAL = CAST(ROUND(RAND(), 2) AS REAL); -- Random Discount between 0.0 and 1.0

        -- Insert the OrderDetail for the current OrderID
        INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
        VALUES (
            @OrderID,
            @ProductID,
            @UnitPrice,
            @Quantity,
            @Discount
        );

        SET @DetailCount = @DetailCount + 1; -- Move to the next detail
    END;

    SET @OrderID = @OrderID + 1; -- Move to the next OrderID
END;


-- Deleting orders with no order details
DELETE FROM Orders
WHERE OrderID NOT IN (SELECT DISTINCT OrderID FROM OrderDetails);

