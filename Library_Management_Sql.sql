-- ===============================
--    Smart Library Management System 
-- ===============================

-- 1. Establish a New Database
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- 2. Define Table Structures with Constraints
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL
);

CREATE TABLE Books (
    ItemID INT AUTO_INCREMENT PRIMARY KEY, -- Changed BookID to ItemID
    Title VARCHAR(100) NOT NULL,
    AuthorID INT NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) CHECK (Price > 0),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    JoinDate DATE NOT NULL
);

CREATE TABLE Borrowing (
    BorrowID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT NOT NULL,
    ItemID INT NOT NULL, -- Changed BookID to ItemID
    CheckoutDate DATE NOT NULL, -- Changed BorrowDate to CheckoutDate
    DueDate DATE DEFAULT NULL, -- Changed ReturnDate to DueDate
    Fine DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ItemID) REFERENCES Books(ItemID) -- Ensuring correct relationship
);

-- 3. Populate Data for Authors, Books, and Members
INSERT INTO Authors (Name, Country) VALUES 
('Shruti Hela', 'United States'),
('Moumita Saha', 'United States'),
('Sohini Banerjee', 'United Kingdom'),
('Amina Khatun', 'India'),
('Sakila Tarannom', 'India');

INSERT INTO Books (Title, AuthorID, Category, Price) VALUES 
('The Last Detective', 1, 'Mystery', 18.50),
('Secrets of the Orient', 2, 'Adventure', 15.50),
('Courage in Chaos', 3, 'Drama', 12.75),
('Life of the Wild', 4, 'Nature', 11.99),
('Cooking with Passion', 5, 'Cooking', 21.00);

INSERT INTO Members (Name, JoinDate) VALUES 
('Henry', '2025-06-01'),
('Isla', '2025-07-08'),
('Leo', '2025-08-12'),
('Amelia', '2025-09-25'),
('Felix', '2025-10-30');

-- 4. Record Borrowing Transactions with Correct Dates
INSERT INTO Borrowing (MemberID, ItemID, CheckoutDate, DueDate) VALUES 
(1, 1, '2025-01-10', '2025-12-20'), -- Fixed incorrect date format
(2, 2, '2025-02-06', '2025-12-15'), -- Fixed incorrect date format
(3, 3, '2025-03-12', '2025-02-24'),
(4, 4, '2025-04-01', '2025-12-10'), -- Fixed incorrect date format
(5, 5, '2025-05-15', '2025-03-25');

-- 5. Apply a System for Late Fees
UPDATE Borrowing
SET Fine = CASE 
    WHEN DueDate IS NOT NULL AND DATEDIFF(DueDate, CheckoutDate) > 7 
    THEN (DATEDIFF(DueDate, CheckoutDate) - 7) * 2
    ELSE 0
END;

-- 6. Retrieve Essential Information
-- a. Display Books Alongside Their Authors
SELECT B.Title, A.Name AS Author
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID;

-- b. Identify Books Borrowed by a Specific Member
SELECT B.Title 
FROM Borrowing Br
JOIN Members M ON Br.MemberID = M.MemberID
JOIN Books B ON Br.ItemID = B.ItemID
WHERE M.Name = 'Henry';

-- 7. Create a Procedure to Search Books by Category
DELIMITER //
CREATE PROCEDURE GetBooksByCategory(IN category_name VARCHAR(50))
BEGIN
    SELECT Title, Price FROM Books WHERE Category = category_name;
END //
DELIMITER ;

-- 8. Enhance Query Efficiency with Indexing
CREATE INDEX idx_authorid ON Books(AuthorID);
CREATE INDEX idx_itemid ON Borrowing(ItemID); -- Ensures faster retrieval of borrowed items
CREATE INDEX idx_memberid ON Borrowing(MemberID);

-- 9. Establish a View to Summarize Borrowing Information
CREATE VIEW BorrowedBooksView AS
SELECT Br.BorrowID, M.Name AS Member, B.Title AS BookTitle, Br.CheckoutDate, Br.DueDate, Br.Fine
FROM Borrowing Br
JOIN Members M ON Br.MemberID = M.MemberID
JOIN Books B ON Br.ItemID = B.ItemID;

-- 10. Confirm View Functionality
SELECT * FROM BorrowedBooksView;