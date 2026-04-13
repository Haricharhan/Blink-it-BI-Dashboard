USE Blinkit ;
SELECT * FROM Blinkit_data;
SELECT Distinct Item_Fat_Content From Blinkit_data;

--Cleaning Item_Fat_Content  ( lf, lowfat , reg to only Low Fat,Regular )
UPDATE Blinkit_data
SET Item_Fat_Content  =
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

-- Total Sales
SELECT CAST(SUM(Sales)/ 1000000 AS decimal(10,2)) FROM Blinkit_data;

-- NUMBER OF ITEMS 
SELECT COUNT(*) AS NO_OF_ITEMS FROM Blinkit_data;

--AVERAGE RATINGS 
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) FROM Blinkit_data

--TOTAL SALES BY FAT CONTENT 
SELECT Item_Fat_Content , 
		CAST(SUM(Sales) AS DECIMAL(10,2)) AS TOTAL_SALES,
		CAST(AVG(Sales) AS DECIMAL(10,0)) AS AVG_SALES,
		COUNT(*) AS NO_OF_ITEMS,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_RATING
FROM Blinkit_data
GROUP BY Item_Fat_Content 
ORDER BY TOTAL_SALES DESC

-- Converting normal table to pivot table 
SELECT Outlet_Location_Type,
	ISNULL([Low Fat],0) AS LF,
	ISNULL([Regular],0) AS REG
FROM 
(
	SELECT Outlet_Location_Type ,Item_Fat_Content,
		Cast(SUM(Sales) AS DECIMAL(10,2)) AS TS
		from Blinkit_data
		GROUP BY Outlet_Location_Type,Item_Fat_Content
) AS SourceTable
PIVOT 
(
	SUM(TS) 
	FOR Item_Fat_Content IN ([Low Fat],[Regular])
) AS PivotTable 
ORDER BY Outlet_Location_Type


-- Percentage of Sales by Outlet Size 
/*
	 IN place of (select SUM(Sales) from Blinkit_data)
	 we can also write or replace with 
	 sum(sum(sales)) Over()
*/
SELECT Outlet_Size,
	 cast(CAST((sum(Sales) * 100.0)/(select SUM(Sales) from Blinkit_data) as DECIMAL(10,0)) AS VARCHAR(64)) +'%' as Percentagee ,
	 CAST(SUM(Sales) AS DECIMAL( 10,2)) AS TS
FROM Blinkit_data
GROUP by Outlet_Size 
Order by Percentagee


-- Sales By Outlet Location 
SELECT Outlet_Location_Type,
	Cast(sum(sales) as DECIMAL(10,2)) AS Sales 
FROM Blinkit_data
GROUP BY Outlet_Location_Type
Order by Outlet_Location_Type ASC


--All the metrics by Outlet Type 











