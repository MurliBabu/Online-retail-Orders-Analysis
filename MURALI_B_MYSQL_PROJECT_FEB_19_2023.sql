-- Question1.Write a query to display customer_id,customer full name with their title (Mr/Ms),both first name and last name are in upper case,customer_email,customer_creation_year and display customer’s category after applying below categorization rules:i.if CUSTOMER_CREATION_DATE year <2005 then category A ii.if CUSTOMER_CREATION_DATE year>=2005 and <2011 then category B iii.if CUSTOMER_CREATION_DATE year>= 2011 then category C --

-- Solution --

USE ORDERS;
SELECT CUSTOMER_ID,CONCAT(
CASE
WHEN CUSTOMER_GENDER='M' THEN 'MR.'
ELSE 'MS.'END ,' ',UPPER(CUSTOMER_FNAME),' ',UPPER(CUSTOMER_LNAME)) AS CUSTOMER_FULL_NAME,CUSTOMER_EMAIL,(CUSTOMER_CREATION_DATE),
CASE  
WHEN YEAR(CUSTOMER_CREATION_DATE)<2005 THEN 'A'
WHEN YEAR(CUSTOMER_CREATION_DATE)>=2005 AND YEAR(CUSTOMER_CREATION_DATE)<2011 THEN 'B' 
ELSE 'C'
END AS CUSTOMERS_CATEGORY FROM ONLINE_CUSTOMER;




-- Question2. Write a query to display the following information for the products which have not been sold:product_id,product_desc,product_quantity_avail,product_price,inventory values(product_quantity_avail * product_price),New_Price after applying discount as per below criteria.Sort the output with respect to decreasing value of Inventory_Value.i)If Product Price >200,000 then apply 20% discount ii)If Product Price >100,000 then apply 15% discount iii)if Product Price =<100,000 then apply 10% discount -- 

-- Solution--

SELECT PROD.PRODUCT_ID,PROD.PRODUCT_DESC,PROD.PRODUCT_QUANTITY_AVAIL,PROD.PRODUCT_PRICE,(PROD.PRODUCT_QUANTITY_AVAIL*PROD.PRODUCT_PRICE) AS INVENTORY_VALUES,
(CASE
WHEN PROD.PRODUCT_PRICE >20000 THEN PROD.PRODUCT_PRICE *0.8
WHEN PRODUCT_PRICE >10000 THEN PROD.PRODUCT_PRICE *0.85
ELSE PROD.PRODUCT_PRICE *0.9
END) AS NEW_PRICE FROM PRODUCT PROD LEFT JOIN ORDER_ITEMS ORD ON PROD.PRODUCT_ID=ORD.PRODUCT_ID
WHERE PRODUCT_QUANTITY IS NULL ORDER BY INVENTORY_VALUES DESC;



-- Question3.Write a query to display Product_class_code,Product_class_desc,Count of Product type in each product class,Inventory Value(p.product_quantity_avail*p.product_price).Information should be displayed for only those product_class_code which have more than 1,00,000 Inventory Value.Sort the output with respect to decreasing value of Inventory_Value. --

-- Solution --

SELECT PRDC.PRODUCT_CLASS_CODE, PRDC.PRODUCT_CLASS_DESC, COUNT(PRD.PRODUCT_ID) AS COUNT_PRODUCT_TYPE, SUM(PRD.PRODUCT_QUANTITY_AVAIL *PRD.PRODUCT_PRICE) AS INVENTORY_VALUE
FROM PRODUCT PRD 
JOIN PRODUCT_CLASS PRDC ON PRD.PRODUCT_CLASS_CODE = PRDC.PRODUCT_CLASS_CODE 
GROUP BY PRDC.PRODUCT_CLASS_CODE, PRDC.PRODUCT_CLASS_DESC 
HAVING INVENTORY_VALUE >100000 
ORDER BY INVENTORY_VALUE DESC;



-- Question4.Write a query to display customer_id,full name,customer_email,customer_phone and country of customers who have cancelled all the orders placed by them --

-- Solution -- 

