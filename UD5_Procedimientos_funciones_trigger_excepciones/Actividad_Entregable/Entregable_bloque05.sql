CREATE DATABASE entregable;
USE entregable;

CREATE TABLE empleado (
	idEmpleado NUMERIC(6) NOT NULL PRIMARY KEY,
	dni VARCHAR(9) UNIQUE NOT NULL,
	idDepartamento NUMERIC(3) NOT NULL,
	fechaIngreso DATE NOT NULL,
	fNac DATE NOT NULL,
	nombre VARCHAR(40) NOT NULL,
	apellido1 VARCHAR (40) NOT NULL,
	apellido2 VARCHAR (40) NOT NULL,
	salario DECIMAL(6,2) DEFAULT 0 CHECK (salario >= 0) NOT NULL,
	comision DECIMAL (6,2) DEFAULT 0 CHECK (comision  >= 0) NOT NULL
);

ALTER TABLE entregable.empleado ADD CONSTRAINT empleado_FK 
FOREIGN KEY (idDepartamento) REFERENCES entregable.departamento(idDpt)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE hijo (
	padre NUMERIC(6),
	idHijo NUMERIC (2),
	fNac DATE NOT NULL,
	nombre VARCHAR (40) NOT NULL
);

ALTER TABLE hijo ADD CONSTRAINT pk_hijo PRIMARY KEY (padre, idHijo);
ALTER TABLE hijo ADD CONSTRAINT fk_padre FOREIGN KEY (padre) REFERENCES empleado (idEmpleado) 
ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE centro (
	idCentro NUMERIC(2) PRIMARY KEY,
	director NUMERIC(6) NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	direccion VARCHAR (50) NOT NULL,
	poblacion VARCHAR(15)
);

ALTER TABLE centro ADD CONSTRAINT fk_director FOREIGN KEY (director) REFERENCES empleado (idEmpleado)
	ON DELETE CASCADE ON UPDATE CASCADE

CREATE TABLE departamento(
	idDpt NUMERIC (3) PRIMARY KEY,
	director NUMERIC (6),
	idCentro NUMERIC(2),
	nombre VARCHAR(40),
	presupuesto DECIMAL(9,2) CHECK (presupuesto>0) DEFAULT 0,
	director_Tipo ENUM('R1','R2','R3')
);
ALTER TABLE departamento ADD CONSTRAINT fk_dicDpt FOREIGN KEY (director) REFERENCES empleado (idEmpleado)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE departamento ADD CONSTRAINT fk_centro FOREIGN KEY (idCentro) REFERENCES centro (idCentro)
	ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE departamento MODIFY director NUMERIC(6) NOT NULL;



-- 3. Explicamos como subir un CSV para poder subir con carga masiva. 

-- DOCUMENTO WORD


-- 4 Añadir el campo "nempleados" a DEPARTAMENTO. Por defecto, almacenará un valor 0 
-- y deberá tener un valor positivo. Posteriormente, controlaremos el campo para convertirlo
-- en un campo que permita calcular el número de empleados existente en cada departamento.

ALTER TABLE departamento ADD COLUMN nempleados INT UNSIGNED DEFAULT 0;

DELIMITER $$
CREATE PROCEDURE p_numEmpleados()
COMMENT 'Contabilizamos el numero de empleados que tiene cada departamento'
BEGIN
	DECLARE depart INT DEFAULT 1;

	WHILE (depart <=20) DO
		UPDATE departamento d SET d.nempleados = (SELECT COUNT(*)  
												FROM empleado e
												WHERE e.idDepartamento = depart 
												GROUP BY e.idDepartamento) WHERE d.idDpt = depart ;
		SET depart = depart+1;
	END WHILE;
END$$
DELIMITER ;

CALL p_numEmpleados;


SELECT e.idDepartamento, COUNT(*)  
FROM empleado e
GROUP BY e.idDepartamento;


---- FUNCIONES, PROCEDIMIENTOS, TRIGGERS.

/*
 * 1. Función "comprobar_cumple" que reciba como parámetro una fecha y que devuelva TRUE o FALSE si
 *  hoy fuera el cumpleaños de algún empleado nacido en esa fecha.
 */

