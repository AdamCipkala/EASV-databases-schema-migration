CREATE TABLE ProductRatings (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT NOT NULL,
    Rating TINYINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    CONSTRAINT FK_ProductRatings_Products FOREIGN KEY (ProductId) REFERENCES Products(Id)
);