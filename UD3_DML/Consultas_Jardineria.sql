USE jardineria;
SELECT *
FROM oficina o;

SELECT *
FROM empleado e ;

SELECT *
FROM cliente c;

/*
1.1.4 CONSULTAS DE UNA TABLAS 
 */
-- 1.1.4.1 Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

SELECT o.codigo_oficina, o.ciudad 
FROM oficina o;

-- 1.1.4.2 Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

SELECT o.ciudad, o.telefono 
FROM oficina o
WHERE pais = 'España';

-- 1.1.4.3 Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.

SELECT e.nombre, e.apellido1, e.apellido2, e.email 
FROM empleado e 
WHERE codigo_jefe = 7;

-- 1.1.4.4 Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.

SELECT e.puesto, e.nombre, e.apellido1, e.apellido2, e.email 
FROM empleado e
WHERE codigo_jefe IS NULL;

-- 1.1.4.5 Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.

SELECT e.nombre, e.apellido1, e.apellido2, e.puesto 
FROM empleado e 
WHERE e.puesto <> ('Representante Ventas');

SELECT e.nombre, e.apellido1, e.apellido2, e.puesto 
FROM empleado e 
WHERE e.puesto NOT IN ('Representante Ventas')


-- 1.1.4.6 Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT c.nombre_cliente 
FROM cliente c 
WHERE c.pais = 'Spain';

-- 1.1.4. Devuelve un listado con los distintos estados por los que puede pasar un pedido.

SELECT DISTINCT p.estado 
FROM pedido p 

-- 1.1.4.8 Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. 
-- Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:

	-- Utilizando la función YEAR de MySQL.
select *
FROM pago p 

SELECT DISTINCT p.codigo_cliente
FROM pago p
WHERE YEAR(fecha_pago) = 2008;

	-- Utilizando la función DATE_FORMAT de MySQL. Permite sacar de la fecha un formato concreto

SELECT DISTINCT p.codigo_cliente 
FROM pago p 
WHERE DATE_FORMAT(fecha_pago, "%Y") = 2008;

	-- Sin utilizar ninguna de las funciones anteriores.

SELECT DISTINCT p.codigo_cliente 
FROM pago p 
WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31';

SELECT DISTINCT p.codigo_cliente 
FROM pago p 
WHERE fecha_pago LIKE '2008-__-__';

SELECT DISTINCT p.codigo_cliente 
FROM pago p 
WHERE fecha_pago LIKE '2008%';

-- 1.1.4.9 Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los 
-- pedidos que no han sido entregados a tiempo.

SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega, p.comentarios 
FROM pedido p 
WHERE comentarios LIKE '%tarde%';

-- 1.1.4.10 Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos 
-- cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.

SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega, p.comentarios 
FROM pedido p 
WHERE comentarios LIKE '%antes%';

	-- Utilizando la función ADDDATE de MySQL.
	
SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega,  ADDDATE(fecha_esperada, INTERVAL -2 DAY)
FROM pedido p 
WHERE fecha_entrega <= (ADDDATE(fecha_esperada,  -2 )); -- con un más delante te suma días. 

	 -- Utilizando la función DATEDIFF de MySQL.

SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega
FROM pedido p 
WHERE DATEDIFF(fecha_esperada , fecha_entrega) >= 2;

	 -- ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?

/*
 * SI, porque convierte las fechas en números  y le resta los valores y si es menor o igual a 2, entonces funciona.
 * Pero en general no, porque no expresa la diferencia de dias. 
 */

-- 1.1.4.11 Devuelve un listado de todos los pedidos que fueron rechazados en 2009.

SELECT p.codigo_pedido, p.estado, p.fecha_pedido 
FROM pedido p 
WHERE estado = 'Rechazado' AND YEAR(fecha_pedido) = 2009;


-- 1.1.4.12 Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.

SELECT p.codigo_pedido, p.estado, p.fecha_pedido
FROM pedido p 
WHERE estado = 'Entregado' AND MONTH(fecha_pedido) = 01;

-- 1.1.4.13 Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. 
-- Ordene el resultado de mayor a menor.

SELECT *
FROM pago p
WHERE forma_pago = 'Paypal' AND YEAR(fecha_pago)=2008
ORDER BY total DESC;

-- 1.1.4.14 Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. 
-- Tenga en cuenta que no deben aparecer formas de pago repetidas.

SELECT DISTINCT forma_pago 
FROM pago p 

-- 1.1.4.15 Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 
-- 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer 
-- lugar los de mayor precio.

SELECT *
FROM producto p 
WHERE gama = 'Ornamentales' AND cantidad_en_stock > 100 
ORDER BY precio_venta DESC;

-- 1.1.4.16 Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante 
-- de ventas tenga el código de empleado 11 o 30.

SELECT c.nombre_cliente, ciudad, codigo_empleado_rep_ventas 
FROM cliente c 
WHERE ciudad = 'Madrid' AND codigo_empleado_rep_ventas in (11,30)




