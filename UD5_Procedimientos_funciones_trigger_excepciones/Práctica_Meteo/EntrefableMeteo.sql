CREATE DATABASE meteo;
USE meteo ;

/*
 * 1. Crear la tabla TIEMPO en la base de datos atendiendo al esquema relacional anterior; 
 * considerando el atributo fecha como clave primaria. El resto de los atributos no admiten valores nulos.
 */

CREATE TABLE tiempo(
	fecha DATE,
	dia INT NOT NULL,
	dia_Semana VARCHAR(10) NOT NULL,
	mes VARCHAR(10) NOT NULL,
	cuarto VARCHAR(2) NOT NULL,
	anyo INT NOT NULL,
	PRIMARY KEY (fecha)
);

/*
 * 2. Crear una función que dado un entero obtenga en formato de texto el correspondiente mes.
*/

DELIMITER $$
CREATE FUNCTION f_convertir_mes (mes INTEGER )
RETURNS VARCHAR(10) DETERMINISTIC 
    COMMENT 'Devuelve el nombre del mes que corresponde con su numero de mes'
BEGIN
	DECLARE name_mes varchar(10);		

	CASE mes
		WHEN 1 THEN SET name_mes = 'Enero';
		WHEN 2 THEN	SET name_mes = 'Febrero';
		WHEN 3 THEN SET name_mes = 'Marzo';
		WHEN 4 THEN SET name_mes = 'Abril';
		WHEN 5 THEN SET name_mes = 'Mayo';
		WHEN 6 THEN SET name_mes = 'Junio';
		WHEN 7 THEN SET name_mes = 'Julio';
		WHEN 8 THEN SET name_mes = 'Agosto';
		WHEN 9 THEN SET name_mes = 'Septiembre';
		WHEN 10 THEN SET name_mes = 'Octubre';
		WHEN 11 THEN SET name_mes = 'Noviembre';
		WHEN 12 THEN SET name_mes = 'Diciembre';
	END CASE;
	
	RETURN name_mes;
END $$
DELIMITER ;

SELECT f_convertir_mes(2);


/*
 * 3. Crear un procedimiento almacenado que recibiendo un rango de fechas introduzca en la tabla de 
 * TIEMPO una tupla por cada día comprendido entre ambas fechas. Ejecutar el procedimiento creado para 
 * que genere las tuplas correspondientes a los años 2020 y 2021.
*/

DELIMITER $$
CREATE PROCEDURE p_add_fechas(fechaIn DATE, fechaFin DATE)
BEGIN
	DECLARE dia int DEFAULT 1;
	DECLARE diaSemana VARCHAR(10) DEFAULT '';
	DECLARE mes VARCHAR(10) DEFAULT '';
	DECLARE cuarto VARCHAR(2) DEFAULT '';
	DECLARE anyo INT DEFAULT 0;
	
	WHILE fechaIn <= fechaFin DO
		
		SET dia = DAY(fechaIN);
		SET diaSemana = DAYNAME(fechaIN);
		SET mes = MONTHNAME(fechaIN); 
		SET cuarto = CONCAT('Q', QUARTER(fechaIN));
		SET anyo = YEAR(fechaIN);
	
		INSERT INTO tiempo VALUES (fechaIn, dia, diaSemana, mes, cuarto, anyo);
		
		SET fechaIn = ADDDATE(fechaIn,1);
	END WHILE;
END$$
DELIMITER ;

CALL p_add_fechas('2020-01-01', '2021-12-31');

/*
 * 4.Crear la tabla VENTA atendiendo al esquema relacional anterior; considerando el atributo id_venta 
 * como clave primaria. El resto de los atributos de la relación no pueden tomar valor nulo.
 * Realizar carga masiva con la tabla proporcionada ventas.csv
*/

CREATE TABLE venta(
	id_venta INT AUTO_INCREMENT,
	fecha DATE NOT NULL,
	producto VARCHAR(200) NOT NULL,
	unidades_vendidas INT NOT NULL,
	precio_unitario DECIMAL(5,2) NULL, 
	PRIMARY KEY (id_venta)
);

ALTER TABLE venta ADD CONSTRAINT fk_fecha_venta FOREIGN KEY (fecha) REFERENCES tiempo (fecha);

/*
 * Crear un procedimiento “Mostrar_ Estadísticas” que genere la siguiente información, 
 * considerando que la mayor venta se refiere a las ventas con mayor valor económico, 
 * no con mayor número de unidades vendidas:

Valor total de las ventas:
Valor total de las ventas en 2020:
Valor total de las ventas en 2021:
Listado ordenado de las ventas por día de la semana
Listado ordenado de las ventas por mes del año
Listado ordenado de la ventas por cuarto del año:
 */

-- cosulta de ventas totales

SELECT SUM(v.unidades_vendidas*precio_unitario)  
FROM venta v; 

-- consultas de ventas por año 2020

SELECT YEAR(fecha), SUM(unidades_vendidas*precio_unitario)  
FROM venta v
GROUP BY YEAR(fecha); 

-- consulta de ventas por dias ordenados de mayor a menor

