from flask import Blueprint, Response, jsonify, request, render_template, redirect, url_for, flash
from app.models import OrderDetail, Supplier, Employee, Customer, Order, Product, Category, Shipper
from app import db
import logging
import base64

# Set up logging
logging.basicConfig(level=logging.INFO)

# Define a blueprint for your routes
main = Blueprint('main', __name__)

@main.route('/')
def home():
    return render_template('home.html')

@main.route('/products')
def products():
    products = Product.query.all() 
    return render_template('products.html', products=products)

@main.route('/categories')
def categories():
    categories = Category.query.all() 
    return render_template('categories.html', categories=categories)

@main.route('/employees')
def employees():
    employees = Employee.query.all()
    return render_template('employees.html', employees=employees)

@main.route('/customers')
def customers():
    customers = Customer.query.all()
    return render_template('customers.html', customers=customers)

@main.route('/orders')
def orders():
    orders = Order.query.all()
    return render_template('orders.html', orders=orders)

@main.route('/shippers')
def shippers():
    shippers = Shipper.query.all()
    return render_template('shippers.html', shippers=shippers)

@main.route('/suppliers')
def suppliers():
    suppliers = Supplier.query.all()
    return render_template('suppliers.html', suppliers=suppliers)

@main.route('/track-order/<int:order_id>')
def track_order(order_id):
    order = Order.query.filter_by(OrderID=order_id).first()
    if order:
        order_details = OrderDetail.query.filter_by(OrderID=order_id).all()
        total_price = sum(detail.Quantity * detail.UnitPrice for detail in order_details)  # Calculate total price
        return render_template('track_order.html', order=order, order_details=order_details, total_price=total_price)
    else:
        flash('Order not found')
        return redirect(url_for('main.orders'))

@main.route('/add_customer', methods=['GET', 'POST'])
def add_customer():
    if request.method == 'POST':
        new_customer = Customer(
            CustomerID=request.form['CustomerID'],
            CompanyName=request.form['CompanyName'],
            ContactName=request.form['ContactName'],
            ContactTitle=request.form['ContactTitle'],
            Address=request.form['Address'],
            City=request.form['City'],
            Region=request.form['Region'],
            PostalCode=request.form['PostalCode'],
            Country=request.form['Country'],
            Phone=request.form['Phone'],
            Fax=request.form.get('Fax')  # Optional field
        )
        db.session.add(new_customer)
        try:
            db.session.commit()
            flash('Customer added successfully!', 'success')
            return redirect(url_for('main.customers'))
        except Exception as e:
            logging.error(f'Error occurred while adding customer: {e}')
            db.session.rollback()
            flash('Failed to add customer. Please try again.', 'danger')

    return render_template('add_customer.html')

@main.route('/add_product', methods=['GET', 'POST'])
def add_product():
    if request.method == 'POST':
        new_product = Product(
            ProductName=request.form['ProductName'],
            SupplierID=request.form.get('SupplierID'),
            CategoryID=request.form.get('CategoryID'),
            QuantityPerUnit=request.form.get('QuantityPerUnit'),
            UnitPrice=request.form.get('UnitPrice', type=float),
            UnitsInStock=request.form.get('UnitsInStock', type=int),
            UnitsOnOrder=request.form.get('UnitsOnOrder', type=int),
            ReorderLevel=request.form.get('ReorderLevel', type=int),
            Discontinued=bool(request.form.get('Discontinued'))
        )
        db.session.add(new_product)
        try:
            db.session.commit()
            flash('Product added successfully!', 'success')
            return redirect(url_for('main.products'))
        except Exception as e:
            logging.error(f'Error occurred while adding product: {e}')
            db.session.rollback()
            flash('Failed to add product. Please try again.', 'danger')

    return render_template('add_product.html')

