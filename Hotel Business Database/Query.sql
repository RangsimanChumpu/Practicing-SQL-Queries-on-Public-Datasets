-- ดึงข้อมูลประเภทของห้อง และจำนวนห้องที่ว่างในแต่ละประเภท

SELECT 
	room_type,
    COUNT(status) AS number_avialable
FROM Rooms
WHERE status = 'available'
GROUP BY 1;

--คำนวณราคาเฉลี่ยที่ลูกค้าจ่ายต่อครั้ง

SELECT ROUND(AVG(amount_paid),2) AS avg_cus_paid
FROM Reservations;

-- ลูกค้าคนไหนเอ่ย? ที่มียอดการใช้จ่ายสูงที่สุดตลอดกาล และจองห้องไปกี่ครั้ง

SELECT 
	customer_id,
    COUNT(*) AS quatity,
    SUM(amount_paid) AS Total_paid
FROM Reservations
GROUP BY customer_id
ORDER BY Total_paid DESC
LIMIT 1;

--หาว่าวันไหนจันทร์-อาทิตย์) ที่ยอดจองห้องสูงที่สุด

SELECT 
	CASE STRFTIME('%w', check_in_date) 
    	WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        ELSE 'Saturday'
    END 'day_of_week',
    COUNT(*) AS amount 
FROM Reservations
GROUP BY 1
ORDER BY amount DESC;

--คำนวณอัตราการเข้าพัก (Occupancy Rate) ของโรงแรมนี้

SELECT 
	DISTINCT status AS status,
    COUNT(status) AS count_status
FROM Rooms
GROUP by 1