SELECT OC.CUSTOMER_ID,CONCAT(UPPER(OC.CUSTOMER_FNAME),'',UPPER(OC.CUSTOMER_LNAME))
FULL_NAME,OC.CUSTOMER_EMAIL,OC.CUSTOMER_PHONE,ADR.COUNTRY
FROM ONLINE_CUSTOMER OC
INNER JOIN ADDRESS ADR
USING (ADDRESS_ID)
INNER JOIN ORDER_HEADER
USING (CUSTOMER_ID)
WHERE ORDER_STATUS='CANCELLED';




-- Question5.Write a query to display Shipper name,City to which it is catering,num of customer catered by the shipper in the city,number of consignment delivered to that city for Shipper DHL. 

-- Solution -- 

SELECT SHP.SHIPPER_NAME, ADR.CITY, COUNT(DISTINCT OH.CUSTOMER_ID) AS NUM_CUSTOMERS, COUNT(OH.ORDER_ID) AS NUM_CONSIGNMENTS
FROM SHIPPER SHP
INNER JOIN ORDER_HEADER OH ON SHP.SHIPPER_ID=OH.SHIPPER_ID
INNER JOIN ONLINE_CUSTOMER OC ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
INNER JOIN ADDRESS ADR ON OC.ADDRESS_ID=ADR.ADDRESS_ID
WHERE SHP.SHIPPER_NAME ='DHL'
GROUP BY SHP.SHIPPER_NAME,ADR.CITY;




/* Question6.Write a query to display product_id, product_desc, product_quantity_avail, quantity sold 
and show inventory Status of products as per below condition: 
a. For Electronics and Computer categories, 
if sales till date is Zero then show  'No Sales in past, give discount to reduce inventory', 
if inventory quantity is less than 10% of quantity sold, show 'Low inventory, need to add inventory', 
if inventory quantity is less than 50% of quantity sold, show 'Medium inventory, need to add some inventory',
if inventory quantity is more or equal to 50% of quantity sold, show 'Sufficient inventory' 
b. For Mobiles and Watches categories, 
if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
if inventory quantity is less than 20% of quantity sold, show 'Low inventory, need to add inventory', 
if inventory quantity is less than 60% of quantity sold, show 'Medium inventory, need to add some inventory',
if inventory quantity is more or equal to 60% of quantity sold, show 'Sufficient inventory' 

c. Rest of the categories, 
if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
if inventory quantity is less than 30% of quantity sold, show 'Low inventory, need to add inventory', 
if inventory quantity is less than 70% of quantity sold, show 'Medium inventory, need to add some inventory',
if inventory quantity is more or equal to 70% of quantity sold, show 'Sufficient inventory'
*/


-- Solution -- 

SELECT PC.PRODUCT_CLASS_DESC, P.PRODUCT_ID, P.PRODUCT_DESC, P.PRODUCT_QUANTITY_AVAIL,
CASE WHEN P.PRODUCT_QUANTITY_AVAIL = 0 THEN 'NO SALES IN PAST,GIVE DISCOUNT TO REDUCE INVENTORY'
WHEN PC.PRODUCT_CLASS_DESC IN ('ELECTRONICS','COMPUTER') THEN
CASE WHEN P.PRODUCT_QUANTITY_AVAIL <= 10 THEN 'LOW INVENTORY,NEED TO ADD INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL <50 THEN 'MEDIUM INVENTORY,NEED TO ADD INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL >= 50 THEN 'SUFFICIENT INVENTORY'
WHEN PC.PRODUCT_CLASS_DESC IN ('MOBILES','WATCHES') THEN
CASE WHEN P.PRODUCT_QUANTITY_AVAIL = 0 THEN 'NO SALES IN PAST,GIVE DISCOUNT TO REDUCE INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL <20 THEN 'LOW INVENTORY,NEED TO ADD INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL <60 THEN 'MEDIUM INVENTORY,NEED TO ADD INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL >=60 THEN 'SUFFICIENT INVENTORY'
WHEN PC.PRODUCT_CLASS_DESC NOT IN ('ELECTRONICS','COMPUTER','MOBILES','WATCHES') THEN
CASE WHEN P.PRODUCT_QUANTITY_AVAIL = 0 THEN 'NO SALES IN PAST,GIVE DISCOUNT TO REDUCE INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL <30 THEN 'LOW INVENTORY,NEED TO ADD INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL <70 THEN 'MEDIUM INVENTORY,NEED TO ADD INVENTORY'
WHEN P.PRODUCT_QUANTITY_AVAIL >=70 THEN 'SUFFICIENT INVENTORY'
END AS STATUS FROM PRODUCT P INNER JOIN PRODUCT_CLASS PC ON PRODUCT_ID = PRODUCT_ID;




