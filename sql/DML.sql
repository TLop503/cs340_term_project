-- In all the below queries the colon : character is used to denote a
-- variables that will have data from the backend programming language

-- DROP DOWN POPULATION ----------------------------------------------------------

-- authors drop downs
SELECT author_ID, first_name, last_name FROM Authors;

-- books drop downs
SELECT book_ID, title FROM Books;

-- patrons drop downs
SELECT patron_ID, first_name, last_name FROM Patron;

-- genres drop downs
SELECT genre_ID, genre_name FROM Genres;

-- checkouts drop downs
SELECT checkout_ID, book_ID, patron_ID FROM Checkouts;

-- book genres drop downs
SELECT book_genre_ID, book_ID, author_ID FROM Book_Genres;


-- CREATE ----------------------------------------------------------

-- add a new author
INSERT INTO Authors (first_name, last_name, biography)
    VALUES (:first_name_input, :last_name_input, :biography_input);

-- add a new genre
INSERT INTO Genres (genre_name)
    VALUES (:genre_name_input);

-- add a new book
-- Books.author_ID is a NULLable relationship
INSERT INTO Books (title, author_ID, synopsis, audience, language, format, publishing_date)
    VALUES (:title_input, :author_ID_input_from_dropdown, :synopsis_input, :audience_input, :language_input, :format_input, :publishing_date_input);

-- add a patron
INSERT INTO Patrons (first_name, last_name, date_of_birth, email, phone_number)
    VALUES (:first_name_input, :last_name_input, :date_of_birth_input, :email_input, :phone_number_input);

-- add a checkout
INSERT INTO Checkouts (book_ID, patron_ID, checkout_date, due_date, is_returned)
    VALUES (:book_ID_input_from_dropdown, :patron_ID_input_from_dropdown, :checkout_date_input, :due_date_input, :is_returned_input);

-- add a book-genre
INSERT INTO Book_Genres (book_ID, genre_ID)
    VALUES (:book_ID_input_from_dropdown, :genre_ID_input_from_dropdown);


-- READ ------------------------------------------------------------
-- Naive, for dispalying sample of whole dataset
SELECT * FROM Authors;
SELECT * FROM Genres;
SELECT * FROM Books;
SELECT * FROM Patrons;
SELECT * FROM Checkouts WHERE Checkouts.is_returned = 0; -- currently checked out
SELECT * FROM Checkouts WHERE Checkouts.is_returned = 1; -- returned
SELECT * FROM Book_Genres;

-- Or for specifying desired fields we'd need to:
-- SELECT * FROM <TABLE> WHERE <FIELD> = <VALUE>;
-- However: Every table should be used in at least one SELECT query. For the SELECT queries, it is fine to just display the content of the tables. It is generally not appropriate to have only a single query that joins all tables and displays them.
-- so, I'm not going to implement all of this now, since it will need to be plugged into the rest of the stack later.

-- UPDATE ----------------------------------------------------------

-- update patron's data based on form submission
UPDATE Patrons
    SET first_name = :first_name_input, last_name = :last_name_input, date_of_birth = date_of_birth_input,
    email = email_input, phone_number = phone_number_input
    WHERE patron_ID = :patron_ID_selected_from_page;

-- update the return status of a checkout
UPDATE Checkouts
    SET is_returned = 1 --true
    WHERE checkout_ID = checkout_ID_selected_from_page;

-- update book-genre's data based on form submission
UPDATE Book_Genres
    SET book_ID = :book_ID_input_from_dropdown, genre_ID = :genre_ID_input_from_dropdown
    WHERE book_genre_ID = book_genre_ID_selected_from_page;

-- update book's data based on form submission
-- Books.author_ID is a NULLable relationship
UPDATE Books
    SET title = :title_input, author_ID = :author_ID_input_from_dropdown, synopsis = synopsis_input,
    audience = audience_input, format = format_input, language, language_input, publishing_date, publishing_date_input
    WHERE book_ID = :book_genre_ID_selected_from_page;

-- update genres's data based on form submission
UPDATE Genres
    SET genre_name = :genre_name_input
    WHERE genre_ID = genre_ID_input_from_dropdown;

-- update author's data based on form submission
UPDATE Authors
    SET first_name = :first_name_input, last_name = :last_name_input, biography = :biography_input
    WHERE author_ID = :author_ID_input_from_dropdown;


-- DELETE -----------------------------------------------------------

-- delete a patron
DELETE FROM Patrons WHERE patron_ID = :patron_ID_selected_from_page;

-- delete a book-genre
DELETE FROM Book_Genres WHERE book_genre_ID = :book_genre_ID_selected_from_page;

-- delete a book (and genre map associated)
DELETE FROM Books WHERE book_ID = :book_ID_selected_from_page;

-- delete a genre
DELETE FROM Genres WHERE genre_ID = :genre_ID_input_from_dropdown;

-- delete an author
DELETE FROM Authors WHERE author_ID = :author_ID_input_from_dropdown;