ALTER TABLE Products DROP CONSTRAINT FK_Products_Categories;
ALTER TABLE Products DROP COLUMN CategoryId;
DROP TABLE IF EXISTS Categories;