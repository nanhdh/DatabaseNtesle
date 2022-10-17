USE NTESLE_PROJECT

--10 soal
--1
SELECT 
	SupplierName,
	IngridientName,
	[Total_Quantity] = SUM(Quantity_of_Ingridient)
FROM Supplier sp 
JOIN PurchaseTransaction pt ON Pt.SupplierID = sp.supplierID
JOIN DetailPurchaseTransaction dp ON dp.PurchaseTransactionID = pt.PurchaseTransactionID
JOIN Ingridient Id ON id.IngridientID = dp.IngridientID
WHERE IngridientName LIKE '%Sugar%'
AND DATENAME(MONTH, DatePurchase) = 'May'
GROUP BY SupplierName, IngridientName

--2
SELECT
	StaffName,
	StaffGender,
	StaffSalary,
	[Total Transaction] = COUNT(SalesTransactionID)
FROM staff s
JOIN SalesTransaction st ON s.StaffID = st.StaffID
WHERE StaffSalary BETWEEN 6000000 AND 7000000
GROUP BY StaffName, StaffGender,StaffSalary
HAVING COUNT(SalesTransactionID)>1

--3-- 
SELECT
	CustomerName, 
	[Customer Phone Number] = STUFF (CustomerNumberPhone, 1, 3,'0'),
	ProductName,
	[Total Transaction] = COUNT(st.SalesTransactionID),
	[Total Product Price ] = SUM(ProductPrice*ProductQuantity)
FROM Customer cs 
JOIN SalesTransaction st ON cs.CustomerID = st.CustomerID
JOIN DetailSalesTransaction ds ON st.SalesTransactionID = ds.SalesTransactionID
JOIN Product pd ON pd.ProductID = ds.ProductID
WHERE CHARINDEX (' ' , ProductName)>0 AND YEAR (Product_Exp_Date) > 2021
GROUP BY  CustomerName, CustomerNumberPhone, ProductName

--4
SELECT
	[Total Price] = SUM(ing.IngridientPrice),
	ing.IngridientName,
	[Total Transaction] = COUNT(dpt.PurchaseTransactionID)
FROM Ingridient ing
JOIN DetailPurchaseTransaction dpt ON ing.IngridientID = dpt.IngridientID
JOIN PurchaseTransaction pt ON pt.PurchaseTransactionID = dpt.PurchaseTransactionID
JOIN Staff sf ON sf.StaffID = pt.StaffID
WHERE sf.StaffDOB < '2001' AND YEAR(ing.Ingridient_exp_date) > '2024'
GROUP BY ing.IngridientName

--5
SELECT 
	StaffName,
	StaffGender = LEFT (StaffGender ,1 ),
	StaffDOB,
	StaffSalary,
	st.SalesTransactionID
FROM Staff Sf
JOIN SalesTransaction st ON st.StaffID = sf.StaffID
JOIN DetailSalesTransaction ds ON st.SalesTransactionID = ds.SalesTransactionID
JOIN Product pd ON pd.ProductID = ds.ProductID,
(
	SELECT 
		AverageSalaryStaff= AVG(StaffSalary)
		FROM Staff
) as x 
WHERE StaffSalary > x.AverageSalaryStaff AND YEAR (StaffDOB) > 2000
GROUP By StaffName,StaffGender, StaffDOB, StaffSalary, st.SalesTransactionID
ORDER BY StaffDOB ASC

--6
SELECT 
	[Supplier Number]= RIGHT(sp.SupplierID,3),
	SupplierName,
	IngridientName,
	IngridientPrice = 'Rp. ' + CAST(Ingridientprice AS VARCHAR),
	[IngridientExpiredDate]= Ingridient_exp_date
FROM Supplier sp 
JOIN PurchaseTransaction pt ON Pt.SupplierID = sp.supplierID
JOIN DetailPurchaseTransaction dp ON dp.PurchaseTransactionID = pt.PurchaseTransactionID
JOIN Ingridient Id ON id.IngridientID = dp.IngridientID,
	(
	SELECT 
		AverageIngridientPrice= AVG(IngridientPrice)
		FROM Ingridient
	) as x 
WHERE Ingridientprice >= x.AverageIngridientPrice AND YEAR (Ingridient_EXP_Date) > 2022


