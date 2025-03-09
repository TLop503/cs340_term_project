# cs340_term_project
Term project for Intro to Databases; A library management system

## Notes for later:
- TODO add notes about code adapted from course examples
- TODO make Checkouts Read tables the same width
- TODO addmore info to home page
- TODO fix internal server error
- Check `ON DELETE` methods once implementation starts
- I think there are too many updates that don't match the ones we picked for crud
- delete authors > find user? why is it here
- deduplication
- smart update stuff
- fix the error pages
- add credit for code adapted from class content

## Useful HTML snippets:

```
<!DOCTYPE html>
<html>
    <head>
        <title>TITLE</title>
    </head>
    <body>
        <div class="topnav">
            <a href="index.html">Home</a>
            <a href="checkout.html">Checkout</a>
            <a href="inventory.html">View Books</a>
            <a href="books.html">Book Management</a>
            <a href="genre.html">Genres</a>
            <a href="account.html">Account Info</a>
          </div>

        <h1>TITLE</h1>
        <p>Here you can do something</p>

        <!--Book Table-->
        <table border="2">
            <tr>
                <th>Book ID</th>
                <th>Title</th>
                <th>Author ID</th>
                <th>Synopsis</th>
                <th>Audience</th>
                <th>Format</th>
                <th>Language</th>
                <th>Publishing Date</th>
            </tr>
        </table>
    </body>
</html>


<h2>Find Patron</h2>
<p>This looks up users. Toggle behavior of search paramaters below:</p>
<label><input type="radio" name="behavior">OR</label>
<label><input type="radio" name="behavior">AND</label>
<form method="post" action="#">
    <label>Patron: <input type="text" name="patron" required></label><br>
    <label>First Name: <input type="text" name="first_name" required></label><br>
    <label>Last Name: <input type="text" name="last_name" required></label><br>
    <label>Date of Birth <input type="date" name="date_of_birth" required></label><br>
    <label>Email Address<input type="email" name="email"></label><br>
    <label>Phone Number<input type="number" name="phone_number"></label><br>
    <button type="submit">Find User</button>
</form>
<hr><br>


```