/*
 * CONSULTAS DOS TABLAS 
 */

-- 1.4.5 Consultas multitabla (Composición interna)
-- Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2. Las consultas con sintaxis de 
-- SQL2 se deben resolver con INNER JOIN y NATURAL JOIN.

-- 1.4.5.1 Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2 
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 1.4.5.2 Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
			
SELECT c.nombre_cliente, e.nombre 
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
WHERE c.codigo_cliente IN (SELECT p.codigo_cliente
							FROM pago p)
			
-- 1.4.5.3 Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.

SELECT c.nombre_cliente, e.nombre 
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
WHERE c.codigo_cliente NOT IN (SELECT p.codigo_cliente
							FROM pago p)

							SELECT *
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
WHERE c.codigo_cliente NOT IN(SELECT DISTINCT p.codigo_cliente 
								FROM pago p)
							
							
-- 1.4.5.4 Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con 
-- la ciudad de la oficina a la que pertenece el representante.

SELECT c.nombre_cliente, e.nombre, o.ciudad  
FROM cliente c INNER JOIN empleado e 
			ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
			INNER JOIN oficina o 
			ON e.codigo_oficina = o.codigo_oficina 
WHERE c.codigo_cliente IN (SELECT p.codigo_cliente 
							FROM pago p)


-- 1.4.5.5 Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con 
-- la ciudad de la oficina a la que pertenece el representante.
							
SELECT c.nombre_cliente, e.nombre, o.ciudad  
FROM cliente c INNER JOIN empleado e 
			ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
			INNER JOIN oficina o 
			ON e.codigo_oficina = o.codigo_oficina 
WHERE c.codigo_cliente NOT IN (SELECT p.codigo_cliente 
							FROM pago p)							
							
-- 1.4.5.6 Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
							
SELECT c.nombre_cliente, o.linea_direccion1, o.linea_direccion2
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
				INNER JOIN oficina o 
				ON e.codigo_oficina = o.codigo_oficina 
WHERE c.nombre_cliente IN (SELECT DISTINCT c2.nombre_cliente 
						FROM cliente c2 
						WHERE c2.ciudad = 'Fuenlabrada')

							
-- 1.4.5.7 Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina 
-- a la que pertenece el representante.

SELECT c.nombre_cliente, e.nombre AS nombreEmpleado, o.ciudad  AS ciudadOficina
FROM cliente c INNER JOIN empleado e 
			ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
			INNER JOIN oficina o 
			ON e.codigo_oficina = o.codigo_oficina 
			
-- 1.4.5.8 Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes. **** RELACON REFLEXIVA ***

SELECT e.nombre as empleado, e2.nombre as jefe
FROM empleado e LEFT JOIN empleado e2 
				ON e2.codigo_empleado = e.codigo_jefe 
-- En ON indicamos  que el codigo empleado de la T2 sea igual al codigo empleado sea igual al codigo jefe de T1 			

-- 1.4.5.9 Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.

SELECT e.nombre as empleado, e2.nombre as jefe, e3.nombre as  jefeDjefe
FROM empleado e INNER JOIN empleado e2 
					ON e2.codigo_empleado = e.codigo_jefe 
				INNER JOIN empleado e3 
					ON e3.codigo_empleado = e2.codigo_jefe 


-- 1.4.5.10 Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.


		-- considerando que es pasando la fecha de entrega
		SELECT c.nombre_cliente, p.fecha_esperada, p.fecha_entrega 
		FROM cliente c INNER JOIN pedido p 
					ON c.codigo_cliente = p.codigo_cliente 
		WHERE p.fecha_entrega > p.fecha_esperada;

	-- considerando que es ates la fecha de entrega
		SELECT c.nombre_cliente, p.fecha_esperada, p.fecha_entrega 
		FROM cliente c INNER JOIN pedido p 
					ON c.codigo_cliente = p.codigo_cliente 
		WHERE p.fecha_entrega < p.fecha_esperada;

	-- considerando que la fecha de entrega no coincide con la esperada
		SELECT c.nombre_cliente, p.fecha_esperada, p.fecha_entrega 
		FROM cliente c INNER JOIN pedido p 
					ON c.codigo_cliente = p.codigo_cliente 
		WHERE p.fecha_entrega <> p.fecha_esperada;



-- 1.4.5.11 Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
	
