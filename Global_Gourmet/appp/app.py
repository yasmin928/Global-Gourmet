from app import create_app

# Create the Flask app instance
app = create_app()

# Start the Flask application
if __name__ == '__main__':
    app.run(debug=True)
