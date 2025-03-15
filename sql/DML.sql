-- In all the below queries the colon : character is used to denote a
-- variables that will have data from the backend programming language

-- AUTHORS
    -- READ
    SELECT * FROM Authors

    -- CREATE
    INSERT INTO Authors (first_name, last_name, biography) 
        VALUES (:first_name_input, :last_name_input, :biography_input);

    -- UPDATE
    UPDATE Authors SET first_name=:first_name_input, last_name=:last_name_input, biography=:biography_input
        WHERE author_ID=:author_ID_input;

    -- DELETE
    DELETE FROM Authors WHERE author_ID=:author_ID_input;


-- BOOKS
    -- READ
    SELECT book_ID, title, CONCAT(first_name, ' ', last_name) AS 'author',
            synopsis, audience, language, format, publishing_date 
        FROM Books
        LEFT JOIN Authors ON Authors.author_ID = Books.author_ID;
   
    -- Populate author_ID FK drop downs
    SELECT DISTINCT author_ID, first_name, last_name FROM Authors;

    -- CREATE
    -- Books.author_ID is a NULLable relationship
    INSERT INTO Books (author_ID, title, synopsis, audience, format, language, publishing_date) 
    VALUES (:author_ID_input, :title_input, :synopsis_input, :audience_input, 
        :format_input, :language_input, :publishing_date_input);

    -- UPDATE
    -- Books.author_ID is a NULLable relationship
    UPDATE Books SET author_ID=:author_ID_input, title=:title_input, 
            synopsis=:synopsis_input, audience=:audience_input, format=:format_input, 
            language=:language_input, publishing_date=:publishing_date_input 
        WHERE book_ID=:book_ID_input;

    -- DELETE
    DELETE FROM Books WHERE book_ID=:book_ID_input;


-- BOOK_GENRES
    -- READ
    SELECT book_genre_ID, Books.title AS 'book_title', Genres.genre_name 
        FROM Book_Genres
        LEFT JOIN Books ON Books.book_ID = Book_Genres.book_ID
        LEFT JOIN Genres ON Genres.genre_ID = Book_Genres.genre_ID;
    
    -- Populate book_ID FK dropdown
    SELECT book_ID, title FROM Books;

    -- Populate genre_ID FK dropdown
    SELECT genre_ID, genre_name FROM Genres;

    -- CREATE
    INSERT INTO Book_Genres (book_ID, genre_ID) 
        VALUES (:book_ID_input, :genre_ID_input);

    -- UPDATE
    -- Update M:M
    UPDATE Book_Genres SET book_ID=:book_ID_input, genre_ID=:genre_ID_input 
        WHERE book_genre_ID=:book_genre_ID_input;

    -- DELETE
    -- Delete M:M
    DELETE FROM Book_Genres WHERE book_genre_ID=:book_genre_ID_input;



-- CHECKOUTS
    -- READ(s)
        -- Currently checked out books
    SELECT checkout_ID, title AS 'book_title', CONCAT(first_name, ' ', last_name) 
            AS 'patron_name', checkout_date, due_date, is_returned 
        FROM Checkouts
        LEFT JOIN Books ON Books.book_ID = Checkouts.book_ID
        LEFT JOIN Patrons ON Patrons.patron_ID = Checkouts.patron_ID
        WHERE is_returned = 0;

        -- returned books
    SELECT checkout_ID, title AS 'book_title', CONCAT(first_name, ' ', last_name) 
            AS 'patron_name', checkout_date, due_date, is_returned 
        FROM Checkouts
        LEFT JOIN Books ON Books.book_ID = Checkouts.book_ID
        LEFT JOIN Patrons ON Patrons.patron_ID = Checkouts.patron_ID
        WHERE is_returned = 1;

    -- Populate book_ID FK drop down (books not currently checked out)
    SELECT book_ID, title 
        FROM Books 
        WHERE book_ID NOT IN (SELECT book_ID FROM Checkouts WHERE is_returned = 0);
    
    -- Populate patron_ID FK drop down
    SELECT patron_ID, CONCAT(first_name, ' ', last_name) AS 'patron_name' 
        FROM Patrons;

    -- CREATE
    INSERT INTO Checkouts (book_ID, patron_ID, checkout_date, due_date) 
        VALUES (:book_ID_input, :patron_ID_input, :checkout_date_input, :due_date_input);

    -- UPDATE (mark checkout as returned)
    UPDATE Checkouts SET is_returned = 1 WHERE checkout_ID = :checkout_ID_input;


-- GENRES
    -- READ
    SELECT * FROM Genres;

    -- CREATE
    INSERT INTO Genres (genre_name) VALUES (:genre_name_input);

    -- UPDATE
    UPDATE Genres SET genre_name = :genre_name_input 
        WHERE genre_id = :genre_ID_input;

    -- DELETE
    DELETE FROM Genres WHERE genre_id = :genre_ID_input;


-- PATRONS
    -- READ
    SELECT * FROM Patrons;

    -- CREATE
    INSERT INTO Patrons (first_name, last_name, date_of_birth, email, phone_number)
        VALUES (:first_name_input, :last_name_input, :date_of_birth_input, :email_input, :phone_number_input);

    -- UPDATE
    UPDATE Patrons SET first_name=:first_name_input, last_name=:last_name_input, 
            date_of_birth=:date_of_birth_input, email=:email_input, phone_number=:phone_number_input
        WHERE patron_ID=:patron_ID_input;

    -- DELETE
    DELETE FROM Patrons WHERE patron_ID=:patron_ID_input;
