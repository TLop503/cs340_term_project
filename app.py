from flask import Flask, render_template

app = Flask(__name__)

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
    return render_template('genre.html')

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