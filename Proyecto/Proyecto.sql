-- DDL: CREACION DE LAS TABLAS.

CREATE DATABASE proyecto;
USE proyecto;

-- proyecto_BBDD.muestra definition

CREATE TABLE muestra (
  id int ,
  name varchar(40) DEFAULT NULL,
  family varchar(27) DEFAULT NULL,
  genus varchar(16) DEFAULT NULL,
  name_scientific varchar(30) DEFAULT NULL,
  classification varchar(9) DEFAULT NULL,
  weight double DEFAULT NULL,
  PRIMARY KEY (id)
);

-- proyecto_BBDD.area definition

CREATE TABLE area (
  ID varchar(8) NOT NULL,
  sampling varchar(10) DEFAULT NULL,
  latitud double DEFAULT NULL,
  longitude double DEFAULT NULL,
  PRIMARY KEY (ID)
);

-- proyecto_BBDD.laboratorio definition

CREATE TABLE laboratorio (
  IdLab int unsigned AUTO_INCREMENT,
  CIF varchar(20) DEFAULT NULL,
  name varchar(100) DEFAULT NULL,
  phone varchar(15) DEFAULT NULL,
  address varchar(100) DEFAULT NULL,
  city varchar(100) DEFAULT NULL,
  region varchar(100) DEFAULT NULL,
  PRIMARY KEY (IdLab)
);

-- proyecto_BBDD.empleado definition

CREATE TABLE empleado (
  id int NOT NULL,
  firts_name varchar(8)  DEFAULT NULL,
  last_name varchar(10) DEFAULT NULL,
  second_last_name varchar(9) DEFAULT NULL,
  phone varchar(10) DEFAULT NULL,
  email varchar(36) DEFAULT NULL,
  postions varchar(7) DEFAULT NULL,
  Id_jefe int DEFAULT NULL,
  Id_laboratorio int unsigned,
  PRIMARY KEY (id) 
);

ALTER TABLE empleado ADD CONSTRAINT fk_emple_jefe FOREIGN KEY (Id_jefe) REFERENCES empleado (id);
ALTER TABLE empleado ADD CONSTRAINT fk_emple_lab FOREIGN KEY (Id_laboratorio) REFERENCES laboratorio (IdLab);

-- proyecto_BBDD.factorAmbiental definition

CREATE TABLE factorAmbiental (
  cod_factor int NOT NULL,
  fType enum ('fisico','quimico'),
  name varchar(16) DEFAULT NULL,
  average decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (cod_factor)
);

-- proyecto_BBDD.area_recolecta_muestra definition

CREATE TABLE area_recolecta_muestra (
  amount int DEFAULT NULL,
  date date DEFAULT NULL,
  id_area varchar(8) NOT NULL,
  id_muestra int NOT NULL,
  PRIMARY KEY (id_muestra,id_area)
);

ALTER TABLE area_recolecta_muestra ADD CONSTRAINT fk_areamuestra FOREIGN KEY (id_muestra) 
REFERENCES muestra (id);
ALTER TABLE area_recolecta_muestra ADD CONSTRAINT fk_area2 FOREIGN KEY (id_area) REFERENCES area(ID);

-- proyecto_BBDD.lab_aporta_muestra definition

CREATE TABLE lab_aporta_muestra (
  number_samples int DEFAULT NULL,
  contribution_date date DEFAULT NULL,
  id_laboratorio int unsigned NOT NULL,
  id_muestra int NOT NULL,
  PRIMARY KEY (id_laboratorio,id_muestra)    
);

ALTER TABLE lab_aporta_muestra ADD CONSTRAINT lab_aporta_muestra_FK 
FOREIGN KEY (id_laboratorio) REFERENCES laboratorio (IdLab);
ALTER TABLE lab_aporta_muestra ADD CONSTRAINT  lab_aporta_muestra_FK_1 
FOREIGN KEY (id_muestra) REFERENCES muestra (id);

-- proyecto_BBDD.analisis_fauna definition
CREATE TABLE analisis_fauna (
  id_muestra int NOT NULL,
  id_factoAmbiental int NOT NULL,
  id_empleado int NOT NULL,
  legth double DEFAULT NULL,
  wins varchar(2) DEFAULT NULL,
  color varchar(16) DEFAULT NULL,
  PRIMARY KEY (id_muestra,id_factoAmbiental,id_empleado)
);

