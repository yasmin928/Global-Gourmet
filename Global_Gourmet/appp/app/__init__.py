from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from config import Config

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)  # Load configuration from Config class

    # Initialize the database
    db.init_app(app)

    # Register Blueprints (routes)
    with app.app_context():
        from app.routes import main
        app.register_blueprint(main)

    return app