SELECT *
FROM producto p 


	
SELECT DISTINCT c.nombre_cliente,  p.gama
FROM producto p INNER JOIN detalle_pedido dp 
						ON p.codigo_producto = dp.codigo_producto 
				INNER JOIN pedido p2 
						ON dp.codigo_pedido = p2.codigo_pedido 
				INNER JOIN cliente c 
						ON p2.codigo_cliente = c.codigo_cliente ;

				-- se puede hacer sin el distinc pero debemos agrupar por ambos para que no se repitan 
				-- EL GROPU BY SOLO SALE SI TENGO EL MISMO NUMERO DE PARÁMETROS (JUNTO CON UN COUNT) QUE EN EL GROUP BY. 	
					
				SELECT  c.nombre_cliente,  p.gama, COUNT(p.gama) 
				FROM producto p INNER JOIN detalle_pedido dp 
						ON p.codigo_producto = dp.codigo_producto 
				INNER JOIN pedido p2 
						ON dp.codigo_pedido = p2.codigo_pedido 
				INNER JOIN cliente c 
						ON p2.codigo_cliente = c.codigo_cliente 
				GROUP  BY c.nombre_cliente, p.gama ;

/*
 * CONSULTAS EXTERNAS
 */
-- 1.4.6 Consultas multitabla (Composición externa)
-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, NATURAL LEFT JOIN y NATURAL RIGHT JOIN.

-- 1.4.6.1 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT  * 
FROM cliente c LEFT JOIN pago p 
				ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL; 


-- 1.4.6.2 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

SELECT *
FROM cliente c LEFT JOIN pedido p 
				ON c.codigo_cliente = p.codigo_pedido
WHERE p.codigo_cliente IS NULL;


-- 1.4.6.3 Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado 
-- ningún pedido.

SELECT *
FROM cliente c LEFT JOIN pedido p 
					ON c.codigo_cliente = p.codigo_cliente 
			   LEFT JOIN pago p2 
			   		ON c.codigo_cliente = p2.codigo_cliente 
WHERE p.codigo_pedido IS NULL 
	  AND p2.codigo_cliente IS NULL;


-- 1.4.6.4 Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

/*
 * sale vacía dado que el campo oficina en la tablaa empelados es obligatorio
 * que tengaa nu valo [not null - v]
 */ 
SELECT *
FROM empleado e 
WHERE e.codigo_oficina IS NULL
				
-- 1.4.6.5 Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

SELECT e.nombre 
FROM cliente c RIGHT JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.codigo_empleado_rep_ventas IS NULL;


-- 1.4.6.6 Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto 
-- con los datos de la oficina donde trabajan.

SELECT e.nombre,  o.*
FROM cliente c RIGHT JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
				INNER  JOIN oficina o 
				ON e.codigo_oficina =  o.codigo_oficina 
WHERE c.codigo_empleado_rep_ventas IS NULL;


-- 1.4.6.7 Devuelve un listado que muestre los empleados que no tienen una oficina asociada y 
-- los que no tienen un cliente asociado.

SELECT e.*
FROM empleado e INNER JOIN oficina o 
				ON e.codigo_oficina =  o.codigo_oficina 
WHERE e.codigo_oficina IS NULL 
AND
e.codigo_empleado IN (SELECT e2.codigo_empleado 
					  FROM cliente c RIGHT JOIN empleado e2 
					  				ON c.codigo_empleado_rep_ventas = e2.codigo_empleado 
					  WHERE e2.codigo_empleado IS NULL
					 );
					--- SALE VACÍA PORQUE NO PUEDE HABER EMPLEADOS SIN OFCINA


-- 1.4.6.8 Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT p.*
FROM producto p LEFT JOIN detalle_pedido dp 
				ON p.codigo_producto = dp.codigo_producto 
				LEFT JOIN pedido p2 
				ON dp.codigo_pedido =  p2.codigo_pedido
WHERE p2.codigo_pedido IS NULL;


-- 1.4.6.9 Devuelve un listado de los productos que nunca han aparecido en un pedido. ****OJO****
-- El resultado debe mostrar el nombre, la descripción y la imagen del producto.

SELECT DISTINCT p.codigo_producto, p.nombre, gp.descripcion_texto, gp.imagen
FROM producto p LEFT JOIN detalle_pedido dp 
					ON p.codigo_producto = dp.codigo_producto 
				LEFT JOIN pedido p2 
					ON dp.codigo_pedido =  p2.codigo_pedido
				INNER JOIN gama_producto gp 
					ON p.gama =  gp.gama 
WHERE dp.codigo_pedido IS NULL;
				
			-- comentario: si no estas segura pon el/los campos auxiliares que te ayuden a ver lo que buscas
			-- y luego poner la condicion que haga falta para cumplir la condición. 
		
			