-- Question7.Write a query to display order_id and volume of the biggest order(in terms of volume)that can fit in carton id 10. -- 

-- Solution --

SELECT ORDI.ORDER_ID, (PRT.LEN*PRT.WIDTH*PRT.HEIGHT) PRODUCT_VOLUME
FROM PRODUCT PRT JOIN ORDER_ITEMS ORDI USING (PRODUCT_ID) 
WHERE (PRT.LEN*PRT.WIDTH*PRT.HEIGHT) <= (SELECT(CART.LEN*CART.WIDTH*CART.HEIGHT)
CARTON_VOLUME FROM CARTON CART WHERE CARTON_ID =10) ORDER BY PRODUCT_VOLUME 
DESC LIMIT 1;




-- Question8.Write a query to display customer id,customer full name,total quantity and total value(quantity*price)shipped where mode of payment is Cash and customer last name starts with 'G' --


-- Solution -- 

SELECT ONLC.CUSTOMER_ID,CONCAT(ONLC.CUSTOMER_FNAME,' ',ONLC.CUSTOMER_LNAME) AS 
FULL_NAME,COUNT(OI.PRODUCT_QUANTITY) AS TOTAL_QUANTITY,
SUM(OI.PRODUCT_QUANTITY * PRODT.PRODUCT_PRICE) AS TOTAL_VALUE 
FROM ONLINE_CUSTOMER ONLC
INNER JOIN ORDER_HEADER ORDH
USING (CUSTOMER_ID)
INNER JOIN ORDER_ITEMS OI
USING(ORDER_ID)
INNER JOIN PRODUCT PRODT
USING (PRODUCT_ID) 
WHERE ORDER_STATUS = 'SHIPPED' AND PAYMENT_MODE='CASH' AND CUSTOMER_LNAME LIKE 'G%'
GROUP BY CUSTOMER_ID;




-- Question9.Write a query to display product_id,product_desc and total quantity of products which are sold together with product id 201 and are not shipped to city Bangalore and New Delhi -- 

-- Solution --

SELECT PM1.PRODUCT_ID,PM1.PRODUCT_DESC,SUM(PM2.TOT_QTY) AS TOT_QTY
FROM PRODUCT_MASTER PM1,
SALES_ORDER_MASTER PM2
WHERE PM1.PRODUCT_ID=PM2.PRODUCT_ID
AND PM2.PRODUCT_ID != 201
AND PM2.CITY NOT IN ('BANGALORE', 'NEW DELHI')
GROUP BY PM1.PRODUCT_ID,PM1.PRODUCT_DESC
ORDER BY TOT_QTY DESC;





-- Question10.Write a query to display the order_id,customer_id and customer fullname,total quantity of products shipped for order ids which are even and shipped to address where pincode is not starting with "5" --

-- Solution -- 

SELECT OI.ORDER_ID,ONLC.CUSTOMER_ID,CONCAT(ONLC.CUSTOMER_FNAME,' ',CUSTOMER_LNAME) AS FULL_NAME,
SUM(OI.PRODUCT_QUANTITY) AS TOTAL_QUANTITY
FROM ORDER_ITEMS OI
INNER JOIN ORDER_HEADER ORDH USING(ORDER_ID)
INNER JOIN ONLINE_CUSTOMER ONLC
USING(CUSTOMER_ID)
INNER JOIN ADDRESS ADR
USING (ADDRESS_ID)
WHERE ORDER_ID % 2 = 0 AND PINCODE NOT LIKE '5%' AND ORDER_STATUS='SHIPPED'
GROUP BY ORDER_ID;

