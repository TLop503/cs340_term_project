-- In all the below queries the colon : character is used to denote a
-- variables that will have data from the backend programming language

-- CREATE ----------------------------------------------------------

-- add a new author
INSERT INTO Authors (first_name, last_name, biography)
    VALUES (:first_name_input, :last_name_input, :biography_input);

-- add a new genre
INSERT INTO Genres (genre_name)
    VALUES (:genre_name_input);

-- get all Authors.author_ID options for Books.author_ID
SELECT author_ID, first_name, last_name FROM Authors;

-- add a new book
INSERT INTO Books (title, author_ID, synopsis, audience, language, format, publishing_date)
    VALUES (:title_input, :author_ID_input_from_dropdown, :synopsis_input, :audience_input, :language_input, :format_input, :publishing_date_input);

-- add a patron
INSERT INTO Patrons (first_name, last_name, date_of_birth, email, phone_number)
    VALUES (:first_name_input, :last_name_input, :date_of_birth_input, :email_input, :phone_number_input);

-- get all Books.book_ID options for Checkouts.book_ID
SELECT book_ID, title FROM Books;

-- get all Patron.patron_ID options for Checkouts.patron_ID
SELECT patron_ID, first_name, last_name FROM Patron;

-- add a checkout
INSERT INTO Checkouts (book_ID, patron_ID, checkout_date, due_date, is_returned)
    VALUES (:book_ID_input_from_dropdown, :patron_ID_input_from_dropdown, :checkout_date_input, :due_date_input, :is_returned_input);

-- get all Books.book_ID options for Book_Genres.book_ID
SELECT book_ID, title FROM Books;

-- get all Patron.patron_ID options for Book_Genres.patron_ID
SELECT genre_ID, genre_name FROM Genres;

-- add a book-genre
INSERT INTO Book_Genres (book_ID, genre_ID)
    VALUES (:book_ID_input_from_dropdown, :genre_ID_input_from_dropdown);

-- READ ------------------------------------------------------------
-- Naive, for dispalying sample of whole dataset
SELECT * FROM Authors LIMIT 10;
SELECT * FROM Genres LIMIT 10;
SELECT * FROM Books LIMIT 10;
SELECT * FROM Patrons LIMIT 10;
SELECT * FROM Checkouts LIMIT 10;
SELECT * FROM Book_Genres LIMIT 10;

-- Or for specifying desired fields we'd need to:
-- SELECT * FROM <TABLE> WHERE <FIELD> = <VALUE>;
-- However: Every table should be used in at least one SELECT query. For the SELECT queries, it is fine to just display the content of the tables. It is generally not appropriate to have only a single query that joins all tables and displays them.
-- so, I'm not going to implement all of this now, since it will need to be plugged into the rest of the stack later.

-- UPDATE ----------------------------------------------------------

-- update patron's data based on form submission
SELECT patron_ID, first_name, last_name, date_of_birth, email, phone_number
    FROM Patrons WHERE patron_ID = :patron_ID_selected_from_page;

UPDATE Patrons
    SET first_name = :first_name_input, last_name = :last_name_input, date_of_birth = date_of_birth_input,
    email = email_input, phone_number = phone_number_input
    WHERE patron_ID = :patron_ID_selected_from_page;

-- update checkout's data based on form submission
SELECT checkout_ID, book_ID, patron_ID, checkout_date, due_date, is_returned
    FROM Checkouts WHERE checkout_ID = checkout_ID_selected_from_page;

UPDATE Checkouts
    SET due_date = :due_date_input, is_returned = is_returned_input\
    WHERE checkout_ID = checkout_ID_selected_from_page;

-- update book-genre's data based on form submission
SELECT book_genre_ID, book_ID, author_ID
    FROM Book_Genres WHERE book_genre_ID = :book_genre_ID_selected_from_page

    -- get all Books.book_ID options for Book_Genres.book_ID
    SELECT book_ID, title FROM Books;

    -- get all Patron.patron_ID options for Book_Genres.patron_ID
    SELECT genre_ID, genre_name FROM Genres;

UPDATE Book_Genres
    SET book_ID = :book_ID_input_from_dropdown, genre_ID = :genre_ID_input_from_dropdown
    WHERE book_genre_ID = book_genre_ID_selected_from_page;

-- DELETE -----------------------------------------------------------

-- delete a patron
DELETE FROM Patrons WHERE patron_ID = :patron_ID_selected_from_page;

-- delete a book-genre
DELETE FROM Book_Genres WHERE book_genre_ID = :book_genre_ID_selected_from_page;