-- 1.4.6.10 Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas
--  de algún cliente que haya realizado la compra de algún producto de la gama Frutales. ****OJO***

	SELECT o.*
	FROM oficina o -- LEFT JOIN empleado e 
					-- ON o.codigo_oficina = e.codigo_oficina 
	WHERE o.codigo_oficina NOT IN (SELECT DISTINCT e.codigo_oficina 
			FROM empleado e INNER JOIN cliente c 
							ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
			WHERE c.codigo_cliente  IN (SELECT  c.codigo_cliente 
										FROM cliente c INNER JOIN pedido p 
												ON c.codigo_cliente =  p.codigo_cliente 
										WHERE p.codigo_pedido IN (SELECT dp.codigo_pedido 
																FROM detalle_pedido dp INNER JOIN  producto p2
																						ON dp.codigo_producto = p2.codigo_producto 
																WHERE p2.gama LIKE 'Frutales')) )
			
			-- Seleccion de empleaddos representante de clientes que tiene unpeddod con gama frutales
			
			SELECT DISTINCT e.codigo_oficina 
			FROM empleado e INNER JOIN cliente c 
							ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
			WHERE c.codigo_cliente  IN (SELECT  c.codigo_cliente 
										FROM cliente c INNER JOIN pedido p 
												ON c.codigo_cliente =  p.codigo_cliente 
										WHERE p.codigo_pedido IN (SELECT dp.codigo_pedido 
																FROM detalle_pedido dp INNER JOIN  producto p2
																						ON dp.codigo_producto = p2.codigo_producto 
																WHERE p2.gama LIKE 'Frutales'))
				
			--- seleccon de clientes con pedidos con gama frutales 
			
			SELECT DISTINCT c.codigo_cliente 
			FROM cliente c INNER JOIN pedido p 
							ON c.codigo_cliente =  p.codigo_cliente 
			WHERE p.codigo_pedido IN (SELECT dp.codigo_pedido 
					FROM detalle_pedido dp INNER JOIN  producto p2
											ON dp.codigo_producto = p2.codigo_producto
					WHERE p2.gama LIKE 'Frutales');
					
			-- codigo de los pedidos con gama frutañles								
					SELECT dp.codigo_pedido
					FROM detalle_pedido dp INNER JOIN  producto p2
											ON dp.codigo_producto = p2.codigo_producto
					WHERE p2.gama LIKE 'Frutales';
	
			
				
-- 1.4.6.11 Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
						
SELECT c.nombre_cliente, p.codigo_pedido 
FROM cliente c LEFT JOIN pedido p 
					ON c.codigo_cliente = p.codigo_cliente
			   LEFT JOIN pago p2 
					ON c.codigo_cliente = p2.codigo_cliente
WHERE p.codigo_pedido IS NOT NULL
AND p2.codigo_cliente IS NULL;
/*						
SELECT *
FROM cliente c LEFT JOIN pedido p 
					ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_pedido IS NOT NULL;

			  
SELECT *					
FROM cliente c 	LEFT JOIN pago p2 
					ON c.codigo_cliente = p2.codigo_cliente
WHERE p2.codigo_cliente IS NULL ;
*/
						
-- 1.4.6. 11 Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
SELECT e.nombre, e2.nombre as jefe
FROM cliente c RIGHT JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
				INNER JOIN empleado e2 
				ON e2.codigo_empleado = e.codigo_jefe 
WHERE c.codigo_empleado_rep_ventas IS NULL;




/*
 * CONSULTAS RESUMEN 
 */

-- 1.4.7 Consultas resumen
-- 1.4.7.1 ¿Cuántos empleados hay en la compañía?
SELECT COUNT(e.codigo_empleado) 
FROM empleado e;

-- 1.4.7.2 ¿Cuántos clientes tiene cada país?

SELECT c.pais, COUNT(c.codigo_cliente) 
FROM cliente c 
GROUP BY c.pais;

-- 1.4.7.3 ¿Cuál fue el pago medio en 2009?

SELECT AVG(total) 
FROM pago p 
WHERE YEAR(fecha_pago) = 2009
 
-- 1.4.7.4 ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.

SELECT p. estado, COUNT(codigo_pedido) 
FROM pedido p 
GROUP BY estado 
ORDER BY COUNT(codigo_pedido) DESC; 

-- 1.4.7.5 Calcula el precio de venta del producto más caro y más barato en una misma consulta. ****OJO*****

SELECT p.nombre, MAX(p.precio_venta), MIN(p.precio_venta) 
FROM producto p 
GROUP BY p.precio_venta 
HAVING MAX(p.precio_venta) AND MIN(p.precio_venta);


-- 1.4.7.6 Calcula el número de clientes que tiene la empresa.

SELECT COUNT(c.codigo_cliente) 
FROM cliente c 

-- 1.4.7.7 ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

SELECT c.ciudad , COUNT(c.codigo_cliente) 
FROM cliente c 
WHERE c.ciudad = 'Madrid';

-- 1.4.7.8 ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?

SELECT c.ciudad, COUNT(c.codigo_cliente) 
FROM cliente c 
WHERE c.ciudad LIKE 'M%'
GROUP BY c.ciudad;

-- 1.4.7.9 Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.

SELECT  e.nombre, COUNT(c.codigo_cliente) 
FROM empleado e INNER JOIN cliente c 
				ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
GROUP BY e.nombre;

-- 1.4.7.10 Calcula el número de clientes que no tiene asignado representante de ventas. **** OJO **** 
				