@main.route('/add_order', methods=['GET', 'POST'])
def add_order():
    if request.method == 'POST':
        new_order = Order(
            CustomerID=request.form.get('CustomerID'),
            EmployeeID=request.form.get('EmployeeID'),
            OrderDate=request.form.get('OrderDate'),
            RequiredDate=request.form.get('RequiredDate'),
            ShippedDate=request.form.get('ShippedDate'),
            # ShipVia=request.form.get('ShipVia'),
            Freight=request.form.get('Freight', type=float),
            ShipName=request.form.get('ShipName'),
            ShipAddress=request.form.get('ShipAddress'),
            ShipCity=request.form.get('ShipCity'),
            ShipRegion=request.form.get('ShipRegion'),
            ShipPostalCode=request.form.get('ShipPostalCode'),
            ShipCountry=request.form.get('ShipCountry')
        )
        
        db.session.add(new_order)
        
        try:
            db.session.commit()
            flash('Order submitted successfully!', 'success')
            # Redirect to the order details page after successful order creation
            return redirect(url_for('main.add_order_details', order_id=new_order.OrderID))
        except Exception as e:
            logging.error(f'Error while adding order: {e}')
            db.session.rollback()
            flash('Failed to submit order: ' + str(e), 'danger')

    return render_template('add_order.html')


@main.route('/add_order_details/<int:order_id>', methods=['GET', 'POST'])
def add_order_details(order_id):
    if request.method == 'POST':
        product_id = request.form['ProductID']
        quantity = request.form['Quantity']
        
        # Fetch product price if needed
        product = Product.query.get(product_id)
        unit_price = product.UnitPrice if product else 0
        
        # Create new order detail
        order_detail = OrderDetail(
            OrderID=order_id,
            ProductID=product_id,
            UnitPrice=unit_price,
            Quantity=quantity,
            Discount=0.15  # Adjust as needed
        )
        
        db.session.add(order_detail)
        try:
            db.session.commit()
            flash('Order detail added successfully!', 'success')
            return redirect(url_for('main.home'))  # Redirect to home or wherever you prefer
        except Exception as e:
            logging.error(f'Error while adding order detail: {e}')
            db.session.rollback()
            flash('Failed to add order detail.', 'danger')

    categories = Category.query.all() 
    products = Product.query.all()  # Fetch all categories for the dropdown
    return render_template('add_order_details.html', order_id=order_id, categories=categories)


@main.route('/add_employee', methods=['GET', 'POST'])
def add_employee():
    if request.method == 'POST':
        new_employee = Employee(
            LastName=request.form['LastName'],
            FirstName=request.form['FirstName'],
            Title=request.form.get('Title'),
            TitleOfCourtesy=request.form.get('TitleOfCourtesy'),
            BirthDate=request.form.get('BirthDate'),
            HireDate=request.form.get('HireDate'),
            Address=request.form.get('Address'),
            City=request.form.get('City'),
            Region=request.form.get('Region'),
            PostalCode=request.form.get('PostalCode'),
            Country=request.form.get('Country'),
            HomePhone=request.form.get('HomePhone'),
            Extension=request.form.get('Extension'),
            Photo=request.files.get('Photo'),
            Notes=request.form.get('Notes'),
            ReportsTo=request.form.get('ReportsTo'),
            PhotoPath=request.form.get('PhotoPath')
        )
        db.session.add(new_employee)
        try:
            db.session.commit()
            flash('Employee added successfully!', 'success')
            return redirect(url_for('main.employees'))
        except Exception as e:
            logging.error(f'Error occurred while adding employee: {e}')
            db.session.rollback()
            flash('Failed to add employee. Please try again.', 'danger')

    return render_template('add_employee.html')

@main.route('/add_category', methods=['GET', 'POST'])
def add_category():
    if request.method == 'POST':
        new_category = Category(
            CategoryID=request.form['CategoryID'],
            CategoryName=request.form['CategoryName'],
            Description=request.form['Description'],
            Picture=request.files.get('Picture')  # Assuming Picture is an image upload
        )
        db.session.add(new_category)
        try:
            db.session.commit()
            flash('Category added successfully!', 'success')
            return redirect(url_for('main.categories'))
        except Exception as e:
            logging.error(f'Error occurred while adding category: {e}')
            db.session.rollback()
            flash('Failed to add category. Please try again.', 'danger')

    return render_template('add_category.html')


