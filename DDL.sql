--- Create Authors Table
CREATE OR REPLACE TABLE Authors (
    author_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    biography TEXT
);

--- Create Genres Table
CREATE OR REPLACE TABLE Genres (
    genre_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(255) NOT NULL,
);

--- Create Books Table
CREATE OR REPLACE TABLE Books (
    book_ID INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author_ID INT NOT NULL,
    synopsis TEXT,
    audience ENUM('Youth', 'Middle-grade', 'YA', 'Adult', 'Misc'),
    language VARCHAR(255) NOT NULL,
    format ENUM('Hardcover', 'Paperback', 'Ebook', 'Audio', 'Large Print'),
    publishing_date DATE,
    FOREIGN KEY (author_ID) REFERENCES Authors(author_ID)
);

--- Create Patrons Table
CREATE OR REPLACE TABLE Patrons (
    patron_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(16)
);

--- Create Checkouts Table
CREATE OR REPLACE TABLE Checkouts (
    checkout_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    book_ID INT NOT NULL,
    patron_ID INT NOT NULL,
    checkout_date DATE NOT NULL,
    due_date DATE NOT NULL,
    is_returned BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (book_ID) REFERENCES Books(book_ID),
    FOREIGN KEY (patron_ID) REFERENCES Patrons(patron_ID)
);

--- Create Book_Genres Table (intersection)
CREATE OR REPLACE TABLE Book_Genres (
    book_genre_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    book_ID INT NOT NULL,
    genre_ID INT NOT NULL,
    FOREIGN KEY (book_ID) REFERENCES Books(book_ID),
    FOREIGN KEY (genre_ID) REFERENCES Genres(genre_ID)
);