SELECT DAYNAME(fecha), SUM(unidades_vendidas*precio_unitario) 
FROM venta v 
GROUP BY DAYNAME(fecha)
ORDER BY SUM(unidades_vendidas*precio_unitario) DESC;

-- consulta de ventas por meses ordenados de mayor a menor

SELECT MONTHNAME(fecha), SUM(unidades_vendidas*precio_unitario) 
FROM venta v 
GROUP BY MONTHNAME(fecha)
ORDER BY SUM(unidades_vendidas*precio_unitario) DESC;

-- consulta de ventas por cuartos ordenados de mayor a menor

SELECT CONCAT('Q',QUARTER(fecha)) , SUM(unidades_vendidas*precio_unitario) 
FROM venta v 
GROUP BY CONCAT('Q',QUARTER(fecha))
ORDER BY SUM(unidades_vendidas*precio_unitario) DESC;

DELIMITER $$
CREATE PROCEDURE p_Mostrar_Estadisticas()
BEGIN
	DECLARE v_salida VARCHAR(16000) DEFAULT '============ESTADISTICAS===========
	\n----------------Totales------------\nVentas Totales: ';
	DECLARE v_total DECIMAL(8,2) DEFAULT 0;
	DECLARE v_anyo INT DEFAULT 2020;
	DECLARE v_dia VARCHAR(10) DEFAULT '';
	DECLARE v_mes VARCHAR(10) DEFAULT '';
	DECLARE v_cuarto VARCHAR(2) DEFAULT '';
	DECLARE v_n INT DEFAULT 1;
	DECLARE done BOOL DEFAULT FALSE;

	-- cursor años
	DECLARE c1 CURSOR FOR
	SELECT YEAR(fecha), SUM(unidades_vendidas*precio_unitario)  
	FROM venta v
	GROUP BY YEAR(fecha); 

	-- cursor día semana
	DECLARE c2 CURSOR FOR
	SELECT DAYNAME(fecha), SUM(unidades_vendidas*precio_unitario) 
	FROM venta v 
	GROUP BY DAYNAME(fecha)
	ORDER BY SUM(unidades_vendidas*precio_unitario) DESC;	
	
	-- cursor meses
	DECLARE c3 CURSOR FOR
	SELECT MONTHNAME(fecha), SUM(unidades_vendidas*precio_unitario) 
	FROM venta v 
	GROUP BY MONTHNAME(fecha)
	ORDER BY SUM(unidades_vendidas*precio_unitario) DESC;

	-- cursos cuartos
	DECLARE c4 CURSOR FOR
	SELECT CONCAT('Q',QUARTER(fecha)), SUM(unidades_vendidas*precio_unitario) 
	FROM venta v 
	GROUP BY CONCAT('Q',QUARTER(fecha))
	ORDER BY SUM(unidades_vendidas*precio_unitario) DESC;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	SELECT SUM(v.unidades_vendidas*precio_unitario) INTO v_total
	FROM venta v; 

	SET v_salida = CONCAT(v_salida,v_total,'€\n==============LISTADOS=============\n--------- Ventas por años ----------\n');
	
	-- recorremo los cursores y vamos concatenando con la v_salida
	OPEN c1;
		WHILE (NOT done) DO
			FETCH c1 INTO v_anyo, v_total;
			IF (NOT done) THEN
				SET v_salida = CONCAT(v_salida,'En ',v_anyo,': ',v_total,'€\n');
			END IF;
		END WHILE;
	CLOSE c1;
	SET v_salida = CONCAT(v_salida,'\n--------- Ventas por dias ----------\n');
	OPEN c2;
		SET done = FALSE;
		WHILE (NOT done) DO
			FETCH c2 INTO v_dia, v_total;
			IF (NOT done) THEN
				SET v_salida = CONCAT(v_salida,v_n,'. ',v_dia,': ',v_total,'€\n');
				SET v_n=v_n+1;
			END IF;
		END WHILE;
	CLOSE c2;
		SET v_salida = CONCAT(v_salida,'\n-------- Ventas por meses ---------\n');
	OPEN c3;
		SET v_n=1;
		SET done = FALSE;
		WHILE (NOT done) DO
			FETCH c3 INTO v_mes, v_total;
			IF (NOT done) THEN
				SET v_salida = CONCAT(v_salida,v_n,'. ',v_mes,': ',v_total,'€\n');
				SET v_n=v_n+1;
			END IF;
		END WHILE;
	CLOSE c3;
	SET v_salida = CONCAT(v_salida,'\n------ Ventas por cuartos -------\n');
	OPEN c4;
		SET v_n=1;
		SET done = FALSE;
		WHILE (NOT done) DO
			FETCH c4 INTO v_cuarto, v_total;
			IF (NOT done) THEN
				SET v_salida = CONCAT(v_salida,v_n,'. ',v_cuarto,': ',v_total,'€\n');
				SET v_n=v_n+1;
			END IF;
		END WHILE;
	CLOSE c4;

	SELECT v_salida;
END$$
DELIMITER ;

CALL p_Mostrar_Estadisticas();
DROP PROCEDURE p_Mostrar_Estadisticas;