@main.route('/add_supplier', methods=['GET', 'POST'])
def add_supplier():
    if request.method == 'POST':
        new_supplier = Supplier(
            SupplierID=request.form['SupplierID'],
            CompanyName=request.form['CompanyName'],
            ContactName=request.form['ContactName'],
            ContactTitle=request.form['ContactTitle'],
            Address=request.form['Address'],
            City=request.form['City'],
            Region=request.form['Region'],
            PostalCode=request.form['PostalCode'],
            Country=request.form['Country'],
            Phone=request.form['Phone'],
            Fax=request.form.get('Fax'),  # Optional field
            HomePage=request.form.get('HomePage')  # Optional field for Supplier's website
        )
        db.session.add(new_supplier)
        try:
            db.session.commit()
            flash('Supplier added successfully!', 'success')
            return redirect(url_for('main.suppliers'))
        except Exception as e:
            logging.error(f'Error occurred while adding supplier: {e}')
            db.session.rollback()
            flash('Failed to add supplier. Please try again.', 'danger')

    return render_template('add_supplier.html')


@main.route('/add_shipper', methods=['GET', 'POST'])
def add_shipper():
    if request.method == 'POST':
        new_shipper = Shipper(
            ShipperID=request.form['ShipperID'],
            CompanyName=request.form['CompanyName'],
            Phone=request.form['Phone']
        )
        db.session.add(new_shipper)
        try:
            db.session.commit()
            flash('Shipper added successfully!', 'success')
            return redirect(url_for('main.shippers'))
        except Exception as e:
            logging.error(f'Error occurred while adding shipper: {e}')
            db.session.rollback()
            flash('Failed to add shipper. Please try again.', 'danger')

    return render_template('add_shipper.html')

@main.route('/category/<int:category_id>/image')
def get_category_image(CategoryID):
    conn = db.engine.raw_connection()  # Use SQLAlchemy connection
    cursor = conn.cursor()
    cursor.execute("SELECT Picture FROM Categories WHERE CategoryID = ?", (CategoryID,))
    photo = cursor.fetchone()

    if photo and photo[0]:  # Check if photo exists
        return Response(photo[0], mimetype='image/jpeg')
    else:
        return "Image not found", 404

@main.route('/upload_photo', methods=['GET', 'POST'])
def upload_photo():
    if request.method == 'POST':
        category_id = request.form['CategoryID']
        file = request.files['Picture']
        
        if file:
            binary_data = file.read()
            insert_photo_to_db(category_id, binary_data)
            return redirect(url_for('main.success'))
            
    return render_template('upload_photo.html')

def insert_photo_to_db(category_id, binary_data):
    category = Category.query.get(category_id)
    if category:
        category.Photo = binary_data
        db.session.commit()
    else:
        flash('Category not found.')
@main.route('/success')
def success():
    return render_template('success.html')

@main.route('/edit_category/<int:category_id>', methods=['GET', 'POST'])
def edit_category(category_id):
    category = Category.query.get(category_id)

    if request.method == 'POST':
        # Retrieve form data
        category_name = request.form.get('category_name')
        description = request.form.get('description')
        picture = request.files.get('picture')

        # Check if values are retrieved correctly
        print("Category Name:", category_name)  # Debugging line
        print("Description:", description)  # Debugging line

        # Update category attributes only if they are not None
        if category_name:  # Check for None or empty string
            category.CategoryName = category_name
        if description:  # Check for None or empty string
            category.Description = description

        # Handle picture upload
        if picture:
            category.Picture = picture.read()  # Save the image in a suitable format

        # Commit changes to the database
        db.session.commit()

        flash('Category updated successfully!', 'success')  # Set the success message
        return redirect(url_for('main.categories'))  # Redirect to the categories page

    return render_template('edit_category.html', category=category)



@main.route('/get_products/<int:category_id>')
def get_products(category_id):
    products = Product.query.filter_by(CategoryID=category_id).all()
    return jsonify([{'ProductID': product.ProductID, 'ProductName': product.ProductName} for product in products])