SELECT COUNT(c.codigo_cliente) 
FROM cliente c LEFT JOIN empleado e
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.codigo_empleado_rep_ventas IS NULL;

			-- NO  ES NECESARIO PONER EL LEFT DADO QUE ESTASMIRANDO EL CODIGO REPRESENTANTE DE VENTADS 
			-- QUEE S PROPIO DE LA TABLA CLIENTE. 

-- 1.4.7.11 Calcula la fecha del primer y último pago realizado por cada uno de los clientes. 
-- El listado deberá mostrar el nombre y los apellidos de cada cliente. ****OJO****

SELECT c.nombre_cliente, c.apellido_contacto, min(fecha_pago), max(fecha_pago) 
FROM cliente c INNER JOIN pago p 
				ON c.codigo_cliente  = p.codigo_cliente 
GROUP BY p.codigo_cliente; 

   --- COMENTARIO: Las listas consultas tiene que tener una dependencia con el GROUP BY, si no casca;
  		-- ejm: el c.nom y c.apl tiene una dependedncia con p.cod_cl.


-- 1.4.7.12 Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.

SELECT p2.codigo_pedido, SUM(dp.cantidad) 
FROM producto p INNER JOIN detalle_pedido dp 
					ON p.codigo_producto = dp.codigo_producto 
				INNER JOIN pedido p2 
					ON p2.codigo_pedido = dp.codigo_pedido
GROUP BY p2.codigo_pedido;

SELECT codigo_pedido , cantidad 
FROM  detalle_pedido dp 
ORDER BY dp.codigo_pedido;

-- 1.4.7.13. Calcula el número de productos diferentes que hay en cada uno de los pedidos. ****OJO***

SELECT p2.codigo_pedido, COUNT(p.codigo_producto) 
FROM producto p INNER JOIN detalle_pedido dp 
					ON p.codigo_producto = dp.codigo_producto 
				INNER JOIN pedido p2 
					ON p2.codigo_pedido = dp.codigo_pedido
GROUP BY p2.codigo_pedido
ORDER BY p2.codigo_pedido ASC;

SELECT *
FROM detalle_pedido dp 
					
-- 1.4.7.14 Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. 
-- El listado deberá estar ordenado por el número total de unidades vendidas. ****OJO***

SELECT p.nombre, SUM(dp.cantidad) AS catidad
FROM producto p INNER JOIN detalle_pedido dp 
				ON p.codigo_producto = dp.codigo_producto 
GROUP BY p.nombre 
ORDER BY catidad DESC LIMIT 20;



-- 1.4.7.15 La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA 
-- y el total facturado. La base imponible se calcula sumando el coste del producto por el número de unidades 
-- vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base imponible, y el total la suma de los dos campos 
-- anteriores.

SELECT SUM(baseImponible) AS baseImponible, SUM(baseImponible) * 0.21 AS IVA, 
SUM(baseImponible) + SUM(baseImponible) * 0.21 AS TOTAL
FROM (SELECT (dp.precio_unidad * dp.cantidad)  as baseImponible
	FROM detalle_pedido dp) q_interna;

		--- subconsulta en FROM: obtienes la lista dem la base imponible de cada pedido
		--- conslta principal: obtienes los SELECT que te piden de la subconsultade q_interna (estaseria una nueva tabla).  
		-- se puede cambiar el alias del select por el nombre ded la tabla ya que la tabla q_nterna solo tiene un campo.  

-- 1.4.7.16 La misma información que en la pregunta anterior, pero agrupada por código de producto.

SELECT codigo_producto, baseImponible, baseImponible * 0.21 AS IVA, 
baseImponible + baseImponible * 0.21 AS TOTAL
FROM (SELECT dp.codigo_producto, SUM(dp.precio_unidad * dp.cantidad) as baseImponible
	FROM detalle_pedido dp
	GROUP BY dp.codigo_producto) q_interna;

		-- subconslta: da n alista con el codigo producto y la base imponible de cada produucto (ed ahi el group);
		-- consulta: calcula lo anterior pero por productos dedbiddo a la sbconslta .


-- demostracion de que esta bien la de arriba --NO
SELECT SUM(baseImponible)
FROM
(SELECT codigo_producto, baseImponible , baseImponible * 0.21 AS IVA, 
baseImponible + baseImponible * 0.21 AS TOTAL
FROM (SELECT dp.codigo_producto, SUM(dp.precio_unidad * dp.cantidad) as baseImponible
	FROM detalle_pedido dp
	GROUP BY dp.codigo_producto ) q_interna ) q_interna2

-- 1.4.7.17 La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por 
-- los códigos que empiecen por OR.

SELECT codigo_producto, baseImponible AS baseImponible, baseImponible * 0.21 AS IVA, 
baseImponible + baseImponible * 0.21 AS TOTAL
FROM
(SELECT dp.codigo_producto, SUM(dp.precio_unidad * dp.cantidad) as baseImponible
	FROM detalle_pedido dp
	WHERE dp.codigo_producto LIKE 'OR%'
	GROUP BY dp.codigo_producto
) q_interna