ALTER TABLE analisis_fauna ADD CONSTRAINT analisis_fauna_FK FOREIGN KEY (id_empleado) REFERENCES empleado (id);
ALTER TABLE analisis_fauna ADD CONSTRAINT analisis_fauna_FK_1 
FOREIGN KEY (id_factoAmbiental) REFERENCES factorAmbiental (cod_factor);
ALTER TABLE analisis_fauna ADD CONSTRAINT analisis_fauna_FK_2 FOREIGN KEY (id_muestra) REFERENCES muestra (id);

-- proyecto_BBDD.analisis_flora definition

CREATE TABLE analisis_flora (
  id_muestra int NOT NULL,
  id_factoAmbiental int NOT NULL,
  id_empleado int NOT NULL,
  carotenos enum('baja','media','alta') DEFAULT NULL,
  amilasa enum('si','no') DEFAULT NULL,
  clorofila enum('baja','media','alta') DEFAULT NULL,
  PRIMARY KEY (id_muestra,id_factoAmbiental,id_empleado)
) ;

ALTER TABLE analisis_flora ADD CONSTRAINT analisis_flora_FK FOREIGN KEY (id_empleado) REFERENCES empleado (id);
ALTER TABLE analisis_flora ADD CONSTRAINT analisis_flora_FK_1 FOREIGN KEY (id_factoAmbiental) 
REFERENCES factorAmbiental (cod_factor);
ALTER TABLE analisis_flora ADD CONSTRAINT analisis_flora_FK_2 FOREIGN KEY (id_muestra) REFERENCES muestra (id);






-- CONSULTAS:

-- Se quiere conocer la cantidad de empleados de cada laboratorio y ordenarlos de mayor a menor.

SELECT l.name , COUNT(e.id) AS amount FROM laboratorio l
INNER JOIN empleado e ON l.IdLab = e.Id_laboratorio 
GROUP BY l.IdLab
ORDER BY COUNT(e.id) DESC;

-- Cuántas muestras ha analizado, de tipo vegetal, cada empleado(independientemente del laboratorio 
-- donde trabaja) y quien el nombre de su jefe.

SELECT e.firts_name, COUNT(m.id) AS amount , e2.firts_name AS jefe FROM muestra m
INNER JOIN lab_aporta_muestra lam ON m.id = lam.id_muestra
INNER JOIN laboratorio l ON lam.id_laboratorio = l.IdLab
INNER JOIN empleado e ON l.IdLab = e.Id_laboratorio
LEFT JOIN empleado e2 ON e2.id = e.Id_jefe
WHERE m.classification = 'vegetable'
GROUP BY e.id, e2.id;

-- Que área es la que ha recolectado más muestras de tipo animal.

SELECT a.ID, COUNT(m.id) AS amount FROM area a
INNER JOIN area_recolecta_muestra arm ON a.ID = arm.id_area
INNER JOIN muestra m ON arm.id_muestra = m.id
WHERE m.classification = 'animal'
GROUP BY a.ID
ORDER BY COUNT(m.id) DESC
LIMIT 1;

-- La cantidad de muestras que aporta cada laboratorio de cada tipo. Queremos que se
-- vea el nombre del laboratorio y la cantidad de cada tipo especificado. Se ordenará
-- alfabéticamente por el nombre del laboratorio.

SELECT l.name, m.classification , COUNT(m.classification) AS Amount FROM muestra m
INNER JOIN lab_aporta_muestra lam
ON m.id = lam.id_muestra
INNER JOIN laboratorio l ON lam.id_laboratorio = l.IdLab
GROUP BY l.IdLab, m.classification
ORDER BY l.name ASC;

-- Cuales son las especies con una longitud mayor a la media en el tipo animal.
-- Queremos conocer su nombre común (name) y su nombre científico
-- (name_scientific) y la longitud.

SELECT m.name, m.name_scientific, af.legth 
FROM analisis_fauna af
INNER JOIN muestra m ON af.id_muestra = m.id
WHERE af.legth = (
SELECT MAX(af2.legth) FROM analisis_fauna af2);

-- VISTAS:

-- Cuántas muestras ha analizado, de tipo vegetal, cada empleado
-- (independientemente del laboratorio donde trabaja) y quien el nombre de su jefe.

CREATE VIEW animal AS (SELECT m.name, m.name_scientific, af.legth analisis_fauna 
FROM analisis_fauna af INNER JOIN muestra m ON af.id_muestra = m.id
WHERE af.legth = (
	SELECT MAX(af2.legth) 
	FROM analisis_fauna af2)
);

-- Cuales son las especies con una longitud mayor a la media en el tipo animal.
-- Queremos conocer su nombre común (name) y su nombre científico
-- (name_scientific) y la longitud.