DELIMITER $$
CREATE FUNCTION comprobar_cumple (fecha DATE)
RETURNS VARCHAR (10) DETERMINISTIC 
COMMENT 'Comprobar si algun empleado cumple años en la fecha pasada como parametro'
BEGIN
	DECLARE v_cumple INT DEFAULT 0;
	DECLARE resultado VARCHAR (10);
		
	SELECT COUNT(*) INTO v_cumple 
	FROM empleado e 
	WHERE MONTH(e.fNac) = MONTH(fecha) AND DAY(e.fNac)=DAY(fecha);
	
	IF v_cumple > 0 THEN
		SET resultado = 'TRUE';
	ELSE
		SET resultado = 'FALSE';
	END IF;
	RETURN resultado;
END$$
DELIMITER ;

SELECT comprobar_cumple ('2021-08-21');
SELECT comprobar_cumple ('1098-07-21');
SELECT comprobar_cumple ('01/12/22');

SELECT e.*
FROM empleado e 
WHERE e.fNac = '1998-08-21';

DELIMITER $$
CREATE FUNCTION comprobar_cumple_2 (fecha DATE)
RETURNS VARCHAR (10) DETERMINISTIC 
COMMENT 'Comprobar si algun empleado cumple años en la fecha pasada como parametro'
BEGIN
	DECLARE v_cumple INT DEFAULT 0;
	DECLARE resultado VARCHAR (10);
	DECLARE v_fechaOK VARCHAR (10);
	
	IF fecha = 'YYY'

	IF v_fechaOK = 1 THEN 
	
		SELECT COUNT(*) INTO v_cumple 
		FROM empleado e 
		WHERE MONTH(e.fNac) = MONTH(fecha) AND DAY(e.fNac)=DAY(fecha);
	
		IF v_cumple > 0 THEN
			SET resultado = 'TRUE';
		ELSE
			SET resultado = 'FALSE';
		END IF;
	
	ELSE 
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='Formato fecha incorrecto: YYYY-MM-DD';	
	END IF;
	RETURN resultado;
END$$
DELIMITER ;

SELECT COUNT(DATE_FORMAT('01/12/2022', 'YYYY-MM-DD'));
SELECT COUNT(DATE_FORMAT('2021-08-21', 'YYYY-MM-DD')); 


/* 
 * 2. Función "comprobar_cumple_empleado" que reciba como parámetro el id del empleado y que
 *  devuelva TRUE o FALSE si hoy fuera su cumpleaños.
 */

DELIMITER $$
CREATE FUNCTION comprobar_cumple_empleado (idEmpleado NUMERIC(6))
RETURNS VARCHAR (10) DETERMINISTIC 
COMMENT 'Indica a que centro pertenece un empleado, pasando su idEmpleado como parametro'
BEGIN
	DECLARE v_cumple INT DEFAULT 0;
	DECLARE resultado VARCHAR (10);

	SELECT COUNT(*) INTO v_cumple 
	FROM empleado e 
	WHERE MONTH(e.fNac) = MONTH(CURDATE()) AND DAY(e.fNac)=DAY(CURDATE()) AND e.idEmpleado = idEmpleado ;
	
	IF v_cumple >0 THEN
		SET resultado = 'TRUE';
	ELSE
		SET resultado = 'FALSE';
	END IF;
	RETURN resultado;
END$$
DELIMITER ;

SELECT comprobar_cumple_empleado (1);
SELECT comprobar_cumple_empleado (10);


UPDATE empleado e SET e.fNac = CURDATE()  WHERE e.idEmpleado = 10;

SELECT COUNT(*), e.fNac 
	FROM empleado e 
	WHERE MONTH(e.fNac) = MONTH(CURDATE()) AND DAY(e.fNac)=DAY(CURDATE()) AND e.idEmpleado = 10 ;

/*
 * 3. Función "empleado_centro" que reciba como parámetro el número del empleado y 
 * devuelva el número del centro al que pertenece.
 */

