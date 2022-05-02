/*
BLOQUE 1: DISEÑO 

La base de datos Northwind es una base de datos de muestra creada originalmente por Microsoft y utilizada 
como base para sus tutoriales en una variedad de productos de bases de datos durante décadas. Esta base de 
datos contiene los datos de ventas de una empresa ficticia llamada "Northwind Traders", que importa y exporta 
alimentos especiales de todo el mundo. 
*/

CREATE DATABASE northwind;
USE northwind;

/*
1. Realiza el diseño Entidad Relación de esta base de datos teniendo en cuenta lo siguiente:
*/

CREATE TABLE proveedor (
	providerID INT AUTO_INCREMENT,
	nombre VARCHAR(70),
	contacto VARCHAR(50),
	contactTitle VARCHAR(50),
	direccion VARCHAR(100),
	ciudad VARCHAR(50),
	codigo_postal INT,
	tlf_contact VARCHAR(9),
	fax VARCHAR(9),
	PRIMARY KEY (providerID)
);

CREATE TABLE cliente (
	providerID INT AUTO_INCREMENT,
	nombre VARCHAR(70),
	contacto VARCHAR(50),
	contactTitle VARCHAR(50),
	direccion VARCHAR(100),
	ciudad VARCHAR(50),
	codigo_postal INT,
	tlf_contact VARCHAR(9),
	fax VARCHAR(9),
	PRIMARY KEY (providerID)
);

CREATE TABLE empleado (
	empleadoID INT AUTO_INCREMENT,
	nombre VARCHAR(20),
	apellidos VARCHAR(30),
	fecNac DATE,
	telefono VARCHAR(9),
	direccion VARCHAR(40),
	email VARCHAR(20),
	codigo_postal INT,
	responsable INT,
	PRIMARY KEY (empleadoID)
);

ALTER TABLE empleado ADD CONSTRAINT fk_responsable FOREIGN KEY (responsable) REFERENCES empleado (empleadoID);

CREATE TABLE categoria(
	id VARCHAR(4),
	nombre VARCHAR(10),
	descripcion VARCHAR(200),
	PRIMARY KEY (id)
);

CREATE TABLE productos(
	productoID VARCHAR(5),
	precio DECIMAL(10,2) CHECK (precio > 0),
	stock INT UNSIGNED,
	categoria VARCHAR(4),
	proveedor INT,
	PRIMARY KEY (productoID)
);

ALTER TABLE productos  ADD CONSTRAINT fk_categoria FOREIGN KEY (categoria) REFERENCES categoria(id);
ALTER TABLE productos  ADD CONSTRAINT fk_proveedores FOREIGN KEY (proveedor) REFERENCES proveedor(providerID);

CREATE TABLE transportista( 
	nombreCompañia VARCHAR(50) UNIQUE,
	telefono VARCHAR(9),
	PRIMARY KEY(nombreCompañia)
);

CREATE TABLE pedidos(
	productoID VARCHAR(5),
	cantidad INT DEFAULT 0,
	precioTotal DECIMAL(10,2) CHECK 
	descuento DECIMAL(3,2)
	PRIMARY KEY(productoID)
);

CREATE TABLE

-- -------- ACTIVIDADES DE CONSULTAS Y MAS -------  

USE Northwind;

-- 1. Recuperar todas las columnas de la tabla Region

SELECT *
FROM Region r ; 

-- SUBSTRING(p.product_name, 18)

-- 2. Seleccione las columnas Nombre y Apellido de la tabla Empleados.

SELECT LastName, FirstName
FROM Employees;

-- 3. Sleccione las columnas Nombre y Apellido de la tabla Empleados. Ordenar por apellido.

SELECT LastName, FirstName
FROM Employees
ORDER BY LastName;

-- 4. Cree un informe que muestre los pedidos de Northwind ordenados por precio del más caro al más barato. 
-- Muestra ID de pedido, Fecha de pedido, Fecha de envío, ID de cliente.

