SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- Drop Existing Tables if They Exist
DROP TABLE IF EXISTS Book_Genres, Checkouts, Genres, Books, Authors, Patrons;

-- Create Authors Table
CREATE OR REPLACE TABLE Authors (
    author_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    biography TEXT
);

-- Create Genres Table
CREATE OR REPLACE TABLE Genres (
    genre_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(255) NOT NULL
);

-- Create Books Table
CREATE OR REPLACE TABLE Books (
    book_ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author_ID INT NULL,
    synopsis TEXT NOT NULL,
    audience ENUM('Youth', 'Middle-grade', 'YA', 'Adult', 'Misc'),
    language VARCHAR(255) NOT NULL,
    format ENUM('Hardcover', 'Paperback', 'Ebook', 'Audio', 'Large Print') NOT NULL,
    publishing_date DATE,
    FOREIGN KEY (author_ID) REFERENCES Authors(author_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Create Patrons Table
CREATE OR REPLACE TABLE Patrons (
    patron_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(16)
);

-- Create Checkouts Table
CREATE OR REPLACE TABLE Checkouts (
    checkout_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    book_ID INT NULL,
    patron_ID INT NULL,
    checkout_date DATE NOT NULL,
    due_date DATE NOT NULL,
    is_returned tinyint NOT NULL DEFAULT 0,
    FOREIGN KEY (book_ID) REFERENCES Books(book_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (patron_ID) REFERENCES Patrons(patron_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Create Book_Genres Table (intersection)
CREATE OR REPLACE TABLE Book_Genres (
    book_genre_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    book_ID INT NOT NULL,
    genre_ID INT NOT NULL,
    FOREIGN KEY (book_ID) REFERENCES Books(book_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (genre_ID) REFERENCES Genres(genre_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Insert Authors
INSERT INTO Authors (first_name, last_name, biography) VALUES
('David', 'Foster Wallace', 'An American author known for his complex and often postmodern novels.'),
('J.R.R.', 'Tolkien', 'An English author known for his high fantasy novels.'),
('George', 'Orwell', 'An English author known for his dystopian novels.'),
('Randall', 'Munroe', 'An American author known for his webcomic XKCD and his science books.'),
('William', 'Shakespeare', 'An English author known for his plays and poetry.'),
('Bob', 'Jones', 'Local No Name CO (aspiring) author');

-- Insert Genres
INSERT INTO Genres (genre_name) VALUES
('Plays'),
('Fantasy'),
('Dystopian'),
('Cyberpunk'),
('Postmodern'),
('Surreal'),
('Humor'),
('Nonfiction');

-- Insert Books
INSERT INTO Books (title, author_ID, synopsis, audience, language, format, publishing_date) VALUES
('Infinite Jest', (SELECT author_ID FROM Authors WHERE first_name = 'David' AND last_name = 'Foster Wallace'), 'A postmodern novel about addiction and entertainment', 'Adult', 'English', 'Paperback', '1996-02-01'),
('The Necronomicon', NULL, '?????????????', 'Adult', 'Latin', 'Hardcover', '1606-06-06'),
('Brief Interviews with Hideous Men', (SELECT author_ID FROM Authors WHERE first_name = 'David' AND last_name = 'Foster Wallace'), 'A collection of short stories', 'Adult', 'English', 'Paperback', '1999-05-01'),
('The Hobbit', (SELECT author_ID FROM Authors WHERE first_name = 'J.R.R.' AND last_name = 'Tolkien'), 'A high fantasy novel about a hobbit on a quest to reclaim a treasure', 'Middle-grade', 'English', 'Paperback', '1937-09-21'),
('The Lord of the Rings', (SELECT author_ID FROM Authors WHERE first_name = 'J.R.R.' AND last_name = 'Tolkien'), 'A high fantasy novel about a quest to destroy a powerful ring', 'Adult', 'English', 'Paperback', '1954-07-29'),
('1984', (SELECT author_ID FROM Authors WHERE first_name = 'George' AND last_name = 'Orwell'), 'A dystopian novel about a totalitarian society', 'Adult', 'English', 'Paperback', '1949-06-08'),
('What if?', (SELECT author_ID FROM Authors WHERE first_name = 'Randall' AND last_name = 'Munroe'), 'A collection of scientific answers to absurd hypothetical questions', 'Middle-Grade', 'English', 'Paperback', '2014-09-02'),
('Hamlet', (SELECT author_ID FROM Authors WHERE first_name = 'Bob' AND last_name = 'Jones'), 'A 100% Original play about a prince who seeks revenge for his father', 'Adult', 'Ye Olde English', 'Paperback', '2025-01-23');

-- Insert Book-Genre Relations
INSERT INTO Book_Genres (book_ID, genre_ID) VALUES
((SELECT book_ID FROM Books WHERE title = 'Infinite Jest'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Postmodern')),
((SELECT book_ID FROM Books WHERE title = 'Infinite Jest'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Humor')),
((SELECT book_ID FROM Books WHERE title = 'The Necronomicon'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Surreal')),
((SELECT book_ID FROM Books WHERE title = 'Brief Interviews with Hideous Men'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Surreal')),
((SELECT book_ID FROM Books WHERE title = 'The Hobbit'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Fantasy')),
((SELECT book_ID FROM Books WHERE title = 'The Lord of the Rings'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Fantasy')),
((SELECT book_ID FROM Books WHERE title = '1984'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Dystopian')),
((SELECT book_ID FROM Books WHERE title = 'What if?'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Nonfiction')),
((SELECT book_ID FROM Books WHERE title = 'Hamlet'), (SELECT genre_ID FROM Genres WHERE genre_name = 'Plays'));

-- Example Data for Patrons
INSERT INTO Patrons (first_name, last_name, date_of_birth, email, phone_number) VALUES
('Alice', 'Smith', '1990-01-01', 'alice@alice.com', '555-555-5555'),
('Bob', 'Jones', '1980-02-02', 'bob@bob.com', '555-555-5555'),
('Eve', 'Johnson', '1970-03-03', 'eve@nsa.gov', '555-555-5555'),
('Mallory', 'Brown', '1960-04-04', 'mallory@localhost', '555-555-5555');

-- Example Data for Checkouts
INSERT INTO Checkouts (book_ID, patron_ID, checkout_date, due_date, is_returned) VALUES
((SELECT book_ID FROM Books WHERE title = 'The Hobbit'), (SELECT patron_ID FROM Patrons WHERE first_name = 'Alice'), '2025-01-01', '2025-01-07', 1),
((SELECT book_ID FROM Books WHERE title = 'Infinite Jest'), (SELECT patron_ID FROM Patrons WHERE first_name = 'Alice'), '2025-02-01', '2025-02-15', 0),
((SELECT book_ID FROM Books WHERE title = 'Brief Interviews with Hideous Men'), (SELECT patron_ID FROM Patrons WHERE first_name = 'Eve'), '2025-02-03', '2025-02-17', 0),
((SELECT book_ID FROM Books WHERE title = 'The Hobbit'), (SELECT patron_ID FROM Patrons WHERE first_name = 'Mallory'), '2025-02-04', '2025-02-18', 0),
((SELECT book_ID FROM Books WHERE title = 'Hamlet'), (SELECT patron_ID FROM Patrons WHERE first_name = 'Mallory'), '2025-02-04', '2025-02-18', 0),
((SELECT book_ID FROM Books WHERE title = 'The Necronomicon'), (SELECT patron_ID FROM Patrons WHERE first_name = 'Mallory'), '2025-02-04', '2025-02-18', 0);



SET FOREIGN_KEY_CHECKS=1;
COMMIT;