-- 1.4.7.18 Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre,
-- unidades vendidas, total facturado y total facturado con impuestos (21% IVA).

SELECT * 
FROM (SELECT prod.nombre, SUM(dp.cantidad) AS unidadeds_vendidas, SUM(dp.precio_unidad) * SUM(dp.cantidad) AS total_facturado
, (SUM(dp.precio_unidad) * SUM(dp.cantidad) + SUM(dp.precio_unidad) * SUM(dp.cantidad) *0.21) AS total_con_impuestos
FROM producto prod INNER JOIN detalle_pedido dp
					ON prod.codigo_producto = dp.codigo_producto
GROUP BY prod.nombre ) q_interna	
WHERE q_interna.total_facturado > 3000

		-- Subconsulta: obtiene lo que se pide agrgupadop por el producto. 
		-- consulta: selecionas de la subconulta (q-nterna) los que tengan unafactuuracion de mas de 3000

-- 1.4.7.19 Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.

SELECT YEAR(fecha_pago), SUM(p.total) 
FROM pago p
GROUP BY YEAR (fecha_pago)






SELECT *
FROM cliente c;

-- 1.4.8 Subconsultas https://www.coursehero.com/file/86171458/subconsultasdocx/
-- 1.4.8.1 Con operadores básicos de comparación

-- Devuelve el nombre del cliente con mayor límite de crédito.

SELECT c.nombre_cliente, c.limite_credito 
FROM cliente c
WHERE c.limite_credito = (SELECT MAX(c2.limite_credito) 
						  FROM cliente c2);

-- 1.4.8.1.1 Devuelve el nombre del producto que tenga el precio de venta más caro.
						 
SELECT p.nombre, p.precio_venta 
FROM producto p 
WHERE p.precio_venta = (SELECT MAX(p2.precio_venta)
						FROM producto p2)
						 
-- 1.4.8.1.2 Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular
-- cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla 
-- detalle_pedido)

SELECT p.nombre, dp.cantidad 
FROM producto p INNER JOIN detalle_pedido dp
				ON p.codigo_producto=dp.codigo_producto 
WHERE cantidad =(SELECT MAX(dp2.cantidad) from detalle_pedido dp2)

						
-- 1.4.8.1.3 Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
-- OJO --
SELECT c.nombre_cliente, c.limite_credito, q_interna.total
FROM cliente c,
	(SELECT p.codigo_cliente, SUM(p.total) as total
							FROM pago p 
							GROUP BY p.codigo_cliente) q_interna
WHERE c.limite_credito > q_interna.total
AND c.codigo_cliente  = q_interna.codigo_cliente ;
						  
			-- subconsultaFROM q_interna: saca una lista de los clientes con el total que ha pagado
				-- (la suma de toddos los totales de cada pediido).
			-- relaciones de la tabla cliente con la tabla resuultado de mi sbconsulta.

-- 1.4.8.1.4 Devuelve el producto que más unidades tiene en stock.
					
SELECT p.nombre, p.cantidad_en_stock 
FROM producto p 
WHERE p.cantidad_en_stock = (SELECT MAX(cantidad_en_stock) 
							FROM producto p2);
		-- Sale más de uno porque todos tiene la misma cantidad máxima. 
						  
-- 1.4.8.1.5 Devuelve el producto que menos unidades tiene en stock.
						
SELECT p.nombre, p.cantidad_en_stock 
FROM producto p 
WHERE p.cantidad_en_stock = (SELECT MIN(cantidad_en_stock) 
							FROM producto p2);
						
-- 1.4.8.1.6 Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.

SELECT e.nombre, e.apellido1, e.apellido2, e.email 
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas =  e.codigo_empleado 
WHERE e.nombre = (SELECT e.nombre
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas =  e.codigo_empleado 
WHERE c.nombre_cliente LIKE 'Alberto Soria');

SELECT *
FROM cliente c 


-- 1.4.8.2 Subconsultas con ALL y ANY
-- 1.4.8.2.1 Devuelve el nombre del cliente con mayor límite de crédito.

SELECT c.nombre_cliente 
FROM cliente c 
WHERE c.limite_credito >= ALL (SELECT limite_credito 
								FROM cliente c2)
		-- *EXPLICACION: estamos indicando que el limite_credito sea el máximo de los limite_credto

-- 1.4.8.2.2 Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT p.nombre 
FROM producto p 
WHERE p.precio_venta >= ALL (SELECT p2.precio_venta 
							FROM producto p2)
								
-- 1.4.8.2.3 Devuelve el producto que menos unidades tiene en stock.

SELECT p.nombre 
FROM producto p 
WHERE p.cantidad_en_stock <= ALL (SELECT p2.cantidad_en_stock 
									FROM producto p2)


									
