# *Final Project for Database Management System Course*

# Library Management System Database
# Project Title: Library Management System Database Schema

## Description of what your project does
This project implements a relational database schema for a simple Library Management System using MySQL. It is designed to manage information about books, authors, library members, and the borrowing/returning of books (loans). The schema is structured to ensure data integrity and efficient retrieval, demonstrating key database concepts such as:

## Tables: Authors, Books, Book_Authors (for M-M relationship), Members, and Loans.

## Primary Keys (PK): Unique identifiers for each record.

## Foreign Keys (FK): Enforce relationships between tables and maintain referential integrity.

## Constraints: NOT NULL (ensuring essential data is present), UNIQUE (preventing duplicate entries like ISBNs or emails), and CHECK (for logical data values).


# Relationships:
## One-to-Many (1-M): A member can have many loans; a book can be part of many loans over time.

## Many-to-Many (M-M): An author can write multiple books, and a book can have multiple authors (handled via the Book_Authors junction table).

## The .sql file also includes sample data to populate the tables, making it easy to test the schema immediately after import.

# How to run/setup the project (or import SQL)
* To set up and run this database project, you will need a MySQL server instance (e.g., XAMPP, WAMP, MAMP, Docker MySQL container, or a standalone MySQL installation).

* Install MySQL: If you don't have MySQL installed, download and install it from the official MySQL website or use a package like XAMPP/WAMP/MAMP which bundles MySQL.

* Access MySQL Client: Open a MySQL client. This could be:
  - MySQL Workbench
  - phpMyAdmin (if using XAMPP/WAMP)
  - The MySQL command-line client

# Create a New Database:
* You can create a new database named library_db (or any name you prefer) using the following SQL command in your MySQL client:

# CREATE DATABASE IF NOT EXISTS library_db;
* USE library_db;

# Import the SQL File:
* Using MySQL Workbench/phpMyAdmin: Most GUI tools have an "Import" or "Execute SQL Script" option. Select the library_management_system.sql file and run it against your newly created library_db.

# Using MySQL Command-Line Client:
* Navigate to the directory where you saved library_management_system.sql in your terminal or command prompt. Then, run the following command, replacing your_username with your MySQL username:
- mysql -u your_username -p library_db < library_management_system.sql
- You will be prompted to enter your MySQL password.
- After successful import, your library_db will be populated with the defined tables and sample data.

# Entity-Relationship Diagram (ERD)
Below is a textual representation of the database schema, which can be used to generate an ERD using various online tools or database design software.

# Entities and their Attributes:
  *Authors
  
  *author_id (PK)
  
  *first_name (NOT NULL)
  
  *last_name (NOT NULL)
  
  *nationality
  
  *Books
  
  *book_id (PK)
  
  *title (NOT NULL)
  
  *isbn (UNIQUE, NOT NULL)
  
  *publication_year (NOT NULL)
  
  *genre
  
  *total_copies (NOT NULL, DEFAULT 1)
  
  *available_copies (NOT NULL, DEFAULT 1, CHECK)
  
  *Members
  
  *member_id (PK)
  
  *first_name (NOT NULL)
  
  *last_name (NOT NULL)
  
  *email (UNIQUE, NOT NULL)
  
  *phone_number
  
  *registration_date (NOT NULL, DEFAULT CURRENT_DATE)
  
  *Loans
  
  *loan_id (PK)
  
  *book_id (FK to Books, NOT NULL)
  
  *member_id (FK to Members, NOT NULL)
  
  *loan_date (NOT NULL, DEFAULT CURRENT_DATE)
  
  *due_date (NOT NULL, CHECK)
  
  *return_date
  
  *status (ENUM: 'Borrowed', 'Returned', 'Overdue', NOT NULL, DEFAULT 'Borrowed')
  
  *Book_Authors (Junction Table)
  
  *book_id (FK to Books, PK)
  
  *author_id (FK to Authors, PK)

# Relationships:

Authors (1) --- Book_Authors (M) --- (M) Books: Many-to-Many relationship between Authors and Books.

Book_Authors.book_id references Books.book_id (ON DELETE CASCADE, ON UPDATE CASCADE)

Book_Authors.author_id references Authors.author_id (ON DELETE CASCADE, ON UPDATE CASCADE)

Books (1) --- Loans (M): One-to-Many relationship. A book can have multiple loans over time.

Loans.book_id references Books.book_id (ON DELETE RESTRICT, ON UPDATE CASCADE)

Members (1) --- Loans (M): One-to-Many relationship. A member can have multiple loans.

Loans.member_id references Members.member_id (ON DELETE RESTRICT, ON UPDATE CASCADE)


# To generate an ERD:
You can use online tools like:

dbdiagram.io

draw.io (now diagrams.net)

Lucidchart
