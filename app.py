from flask import Flask, render_template, request, redirect, url_for
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


# Genres
@app.route('/genre')
def genre():
    q = 'SELECT * FROM Genres'
    c = mysql.connection.cursor()
    c.execute(q)
    results = c.fetchall()
    return render_template('genre.html', genres=results)

@app.route('/addGenre', methods=['POST'])
def add_genre():
    if request.method == 'POST':
        genre_name = request.form['genre_name']
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO Genres (genre_name) VALUES (%s);", (genre_name,))
        mysql.connection.commit() # ensure our changes save
        cur.close()
        return redirect(url_for('genre')) # send user back to genre page
    
@app.route('/remGenre', methods=['POST'])
def rem_genre():
    if request.method == 'POST':
        genre_id = request.form['Genre_ID']
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM Genres WHERE genre_id=%s;", (genre_id,))
        mysql.connection.commit() # ensure our changes save
        cur.close()
    return redirect(url_for('genre')) # send user back to genre page

@app.route('/editGenre', methods=['POST'])
def edit_genre():
    if request.method == 'POST':
        genre_id = request.form['Genre_ID']
        new_genre_name = request.form['new_genre_name']
        cur = mysql.connection.cursor()
        cur.execute("UPDATE Genres SET genre_name=%s WHERE genre_id=%s;", (new_genre_name, genre_id))
        mysql.connection.commit() # ensure our changes save
        cur.close()
    return redirect(url_for('genre')) # send user back to genre page


# Patrons
@app.route('/patron')
def patron():
    q = 'SELECT * FROM Patrons'
    c = mysql.connection.cursor()
    c.execute(q)
    results = c.fetchall()
    return render_template('patron.html', patrons=results)

@app.route('/addPatron', methods=['POST'])
def add_patron():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        date_of_birth = request.form['date_of_birth']
        email = request.form['email']
        phone_number = request.form['phone_number']
        cur = mysql.connection.cursor()

        # account for NULL email and phone_number
        if email == "" and phone_number == "":
            cur.execute("INSERT INTO Patrons (first_name, last_name, date_of_birth) VALUES (%s, %s, %s);", (first_name, last_name, date_of_birth))
        # account for NULL email
        elif email == "":
            cur.execute("INSERT INTO Patrons (first_name, last_name, date_of_birth, phone_number) VALUES (%s, %s, %s, %s);", (first_name, last_name, date_of_birth, phone_number))
        # account for NULL phone_number
        elif phone_number == "":
            cur.execute("INSERT INTO Patrons (first_name, last_name, date_of_birth, email) VALUES (%s, %s, %s, %s);", (first_name, last_name, date_of_birth, email))
        # no NULL inputs
        else:
            cur.execute("INSERT INTO Patrons (first_name, last_name, date_of_birth, email, phone_number) VALUES (%s, %s, %s, %s, %s);", (first_name, last_name, date_of_birth, email, phone_number))
        
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('patron'))

@app.route('/editPatron', methods=['POST'])
def edit_patron():
    if request.method == 'POST':
        patron_ID = request.form['patron_ID']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        date_of_birth = request.form['date_of_birth']
        email = request.form['email']
        phone_number = request.form['phone_number']
        cur = mysql.connection.cursor()

        # account for NULL email and phone_number
        if email == "" and phone_number == "":
            cur.execute("UPDATE Patrons SET first_name=%s, last_name=%s, date_of_birth=%s WHERE patron_ID=%s;", (first_name, last_name, date_of_birth, patron_ID))
        # account for NULL email
        elif email == "":
            cur.execute("UPDATE Patrons SET first_name=%s, last_name=%s, date_of_birth=%s, phone_number=%s WHERE patron_ID=%s;", (first_name, last_name, date_of_birth, phone_number, patron_ID))
        # account for NULL phone_number
        elif phone_number == "":
            cur.execute("UPDATE Patrons SET first_name=%s, last_name=%s, date_of_birth=%s, email=%s WHERE patron_ID=%s;", (first_name, last_name, date_of_birth, email, patron_ID))
        # no NULL inputs
        else:
            cur.execute("UPDATE Patrons SET first_name=%s, last_name=%s, date_of_birth=%s, email=%s, phone_number=%s WHERE patron_ID=%s;", (first_name, last_name, date_of_birth, email, phone_number, patron_ID))
    
        cur.execute("UPDATE Patrons SET first_name=%s, last_name=%s, date_of_birth=%s, email=%s, phone_number=%s WHERE patron_ID=%s;", (first_name, last_name, date_of_birth, email, phone_number, patron_ID))
        mysql.connection.commit() # ensure our changes save
        cur.close()
    return redirect(url_for('patron')) # send user back to patrons page

@app.route('/remPatron', methods=['POST'])
def rem_patron():
    if request.method == 'POST':
        patron_ID = request.form['patron_ID']
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM Patrons WHERE patron_ID=%s;", (patron_ID))
        mysql.connection.commit() # ensure our changes save
        cur.close()
    return redirect(url_for('patron'))


# Authors
@app.route('/author')
def author():
    q = 'SELECT * FROM Authors'
    c = mysql.connection.cursor()
    c.execute(q)
    results = c.fetchall()
    return render_template('author.html', authors=results)

@app.route('/addAuthor', methods=['POST'])
def add_author():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        biography = request.form['biography']

        cur = mysql.connection.cursor()

        # account for NULL biography
        if biography == "":
            cur.execute("INSERT INTO Authors (first_name, last_name) VALUES (%s, %s);", (first_name, last_name))
        # no NULL inputs
        else:
            cur.execute("INSERT INTO Authors (first_name, last_name, biography) VALUES (%s, %s, %s);", (first_name, last_name, biography))
        
        mysql.connection.commit() # ensure our changes save
        cur.close()
        return redirect(url_for('author')) # send user back to author page
    
@app.route('/remAuthor', methods=['POST'])
def rem_author():
    if request.method == 'POST':
        author_id = request.form['author_ID']
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM Authors WHERE author_ID=%s;", (author_id,))
        mysql.connection.commit() # ensure our changes save
        cur.close()
    return redirect(url_for('author')) # send user back to author page

@app.route('/editAuthor', methods=['POST'])
def edit_author():
    if request.method == 'POST':
        author_id = request.form['author_ID']
        new_first_name = request.form['new_first_name']
        new_last_name = request.form['new_last_name']
        new_biography = request.form['new_biography']
        cur = mysql.connection.cursor()

        # account for NULL biography
        if new_biography == "":
            cur.execute("UPDATE Authors SET first_name=%s, last_name=%s WHERE author_ID=%s;", (new_first_name, new_last_name, author_id))
        # no NULL inputs
        else:
            cur.execute("UPDATE Authors SET first_name=%s, last_name=%s, biography=%s WHERE author_ID=%s;", (new_first_name, new_last_name, new_biography, author_id))
        
        mysql.connection.commit() # ensure our changes save
        cur.close()
    return redirect(url_for('author')) # send user back to authors page


@app.route('/book_genre')
def book_genre():
    return render_template('book_genre.html')


# Listener
if __name__ == "__main__":
    app.run(port=1749, debug=True)