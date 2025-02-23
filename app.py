from flask import Flask, render_template, request
from flask_mysqldb import MySQL
from dotenv import load_dotenv

import os


app = Flask(__name__)

# setup env variables, including stuff loaded from .env
load_dotenv()
app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = os.getenv('DBUSER')
app.config['MYSQL_PASSWORD'] = os.getenv('PASSWD')
app.config['MYSQL_DB'] = os.getenv('DBUSER')
app.config['MYSQL_CURSORCLASS'] = "DictCursor"

mysql = MySQL(app)

print("DBUSER:", os.getenv("DBUSER"))
# Routes
# Index.html
@app.route('/')
def home():
    return render_template('index.html')

@app.route('/checkout')
def checkout():
    return render_template('checkout.html')

@app.route('/books')
def books():
    return render_template('books.html')

@app.route('/genre')
def genre():
    q = 'SELECT * FROM Genres'
    c = mysql.connection.cursor()
    c.execute(q)
    results = c.fetchall()
    return render_template('genre.html', genres=results)

@app.route('/patron')
def patron():
    return render_template('patron.html')

@app.route('/author')
def author():
    return render_template('author.html')

@app.route('/book_genre')
def book_genre():
    return render_template('book_genre.html')


# Listener
if __name__ == "__main__":
    app.run(port=1740, debug=True)