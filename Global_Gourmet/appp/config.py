import os

class Config:
    SECRET_KEY = 'supersecretkey123456789'  # Set a secure key here
    SQLALCHEMY_DATABASE_URI = (
        'mssql+pyodbc:///?odbc_connect='
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=DESKTOP-MQNA8AN\\SQLEXPRESS;'
        'DATABASE=GlobalGourmet;'
        'Trusted_Connection=yes;'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
