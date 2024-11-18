from flask_wtf import FlaskForm
from wtforms import StringField, SelectField, IntegerField, DateField, DecimalField, SubmitField, FileField
from wtforms.validators import DataRequired, Optional, Length

# Customer Form
class CustomerForm(FlaskForm):
    CustomerID = StringField('Customer ID', validators=[DataRequired(), Length(max=5)])
    CompanyName = StringField('Company Name', validators=[DataRequired(), Length(max=40)])
    ContactName = StringField('Contact Name', validators=[DataRequired(), Length(max=30)])
    ContactTitle = StringField('Contact Title', validators=[Optional(), Length(max=30)])
    Address = StringField('Address', validators=[Optional(), Length(max=60)])
    City = StringField('City', validators=[Optional(), Length(max=15)])
    Region = StringField('Region', validators=[Optional(), Length(max=15)])
    PostalCode = StringField('Postal Code', validators=[Optional(), Length(max=10)])
    Country = StringField('Country', validators=[DataRequired(), Length(max=15)])
    Phone = StringField('Phone', validators=[DataRequired(), Length(max=24)])
    Fax = StringField('Fax', validators=[Optional(), Length(max=24)])
    submit = SubmitField('Add Customer')

# Order Form
class OrderForm(FlaskForm):
    CustomerID = StringField('Customer ID', validators=[DataRequired()])
    EmployeeID = IntegerField('Employee ID', validators=[DataRequired()])
    OrderDate = DateField('Order Date', format='%Y-%m-%d', validators=[DataRequired()])
    RequiredDate = DateField('Required Date', format='%Y-%m-%d', validators=[DataRequired()])
    ShippedDate = DateField('Shipped Date', format='%Y-%m-%d', validators=[Optional()])
    ShipVia = SelectField('Ship Via', choices=[('1', 'Carrier 1'), ('2', 'Carrier 2')], validators=[DataRequired()])
    Freight = DecimalField('Freight', validators=[DataRequired()])
    ShipName = StringField('Ship Name', validators=[DataRequired()])
    ShipAddress = StringField('Ship Address', validators=[DataRequired()])
    ShipCity = StringField('Ship City', validators=[DataRequired()])
    ShipRegion = StringField('Ship Region', validators=[Optional()])
    ShipPostalCode = StringField('Ship Postal Code', validators=[DataRequired()])
    ShipCountry = StringField('Ship Country', validators=[DataRequired()])
    submit = SubmitField('Submit Order')

# Category Form
class CategoryForm(FlaskForm):
    CategoryName = StringField('Category Name', validators=[DataRequired(), Length(max=15)])
    Description = StringField('Description', validators=[Optional(), Length(max=200)])
    Picture = FileField('Picture', validators=[Optional()])
    submit = SubmitField('Add Category')

# Product Form
class ProductForm(FlaskForm):
    ProductName = StringField('Product Name', validators=[DataRequired(), Length(max=40)])
    SupplierID = IntegerField('Supplier ID', validators=[DataRequired()])
    CategoryID = IntegerField('Category ID', validators=[DataRequired()])
    QuantityPerUnit = StringField('Quantity Per Unit', validators=[Optional(), Length(max=20)])
    UnitPrice = DecimalField('Unit Price', validators=[DataRequired()])
    UnitsInStock = IntegerField('Units In Stock', validators=[Optional()])
    UnitsOnOrder = IntegerField('Units On Order', validators=[Optional()])
    ReorderLevel = IntegerField('Reorder Level', validators=[Optional()])
    Discontinued = SelectField('Discontinued', choices=[('0', 'No'), ('1', 'Yes')], validators=[DataRequired()])
    submit = SubmitField('Add Product')

# Shipper Form
class ShipperForm(FlaskForm):
    CompanyName = StringField('Company Name', validators=[DataRequired(), Length(max=40)])
    Phone = StringField('Phone', validators=[DataRequired(), Length(max=24)])
    submit = SubmitField('Add Shipper')

# Supplier Form
class SupplierForm(FlaskForm):
    CompanyName = StringField('Company Name', validators=[DataRequired(), Length(max=40)])
    ContactName = StringField('Contact Name', validators=[Optional(), Length(max=30)])
    ContactTitle = StringField('Contact Title', validators=[Optional(), Length(max=30)])
    Address = StringField('Address', validators=[Optional(), Length(max=60)])
    City = StringField('City', validators=[Optional(), Length(max=15)])
    Region = StringField('Region', validators=[Optional(), Length(max=15)])
    PostalCode = StringField('Postal Code', validators=[Optional(), Length(max=10)])
    Country = StringField('Country', validators=[DataRequired(), Length(max=15)])
    Phone = StringField('Phone', validators=[DataRequired(), Length(max=24)])
    Fax = StringField('Fax', validators=[Optional(), Length(max=24)])
    HomePage = StringField('Home Page', validators=[Optional()])
    submit = SubmitField('Add Supplier')