CREATE VIEW control_samples_employee AS (
	SELECT e.firts_name, COUNT(m.id), e2.firts_name AS jefe FROM muestra m
	INNER JOIN lab_aporta_muestra lam ON m.id = lam.id_muestra
	INNER JOIN laboratorio l ON lam.id_laboratorio = l.IdLab
	INNER JOIN empleado e ON l.IdLab  = e.Id_laboratorio
	LEFT JOIN empleado e2 ON e2.id = e.Id_jefe
	WHERE m.classification = 'vegetable'
	GROUP BY e.id, e2.id
);

-- FUNCIONES:

/*
 * 2. Crear una función "f_num_empleado_laboratorio" que reciba como parámetro
el CIF de un laboratorio y devuelva la fecha donde más ejemplares de una
muestra ha aportado. Se debe comprobar si el laboratorio pertenece o no a la
red de laboratorio.
 */

-- Comprobacion de los esperados: 

SELECT lam.contribution_date,
lam.number_samples
FROM lab_aporta_muestra lam INNER JOIN
laboratorio l
ON lam.id_laboratorio = l.IdLab
WHERE l.CIF = 'LXN36ZUQ7TY'
ORDER BY lam.number_samples DESC;

-- desarrollo de la funcion

DELIMITER $$
CREATE FUNCTION f_fecha_MaxEjemplares (cif VARCHAR(20))
RETURNS DATE DETERMINISTIC
COMMENT 'Devulve la fecha en la que un laboratorio ha aportado más
muestras'
BEGIN
	DECLARE v_estaLab INT DEFAULT 0;
	DECLARE v_salida DATE ;

	SELECT COUNT(*) INTO v_estaLab
	FROM laboratorio l
	WHERE l.CIF = cif;
	
	IF v_estaLab > 0 THEN
		SELECT lam.contribution_date
		INTO v_salida
		FROM laboratorio l INNER JOIN lab_aporta_muestra lam
		ON l.IdLab = lam.id_laboratorio
		WHERE l.CIF = 'LXN36ZUQ7TY' AND lam.number_samples = (

		SELECT MAX(lam2.number_samples)
		FROM lab_aporta_muestra lam2);
	END IF;
RETURN v_salida;
END$$
DELIMITER ;

SELECT f_fecha_MaxEjemplares('LXN36ZUQ7TY');

/*
 * 1. Crear una función “f_informacionArea” que pasándole como parámetro la
latitud y longitud, así como el tipo de muestras (animal, vegetal) nos saque por
consola la cantidad de muestras que se han recolectado con el siguiente
formato:

"En la área xxxx se han recolectado yyy muestras del tipo zzzz"

xxxx --> ID del área
yyyy --> cantidad de muestras
zzzz --> classification de la muestras
 */

