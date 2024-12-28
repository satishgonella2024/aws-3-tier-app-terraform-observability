from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Database connection details
DB_HOST = "database"
DB_NAME = "mydatabase"
DB_USER = "user"
DB_PASSWORD = "password"

def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    return conn

@app.route('/')
def home():
    return {"message": "Hello from the backend!"}

@app.route('/data', methods=['GET'])
def get_data():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM test_table;")
    rows = cursor.fetchall()
    conn.close()
    return jsonify(rows)

@app.route('/data', methods=['POST'])
def add_data():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO test_table (name, value) VALUES (%s, %s)",
        (data['name'], data['value'])
    )
    conn.commit()
    conn.close()
    return {"message": "Data added successfully!"}, 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
