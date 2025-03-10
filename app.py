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

# Checkouts
@app.route('/checkout')
def checkout():
    # Query for active checkouts
    active_checkouts_query = "SELECT checkout_ID, title AS 'book_title', \
            CONCAT(first_name, ' ', last_name) AS 'patron_name', \
            checkout_date, due_date, is_returned FROM Checkouts \
            LEFT JOIN Books ON Books.book_ID = Checkouts.book_ID \
            LEFT JOIN Patrons ON Patrons.patron_ID = Checkouts.patron_ID \
            WHERE is_returned = 0"

    past_checkouts_query = "SELECT checkout_ID, title AS 'book_title', \
            CONCAT(first_name, ' ', last_name) AS 'patron_name', \
            checkout_date, due_date, is_returned FROM Checkouts \
            LEFT JOIN Books ON Books.book_ID = Checkouts.book_ID \
            LEFT JOIN Patrons ON Patrons.patron_ID = Checkouts.patron_ID \
            WHERE is_returned = 1"

    # Query for Books IDs and titles
    books_query = "SELECT book_ID, title FROM Books WHERE book_ID NOT IN \
            (SELECT book_ID FROM Checkouts WHERE is_returned = 0);"
    
    # Query for Patron IDs and names
    patron_query = "SELECT patron_ID, CONCAT(first_name, ' ', last_name) AS 'patron_name' FROM Patrons"

    c = mysql.connection.cursor()

    # Execute active checkout query
    c.execute(active_checkouts_query)
    active_checkouts_results = c.fetchall()

    # Execute past checkout query
    c.execute(past_checkouts_query)
    past_checkouts_results = c.fetchall()

    # Execute book query
    c.execute(books_query)
    books_results = c.fetchall()

    # Execute patron query
    c.execute(patron_query)
    patrons_results = c.fetchall()

    return render_template('checkout.html', active_checkouts=active_checkouts_results, past_checkouts=past_checkouts_results, books=books_results, patrons=patrons_results)

@app.route('/addCheckout', methods=['POST'])
def add_checkout():
    if request.method == 'POST':
        print(request.form)
        book_ID = request.form['book_ID']
        patron_ID = request.form['patron_ID']
        checkout_date = request.form['checkout_date']
        due_date = request.form['due_date']
        cur = mysql.connection.cursor()

        cur.execute("INSERT INTO Checkouts (book_ID, patron_ID, checkout_date, due_date) VALUES (%s, %s, %s, %s);", (book_ID, patron_ID, checkout_date, due_date))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('checkout'))
    
@app.route('/editCheckout', methods=['POST'])
def edit_checkout():
    if request.method == 'POST':
        checkout_ID = request.form['checkout_ID']
        cur = mysql.connection.cursor()

        cur.execute("UPDATE Checkouts SET is_returned=1 WHERE checkout_ID=%s;", (checkout_ID,))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('checkout'))

# Books
@app.route('/books')
def books():
    # Query for books
    books_query = "SELECT book_ID, title, CONCAT(first_name, ' ', last_name) AS 'author',\
        synopsis, audience, language, format, publishing_date FROM Books \
        LEFT JOIN Authors ON Authors.author_ID = Books.author_ID"
    
    # Query for distinct authors
    authors_query = "SELECT DISTINCT author_ID, first_name, last_name FROM Authors"
    
    c = mysql.connection.cursor()
    
    # Execute book query
    c.execute(books_query)
    books_results = c.fetchall()
    
    # Execute distinct author query
    c.execute(authors_query)
    authors_results = c.fetchall()
    
    return render_template('books.html', books=books_results, authors=authors_results)



