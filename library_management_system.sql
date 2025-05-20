-- Database: Library Management System
-- This SQL file contains the schema (CREATE TABLE statements) for a simple
-- Library Management System. It demonstrates the use of primary keys,
-- foreign keys, unique constraints, not null constraints, and different
-- types of relationships (1-M, M-M).


-- Drop tables if they already exist to ensure a clean slate
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Book_Authors;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Members;

-- -----------------------------------------------------
-- Table `Authors`
-- Stores information about the authors of books.
-- -----------------------------------------------------
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY, -- Primary Key: Unique identifier for each author
    first_name VARCHAR(100) NOT NULL,        -- Author's first name, cannot be empty
    last_name VARCHAR(100) NOT NULL,         -- Author's last name, cannot be empty
    nationality VARCHAR(50)                  -- Author's nationality, can be NULL
);

-- -----------------------------------------------------
-- Table `Books`
-- Stores information about the books available in the library.
-- -----------------------------------------------------
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,  -- Primary Key: Unique identifier for each book
    title VARCHAR(255) NOT NULL,             -- Title of the book, cannot be empty
    isbn VARCHAR(13) UNIQUE NOT NULL,        -- International Standard Book Number, must be unique and not empty
    publication_year INT NOT NULL,           -- Year the book was published, cannot be empty
    genre VARCHAR(100),                      -- Genre of the book, can be NULL
    total_copies INT NOT NULL DEFAULT 1,     -- Total number of copies of this book in the library, defaults to 1
    available_copies INT NOT NULL DEFAULT 1  -- Number of copies currently available for loan, defaults to 1
        CHECK (available_copies <= total_copies AND available_copies >= 0) -- Ensure available copies are logical
);

-- -----------------------------------------------------
-- Table `Book_Authors`
-- This is a junction/linking table to handle the Many-to-Many (M-M) relationship
-- between `Books` and `Authors`. A book can have multiple authors, and an author
-- can write multiple books.
-- -----------------------------------------------------
CREATE TABLE Book_Authors (
    book_id INT NOT NULL,                     -- Foreign Key: References `Books` table
    author_id INT NOT NULL,                   -- Foreign Key: References `Authors` table
    PRIMARY KEY (book_id, author_id),         -- Composite Primary Key: Ensures unique book-author pairs

    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE CASCADE                    -- If a book is deleted, remove its entries from this table
        ON UPDATE CASCADE,                    -- If a book_id changes, update it here
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
        ON DELETE CASCADE                    -- If an author is deleted, remove their entries from this table
        ON UPDATE CASCADE                     -- If an author_id changes, update it here
);

-- -----------------------------------------------------
-- Table `Members`
-- Stores information about the library members (users).
-- -----------------------------------------------------
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,  -- Primary Key: Unique identifier for each member
    first_name VARCHAR(100) NOT NULL,         -- Member's first name, cannot be empty
    last_name VARCHAR(100) NOT NULL,          -- Member's last name, cannot be empty
    email VARCHAR(255) UNIQUE NOT NULL,       -- Member's email, must be unique and not empty
    phone_number VARCHAR(20),                 -- Member's phone number, can be NULL
    registration_date DATE NOT NULL DEFAULT (CURRENT_DATE) -- Date of registration, defaults to current date
);

-- -----------------------------------------------------
-- Table `Loans`
-- Records each instance of a book being borrowed by a member.
-- This table handles the One-to-Many (1-M) relationship between `Books` and `Loans`
-- (one book can have many loans over time) and `Members` and `Loans`
-- (one member can have many loans).
-- -----------------------------------------------------
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,  -- Primary Key: Unique identifier for each loan
    book_id INT NOT NULL,                    -- Foreign Key: References the `Books` table
    member_id INT NOT NULL,                  -- Foreign Key: References the `Members` table
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE), -- Date the book was borrowed, defaults to current date
    due_date DATE NOT NULL,                  -- Date the book is due, cannot be empty
    return_date DATE,                        -- Date the book was returned, can be NULL if not yet returned
    status ENUM('Borrowed', 'Returned', 'Overdue') NOT NULL DEFAULT 'Borrowed', -- Current status of the loan

    -- Constraints to ensure due_date is after loan_date
    CHECK (due_date >= loan_date),

    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE RESTRICT                   -- Prevent deleting a book if there are active loans for it
        ON UPDATE CASCADE,                    -- If a book_id changes, update it here
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
        ON DELETE RESTRICT                   -- Prevent deleting a member if they have active loans
        ON UPDATE CASCADE                     -- If a member_id changes, update it here
);

-- Optional: Add indexes for performance on frequently queried columns
CREATE INDEX idx_book_title ON Books(title);
CREATE INDEX idx_member_email ON Members(email);
CREATE INDEX idx_loan_dates ON Loans(loan_date, due_date);

-- Optional: Add some sample data to test the schema
INSERT INTO Authors (first_name, last_name, nationality) VALUES
('Stephen', 'King', 'American'),
('J.K.', 'Rowling', 'British'),
('George', 'Orwell', 'British');

INSERT INTO Books (title, isbn, publication_year, genre, total_copies, available_copies) VALUES
('The Shining', '9780307743657', 1977, 'Horror', 5, 5),
('Harry Potter and the Sorcerer''s Stone', '9780590353427', 1997, 'Fantasy', 10, 10),
('1984', '9780451524935', 1949, 'Dystopian', 7, 7);

INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1), -- The Shining by Stephen King
(2, 2), -- Harry Potter by J.K. Rowling
(3, 3); -- 1984 by George Orwell

INSERT INTO Members (first_name, last_name, email, phone_number) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '111-222-3333'),
('Bob', 'Johnson', 'bob.j@example.com', '444-555-6666');

-- Example loan (Alice borrows The Shining)
INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
(1, 1, '2023-01-10', '2023-01-24');

-- Example loan (Bob borrows Harry Potter)
INSERT INTO Loans (book_id, member_id, loan_date, due_date) VALUES
(2, 2, '2023-01-15', '2023-01-29');