DELIMITER $$
CREATE FUNCTION empleado_centro (idEmpleado NUMERIC(6))
RETURNS NUMERIC (2) DETERMINISTIC 
COMMENT 'Comprobar si algun empleado cumple años en la fecha pasada como parametro'
BEGIN
	DECLARE v_existeEmpleado INT DEFAULT 0;
	DECLARE resultado NUMERIC(2);

	SELECT COUNT(*) INTO v_existeEmpleado  
	FROM empleado e 
	WHERE e.idEmpleado  = idEmpleado ;

	IF v_existeEmpleado >0 THEN 
		SELECT c.idCentro INTO resultado 
		FROM empleado e INNER JOIN departamento d 
		ON e.idDepartamento  = d.idDpt 
		INNER JOIN centro c ON d.idCentro = c.idCentro 
		WHERE e.idEmpleado = idEmpleado ;
	END IF;
	
	RETURN resultado;
END$$
DELIMITER ;

SELECT empleado_centro(15);
SELECT empleado_centro (1)



SELECT c.idCentro, d.idDpt, e.idEmpleado 
FROM empleado e INNER JOIN departamento d 
	ON e.idDepartamento  = d.idDpt 
	INNER JOIN centro c ON d.idCentro = c.idCentro 
WHERE e.idEmpleado = 30;

/* 
 * 4. Función "calcular_hijos" que devolverá el número de hijos según el id del empleado.
 */

DELIMITER $$
CREATE FUNCTION calcular_hijos (idEmpleado NUMERIC(6))
RETURNS NUMERIC (2) DETERMINISTIC 
COMMENT 'Comprobar si algun empleado cumple años en la fecha pasada como parametro'
BEGIN
	DECLARE v_existeEmpleado INT DEFAULT 0;
	DECLARE resultado NUMERIC(2);

	SELECT COUNT(*) INTO v_existeEmpleado  
	FROM empleado e 
	WHERE e.idEmpleado  = idEmpleado ;

	IF v_existeEmpleado >0 THEN 
		SELECT COUNT(h.idHijo) INTO resultado 
		FROM empleado e INNER JOIN hijo h 
		ON e.idEmpleado = h.padre 
		WHERE e.idEmpleado = idEmpleado 
		GROUP BY e.idEmpleado ;
	END IF;

	RETURN resultado;
END$$
DELIMITER ;

SELECT calcular_hijos (10);
SELECT calcular_hijos (20);
SELECT calcular_hijos (24);



SELECT COUNT(h.idHijo) 
FROM empleado e INNER JOIN hijo h 
	ON e.idEmpleado = h.padre 
WHERE e.idEmpleado = 10
GROUP BY e.idEmpleado ;

/*
 * Procedimiento "mostrar_hijos" que dado un id de del empleado muestre todos los datos de sus hijos.
 */

DELIMITER $$ 
CREATE PROCEDURE mostrar_hijos (idEmpleado NUMERIC(6))
COMMENT 'Devuelve los datos de los hijos de un empleado'
BEGIN 
	DECLARE v_existeEmpleado INT DEFAULT 0;

	SELECT COUNT(*) INTO v_existeEmpleado  
	FROM empleado e 
	WHERE e.idEmpleado  = idEmpleado;

	IF v_existeEmpleado > 0 THEN
	
		SELECT h.idHijo, h.nombre, h.fNac 
		FROM empleado e INNER JOIN hijo h 
		ON e.idEmpleado = h.idHijo 
		WHERE h.padre  = idEmpleado;
	
	ELSE 
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='El empleado no existe';
	END IF;
END$$
DELIMITER ; 

CALL mostrar_hijos (24);
CALL mostrar_hijos (32);


	SELECT h.nombre, h.fNac 
		FROM empleado e INNER JOIN hijo h 
		ON e.idEmpleado = h.idHijo 
		WHERE h.padre = 30;

/* 
 * 6. Procedimiento "mostrar_empleados" que dado un id de centro muestre el nombre completo de los 
 * empleados junto con el nombre del departamento en el que trabajan.
 */

