from sqlalchemy import Boolean, Column, DateTime, Integer, Numeric, SmallInteger, String, Text, LargeBinary, ForeignKey, Date, Float
from app import db

class Employee(db.Model):
    __tablename__ = 'employees'
    
    EmployeeID = db.Column(Integer, primary_key=True)
    LastName = db.Column(String(20), nullable=False)
    FirstName = db.Column(String(15), nullable=False)
    Title = db.Column(String(30), nullable=True)
    BirthDate = db.Column(Date, nullable=True)
    HireDate = db.Column(Date, nullable=True)
    Address = db.Column(String(60), nullable=True)
    City = db.Column(String(15), nullable=True)
    Region = db.Column(String(15), nullable=True)
    PostalCode = db.Column(String(10), nullable=True)
    Country = db.Column(String(15), nullable=True)
    HomePhone = db.Column(String(24), nullable=True)
    Extension = db.Column(String(4), nullable=True)
    Photo = db.Column(LargeBinary, nullable=True)
    Notes = db.Column(Text, nullable=True)
    ReportsTo = db.Column(Integer, ForeignKey('employees.EmployeeID'), nullable=True)
    PhotoPath = db.Column(String(255), nullable=True)
    
    # Relationship with Orders
    orders = db.relationship('Order', backref='employee', lazy=True)

class Customer(db.Model):
    __tablename__ = 'customers'
    
    CustomerID = db.Column(String(5), primary_key=True)
    CompanyName = db.Column(String(40), nullable=False)
    ContactName = db.Column(String(30), nullable=True)
    ContactTitle = db.Column(String(30), nullable=True)
    Address = db.Column(String(60), nullable=True)
    City = db.Column(String(15), nullable=True)
    Region = db.Column(String(15), nullable=True)
    PostalCode = db.Column(String(10), nullable=True)
    Country = db.Column(String(15), nullable=True)
    Phone = db.Column(String(24), nullable=True)
    Fax = db.Column(String(24), nullable=True)
    
    # Relationship with Orders
    orders = db.relationship('Order', backref='customer', lazy=True)

class Order(db.Model):
    __tablename__ = 'orders'
    
    OrderID = db.Column(Integer, primary_key=True)
    CustomerID = db.Column(String(5), ForeignKey('customers.CustomerID'))
    EmployeeID = db.Column(Integer, ForeignKey('employees.EmployeeID'))
    OrderDate = db.Column(Date, nullable=True)
    RequiredDate = Column(DateTime)
    ShippedDate = db.Column(String(60), nullable=True)
    # ShipVia = db.Column(Integer, ForeignKey('Shippers.ShipperID')) 
    Freight = Column(Numeric(10, 2), default=0)
    ShipName = Column(String(40))
    ShipAddress = Column(String(60))
    ShipCity = Column(String(15))
    ShipRegion = Column(String(15))
    ShipPostalCode = Column(String(10))
    ShipCountry = Column(String(15))
    
    # Relationship with OrderDetails
    order_details = db.relationship('OrderDetail', backref='order', lazy=True)

class OrderDetail(db.Model):
    __tablename__ = 'orderdetails'
    
    OrderID = db.Column(Integer, ForeignKey('orders.OrderID'), primary_key=True)
    ProductID = db.Column(Integer, ForeignKey('products.ProductID'), primary_key=True)
    UnitPrice = db.Column(Float, nullable=False)
    Quantity = db.Column(Integer, nullable=False)
    Discount = db.Column(Float, nullable=False)

class Product(db.Model):
    __tablename__ = 'products'
    
    ProductID = db.Column(Integer, primary_key=True)
    ProductName = db.Column(String(40), nullable=False)
    SupplierID = Column(Integer, ForeignKey('Suppliers.SupplierID'))
    CategoryID = Column(Integer, ForeignKey('Categories.CategoryID'))
    QuantityPerUnit = Column(String(20))
    UnitPrice = Column(Numeric(10, 2), default=0)
    UnitsInStock = Column(SmallInteger, default=0)
    UnitsOnOrder = Column(SmallInteger, default=0)
    ReorderLevel = Column(SmallInteger, default=0)
    Discontinued = Column(Boolean, nullable=False, default=False)
    
    # Relationship with OrderDetails
    order_details = db.relationship('OrderDetail', backref='product', lazy=True)

class Category(db.Model):
    __tablename__ = 'categories'

    CategoryID = db.Column(Integer, primary_key=True)
    CategoryName = db.Column(String(15), nullable=False, index=True)
    Description = db.Column(Text, nullable=True)
    Picture = db.Column(LargeBinary, nullable=True)  

class Shipper(db.Model):
    __tablename__ = 'shippers'

    ShipperID = db.Column(Integer, primary_key=True)
    CompanyName = db.Column(String(40), nullable=False)
    Phone = db.Column(String(24), nullable=True)

class Supplier(db.Model):
    __tablename__ = 'suppliers'

    SupplierID = db.Column(Integer, primary_key=True)
    CompanyName = db.Column(String(40), nullable=False, index=True)
    ContactName = db.Column(String(30), nullable=True)
    ContactTitle = db.Column(String(30), nullable=True)
    Address = db.Column(String(60), nullable=True)
    City = db.Column(String(15), nullable=True)
    Region = db.Column(String(15), nullable=True)
    PostalCode = db.Column(String(10), nullable=True, index=True)
    Country = db.Column(String(15), nullable=True)
    Phone = db.Column(String(24), nullable=True)
    Fax = db.Column(String(24), nullable=True)
    HomePage = db.Column(Text, nullable=True)

class Territory(db.Model):
    __tablename__ = 'territories'

    TerritoryID = db.Column(Integer, primary_key=True)
    TerritoryDescription = db.Column(String(50), nullable=False)
    RegionID = db.Column(Integer, ForeignKey('regions.RegionID'), nullable=False)

class EmployeeTerritory(db.Model):
    __tablename__ = 'employee_territories'

    EmployeeID = db.Column(Integer, ForeignKey('employees.EmployeeID'), primary_key=True)
    TerritoryID = db.Column(Integer, ForeignKey('territories.TerritoryID'), primary_key=True)

class Region(db.Model):
    __tablename__ = 'regions'

    RegionID = db.Column(Integer, primary_key=True)
    RegionDescription = db.Column(String(50), nullable=False)

