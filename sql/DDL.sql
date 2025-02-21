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
    author_ID INT,
    synopsis TEXT,
    audience ENUM('Youth', 'Middle-grade', 'YA', 'Adult', 'Misc'),
    language VARCHAR(255) NOT NULL,
    format ENUM('Hardcover', 'Paperback', 'Ebook', 'Audio', 'Large Print'),
    publishing_date DATE,
    FOREIGN KEY (author_ID) REFERENCES Authors(author_ID) ON DELETE SET NULL
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
    book_ID INT NOT NULL DEFAULT -1,
    patron_ID INT NOT NULL DEFAULT -1,
    checkout_date DATE NOT NULL,
    due_date DATE NOT NULL,
    is_returned tinyint NOT NULL DEFAULT 0,
    FOREIGN KEY (book_ID) REFERENCES Books(book_ID) ON DELETE SET DEFAULT,
    FOREIGN KEY (patron_ID) REFERENCES Patrons(patron_ID) ON DELETE SET DEFAULT
);

-- Create Book_Genres Table (intersection)
CREATE OR REPLACE TABLE Book_Genres (
    book_genre_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    book_ID INT NOT NULL,
    genre_ID INT NOT NULL,
    FOREIGN KEY (book_ID) REFERENCES Books(book_ID) ON DELETE CASCADE,
    FOREIGN KEY (genre_ID) REFERENCES Genres(genre_ID) ON DELETE RESTRICT
);

-- Example Data for Authors
INSERT INTO Authors (first_name, last_name, biography) VALUES
('David', 'Foster Wallace', 'An American author known for his complex and often postmodern novels.'),
('J.R.R.', 'Tolkien', 'An English author known for his high fantasy novels.'),
('George', 'Orwell', 'An English author known for his dystopian novels.'),
('Randall', 'Munroe', 'An American author known for his webcomic XKCD and his science books.'),
('William', 'Shakespeare', 'An English author known for his plays and poetry.'),
('Bob', 'Jones', 'Local No Name CO (aspiring) author');

-- Example Data for Genres
INSERT INTO Genres (genre_name) VALUES
('Plays'),
('Fantasy'),
('Dystopian'),
('Cyberpunk'),
('Postmodern'),
('Surreal'),
('Humor'),
('Nonfiction');

-- Example Data for Books
INSERT INTO Books (title, author_ID, synopsis, audience, language, format, publishing_date) VALUES
('Infinite Jest', 1, 'A postmodern novel about addiction and entertainment', 'Adult', 'English', 'Paperback', '1996-02-01'),
('The Necronomicon', , '?????????????', 'Adult', 'Latin', 'Hardcover', '1606-06-06'),
('Brief Interviews with Hideous Men', 1, 'A collection of short stories', 'Adult', 'English', 'Paperback', '1999-05-01'),
('The Hobbit', 2, 'A high fantasy novel about a hobbit on a quest to reclaim a treasure', 'Middle-grade', 'English', 'Paperback', '1937-09-21'),
('The Lord of the Rings', 2, 'A high fantasy novel about a quest to destroy a powerful ring', 'Adult', 'English', 'Paperback', '1954-07-29'),
('1984', 3, 'A dystopian novel about a totalitarian society', 'Adult', 'English', 'Paperback', '1949-06-08'),
('What if?', 4, 'A collection of scientific answers to absurd hypothetical questions', 'Middle-Grade', 'English', 'Paperback', '2014-09-02'),
('Hamlet', 5, 'A play about a prince who seeks revenge for his father', 'Adult', 'Ye Olde English', 'Paperback', '1603-01-01');

-- Example Data for Patrons
INSERT INTO Patrons (first_name, last_name, date_of_birth, email, phone_number) VALUES
('Alice', 'Smith', '1990-01-01', 'alice@alice.com', '555-555-5555'),
('Bob', 'Jones', '1980-02-02', 'bob@bob.com', '555-555-5555'),
('Eve', 'Johnson', '1970-03-03', 'eve@nsa.gov', '555-555-5555'),
('Mallory', 'Brown', '1960-04-04', 'mallory@localhost', '555-555-5555');


-- Example Book to Genre Mappings
-- Format: (book_ID, genre_ID)
INSERT INTO Book_Genres (book_ID, genre_ID) VALUES
(1, 5),  -- Infinite Jest -> Postmodern
(1, 7),  -- Infinite Jest -> Humor
(2, 6),  -- The Pale King -> Surreal
(3, 6),  -- Brief Interviews with Hideous Men -> Surreal
(4, 2),  -- The Hobbit -> Fantasy
(5, 2),  -- The Lord of the Rings -> Fantasy
(6, 3),  -- 1984 -> Dystopian
(7, 8), -- What if? -> Nonfiction
(8, 1); -- Hamlet -> Plays

-- a few checkouts
INSERT INTO Checkouts (book_ID, patron_ID, checkout_date, due_date, is_returned) VALUES
(4, 1, '2025-01-01', '2025-01-07', 1),
(1, 1, '2025-02-01', '2025-02-15', 0),
(3, 3, '2025-02-03', '2025-02-17', 0),
(4, 4, '2025-02-04', '2025-02-18', 0),
(8, 4, '2025-02-04', '2025-02-18', 0),
(2, 4, '2025-02-04', '2025-02-18', 0);

-- Show our work!
SELECT * FROM Authors LIMIT 5;
SELECT * FROM Genres LIMIT 5;
SELECT * FROM Books LIMIT 5;
SELECT * FROM Patrons LIMIT 5;
SELECT * FROM Checkouts LIMIT 5;
SELECT * FROM Book_Genres LIMIT 5;

SET FOREIGN_KEY_CHECKS=1;
COMMIT;