DELIMITER $$ 
CREATE PROCEDURE mostrar_empleados (idCentro NUMERIC(6))
COMMENT 'Devuelve los datos de los hijos de un empleado'
BEGIN 
	DECLARE v_existeCentro INT DEFAULT 0;

	SELECT COUNT(*) INTO v_existeCentro  
	FROM centro c 
	WHERE c.idCentro  = idCentro ;

	IF v_existeCentro > 0 THEN
	
		SELECT d.nombre, e.nombre, e.apellido1, e.apellido2 
		FROM centro c INNER JOIN departamento d ON c.idCentro =d.idCentro 
		INNER JOIN empleado e ON d.idDpt =e.idEmpleado 
		WHERE c.idCentro = idCentro;
	
	ELSE 
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='El centro no existe';
	END IF;
		
END$$
DELIMITER ; 

CALL mostrar_empleados (10);
CALL mostrar_empleados (15);
CALL mostrar_empleados (30);

SELECT d.nombre, e.nombre, e.apellido1, e.apellido2 
FROM centro c INNER JOIN departamento d ON c.idCentro =d.idCentro 
INNER JOIN empleado e ON d.idDpt =e.idEmpleado 
WHERE c.idCentro = 10

/* 
 * 7) Procedimiento "listar_empleados_salario_minimo" que dado un id de centro y un número N muestre los N 
 * empleados que tienen el salario más bajo.
 */

DELIMITER $$ 
CREATE PROCEDURE p_listar_empleados_salario_minimo (idCentro NUMERIC(2), n INT)
COMMENT 'Devuel ve los N empleados de un determinado centro que tengal el salario más bajo'
BEGIN 
	DECLARE v_existeCentro INT DEFAULT 0;

	SELECT COUNT(*) INTO v_existeCentro  
	FROM centro c 
	WHERE c.idCentro  = idCentro ;

	IF v_existeCentro > 0 THEN
	
		SELECT e.nombre, e.apellido1, e.apellido2, e.salario 
		FROM centro c INNER JOIN departamento d ON c.idCentro =d.idCentro 
		INNER JOIN empleado e ON d.idDpt =e.idEmpleado 
		WHERE c.idCentro = idCentro 
		ORDER BY e.salario ASC
		LIMIT n;
	
	ELSE 
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='El centro no existe';
	END IF;
		
END$$
DELIMITER ;

CALL p_listar_empleados_salario_minimo(10,2);
-- solo tenemos tres empleados en este centro 

		SELECT e.nombre, e.apellido1, e.apellido2, e.salario 
		FROM centro c INNER JOIN departamento d ON c.idCentro =d.idCentro 
		INNER JOIN empleado e ON d.idDpt =e.idEmpleado 
		WHERE c.idCentro = 10
		ORDER BY e.salario ASC;
	
/*
 * 8) Procedimiento "aplicar_comision_centros" que establezca la comisión de los empleados que 
 * trabajan en los centros:
- "C1", el 5% de su salario.
- "C2", el 10%.
- "C3", un 15%.
 */

DELIMITER $$ 
CREATE PROCEDURE p_aplicar_comision_centros ()
COMMENT 'Aplica un porcentaje de comisión en relación a su salario de los centros cuyo nombre son C1,C2,C3'
BEGIN 
	UPDATE empleado e SET e.comision = (e.salario*0.05) WHERE e.idEmpleado IN (SELECT * FROM 
												(SELECT e.idEmpleado 
												FROM empleado e INNER JOIN departamento d 
												ON e.idDepartamento = d.idDpt INNER JOIN centro c 
												ON d.idCentro = c.idCentro WHERE c.nombre = 'C1')tablatemp);	
																			
	UPDATE empleado e SET e.comision = (e.salario*0.1) WHERE e.idEmpleado IN (SELECT * FROM 
												(SELECT e.idEmpleado 
												FROM empleado e INNER JOIN departamento d 
												ON e.idDepartamento = d.idDpt INNER JOIN centro c 
												ON d.idCentro = c.idCentro WHERE c.nombre = 'C2')tablatemp);	
																		
	UPDATE empleado e SET e.comision = (e.salario*0.15) WHERE e.idEmpleado IN (SELECT * FROM 
												(SELECT e.idEmpleado 
												FROM empleado e INNER JOIN departamento d 
												ON e.idDepartamento = d.idDpt INNER JOIN centro c 
												ON d.idCentro = c.idCentro WHERE c.nombre = 'C3')tablatemp);																		
																
