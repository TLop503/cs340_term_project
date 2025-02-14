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
    FOREIGN KEY (author_ID) REFERENCES Authors(author_ID) ON DELETE RESTRICT
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
('Bob', 'Jones', 'Local No Name CO (aspiring) author'),
('Kurt', 'Vonnegut', 'An American author known for his satirical and darkly humorous novels.'),
('David', 'Foster Wallace', 'An American author known for his complex and often postmodern novels.'),
('J.R.R.', 'Tolkien', 'An English author known for his high fantasy novels.'),
('George', 'Orwell', 'An English author known for his dystopian novels.'),
('Randall', 'Munroe', 'An American author known for his webcomic XKCD and his science books.'),
('William', 'Burroughs', 'An American author known for his experimental and often controversial novels.'),
('William', 'Gibson', 'An American author known for his cyberpunk novels.'),
('William', 'Shakespeare', 'An English author known for his plays and poetry.'),
('Jorge Luis', 'Borges', 'An Argentine author known for his short stories and essays.'),
('Dave', 'Eggers', 'An American author known for his semi-autobiographical novels and nonfiction.'),
('Don', 'DeLillo', 'An American author known for his postmodern novels.'),
('Frank', 'Herbert', 'An American author known for his science fiction novels.'),
('Franz', 'Kafka', 'A Czech author known for his surreal and often existential novels.'),
('Kenji', 'J-Lopez Alt.', 'An American author known for his food science books.'),
('Mark Z.', 'Danielowski', 'An American author known for his ergodic lit and nested frame stories');

-- Example Data for Genres
INSERT INTO Genres (genre_name) VALUES
('Science Fiction'),
('Fantasy'),
('Dystopian'),
('Cyberpunk'),
('Postmodern'),
('Surreal'),
('Existential'),
('Satire'),
('Humor'),
('Nonfiction'),
('Science'),
('Cooking'),
('Poetry'),
('Plays');

-- Example Data for Books
INSERT INTO Books (title, author_ID, synopsis, audience, language, format, publishing_date) VALUES
('Slaughterhouse-Five', 1, 'A science fiction novel about the authors experience in the firebombing of Dresden', 'Adult', 'English', 'Paperback', '1969-03-31'),
('Breakfast of Champions', 1, 'A novel about the adventures of a writer and a car dealer', 'Adult', 'English', 'Paperback', '1973-10-01'),
('Infinite Jest', 2, 'A postmodern novel about addiction and entertainment', 'Adult', 'English', 'Paperback', '1996-02-01'),
('The Pale King', 2, 'A posthumously published novel about the IRS', 'Adult', 'English', 'Paperback', '2011-04-15'),
('Brief Interviews with Hideous Men', 2, 'A collection of short stories', 'Adult', 'English', 'Paperback', '1999-05-01'),
('The Hobbit', 3, 'A high fantasy novel about a hobbit on a quest to reclaim a treasure', 'Middle-grade', 'English', 'Paperback', '1937-09-21'),
('The Lord of the Rings', 3, 'A high fantasy novel about a quest to destroy a powerful ring', 'Adult', 'English', 'Paperback', '1954-07-29'),
('1984', 4, 'A dystopian novel about a totalitarian society', 'Adult', 'English', 'Paperback', '1949-06-08'),
('What if?', 5, 'A collection of scientific answers to absurd hypothetical questions', 'Middle-Grade', 'English', 'Paperback', '2014-09-02'),
('Naked Lunch', 6, 'An experimental novel about drug addiction', 'Adult', 'English', 'Paperback', '1959-07-01'),
('Neuromancer', 7, 'A cyberpunk novel about a washed-up computer hacker', 'Adult', 'English', 'Paperback', '1984-07-01'),
('Hamlet', 8, 'A play about a prince who seeks revenge for his father', 'Adult', 'Ye Olde English', 'Paperback', '1603-01-01'),
('Labryinths', 9, 'A collection of short stories and essays', 'Adult', 'Spanish', 'Paperback', '1962-01-01'),
('A Heartbreaking Work of Staggering Genius', 10, 'A semi-autobiographical novel about the authors life', 'Adult', 'English', 'Paperback', '2000-02-01'),
('White Noise', 11, 'A postmodern novel about a toxic cloud', 'Adult', 'English', 'Paperback', '1985-01-01'),
('Dune', 12, 'A science fiction novel about worms', 'Adult', 'English', 'Paperback', '1965-06-01'),
('The Metamorphosis', 13, 'A surreal novel about isolation and transformation', 'Adult', 'English', 'Paperback', '1915-10-15'),
('The Food Lab', 14, 'A food science book about cooking', 'Adult', 'English', 'Hardcover', '2015-09-21'),
('House of Leaves', 15, 'An egrodic novel about a house that is bigger on the inside', 'Adult', 'English', 'Paperback', '2000-03-07');

-- Example Data for Patrons
INSERT INTO Patrons (first_name, last_name, date_of_birth, email, phone_number) VALUES
('Alice', 'Smith', '1990-01-01', 'alice@alice.com', '555-555-5555'),
('Bob', 'Jones', '1980-02-02', 'bob@bob.com', '555-555-5555'),
('Eve', 'Johnson', '1970-03-03', 'eve@nsa.gov', '555-555-5555'),
('Mallory', 'Brown', '1960-04-04', 'mallory@localhost', '555-555-5555');


-- Example Book to Genre Mappings
-- Format: (book_ID, genre_ID)
INSERT INTO Book_Genres (book_ID, genre_ID) VALUES
(1, 1),  -- Slaughterhouse-Five -> Science Fiction
(1, 8),  -- Slaughterhouse-Five -> Satire
(2, 5),  -- Breakfast of Champions -> Postmodern
(2, 8),  -- Breakfast of Champions -> Satire
(3, 5),  -- Infinite Jest -> Postmodern
(3, 9),  -- Infinite Jest -> Humor
(4, 6),  -- The Pale King -> Surreal
(5, 6),  -- Brief Interviews with Hideous Men -> Surreal
(6, 2),  -- The Hobbit -> Fantasy
(7, 2),  -- The Lord of the Rings -> Fantasy
(8, 3),  -- 1984 -> Dystopian
(9, 10), -- What if? -> Nonfiction
(10, 1), -- Naked Lunch -> Science Fiction
(10, 9), -- Naked Lunch -> Humor
(11, 4), -- Neuromancer -> Cyberpunk
(12, 1), -- Hamlet -> Plays
(13, 6), -- Labryinths -> Surreal
(14, 11), -- A Heartbreaking Work of Staggering Genius -> Science
(15, 12), -- White Noise -> Postmodern
(16, 1), -- Dune -> Science Fiction
(17, 6), -- The Metamorphosis -> Surreal
(18, 12); -- The Food Lab -> Cooking

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