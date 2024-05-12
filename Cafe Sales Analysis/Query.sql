--หายอดขายรวมของแต่ละสินค้าแต่ละรายการ เรียงตามลำดับไอดีของสินค้า

SELECT 
	it.item_id AS itemID,
    it.item_name AS itemName,
    SUM(it.price * inv.quantity) AS Total_sales
FROM Items AS it 
INNER JOIN Invoices AS inv ON it.item_id = inv.item_id
GROUP BY 1,2
ORDER BY Total_sales DESC

--หายอดขายสะสมของลูกค้าแต่ละคน เรียงลำดับจากยอดขายสะสมมากไปน้อย

SELECT 
	cu.customer_id AS customer_id,
    cu.email AS email,
    SUM(it.price * inv.quantity) AS Cumulative_sales
 FROM Invoices AS inv 
 INNER JOIN Items AS it ON inv.invoice_id = it.invoice_id
 INNER JOIN Customers AS cu ON cu.customer_id = inv.customer_id
 GROUP BY 1,2
 ORDER BY Cumulative_sales DESC;

-- ให้จำแนกรายการสินค้า Dairy Products หรือ Non-Dairy Products

SELECT 
	* ,
    CASE 
    	WHEN item_id IN ('3', '4', '5', '8', '9') THEN 'Dairy Product'
        ELSE 'Non-Dairy Product'
    END 'product_category'
FROM Items

-- คำนวณยอดขายสินค้าประเภท Dairy Products และ Non-Dairy Products พร้อมทั้งหาสัดส่วนยอดขายของสินค้าทั้งสอง
  
WITH product_category AS (
	SELECT 
  	item_id,
    CASE 
    	WHEN item_id IN ('3', '4', '5', '8', '9') THEN 'Dairy Product'
        ELSE 'Non-Dairy Product'
    END 'product_category'
FROM Items
) 

SELECT 
	pc.product_category AS Product_cate,
    SUM(inv.quantity) AS Total_quan,
    SUM(inv.quantity) * 100 / (SELECT SUM(quantity) FROM Invoices) AS percentage
FROM product_category AS pc
INNER JOIN Invoices AS inv ON pc.item_id = inv.item_id
GROUP BY 1

-- คำนวณยอดขายรวมของแต่ละวันในสัปดาห์ (Sunday to Saturday)
  
SELECT
	CASE STRFTIME('%w', inv.order_date) 
    	WHEN '0' THEn 'Sunday'
        WHEN '1' THEn 'Monday'
        WHEN '2' THEn 'Tuesday'
        WHEN '3' THEn 'Wednesday'
        WHEN '4' THEn 'Thursday'
        WHEN '5' THEn 'Friday'
    	ELSE 'Saturday'
	END 'day_of_week',
    SUM(inv.quantity * it.price)  AS Total_sales
FROM Invoices AS inv 
INNER JOIN Items AS it ON inv.item_id = it.item_id
GROUP BY 1
ORDER BY Total_sales DESC;

-- คำนวณยอดขายรวมแต่ละวันในสัปดาห์จำแนกตามสินค้าประเภท Dairy และ Non-Dairy

WITH product_category AS (
	SELECT 
  	item_id,
    CASE 
    	WHEN item_id IN ('3', '4', '5', '8', '9') THEN 'Dairy Product'
        ELSE 'Non-Dairy Product'
    END 'product_category'
FROM Items
), day_of_week AS (
	SELECT
  		item_id,
  		CASE STRFTIME('%w', order_date) 
    	WHEN '0' THEn 'Sunday'
        WHEN '1' THEn 'Monday'
        WHEN '2' THEn 'Tuesday'
        WHEN '3' THEn 'Wednesday'
        WHEN '4' THEn 'Thursday'
        WHEN '5' THEn 'Friday'
    	ELSE 'Saturday'
	END 'day_of_week'
  FROM Invoices
)

SELECT
	dw.day_of_week AS day_of_week,
	pr.product_category AS product_category,
    SUM(inv.quantity * it.price) AS Total_sales
FROM product_category AS pr 
INNER JOIN Invoices AS inv ON pr.item_id = inv.item_id
INNER JOIn day_of_week AS dw ON pr.item_id = dw.item_id
INNER JOIN Items AS it ON it.item_id = pr.item_id
GROUP BY 1,2
ORDER BY Total_sales DESC