END$$
DELIMITER ;

CALL p_aplicar_comision_centros;

SELECT e.idEmpleado, e.nombre, e.salario, e.comision, c.nombre 
FROM empleado e INNER JOIN departamento d 
	ON e.idDepartamento = d.idDpt 
INNER JOIN centro c 
	ON d.idCentro = c.idCentro
WHERE c.nombre IN ('C1', 'C2','C3');

/*
 * 9) Procedimiento "actualizar_salario" que modifique el sueldo de un empleado pasándole el número del 
 * empleado y el nuevo sueldo. El procedimiento comprobará que la variación del sueldo no supere el 
 * 20 por 100 sobre el actual.
 */

DELIMITER $$ 
CREATE PROCEDURE p_actualizar_salario (idEmpleado NUMERIC(6), newSalario DECIMAL(6,2))
COMMENT 'Actualiza el salario de un empleado'
BEGIN 
	DECLARE v_existeEmpleado INT DEFAULT 0;
	DECLARE v_salarioMax DECIMAL(6,2);

	SELECT COUNT(*) INTO v_existeEmpleado  
	FROM empleado e 
	WHERE e.idEmpleado  = idEmpleado;

	IF v_existeEmpleado > 0 THEN
	
		SELECT (e.salario+(e.salario*0.2)) INTO v_salarioMax
		FROM empleado e 
		WHERE  e.idEmpleado =idEmpleado;
		
		IF newSalario <= v_salarioMax THEN
	
			UPDATE empleado e SET e.salario = newSalario WHERE e.idEmpleado = idEmpleado;
		ELSE 
			SIGNAL SQLSTATE '45003'
			SET MESSAGE_TEXT='El saliro no puede superar el 20% sobre el actual';
		END IF;
	
	ELSE 
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='El empleado no existe';
	END IF;
END$$
DELIMITER ; 

CALL p_actualizar_salario (30,2000.00);
CALL p_actualizar_salario (30,1200.00);

SELECT e.idEmpleado, e.nombre, e.salario 
FROM empleado e 
WHERE  e.idEmpleado =30;

SELECT (e.salario+(e.salario*0.2))
FROM empleado e 
WHERE  e.idEmpleado =30;

/*
 * 10) Procedimiento "aplicar_comision_hijos" que dado un centro establezca 
 * la comisión de sus empleados según su número de hijos:

- Si tiene 0 hijos, el 1% de su salario.
- Si tiene 1 hijo, el 3%.
- Si tiene más de 2 hijos o más, un 5%.
 */

DELIMITER $$ 
CREATE PROCEDURE p_aplicar_comision_hijos (idCentro NUMERIC(2))
COMMENT 'aplicar comisión en función del numero de hijos que tenga el empleado'
BEGIN 
	DECLARE v_existeCentro INT DEFAULT 0;
	DECLARE v_numHijos INT DEFAULT 0;

	SELECT COUNT(*) INTO v_existeCentro  
	FROM centro c 
	WHERE c.idCentro  = idCentro ;

	IF v_existeCentro > 0 THEN
	
		UPDATE empleado e SET e.comision = (e.salario *0.01) WHERE idEmpleado IN 
			(SELECT * FROM 
				(SELECT e2.idEmpleado
					FROM empleado e2 LEFT JOIN hijo h 
					ON e2.idEmpleado = h.padre 
					INNER JOIN departamento d 
						ON e2.idDepartamento = d.idDpt 
						WHERE d.idCentro = idCentro 
						GROUP BY e2.idEmpleado
						HAVING COUNT(h.idHijo) =0)
			selectTemp);
		
				UPDATE empleado e SET e.comision = (e.salario *0.03) WHERE idEmpleado IN 
			(SELECT * FROM 
				(SELECT e2.idEmpleado
					FROM empleado e2 LEFT JOIN hijo h 
					ON e2.idEmpleado = h.padre 
					INNER JOIN departamento d 
						ON e2.idDepartamento = d.idDpt 
						WHERE d.idCentro = idCentro 
						GROUP BY e2.idEmpleado
						HAVING COUNT(h.idHijo) =1)
			selectTemp);
		
				UPDATE empleado e SET e.comision = (e.salario *0.05) WHERE idEmpleado IN 
			(SELECT * FROM 
				(SELECT e2.idEmpleado
					FROM empleado e2 LEFT JOIN hijo h 
					ON e2.idEmpleado = h.padre 
					INNER JOIN departamento d 
						ON e2.idDepartamento = d.idDpt 
						WHERE d.idCentro = idCentro 
						GROUP BY e2.idEmpleado
						HAVING COUNT(h.idHijo) >=2)
			selectTemp);
		
	ELSE 
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT='El centro no existe';
	END IF;
		