SELECT o.OrderID, o.OrderDate, o.ShippedDate,ROUND(SUM(od.UnitPrice*od.Quantity*1-od.Discount)) AS total
FROM Orders o INNER JOIN OrderDetails od ON o.OrderID = od.OrderID 
GROUP by o.OrderID 
ORDER BY total DESC;

-- 5. Cree un informe que muestre el cargo y el nombre y apellido de todos los representantes de ventas.

SELECT e.FirstName, e.LastName, e.Title 
FROM Employees e
WHERE e.Title = 'Sales Representative'; 

-- 6. Cree un informe que muestre los nombres y apellidos de todos los empleados que tienen una región especificada.

SELECT e.FirstName , e.LastName, e.Region 
FROM Employees e
WHERE e.Region <> '' OR e.Region IS NULL;


-- 7. Cree un informe que muestre el nombre y apellido de todos los empleados cuyos apellidos comienzan con una 
-- letra en la última mitad del alfabeto (suponer la m tanto mayuscula como  mini). 
-- Ordenar por apellido en orden descendente. 

SELECT e.*
FROM Employees e 
WHERE e.LastName >= 'N'
ORDER BY e.LastName DESC;

-- 8. Cree un informe que muestre el título de cortesía y el nombre y apellido de todos los empleados cuyo título 
-- de cortesía comienza con "M".

SELECT e.TitleOfCourtesy  , e.LastName , e.FirstName 
FROM Employees e 
WHERE e.TitleOfCourtesy LIKE 'M%';

-- 9. Cree un informe que muestre el nombre y apellido de todos los representantes de ventas que son de 
-- Seattle o Redmond.

SELECT e.LastName , e.FirstName 
FROM Employees e 
WHERE e.Title = 'Sales Representative' AND e.City IN('Seattle', 'Redmond');

-- 10. Cree un informe que muestre el nombre de la empresa, el cargo del contacto, la ciudad y 
-- el país de todos clientes en México o en cualquier ciudad de España excepto Madrid. 
-- Si el costo de la mercancía es mayor o igual a $500.00, ahora se gravará con un 10%.
 
SELECT c.CompanyName, c.ContactTitle, c.City, c.Country 
FROM Customers c 
WHERE c.Country = 'Mexico' OR (c.Country='Spain' AND c.City <> 'Madrid');

-- 11. Cree un informe que muestre la identificación del pedido, el costo del envío,
-- el costo de la mercancía con este impuesto para todos los pedidos de $500 o más.

SELECT o.OrderID, o.Freight, ROUND(SUM(od.UnitPrice*od.Quantity*1-od.Discount)) AS total
FROM Orders o INNER JOIN OrderDetails od ON o.OrderID =od.OrderID
GROUP BY o.OrderID
HAVING total >= 500;

-- 12. Encuentre el número total de unidades pedidas del producto ID 3

SELECT COUNT(od.ProductID) AS Cantidad
FROM OrderDetails od 
WHERE od.ProductID = 3
GROUP BY od.ProductID ;

-- 13. Recuperar el número de empleados en cada ciudad.

SELECT e.City, COUNT(e.EmployeeID) AS Cantidad
FROM Employees e 
GROUP BY e.City;

-- 14. Encuentra el número de representantes de ventas en cada ciudad que contiene al menos 2 ventas representantes.
-- Ordenar por número de empleados.

SELECT e.City, COUNT(e.EmployeeID) AS numEmployees
FROM Employees e 
WHERE e.Title = 'Sales Representative'
GROUP BY e.City 
HAVING numEmployees >=2;

-- 15. Encuentre las empresas (el nombre de la empresa) que realizaron pedidos en 1997  
-- Cree un informe que muestre los pedidos de los empleados.

SELECT c.CompanyName, e.FirstName, o.OrderID 
FROM Orders o INNER JOIN Customers c ON o.CustomerID = c.CustomerID 
INNER JOIN Employees e ON o.EmployeeID =e.EmployeeID 
WHERE YEAR(o.OrderDate) = 1997;