@app.route('/addBook', methods=['POST'])
def add_book():
    if request.method == 'POST':
        author_ID = request.form['author_ID']
        title = request.form['title']
        synopsis = request.form['synopsis']
        audience = request.form['audience']
        format = request.form['format']
        language = request.form['language']
        publishing_date = request.form['publishing_date']
        cur = mysql.connection.cursor()

        # account for NULL author_ID, audience, publishing date
        if author_ID == "" and audience == "" and publishing_date == "":
            cur.execute("INSERT INTO Books (title, synopsis, format, language) VALUES (%s, %s, %s, %s);", (title, synopsis, format, language))
        # account for NULL author_ID, audience
        if author_ID == "" and audience == "":
            cur.execute("INSERT INTO Books (title, synopsis, format, language, publishing_date) VALUES (%s, %s, %s, %s, %s);", (title, synopsis, format, language, publishing_date))
        # account for NULL author_ID, publishing date
        if author_ID == "" and publishing_date == "":
            cur.execute("INSERT INTO Books (title, synopsis, audience, format, language) VALUES (%s, %s, %s, %s, %s);", (title, synopsis, audience, format, language))
        # account for NULL audience, publishing date
        if audience == "" and publishing_date == "":
            cur.execute("INSERT INTO Books (author_ID, title, synopsis, format, language) VALUES (%s, %s, %s, %s, %s);", (author_ID, title, synopsis, format, language))
        # account for NULL author_ID
        if author_ID == "":
            cur.execute("INSERT INTO Books (title, synopsis, audience, format, language, publishing_date) VALUES (%s, %s, %s, %s, %s, %s);", (title, synopsis, audience, format, language, publishing_date))
        # account for NULL audience
        if audience == "":
            cur.execute("INSERT INTO Books (author_ID, title, synopsis, format, language, publishing_date) VALUES (%s, %s, %s, %s, %s, %s);", (author_ID, title, synopsis, format, language, publishing_date))
        # account for NULL publishing date
        if publishing_date == "":
            cur.execute("INSERT INTO Books (author_ID, title, synopsis, audience, format, language) VALUES (%s, %s, %s, %s, %s, %s);", (author_ID, title, synopsis, audience, format, language))
        # no NULL inputs
        else:
            cur.execute("INSERT INTO Books (author_ID, title, synopsis, audience, format, language, publishing_date) VALUES (%s, %s, %s, %s, %s, %s, %s);", (author_ID, title, synopsis, audience, format, language, publishing_date))

        mysql.connection.commit()
        cur.close()
        return redirect(url_for('books'))

@app.route('/editBook', methods=['POST'])
def edit_book():
    if request.method == 'POST':
        book_ID = request.form['book_ID']
        author_ID = request.form['author_ID']
        title = request.form['title']
        synopsis = request.form['synopsis']
        audience = request.form['audience']
        format = request.form['format']
        language = request.form['language']
        publishing_date = request.form['publishing_date']
        cur = mysql.connection.cursor()

        # account for NULL author_ID, audience, publishing date
        if author_ID == "" and audience == "" and publishing_date == "":
            cur.execute("UPDATE Books SET title=%s, synopsis=%s, format=%s, language=%s WHERE book_ID=%s;", (title, synopsis, format, language, book_ID))
        # account for NULL author_ID, audience
        if author_ID == "" and audience == "":
            cur.execute("UPDATE Books SET title=%s, synopsis=%s, format=%s, language=%s, publishing_date=%s WHERE book_ID=%s;", (title, synopsis, format, language, publishing_date, book_ID))
        # account for NULL author_ID, publishing date
        if author_ID == "" and publishing_date == "":
            cur.execute("UPDATE Books SET title=%s, synopsis=%s, audience=%s, format=%s, language=%s WHERE book_ID=%s;", (title, synopsis, audience, format, language, book_ID))
        # account for NULL audience, publishing date
        if audience == "" and publishing_date == "":
            cur.execute("UPDATE Books SET author_ID=%s, title=%s, synopsis=%s, format=%s, language=%s WHERE book_ID=%s;", (author_ID, title, synopsis, format, language, book_ID))
        # account for NULL author_ID
        if author_ID == "":
            cur.execute("UPDATE Books SET title=%s, synopsis=%s, audience=%s, format=%s, language=%s, publishing_date=%s WHERE book_ID=%s;", (title, synopsis, audience, format, language, publishing_date, book_ID))
        # account for NULL audience
        if audience == "":
            cur.execute("UPDATE Books SET author_ID=%s, title=%s, synopsis=%s, format=%s, language=%s, publishing_date=%s WHERE book_ID=%s;", (author_ID, title, synopsis, format, language, publishing_date, book_ID))
        # account for NULL publishing date
        if publishing_date == "":
            cur.execute("UPDATE Books SET author_ID=%s, title=%s, synopsis=%s, audience=%s, format=%s, language=%s WHERE book_ID=%s;", (author_ID, title, synopsis, audience, format, language, book_ID))
        # no NULL inputs
        else:
            cur.execute("UPDATE Books SET author_ID=%s, title=%s, synopsis=%s, audience=%s, format=%s, language=%s, publishing_date=%s WHERE book_ID=%s;", (author_ID, title, synopsis, audience, format, language, publishing_date, book_ID))

        mysql.connection.commit()
        cur.close()
        return redirect(url_for('books'))
    