END$$
DELIMITER ;

CALL p_aplicar_comision_hijos (20);

SELECT e.idEmpleado, e.salario, e.comision, COUNT(h.idHijo) 
FROM empleado e LEFT JOIN hijo h 
	ON e.idEmpleado = h.padre 
	INNER JOIN departamento d 
	ON e.idDepartamento = d.idDpt 
WHERE d.idCentro = 20
GROUP BY e.idEmpleado;

SELECT e.idEmpleado, COUNT(h.idHijo) 
		FROM empleado e LEFT JOIN hijo h 
		ON e.idEmpleado = h.padre 
		INNER JOIN departamento d 
		ON e.idDepartamento = d.idDpt 
		WHERE d.idCentro = 20 
		GROUP BY e.idEmpleado
		HAVING COUNT(h.idHijo)=0;

SELECT e.idEmplead
		FROM empleado e LEFT JOIN hijo h 
		ON e.idEmpleado = h.padre 
		INNER JOIN departamento d 
		ON e.idDepartamento = d.idDpt 
		WHERE d.idCentro = 20 
		GROUP BY e.idEmpleado;

SELECT e.idEmpleado 
FROM empleado e 
WHERE e2.idEmpleado EXISTS  (
						SELECT e.idEmpleado, COUNT(h.idHijo) AS numHijos
		FROM empleado e LEFT JOIN hijo h 
		ON e.idEmpleado = h.padre 
		INNER JOIN departamento d 
		ON e.idDepartamento = d.idDpt 
		WHERE d.idCentro = 20 
		GROUP BY e.idEmpleado
	HAVING numHijos =0);
	
SELECT d.idCentro 
FROM empleado e INNER join departamento d 
ON e.idDepartamento = d.idDpt 
WHERE e.idEmpleado =20;

/*
 * 11 Trigger que al insertar un nuevo empleado compruebe si su nombre y apellidos son en mayúsculas. 
 * Además deberá actualizar el número de empleados según el departamento al cual se asigna.

OPCIONAL Y CALIFICABLE: Deberá comprobar además si es o no su cumpleaños en el día de su incorporación. 
Para ello usar la función "comprobar_cumple_empleado". Si es su cumpleaños, se fijará un 5% de comisión del
 salario al insertarlo.

 */
   DROP TRIGGER t_nombreMayuscula;  


DELIMITER $$
CREATE TRIGGER t_nombreMayuscula
AFTER INSERT ON empleado FOR EACH ROW 
BEGIN 
	IF (BINARY(NEW.nombre) = BINARY (UPPER(NEW.nombre))) THEN 
		SIGNAL SQLSTATE '45005'
		SET MESSAGE_TEXT='El nombre y apellido estan en mayúscula, no cumplen el formato';
	ELSE	
		UPDATE departamento SET nempleados = (nempleados+1) WHERE idDpt = NEW.idDepartamento;
			
	 	IF (comprobar_cumple_empleado(NEW.idEmpleado) = 'TRUE') THEN 
			-- SET NEW.comision = (NEW .salario*0.05); 
			UPDATE empleado SET comision = (NEW.salario*0.05) WHERE idEmpleado = NEW.idEmpleado;
		END IF;
	END IF;
END$$ 
DELIMITER ;

