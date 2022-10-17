CREATE DATABASE NTESLE_PROJECT

USE NTESLE_PROJECT
--Customer
CREATE TABLE Customer(
CustomerID CHAR (5) PRIMARY KEY NOT NULL CHECK(CustomerID LIKE 'CS[0-9][0-9][0-9]'),
CustomerName VARCHAR (20),
CustomerNumberPhone VARCHAR (20) CHECK (CustomerNumberPhone LIKE '+62%'),
CustomerAddress VARCHAR (20)
)

--Type
CREATE TABLE [Type](
TypeID CHAR(5) PRIMARY KEY NOT NULL CHECK(TypeID LIKE 'PT[0-9][0-9][0-9]'),
TypeName VARCHAR (20))

--Product
CREATE TABLE Product(
ProductID CHAR(5) PRIMARY KEY NOT NULL CHECK(ProductID LIKE 'PD[0-9][0-9][0-9]'),
ProductName VARCHAR (20) CHECK (LEN(ProductName)>=5) ,
ProductPrice INT CHECK(ProductPrice  >=5000),
Product_Exp_Date date CHECK (YEAR(Product_Exp_Date) > '2020'),
TypeID CHAR(5) FOREIGN KEY REFERENCES [Type](TypeID) ON UPDATE CASCADE ON DELETE CASCADE
)

--Staff
CREATE TABLE Staff(
StaffID CHAR(5) PRIMARY KEY NOT NULL CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
StaffName VARCHAR (20),
StaffGender VARCHAR(20) CHECK(StaffGender ='Male' OR StaffGender = 'Female'),
StaffPhoneNumber VARCHAR(20),
StaffDOB Date,
StaffSalary NUMERIC CHECK (StaffSalary BETWEEN 1000000 AND 10000000)
)

--SalesTransaction
CREATE TABLE SalesTransaction(
SalesTransactionID CHAR (5) PRIMARY KEY NOT NULL CHECK(SalesTransactionID LIKE 'SL[0-9][0-9][0-9]'),
StaffID CHAR (5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE,
CustomerID CHAR (5) FOREIGN KEY REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE,
SalesDate DATE
)

--Detailsalestransaction
CREATE TABLE DetailSalesTransaction(
SalesTransactionID CHAR(5) FOREIGN KEY REFERENCES SalesTransaction(SalesTransactionID) ON UPDATE CASCADE ON DELETE CASCADE,
ProductID CHAR(5) FOREIGN KEY REFERENCES Product(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
ProductQuantity INT,
PRIMARY KEY(SalesTransactionID, ProductID)
)

--Supplier
CREATE TABLE Supplier(
SupplierID CHAR (5) PRIMARY KEY NOT NULL CHECK(SupplierID LIKE 'SU[0-9][0-9][0-9]'),
SupplierName VARCHAR (20),
SupplierPhoneNumber VARCHAR(20),
SupplierAddress VARCHAR(20)
)

--Ingridient
CREATE TABLE Ingridient(
IngridientID CHAR (5) PRIMARY KEY NOT NULL CHECK(IngridientID  LIKE 'IG[0-9][0-9][0-9]'),
IngridientName VARCHAR(20),
IngridientPrice INT,
Ingridient_exp_date date CHECK (YEAR(Ingridient_exp_date) > '2022')
)

--PurchaseTransaction
CREATE TABLE PurchaseTransaction(
PurchaseTransactionID CHAR (5) PRIMARY KEY NOT NULL CHECK(PurchaseTransactionID LIKE 'PU[0-9][0-9][0-9]'),
StaffID CHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE,
SupplierID CHAR(5) FOREIGN KEY REFERENCES Supplier(SupplierID) ON UPDATE CASCADE ON DELETE CASCADE, 
DatePurchase DATE
)

--DetailPurchaseTransaction
CREATE TABLE DetailPurchaseTransaction(
PurchaseTransactionID CHAR (5) FOREIGN KEY REFERENCES PurchaseTransaction(PurchaseTransactionID) ON UPDATE CASCADE ON DELETE CASCADE,
IngridientID CHAR(5) FOREIGN KEY REFERENCES Ingridient(IngridientID) ON UPDATE CASCADE ON DELETE CASCADE, 
Quantity_of_ingridient INT,
PRIMARY KEY (PurchaseTransactionID,IngridientID )
)