DELIMITER $$
CREATE FUNCTION f_informacionArea (latitud DOUBLE, longitud DOUBLE,tipo VARCHAR(9))
RETURNS VARCHAR (300) DETERMINISTIC
COMMENT 'la cantidad de muestras de un tipo determinado en dos coordenadas dadas'
BEGIN
	DECLARE v_salida VARCHAR (300) DEFAULT '';
	DECLARE v_area VARCHAR (7) DEFAULT '';
	DECLARE v_cantidad INT DEFAULT 0;

	SELECT COUNT(m.id) INTO v_cantidad
	FROM area a INNER JOIN area_recolecta_muestra arm
	ON a.ID = arm.id_area
	INNER JOIN muestra m
	ON arm.id_muestra = m.id
	WHERE a.latitud = latitud AND a.longitude = longitude
	AND m.classification = tipo;

	SELECT a.ID INTO v_area
	FROM area a
	WHERE a.latitud = latitud AND a.longitude =longitud;

	SET v_salida = CONCAT('En el área ', v_area,' se han
	recolectado ',v_cantidad,' muestras de tipo ', tipo);
RETURN v_salida;
END$$
DELIMITER ;

SELECT f_informacionArea(55.7597032, 37.6108925, 'animal')

-- PROCEDIMIENTOS

/*
 * 1. Crea un procedimiento”p_infoMuestraEmpleado” que se le pase como
parámetro el identificador de un empleado y nos saque por consola los datos y
los análisis de las muestras que ha analizado..
 */

DELIMITER $$
CREATE PROCEDURE p_infoMuestraEmpleado (idEmpleado INT)
COMMENT 'Devuelve los datos de todas las especies y análisis de las muestras que ha analizado'
BEGIN
	SELECT m.*, af.id_factoAmbiental, af.legth, af.wins, af.color
	FROM empleado e INNER JOIN analisis_fauna af
	ON e.id = af.id_empleado
	INNER JOIN muestra m
	ON af.id_muestra = m.id
	WHERE e.id = idEmpleado;

	SELECT m.*, afl.id_factoAmbiental, afl.carotenos, afl.amilasa,
	afl.clorofila
	FROM empleado e INNER JOIN analisis_flora afl
	ON e.id = afl.id_empleado
	INNER JOIN muestra m
	ON afl.id_muestra = m.id
	WHERE e.id = idEmpleado;
END$$
DELIMITER ;

CALL p_infoMuestraEmpleado(5);

/*
 * 2. Crea un procedimiento “p_informe_muestras_recolectadas” que al pasarle por
parámetro dos fechas nos dé como resultado la cantidad de muestras de cada
tipo se han recolectado por estaciones de cada año.
 */

-- En la primera obtendremos la cantidad de ejemplares (amaunt) que se han
-- recolectados por años.

SELECT YEAR(arm.date), SUM(arm.amount)
FROM area_recolecta_muestra arm
GROUP BY YEAR(arm.date);

-- En la segunda queremos saber la cantidad de ejemplares (amaunt) cada trimestre
-- de cada año. Por lo tanto, cada año tendremos 4 filas en representación de los
-- trimestres.
SELECT YEAR(arm.date), QUARTER(arm.date), SUM(arm.amount)
FROM area_recolecta_muestra arm
GROUP BY YEAR(arm.date), QUARTER(arm.date)
ORDER BY YEAR(arm.date);


DELIMITER $$
CREATE PROCEDURE p_informeRecoleccionEjemplares()
BEGIN
	DECLARE v_result VARCHAR(3000) DEFAULT '======== INFORME RECOLECCION
	DE EJEMPLARES =====\n--------------\n\nEjemplares Totales:';
	DECLARE v_total INT DEFAULT 0;
	DECLARE done BOOL DEFAULT FALSE;
	DECLARE v_anyo INT DEFAULT 2000 ;
	DECLARE v_cuarto INT DEFAULT 1;
	DECLARE n integer DEFAULT 1;

-- declaramos el cursor de años
	DECLARE c1 CURSOR FOR
		SELECT YEAR(arm.date), SUM(arm.amount)
		FROM area_recolecta_muestra arm
		GROUP BY YEAR(arm.date);
-- declaramos cursor para los cuartos por años
	DECLARE c2 CURSOR FOR
	SELECT YEAR(arm.date), QUARTER(arm.date), SUM(arm.amount)
	FROM area_recolecta_muestra arm
	GROUP BY YEAR(arm.date), QUARTER(arm.date)
	ORDER BY YEAR(arm.date);

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	SELECT SUM(arm.amount) INTO v_total
	FROM area_recolecta_muestra arm;

	SET v_result = CONCAT(v_result,v_total,'\n','\n-------------
	Ejemplares por años--------------\n','\n');
-- abrimos el cursor c1
	OPEN c1;
		WHILE(NOT done) do
			FETCH c1 INTO v_anyo, v_total;
			IF (NOT done) THEN
				SET v_result = CONCAT(v_result,'En ',v_anyo,':',v_total,' ejemplares\n');
			END IF;
		END WHILE;
	CLOSE c1;
	
	SET v_result = CONCAT(v_result,'\n ------------ Ejemplares por cuartos de cada año -------------\n','\n');
-- abrimos el cursor c2
	OPEN c2;
		SET done = FALSE;
		WHILE(NOT done) do
			FETCH c2 INTO v_anyo,v_cuarto,v_total;
				IF (NOT done) THEN
					SET v_result = CONCAT(v_result,n,'. En ',v_anyo,'en el Q',v_cuarto,': ',
					v_total,' ejemplares\n');
					SET n=n+1;
				END IF;
		END WHILE;
	CLOSE c2;
	SET n=1;
	SELECT v_result;
END$$
DELIMITER ;

CALL p_informeRecoleccionEjemplares();

/*
 * 3. Crea un procedimiento “p_areaRecoleccion_Laboratorio” que se le pase por
parámetro el CIF de un laboratorio y nos devuelva la información del área
donde se han recolectado los ejemplares cuya fecha de aportación es aquella
obtenida por la función “f_fecha_MaxEjemplares”. Recordemos que esta
función nos devuelve la fecha en la que un laboratorio ha aportado más
ejemplares de muestras.
 */

DELIMITER $$
CREATE PROCEDURE p_areaRecoleccion_Laboratorio (cif VARCHAR(20))
COMMENT 'Devuelve la información de la muestra y área cuya fecha de
aportación es aquella que se obtiene en la función f_fecha_MaxEjemplares'
BEGIN
	DECLARE v_fecha DATE;
	DECLARE v_idMuestras INT DEFAULT 0;

	SELECT f_fecha_MaxEjemplares(cif) INTO v_fecha;

	SELECT lam.id_muestra INTO v_idMuestras
	FROM lab_aporta_muestra lam INNER JOIN laboratorio l
	ON lam.id_laboratorio = l.IdLab
	WHERE lam.contribution_date = v_fecha;

	SELECT a.*, m.*
	FROM area a INNER JOIN area_recolecta_muestra arm
	ON a.ID = arm.id_area
	INNER JOIN muestra m ON m.id = arm.id_muestra
	WHERE arm.id_muestra =v_idMuestras;
END$$
DELIMITER ;

CALL p_areaRecoleccion_Laboratorio('LXN36ZUQ7TY');

-- TRIGGER

/*
 * 1. Crea un trigger que cuando se añade un análisis de tipo flora, este le asignado
al empleado que menor análisis lleve realizados. En caso de que el empleado
sea el de mayor análisis realizado este debe de mandar error indicando la
cantidad de análisis hechos.
 */

-- empleado con menor analisis
SELECT af.id_empleado , COUNT(af.id_muestra)
FROM analisis_fauna af
GROUP BY af.id_empleado
ORDER BY COUNT(af.id_muestra) ASC
LIMIT 1;

-- factor ambiental que en menor anlaisis aparecer
SELECT af.id_factoAmbiental, COUNT(af.id_muestra)
FROM analisis_fauna af
GROUP BY af.id_factoAmbiental
ORDER BY COUNT(af.id_muestra) ASC
LIMIT 1;

DELIMITER $$
CREATE TRIGGER t_analisisEmpleado
AFTER INSERT ON muestra FOR EACH ROW
BEGIN
	DECLARE v_idEmpleadoMenor INT DEFAULT 0;
	DECLARE v_idFactoAmbietantalMenor INT DEFAULT 0;
	DECLARE v_temp INT DEFAULT 0;
	DECLARE v_temp2 INT DEFAULT 0;

	SELECT af.id_empleado , COUNT(af.id_muestra)
	INTO v_idEmpleadoMenor, v_temp
	FROM analisis_fauna af
	GROUP BY af.id_empleado
	ORDER BY COUNT(af.id_muestra) ASC
	LIMIT 1;

	SELECT af.id_factoAmbiental, COUNT(af.id_muestra)
	INTO v_idFactoAmbietantalMenor, v_temp2
	FROM analisis_fauna af
	GROUP BY af.id_factoAmbiental
	ORDER BY COUNT(af.id_muestra) ASC
	LIMIT 1;

	IF (NEW.classification = 'animal') THEN
		INSERT INTO analisis_fauna (id_muestra,id_factoAmbiental,
		id_empleado,legth, wins, color) VALUES (
			NEW.id , v_idFactoAmbietantalMenor, v_idEmpleadoMenor, 0.0,
				'no', 'none');
	ELSE
		SIGNAL SQLSTATE '45003'
		SET message_text='Ya hay muchas muestras de tipo vegetal';
	END IF;
END$$
DELIMITER ;

-- sale excepcion
INSERT INTO muestra VALUES (1003, 'prueba','prueba','prueba','prueba','vegerable', 0.0);

-- se inserta con el indicado en empleado y factor ambiental
INSERT INTO muestra VALUES (1007,'prueba','prueba','prueba','prueba','animal', 0.0);

/*
 * 2. Crea la siguiente tabla, revisión Nombre Científico. En esta tabla guardaremos
los nombres antiguos y nuevos de las especies que han sido renombradas
(actualizadas) tras análisis filogenéticos. La tabla está compuesta por:
	○ idMuestra	
	○ generoAntiguo
	○ EspecieAntigua
	○ generoNuevo
	 ○ EspecieNueva
 */

CREATE TABLE revision_nom_cientifico(
	idMuestra INT,
	generoAntiguo VARCHAR (16),
	especieAntigua VARCHAR (30),
	generoNuevo VARCHAR (16),
	especieNueva VARCHAR (30)
);

DELIMITER $$
CREATE TRIGGER t_revisionNombres
BEFORE UPDATE ON muestra FOR EACH ROW
BEGIN
	INSERT INTO revision_nom_cientifico (idMuestra, generoAntiguo,
	especieAntigua,generoNuevo, especieNueva) VALUES (
	OLD.id, OLD.genus, OLD.name_scientific, NEW.genus,
	NEW.name_scientific
);
END$$
DELIMITER ;

UPDATE muestra m SET m.genus = 'Gatinyo', m.name_scientific = 'Gatinyo
Familiaris' WHERE m.id = 5;








