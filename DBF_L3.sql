--L3-----------------------------
--Show first and last names of the employees as well as the count of orders each of them 
--have received during the year 1997.  
SELECT CONCAT(e.firstname, ' ',e.lastname)
, COUNT(shippeddate) count_of_orders
FROM employees E
JOIN orders O 
ON E.employeeid = O.employeeid
WHERE date_part('YEAR', shippeddate) = 1997
GROUP BY E.employeeid; 

--Show first and last names of the employees as well as the count of their orders 
--shipped after required date during the year 1997. 
SELECT CONCAT(firstname,' ', lastname)
, COUNT(orderid) AS ORDERS_QUANTITY
FROM employees E
JOIN orders O
ON E.employeeid = O.employeeid
WHERE DATE_PART('YEAR', o.shippeddate) = 1997 AND o.shippeddate > o.requireddate
GROUP BY E.employeeid;

--Create a report showing the information about employees and orders, whenever they had orders or not.    
SELECT CONCAT(e.lastname,' ',e.firstname), COUNT(o.orderid) AS ORDERS_QUANTITY
FROM employees E
LEFT JOIN orders O
ON E.employeeid = O.employeeid
GROUP BY CONCAT(e.lastname,' ',e.firstname), E.employeeid
ORDER BY 2;

--Show the list of French customers’ names who used to order non-French products
SELECT c.companyname, c.country, s.country product_origin, COUNT(*) Amountoforders
FROM customers c 
JOIN orders o ON o.customerid = c.customerid
JOIN suppliers s ON o.customerid = c.customerid
WHERE s.country NOT LIKE ('France') AND c.country LIKE ('France')
GROUP BY c.companyname, c.country, s.country
ORDER BY 4;


--Show the list of suppliers, products and its category
SELECT companyname, productname, categoryid
FROM suppliers S
LEFT JOIN products P
ON P.supplierid = S.supplierid;

--Create a report that shows all  information about suppliers and products
SELECT *
FROM suppliers S
LEFT JOIN products P
ON p.supplierid = s.supplierid;

--Show the list of French customers’ names who are working in the same cities.
SELECT e1.companyname AS French_Customer
, e1.city
, e2.country
from customers e1, customers e2
WHERE e1.companyname <> e2.companyname
AND e1.city = e2.city AND e1.country LIKE 'France';

--Show the list of German suppliers’ names who are not working in the same cities.
SELECT DISTINCT e1.companyname AS supplier_name_1
, e2.country
from suppliers e1, suppliers e2
WHERE e1.city != e2.city AND e1.country LIKE 'Germany' AND e2.country LIKE 'Germany'
ORDER BY 1;

--Show the count of orders made by each customer from France.
SELECT c.companyname, c.country, COUNT(orderid) orders_amount
FROM customers c
JOIN orders o ON o.customerid = c.customerid
WHERE country IN ('France')
GROUP BY c.companyname, c.country
ORDER BY 3;

--Show the list of French customers’ names who have made more than 5 orders.
SELECT c.companyname, c.country, COUNT(orderid) amountoforders
FROM customers c
JOIN orders o 
ON o.customerid = c.customerid
WHERE country IN ('France')
GROUP BY c.companyname, c.country
HAVING COUNT(orderid) > 5
ORDER BY 3;

--Show the list of customers’ names who used to order the ‘Tofu’ product.
SELECT DISTINCT c.companyname, p.productname ordered_product
FROM customers c
INNER JOIN orders o ON o.customerid = c.customerid
INNER JOIN products p ON c.customerid = o.customerid
WHERE p.productname = 'Tofu'
ORDER BY 1;

--Show the list of French customers’ names who used to order non-French products.
SELECT c.companyname, c.country, s.country product_origin
FROM customers c 
JOIN orders o ON o.customerid = c.customerid
JOIN suppliers s ON o.customerid = c.customerid
WHERE s.country NOT IN ('France') AND c.country IN ('France')
GROUP BY c.companyname, c.country, s.country
ORDER BY 3;

--Show the list of French customers’ names who used to order French products.
SELECT c.companyname, c.country, s.country product_origin
FROM customers c 
JOIN orders o ON o.customerid = c.customerid
JOIN suppliers s ON o.customerid = c.customerid
WHERE s.country IN ('France') AND c.country IN ('France')
GROUP BY c.companyname, c.country, s.country
ORDER BY 3;

--Show the total ordering sum calculated for each country of customer - which one is good?
SELECT c.companyname, c.country customer_country, COUNT(orderid) ordering_sum
FROM customers c
JOIN orders o ON o.customerid = c.customerid
GROUP BY c.country, c.companyname
ORDER BY 1;

SELECT c.companyname, c.country customer_country, COUNT(orderid) ordering_sum
FROM customers c
JOIN orders o ON o.customerid = c.customerid
JOIN suppliers s ON o.customerid = c.customerid
GROUP BY c.country, c.companyname
ORDER BY 1;

--Show the total ordering sums calculated for each customer’s country for domestic 
--and non-domestic products separately (e.g.: “France – French products ordered
--– Non-french products ordered” and so on for each country).
SELECT c.companyname, c.country customer_country, s.country product_country, 'Domestic' product
, COUNT(orderid) ordering_sum
FROM customers c
JOIN orders o ON o.customerid = c.customerid
JOIN suppliers s ON o.customerid = c.customerid
WHERE c.country = s.country
GROUP BY c.country, c.companyname, s.country
UNION ALL
SELECT c.companyname, c.country customer_country, s.country product_country, 'Non Domestic'
, COUNT(orderid) ordering_sum
FROM customers c
JOIN orders o ON o.customerid = c.customerid
JOIN suppliers s ON o.customerid = c.customerid
WHERE c.country <> s.country
GROUP BY c.country, c.companyname, s.country
ORDER BY 2,4;

--Show the list of product categories(???) along with total ordering sums calculated
--for the orders made for the products of each category, during the year 1997.
SELECT p.categoryid product_category, COUNT(orderid) ordering_sum
FROM products p
JOIN categories c ON c.categoryid = p.categoryid
JOIN orders o ON c.categoryid = p.categoryid
WHERE DATE_PART('YEAR', o.orderdate) = 1997
GROUP BY p.categoryid
ORDER BY 1;

--Show the list of product names along with unit prices and the history of unit prices 
--taken from the orders (show ‘Product name – Unit price – Historical price’). 
--The duplicate records should be eliminated. If no orders were made for a certain product, 
--then the result for this product should look like ‘Product name – Unit price – NULL’. 
--Sort the list by the product name.
SELECT p.productname, p.unitprice Unit_Price, od.unitprice Historical_price, COUNT(od.orderid)
FROM products p
LEFT JOIN order_details od ON od.productid = p.productid
WHERE od.unitprice <> p.unitprice 
GROUP BY p.productname, p.unitprice, od.unitprice
ORDER BY 1






