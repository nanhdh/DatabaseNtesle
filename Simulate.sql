USE NTESLE_PROJECT

---SIMULATE 
/*September 04, 2020
Customer Doni Alamsyah (CS005) buy a variety of food at nestle.
The product are:
- 30	Chiken Wings	(PD009)
- 28	nteslemie	(PD007)	
- 20	Pagoda	(PD010)	

--/ This transaction handeled by Dzaky (ST001)
*/

-- INSERT DATA INTO SalesTransaction table
-- SalesTransactionID - StaffID - CustomerID - SalesDate
INSERT INTO SalesTransaction VALUES 
	('SL016', 'ST001', 'CS005', '2020-09-04')

-- INSERT DATA INTO DetailSalesTransaction table
-- SalesTransactionID - ProductID - ProductQuantity
INSERT INTO DetailSalesTransaction VALUES
	('SL016', 'PD009', 30),
	('SL016', 'PD007', 28),
	('SL016', 'PD010', 20)

--====================================================--

-- Purchase Transaction

/*
November 23, 2020
Nestle bought some products from PT.Nakata (SU009)
The Product are:
- 50	Ragi				(IG003)	
- 25	Food Flavoring		(IG014)

This transaction handled by Heru Jackson (ST007)
*/
-- INSERT DATA INTO PurchaseTransaction table
-- PurchaseTransactionID - StaffID- SupplierID- DatePurchase
INSERT PurchaseTransaction VALUES
	('PU016','ST007','SU003','2020-11-23')


-- INSERT DATA INTO DetailPurchaseTransaction table
-- PurchaseTransactionID - Ingridient_ID - Quantity
INSERT DetailPurchaseTransaction VALUES
	('PU016','IG003','50'),
	('PU016','IG014','25')