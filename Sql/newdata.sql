INSERT INTO Shippers (CompanyName, Phone)
VALUES 
('SwiftXpress Delivery', '(800) 123-9876'),
('DroneQuick Shipping', '(800) 456-4321'),
('EcoFleet Logistics', '(800) 654-7890'),
('NextGen Couriers', '(800) 876-5432'),
('Greenline Freight', '(800) 345-9876'),
('GlobalGo Shipping', '(800) 987-1234'),
('Skyline Express', '(800) 123-4567'),
('Jetstream Logistics', '(800) 543-6789'),
('RapidRoute Delivery', '(800) 678-1234'),
('OnTrack Worldwide', '(800) 234-9876');


INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage)
VALUES 
('Amazon Wholesale', 'Jeff Wilcox', 'Supply Chain Manager', '410 Terry Ave N', 'Seattle', 'WA', '98109', 'USA', '(206) 266-1000', '(206) 266-2950', 'https://www.amazon.com'),
('Alibaba Global Supplies', 'Li Jing', 'International Sales Manager', '699 Wang Shang Lu', 'Hangzhou', 'ZJ', '310052', 'China', '(86) 571-8502-2088', '(86) 571-8502-2089', 'https://www.alibaba.com'),
('Samsung Electronics', 'Kim Seok-jin', 'Head of Procurement', '129 Samsung-ro', 'Suwon', 'GG', '443-742', 'South Korea', '(82) 31-200-1114', '(82) 31-200-2225', 'https://www.samsung.com'),
('Tech Innovators', 'Amit Verma', 'Director of Sales', 'Plot 54, Industrial Area', 'Gurgaon', 'HR', '122001', 'India', '(91) 124-4321000', '(91) 124-4321001', 'https://www.techinnovators.com'),
('Tesla Parts', 'Elon Reeves', 'Procurement Officer', '3500 Deer Creek Rd', 'Palo Alto', 'CA', '94304', 'USA', '(650) 681-5100', '(650) 681-5101', 'https://www.tesla.com'),
('Nike Manufacturing', 'Phil Turner', 'Supply Chain Head', 'One Bowerman Dr.', 'Beaverton', 'OR', '97005', 'USA', '(503) 671-6453', '(503) 671-6454', 'https://www.nike.com'),
('Nestlé Wholesale', 'Emma Karlsson', 'Global Sourcing Manager', 'Avenue Nestlé 55', 'Vevey', 'VD', '1800', 'Switzerland', '(41) 21-924-1111', '(41) 21-924-1112', 'https://www.nestle.com'),
('Adidas International', 'Laura Gomez', 'Procurement Director', 'Adi-Dassler-Str. 1', 'Herzogenaurach', NULL, '91074', 'Germany', '(49) 9132-84-0', '(49) 9132-84-1', 'https://www.adidas.com'),
('BMW Parts', 'Stefan Muller', 'Head of Parts Sourcing', 'Petuelring 130', 'Munich', NULL, '80788', 'Germany', '(49) 89-382-0', '(49) 89-382-1', 'https://www.bmw.com'),
('Sony Components', 'Taro Yamada', 'Logistics Director', '1-7-1 Konan', 'Tokyo', NULL, '108-0075', 'Japan', '(81) 3-6748-2111', '(81) 3-6748-2112', 'https://www.sony.com');


INSERT INTO Territories (TerritoryDescription, RegionID)
VALUES 
('Northwest Tech Hub', 1),
('Southeast Logistics', 2),
('Northeast Commerce', 3),
('Pacific Innovation Region', 4),
('Midwest Manufacturing Zone', 5),
('Southwest Industrial Area', 6),
('East Coast Financial Sector', 7),
('West Coast Startup Valley', 8),
('Central Agriculture', 9),
('Northern E-commerce Zone', 10);

-- Insert new data into Employees table with corrected apostrophe escaping
INSERT INTO Employees (LastName, FirstName, Title, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension)
VALUES 
('Johnson', 'Emily', 'Global Sales Manager', '1985-06-15', '2010-08-22', '123 Elm St', 'San Francisco', 'CA', '94103', 'USA', '(415) 555-1234', '101'),
('Smith', 'Daniel', 'Chief Technology Officer', '1979-04-12', '2005-04-10', '456 Pine St', 'New York', 'NY', '10001', 'USA', '(212) 555-5678', '102'),
('Wang', 'Yao', 'Head of Logistics', '1987-09-22', '2011-03-30', '789 Maple Ave', 'Shenzhen', 'GD', '518000', 'China', '(755) 555-6789', '103'),
('Müller', 'Anna', 'HR Director', '1980-07-10', '2006-11-15', '12 Hauptstrasse', 'Berlin', NULL, '10178', 'Germany', '(30) 555-4321', '104'),
('Patel', 'Rajesh', 'Procurement Specialist', '1990-12-05', '2015-07-01', '25 Business Park Rd', 'Mumbai', 'MH', '400001', 'India', '(22) 555-9876', '105'),
('Garcia', 'Luis', 'Marketing Director', '1982-02-28', '2008-09-17', '678 Commerce St', 'Madrid', NULL, '28001', 'Spain', '(91) 555-5432', '106'),
('O''Connor', 'Maeve', 'Chief Operating Officer', '1975-11-02', '2002-05-20', '89 Executive Blvd', 'Dublin', NULL, 'D02 XT34', 'Ireland', '(1) 555-6543', '107'),
('Li', 'Wei', 'Finance Manager', '1983-08-11', '2009-12-02', '301 Finance Ln', 'Shanghai', 'SH', '200040', 'China', '(21) 555-3210', '108'),
('Berg', 'Sofia', 'Product Development Lead', '1986-03-30', '2012-06-22', '15 Innovation Dr', 'Stockholm', NULL, '11122', 'Sweden', '(46) 555-9876', '109'),
('Yamamoto', 'Taro', 'Regional Sales Director', '1988-05-18', '2013-11-25', '88 Market St', 'Tokyo', NULL, '108-0075', 'Japan', '(3) 555-7654', '110');

-- Insert data into Categories table (shortened to fit within 15-character limit)
INSERT INTO Categories (CategoryName, Description, Picture)
VALUES
('Dairy Products', 'Products from milk, including cheese and butter.', NULL),
('Grains & Cere', 'Cereal grains such as wheat, rice, and oats.', NULL),
('Fresh Produce', 'Fruits and vegetables that are fresh.', NULL),
('Snacks & Drink', 'Snacks like chips and non-alcoholic beverages.', NULL),
('Frozen Foods', 'Frozen meats, vegetables, and ready-to-eat meals.', NULL),
('Bakery Items', 'Baked goods such as bread, cakes, and pastries.', NULL),
('Seafood', 'Fresh and frozen fish and shellfish.', NULL),
('Meats', 'Variety of fresh, frozen, and deli meats.', NULL),
('Spices & Herbs', 'Dried spices, seasonings, and herbs.', NULL),
('Beverages', 'Drinks including soda, juice, and water.', NULL),
('Condiments', 'Sauces, ketchup, mustard, and other condiments.', NULL);




