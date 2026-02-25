/*
Project: SQL Server Application Support & Reporting System
Author: Prakhar Shrivastava
Description:
This project simulates a real-world application support system 
with relational database design, reporting queries, 
stored procedures, and query optimization.
*/


-- ============================================
-- SECTION 1: Database Tables Creation
-- ============================================
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserName VARCHAR(100),
    Email VARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE()
);
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- ============================================
-- SECTION 2: Sample Data Insertion
-- ============================================
INSERT INTO Users (UserName, Email)
VALUES 
('Rahul', 'rahul@gmail.com'),
('Amit', 'amit@gmail.com'),
('Priya', 'priya@gmail.com');
INSERT INTO Products (ProductName, Price)
VALUES 
('Laptop', 50000),
('Mouse', 500),
('Keyboard', 1500);
INSERT INTO Orders (UserID)
VALUES (1), (2), (1);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES 
(1,1,1),
(1,2,2),
(2,3,1),
(3,2,3);


-- ============================================
-- SECTION 3: Reporting Queries (Business Logic)
-- ============================================
SELECT U.UserName,
       SUM(P.Price * OD.Quantity) AS TotalSpent
FROM Users U
JOIN Orders O ON U.UserID = O.UserID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY U.UserName
ORDER BY TotalSpent DESC;


-- ============================================
-- SECTION 4: Stored Procedure for Monthly Sales Report
-- ============================================
CREATE PROCEDURE GetMonthlySales
AS
BEGIN
    SELECT 
        FORMAT(O.OrderDate, 'yyyy-MM') AS Month,
        SUM(P.Price * OD.Quantity) AS TotalRevenue
    FROM Orders O
    JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    GROUP BY FORMAT(O.OrderDate, 'yyyy-MM')
    ORDER BY Month;
END;

EXEC GetMonthlySales;


-- ============================================
-- SECTION 5: Index Creation for Performance Optimization
-- ============================================
CREATE INDEX idx_userid ON Orders(UserID);