-- 1.4.8.3 Subconsultas con IN y NOT IN
-- 1.4.8.3.1 Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
									
SELECT e.nombre, e.apellido1, e.apellido2, e.puesto 
FROM empleado e 
WHERE e.codigo_empleado NOT IN (SELECT c.codigo_empleado_rep_ventas 
								FROM cliente c)
									
-- 1.4.8.3.2 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT c.nombre_cliente, c.codigo_cliente 
FROM cliente c 
WHERE c.codigo_cliente IN (SELECT c.codigo_cliente 
								FROM pago p
							WHERE c.codigo_cliente IS NULL)
							
-- definicion: donde el c.cliente sea nuelo en la tabla pago

SELECT *
FROM pago p 
							
-- 1.4.8.3.3 Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
							
SELECT c.nombre_cliente, c.codigo_cliente 
FROM cliente c 
WHERE c.codigo_cliente NOT IN (SELECT c.codigo_cliente 
								FROM pago p
							WHERE c.codigo_cliente IS NULL)
							
-- 1.4.8.3.4 Devuelve un listado de los productos que nunca han aparecido en un pedido.
							
SELECT p.*
FROM producto p
WHERE p.codigo_producto NOT IN (SELECT dp.codigo_producto 
								FROM detalle_pedido dp
								WHERE dp.codigo_producto IS NOT NULL);
 -- quue el codgo producto no este en los codgod pedido de la table detalle_pedido donde el codgo no sea nulo
 -- (quee sten en peddo)							-- 							

							
-- 1.4.8.3.5 Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean 
-- representante de ventas de ningún cliente.
								
SELECT e.nombre, e.apellido1, e.apellido2, e.puesto, o.telefono 
FROM oficina o INNER JOIN empleado e 
				ON o.codigo_oficina = e.codigo_oficina 
WHERE e.codigo_empleado IN (SELECT e2.codigo_empleado 
								FROM empleado e2 LEFT JOIN cliente c 
												ON e2.codigo_empleado = c.codigo_empleado_rep_ventas 
								WHERE c.codigo_empleado_rep_ventas IS NULL)
ORDER BY e.codigo_empleado ASC;	
							
								
-- 1.4.8.3.6 Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido 
-- los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

SELECT DISTINCT e.codigo_oficina 
FROM empleado e 
WHERE e.codigo_oficina NOT IN (SELECT e.codigo_oficina 
							   FROM empleado e INNER JOIN  cliente c 
											   ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
							   WHERE c.codigo_cliente IN  (SELECT p.codigo_cliente 
						  								  FROM pedido p INNER JOIN detalle_pedido dp 
			  															ON p.codigo_pedido = dp.codigo_pedido 
						  		 						  WHERE p.codigo_pedido IN (SELECT dp.codigo_pedido 
						  											FROM detalle_pedido dp INNER JOIN producto p 
												 						ON dp.codigo_producto = p.codigo_producto 
						   											WHERE p.gama LIKE 'Frutales')))
							
			   		
-- selecciones los  detaalles  pedido con  gama frutales
SELECT dp.codigo_pedido 
FROM detalle_pedido dp INNER JOIN producto p 
						ON dp.codigo_producto = p.codigo_producto 
WHERE p.gama LIKE 'Frutales';

-- seleccion los pedidos con ese detalle_pedido

SELECT p.codigo_cliente 
FROM pedido p INNER JOIN detalle_pedido dp 
			  ON p.codigo_pedido = dp.codigo_pedido 
WHERE p.codigo_pedido IN (SELECT dp.codigo_pedido 
						  FROM detalle_pedido dp INNER JOIN producto p 
												 ON dp.codigo_producto = p.codigo_producto 
						   WHERE p.gama LIKE 'Frutales');		
						  
-- 	seleccion de empleados que sean representantes de ventas de clientes que cumplan los requisitos anteriores

SELECT e.codigo_empleado 
FROM empleado e INNER JOIN  cliente c 
				ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
WHERE c.codigo_cliente IN (SELECT p.codigo_cliente 
						   FROM pedido p INNER JOIN detalle_pedido dp 
			  								ON p.codigo_pedido = dp.codigo_pedido 
						   WHERE p.codigo_pedido IN (SELECT dp.codigo_pedido 
						  							FROM detalle_pedido dp INNER JOIN producto p 
												 							ON dp.codigo_producto = p.codigo_producto 
						   							WHERE p.gama LIKE 'Frutales'));
						   						
-- seleccion de las oficinas que no tienen empleados con los requsitos antteroes : SOLUCION ****OJO***
						   						