-- 16. Cree un informe que muestre el ID del pedido, el nombre de la empresa que realizó el pedido, 
-- y el nombre y apellido del empleado asociado.

SELECT o.OrderID, c.CompanyName, e.LastName, e.FirstName 
FROM Orders o INNER JOIN Customers c ON o.CustomerID = c.CustomerID 
INNER JOIN Employees e ON e.EmployeeID = o.EmployeeID;

-- 17. Mostrar solo los pedidos realizados después del 1 de enero de 1998 que se enviaron después 
-- de que se requerían. Ordenar por nombre de la empresa.

SELECT o.*
FROM Orders o 
WHERE o.OrderDate > '1998-01-01' 
AND o.ShippedDate > o.RequiredDate;

-- 18. Cree un informe que muestre la cantidad total de productos (de la tabla Order_Details) ordenado.
-- Mostrar solo registros de productos para los que la cantidad pedida es inferior a 200.

SELECT od.ProductID, SUM(od.Quantity) AS total
FROM OrderDetails od 
GROUP BY od.ProductID 
HAVING total < 200;

-- 19.Subtotales de pedidos: Para cada pedido, calcula un subtotal para cada pedido (identificado por OrderID). 

SELECT o.OrderID, ROUND(SUM(od.UnitPrice*od.Quantity)) AS TOTAL
FROM Orders o INNER JOIN OrderDetails od ON o.OrderID =od.OrderID 
GROUP BY o.OrderID;

-- 20. Ventas por año

SELECT YEAR(o.OrderDate),COUNT(o.OrderID) 
FROM Orders o 
GROUP BY YEAR(o.OrderDate);

-- 21. Ventas de empleados por país. Para cada empleado, obtenga la cantidad de sus ventas, desglosado por nombre de país.

SELECT e.Country, e.EmployeeID, COUNT(o.OrderID)  
FROM Employees e INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID 
GROUP BY e.Country, e.EmployeeID;

-- 22. Detalles de los pedidos ampliados. Esta consulta calcula el importe de venta de cada pedido después de 
-- aplicar el descuento.

SELECT o.OrderID, ROUND(SUM(od.UnitPrice*od.Quantity*(1-od.Discount))) AS TOTAL
FROM Orders o INNER JOIN OrderDetails od ON o.OrderID =od.OrderID 
GROUP BY o.OrderID 

-- 23. Ventas por categoría. Para cada categoría, obtenemos la lista de productos vendidos y el monto total de ventas

SELECT c.CategoryName, p.ProductName, SUM(od.Quantity) 
FROM Categories c INNER JOIN Products p 
ON c.CategoryID=p.CategoryID
INNER JOIN OrderDetails od ON p.ProductID =od.ProductID
GROUP BY c.CategoryName, p.ProductName ;


-- 24. Función que reciba el id de un pedido (OrderId) y devuelva el total de dicho pedido. Usa la consulta 19

DELIMITER $$
CREATE FUNCTION total_pedido(idPedido int) RETURNS double
DETERMINISTIC
BEGIN
    DECLARE resultado double default 0;
   
   	SELECT ROUND(SUM((od.UnitPrice*od.Quantity)-od.Discount),2) INTO resultado 
   	FROM OrderDetails od
   	WHERE od.OrderID = idPedido; 
   
	RETURN (resultado);
END$$
DELIMITER ;

SELECT total_pedido(10249);

-- 25. Para la OrdenId 10.249 indicar los productos que contiene, la cantidad y el descuento en %. En otra columna, 
-- si hay descuento en un prooducto, porner Descuento, en caso de que no haya descuento poner sin descuentos. 

SELECT p.ProductName, od.Quantity,CONCAT(od.Discount*100,'%') AS descuento, IF(od.Discount>0,"Descuento","Sin descuento") 
FROM OrderDetails od INNER JOIN Products p ON od.ProductID = p.ProductID 
WHERE od.OrderID = 10249;



























