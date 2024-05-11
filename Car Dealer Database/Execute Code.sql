-- 1. แสดงประเภทของรถยนต์ที่ขายได้จากขายได้มากที่สุดไปน้อยที่สุด

SELECT
	ve.VehicleType AS vehicle_type,
    COUNT(st.VehicleID) AS Total_sales
FROM Vehicle AS ve 
INNER JOIN SalesTransaction AS st ON ve.VehicleID = st.VehicleID
GROUP BY 1
ORDER BY Total_sales DESC;

-- 2. ระบุพนักงานขาย(ชื่อ-นามสกุล) ที่ขายรถได้มากที่สุดและขายได้กี่คัน
SELECT
	sp.FirstName AS firstname,
    sp.LastName AS lastname,
    COUNT(st.SalespersonID) AS Total_transaction
FROM SalesTransaction AS st
INNER JOIN Salesperson AS sp ON sp.SalespersonID = st.SalespersonID
GROUP BY 1,2
ORDER BY Total_transaction DESC;

-- 3. คำนวณยอดขายทั้งหมดของพนักงานขายแต่ละคน
SELECT
	sp.FirstName AS firstname,
    sp.LastName AS lastname,
    SUM(ve.price) AS Total_revenue
FROM SalesTransaction AS st
INNER JOIN Salesperson AS sp ON sp.SalespersonID = st.SalespersonID
INNER JOIN Vehicle AS ve ON st.VehicleID = ve.VehicleID
GROUP BY 1,2
ORDER BY Total_revenue DESC;

-- 4. ในปี2023ระหว่างรถพลังงานไฟฟ้า(Electric) หรือพลังงานเชื้อเพลิง(Petrol) แบบไหนได้รับความนิยมมากกว่ากัน
SELECT 
	ve.FuelType AS Fuel_type,
    SUM(ve.Price) AS Total_sales
FROM Vehicle AS ve 
INNER JOIN SalesTransaction AS st ON ve.VehicleID = st.VehicleID
WHERE STRFTIME('%Y', st.SaleDate) = '2023'
GROUP by 1
ORDER BY Total_sales DESC;

-- 5. จัดหมวดหมู่ให้กับรถแต่ละโมเดลโดยมีเงื่อนไขว่า ถ้าราคาเท่ากับหรือมากกว่า1ล้านให้จัดเป็นรุ่น FlagshipModel แต่ถ้าราคาต่ำกว่านั้นให้จัดเป็นรุ่น NormalModel
SELECT 
	modelname,
    CASE 
    	WHEN price >= 1000000 THEN 'Flagship Model'
        ELSE 'Normal Model'
    END 'ModelLabel'
FROM Vehicle