SELECT e.codigo_oficina 
FROM empleado e 
WHERE e.codigo_oficina NOT IN (SELECT e.codigo_oficina 
							   FROM empleado e INNER JOIN  cliente c 
											   ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
							   WHERE c.codigo_cliente IN  (SELECT p.codigo_cliente 
						  								  FROM pedido p INNER JOIN detalle_pedido dp 
			  															ON p.codigo_pedido = dp.codigo_pedido 
						  		 						  WHERE p.codigo_pedido IN (SELECT dp.codigo_pedido 
						  											FROM detalle_pedido dp INNER JOIN producto p 
												 						ON dp.codigo_producto = p.codigo_producto 
						   											WHERE p.gama LIKE 'Frutales')))
							
-- 1.4.8.3.7 Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

SELECT c.*
FROM cliente c 
WHERE c.codigo_cliente IN (SELECT p.codigo_cliente 
							FROM pago p
							WHERE p.codigo_cliente IS not NULL)
						   											
						   											
-- 1.4.8.4 Subconsultas con EXISTS y NOT EXISTS
-- 1.4.8.4.1 Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT *
FROM cliente c 
WHERE NOT EXISTS (SELECT p.codigo_cliente 
				 FROM pago p
				 WHERE c.codigo_cliente = p.codigo_cliente);
							
-- 1.4.8.4.2 Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
				
SELECT *
FROM cliente c
WHERE EXISTS (SELECT p.codigo_cliente 
			FROM pago p
			WHERE p.codigo_cliente = c.codigo_cliente)
				 
-- 1.4.8.4.3 Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT *
FROM producto p 
WHERE NOT EXISTS (SELECT dp.codigo_producto
				 FROM detalle_pedido dp 
				 WHERE dp.codigo_producto = p.codigo_producto)
			
-- 1.4.8.4.4 Devuelve un listado de los productos que han aparecido en un pedido alguna vez.

SELECT *
FROM producto p 
WHERE EXISTS (SELECT dp.codigo_producto 
			  FROM detalle_pedido dp
			  WHERE dp.codigo_producto = p.codigo_producto)
			  
				 
-- 1.4.9 Consultas variadas
-- 1.4.9.1 Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. 
-- Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.
			  
SELECT c.nombre_cliente, COUNT(p.codigo_pedido) 
FROM cliente c LEFT JOIN pedido p 
				ON c.codigo_cliente = p.codigo_cliente 
GROUP BY c.nombre_cliente;
			  
			  
-- 1.4.9.2 Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. 
-- Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.

SELECT c.nombre_cliente, SUM(p.total) 
FROM cliente c LEFT JOIN pago p
				ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente
ORDER BY  SUM(p.total) ASC;


-- 1.4.9.3 Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados 
-- alfabéticamente de menor a mayor. --- si que remos que parezacn solo losnombe sin tenerr encuenta 
-- cuantas veces ha hecho en el año 2008

SELECT DISTINCT c.nombre_cliente
FROM cliente c INNER JOIN  pedido p 
				ON c.codigo_cliente = p.codigo_cliente 
WHERE YEAR(p.fecha_pedido) = 2008
ORDER BY c.nombre_cliente ASC;

-- 1.4.9.4 Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas 
-- y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan 
-- realizado ningún pago.

SELECT  c.nombre_cliente, e.nombre, e.apellido1, o.telefono 
FROM cliente c INNER JOIN empleado e 
				ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
				INNER JOIN oficina o 
				ON e.codigo_oficina  = o.codigo_oficina 
WHERE NOT EXISTS (SELECT p.codigo_cliente 
				 FROM pago p
				 WHERE c.codigo_cliente = p.codigo_cliente);
			

-- 1.4.9.5 Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y 
-- primer apellido de su representante de ventas y la ciudad donde está su oficina.
				
SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
FROM cliente c INNER JOIN empleado e 	
					ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
			   INNER JOIN oficina o 
			   		ON e.codigo_oficina = o.codigo_oficina;
				
-- 1.4.9.6 Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados 
-- que no sean representante de ventas de ningún cliente.
			   	
	SELECT e.nombre, e.apellido1, e.apellido2, e.puesto, o.telefono 
	FROM empleado e INNER JOIN oficina o 
					ON e.codigo_oficina = o.codigo_oficina 
	WHERE e.codigo_empleado IN (SELECT e.codigo_empleado 
								FROM cliente c RIGHT JOIN empleado e 
													ON c.codigo_empleado_rep_ventas = e.codigo_empleado
								WHERE c.codigo_empleado_rep_ventas IS NULL);
			   	
			--- empleados de que no son representante de ventas
			
			SELECT e.codigo_empleado 
			FROM cliente c RIGHT JOIN empleado e 
							ON c.codigo_empleado_rep_ventas = e.codigo_empleado
			WHERE c.codigo_empleado_rep_ventas IS NULL;
			
-- 1.4.9.7 Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.
		
SELECT o.ciudad, COUNT(e.codigo_empleado) 
FROM oficina o LEFT JOIN empleado e 
				ON o.codigo_oficina = e.codigo_oficina 
GROUP BY o.ciudad;