INSERT INTO empleado(idEmpleado, dni, idDepartamento, fechaIngreso,
							fNac,nombre,apellido1,apellido2,salario,comision) VALUES (
	31,'12345678D',20,'2022-03-18','2000-03-18','Blanco','Gordo','BolaPelo',1000.00,1.50
);
INSERT INTO empleado  VALUES (
	32,'12345678D',20,'2022-03-18','1982-06-10','BLANCO','GORDO','BOLAPELO',1000.00,1.50
);
INSERT INTO empleado (idEmpleado, dni, idDepartamento, fechaIngreso,
							fNac,nombre,apellido1,apellido2,salario,comision) VALUES (
	33,'12345678A',19,'2022-03-19','2002-12-18','Blanco','Gordo','BolaPelo',1000.00,0
);

CALL p_numEmpleados;

SELECT e.idEmpleado 
FROM empleado e INNER JOIN departamento d 
	ON e.idDepartamento = d.idDpt 
WHERE d.idDpt =19;

/*
 *12. Trigger que al insertar un departamento compruebe que haya un director que no dirija 
 *otro departamento. Cuando insertamos un departamento debemos de ver si ahi algun idEmpleado 
 *que no dirija un dpt (son 10 empleado) En este caso debemos de que indique una excepcion diciendo 
 *que hay empleados que no son direcotres de departamento. 
 */

DELIMITER $$ 
CREATE TRIGGER t_insert_depart_directo
AFTER INSERT ON departamento FOR EACH ROW
BEGIN 
	DECLARE v_numDirector INT DEFAULT 0;

	SELECT COUNT(director) INTO v_numDirector 
	FROM departamento d  
	GROUP BY director
	ORDER BY COUNT(director) DESC
	LIMIT 1;
	
	IF v_numDirector > 1 THEN
		SIGNAL SQLSTATE '45006'
		SET MESSAGE_TEXT='Hay directores que dirijen mas de un departamento';
	END IF;
END$$
DELIMITER ;



INSERT INTO departamento VALUES(
	21,20,15,'Gamer',150.06,'R2',1
);
INSERT INTO departamento VALUES(
	21,30,15,'Gamer',150.06,'R2',1
);


SELECT COUNT(e.idEmpleado)
FROM empleado e 
WHERE  e.idEmpleado NOT IN (
SELECT e.idEmpleado 
FROM empleado e INNER JOIN departamento d 
ON e.idEmpleado = d.director);

/*
 * 13. Trigger que al borrar un empleado compruebe previamente si tiene hijos o no. 
 * En el caso de que los tenga, deberá no ser eliminado indicando el número de hijos que posee. 
 * Recuerda actualizar el número de empleados del departamento si fuese eliminado.
 */

DELIMITER $$
CREATE TRIGGER t_tieneHIjos
BEFORE DELETE ON empleado FOR EACH ROW
BEGIN 
	DECLARE numHijos INT DEFAULT 0;
	DECLARE MESSAGE_TEXT VARCHAR(100) DEFAULT '';

	SELECT COUNT(h.idHijo) INTO numHijos 
	FROM empleado e INNER JOIN hijo h 
	ON e.idEmpleado = h.padre 
	WHERE idEmpleado = OLD.idEmpleado 
	GROUP BY e.idEmpleado;

	IF numHijos > 0 THEN 
		SET @mensaje = CONCAT('Numero de hijo: ', numHijos); 
		SIGNAL SQLSTATE '45008'
		SET MESSAGE_TEXT= @mensaje;
	ELSE
		UPDATE departamento SET nempleados = (nempleados-1)  WHERE idDpt = OLD.idDepartamento;
	END IF;
END$$
DELIMITER ;

DELETE FROM empleado WHERE idEmpleado = 33; -- no tiene hijos
DELETE FROM empleado WHERE idEmpleado = 20; -- tiene 4 hijo
DELETE FROM empleado WHERE idEmpleado = 31; -- no tiene hijos

CALL p_numEmpleados;

SELECT e.*
FROM departamento d INNER JOIN empleado e 
ON d.idDpt =e.idDepartamento
WHERE d.idDpt = 19;

SELECT e.idEmpleado, COUNT(h.idHijo) 
FROM empleado e LEFT  JOIN hijo h 
	ON e.idEmpleado = h.padre 
GROUP BY e.idEmpleado;

SELECT FROM 

USE entregable;

SELECT COUNT(h.idHijo) INTO numHijos 
	FROM empleado e INNER JOIN hijo h 
	GROUP BY e.idEmpleado;
