@app.route('/remBook', methods=['POST'])
def rem_book():
    if request.method == 'POST':
        book_ID = request.form['book_ID']
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM Books WHERE book_ID=%s;", (book_ID,))
        mysql.connection.commit()
        cur.close()
    return redirect(url_for('books'))


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
    
        mysql.connection.commit() # ensure our changes save
        cur.close()
    return redirect(url_for('patron')) # send user back to patrons page

@app.route('/remPatron', methods=['POST'])
def rem_patron():
    if request.method == 'POST':
        patron_ID = request.form['patron_ID']
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM Patrons WHERE patron_ID=%s;", (patron_ID,))
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


# Book_Genres
@app.route('/book_genre')
def book_genre():
    # Query for Book_Genres
    book_genres_query = "SELECT book_genre_ID, Books.title AS 'book_title', Genres.genre_name FROM Book_Genres \
        LEFT JOIN Books ON Books.book_ID = Book_Genres.book_ID \
        LEFT JOIN Genres ON Genres.genre_ID = Book_Genres.genre_ID"
    
    # Query for Books IDs and titles
    books_query = "SELECT book_ID, title FROM Books"
    
    # Query for Genres IDs and names
    genres_query = "SELECT genre_ID, genre_name FROM Genres"

    c = mysql.connection.cursor()

    # Execute book_genres query
    c.execute(book_genres_query)
    book_genres_results = c.fetchall()

    # Execute books query
    c.execute(books_query)
    books_results = c.fetchall()

    # Execute genres query
    c.execute(genres_query)
    genres_results = c.fetchall()

    return render_template('book_genre.html', book_genres=book_genres_results, books=books_results, genres=genres_results)

@app.route('/addBookGenre', methods=['POST'])
def add_book_genre():
    if request.method == 'POST':
        book_ID = request.form['book_ID']
        genre_ID = request.form['genre_ID']
        
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO Book_Genres (book_ID, genre_ID) VALUES (%s, %s);", (book_ID, genre_ID))

        mysql.connection.commit()
        cur.close()
        return redirect(url_for('book_genre'))

@app.route('/editBookGenre', methods=['POST'])
def edit_book_genre():
    if request.method == 'POST':
        book_genre_ID = request.form['book_genre_ID']
        book_ID = request.form['book_ID']
        genre_ID = request.form['genre_ID']
        
        cur = mysql.connection.cursor()
        cur.execute("UPDATE Book_Genres SET book_ID=%s, genre_ID=%s WHERE book_genre_ID=%s;", (book_ID, genre_ID, book_genre_ID,))

        mysql.connection.commit()
        cur.close()
        return redirect(url_for('book_genre'))

@app.route('/remBookGenre', methods=['POST'])
def rem_book_genre():
    if request.method == 'POST':
        book_genre_ID = request.form['book_genre_ID']
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM Book_Genres WHERE book_genre_ID=%s;", (book_genre_ID,))

        mysql.connection.commit()
        cur.close()
        return redirect(url_for('book_genre'))

# Listener
if __name__ == "__main__":
    app.run(port=1749, debug=True)