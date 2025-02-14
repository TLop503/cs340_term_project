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

@app.route('/inventory')
def inventory():
    return render_template('inventory.html')

@app.route('/books')
def books():
    return render_template('books.html')

@app.route('/genre')
def genre():
    return render_template('genre.html')

@app.route('/account')
def account():
    return render_template('account.html')

# Listener
if __name__ == "__main__":
    app.run(port=1739, debug=True)