--7
SELECT
	 sp.SupplierID, 
	 SupplierName,
	 [Supplier Local Phone Number] = STUFF (SupplierPhoneNumber,1,1,'+62'), 
	 SupplierAddress,
	 [Total Price]= SUM(IngridientPrice*Quantity_of_Ingridient)
 FROM Supplier sp 
 JOIN PurchaseTransaction pt ON Pt.SupplierID = sp.SupplierID
 JOIN DetailPurchaseTransaction dp ON dp.PurchaseTransactionID = pt.PurchaseTransactionID
 JOIN Ingridient id ON id.IngridientID = dp.IngridientID,
	 (
	  SELECT 
	  AVGTotalPrice = avg(IngridientPrice*Quantity_of_Ingridient)
	  FROM Ingridient id JOIN DetailPurchaseTransaction dp ON dp.IngridientID = id.IngridientID
	 ) as x
 WHERE SupplierName Like '%Food'
 GROUP BY sp.SupplierID,SupplierName,SupplierPhoneNumber,  SupplierAddress, x.AVGTotalPrice
 HAVING SUM (IngridientPrice*Quantity_of_Ingridient) >= x.AVGTotalPrice
 ORDER BY [Total Price] DESC

--8 
SELECT 
	CustomerName,
	st.SalesTransactionID,
	SalesDate = CONVERT(VARCHAR, SalesDate, 106),
	[DateName] =DATENAME (WEEKDAY, SalesDate),
	[Quantity] = CAST(ProductQuantity as VARCHAR) + ' piece(s)', 
	ProductName,
	[SalesPrice]='RP. ' + CAST(ProductPrice AS VARCHAR),
	[Total Price] = 'Rp. ' + CAST(SUM(ProductPrice*ProductQuantity)AS VARCHAR)
FROM Customer cs
JOIN SalesTransaction st ON cs.CustomerID= st.CustomerID
JOIN DetailSalesTransaction ds ON ds.SalesTransactionID = st.SalesTransactionID
JOIN Product pd ON pd.ProductID = ds.ProductID,
	(
		SELECT 
			HighestQuantity = MAX(ProductQuantity),
			LowestQuantity = MIN(ProductQuantity)
		FROM DetailSalesTransaction
	) as x
WHERE ProductQuantity < x.HighestQuantity 
AND ProductQuantity > x.LowestQuantity
GROUP BY CustomerName, st.SalesTransactionID,  salesDate, ProductName, ProductPrice, ProductQuantity
ORDER  BY ProductQuantity ASC
	
--9 CREATE VIEW
CREATE VIEW SalesTransactionView AS
SELECT
	StaffName,
	StaffPhoneNumber,
	[Total Transaction]= COUNT(st.SalesTransactionID),
	[Highest Quantity] = Max(ProductQuantity) 
FROM Staff sf
JOIN SalesTransaction st ON sf.StaffID = st.StaffID
JOIN DetailSalesTransaction dt ON dt.SalesTransactionID = st.SalesTransactionID
WHERE DATENAME(MONTH, SalesDate) > 'August'
GROUP BY StaffName, StaffPhoneNumber
HAVING COUNT(st.SalesTransactionID)>2

SELECT * FROM SalesTransactionView

--10 CREATE VIEW
CREATE VIEW PurchaseTransactionView AS
SELECT
	SupplierName,
	SupplierPhoneNumber,
	[Total Transaction] = COUNT(pt.PurchaseTransactionID),
	[IngridientExpiredDate]= Ingridient_exp_date,
	IngridientName,
	IngridientPrice,
	[Total Ingridient Price] = SUM(IngridientPrice)
FROM Supplier sp 
JOIN PurchaseTransaction pt ON Pt.SupplierID = sp.SupplierID
JOIN DetailPurchaseTransaction dp ON dp.PurchaseTransactionID = pt.PurchaseTransactionID
JOIN Ingridient Id ON id.IngridientID = dp.IngridientID
WHERE YEAR (Ingridient_EXP_Date) > 2023 
GROUP BY SupplierName, SupplierPhoneNumber, Ingridient_exp_date, IngridientName, IngridientPrice
HAVING SUM(Ingridientprice) > 60000

SELECT * FROM PurchaseTransactionView