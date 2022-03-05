
-- ---------------------- PROCEDIMIENTOS ------ 

USE CIRCO;

-- Crea un procedimiento que reciba un numero como parámetro que saque por pantalla su valor 
-- y el de su cuadrado desde 1 hasta n valor. 

CREATE TABLE cuadrado (
	i INTEGER,
	cuad INTEGER 
);

DELIMITER $$
CREATE PROCEDURE P4(in x INTEGER)
BEGIN 
	DECLARE n INTEGER DEFAULT 1;
	WHILE( n<=x ) DO
		INSERT INTO cuadrado VALUES (n, n*n);
		SET n = n+1;
	END WHILE;
END$$ 
DELIMITER ;

CALL P4(100);
SELECT  P4;

CREATE DATABASE BL5;
USE BL5;

-- EJER 1: Crea un procedimiento de nombre artistas_getList() que devuelva el nombre y apellidos
--  de los artistas separados por coma con el formato: apellidos,nombre ordenados de forma descendente.

DELIMITER $$ 
CREATE PROCEDURE artistas_getList()
BEGIN 
	SELECT CONCAT(a.apellidos,', ',a.nombre) As nombreCompleto
	FROM ARTISTAS a
	ORDER BY nombreCompleto DESC;
END$$ 
DELIMITER ;

CALL artistas_getList;

-- EJER 2: Crea un procedimiento de nombre artistas_getListAnimales() que devuelva los nombres de 
-- los artistas junto con su nif así como el nombre y peso de los animales que están atendidos por los artistas, 
-- ordenados por nif del artista y nombre del animal.


DELIMITER $$ 
CREATE PROCEDURE artistas_getListAnimales()
BEGIN 
	SELECT a.apellidos,a.nombre, a.nif ,al.nombre,al.peso 
	FROM ARTISTAS a INNER JOIN ANIMALES_ARTISTAS aa ON a.nif = aa.nif_artista 
	INNER JOIN ANIMALES al ON aa.nombre_animal = al.nombre 
	ORDER BY a.nif, al.nombre  DESC;
END$$ 
DELIMITER ;

CALL artistas_getListAnimales;

-- EJER 3: Crea un procedimiento de nombre atracciones_getListConAntiguedad5() que devuelva los datos de 
-- las atracciones que hayan comenzado hace 5 años con respecto a la fecha actual. Tendrás que hacer uso 
-- de alguna de las funciones Date Time. Intenta averiguar cual.

-- Fijarse que este procedimiento es un buen candidato para emplear un parámetro en donde indiquemos el 
-- número de años. Lo veremos después cuando expliquemos el paso de datos por parámetros.

DELIMITER $$
CREATE PROCEDURE atracciones_getListConAntiguedad5()
COMMENT 'Devuelve todos los datos de las atracciones que comenzaran hace 5 años con respecto a la fecha actual'
BEGIN
    SELECT *
    FROM ATRACCIONES
    WHERE fecha_inicio BETWEEN DATE_SUB(curdate(), INTERVAL 5 YEAR) AND  curdate()
    ORDER BY nombre;

END$$
DELIMITER ;


CALL atracciones_getListConAntiguedad5;

-- EJER 04: Crea un procedimiento de nombre animales_Leo_getPista() que muestre los datos de la 
-- pista donde trabaja el animal de nombre 'Leo'. Hacerlo empleando una variable local que guarde
-- el nombre de la pista. Después consultar los datos de la pista empleando dicha variable local.

DELIMITER $$ 
CREATE PROCEDURE animales_Leo_getPista() 
COMMENT 'Devulece la pista donde trabaja el aniaml con nombre Leo'
BEGIN 
	SELECT p.nombre, p.aforo FROM PISTAS p INNER JOIN ANIMALES a 
	ON p.nombre = a.nombre_pista
	WHERE a.nombre = 'Leo';
END$$ 
DELIMITER ; 

CALL animales_Leo_getPista;

-- Fijarse que este procedimiento es un buen candidato para emplear un parámetro en donde indiquemos 
-- el nombre del animal. Lo veremos después cuando expliquemos el paso de datos por parámetros.

DELIMITER $$
CREATE PROCEDURE animales_Leo_getPista()
COMMENT 'Devuelve los datos de la pista donde trabaja el animal de nombre Leo'
BEGIN
	DECLARE v_nombrePista varchar(50) default '';	-- El tipo y tamaño debe de coincidir con 
	-- el declarado en la tabla. Si no podemos nada, el valor por defecto es NULL

    SELECT nombre_pista
    INTO v_nombrePista
    FROM ANIMALES
    WHERE nombre = 'Leo';
    
    SELECT *                                   -- Devuelve una única fila. No hace falta order by
    FROM PISTAS
    WHERE nombre=v_nombrePista;
END$$
DELIMITER ;

-- EJER 05: Crea un procedimiento de nombre atracciones_getUltima() que obtenga los datos de la 
-- última atracción celebrada (tabla ATRACCION_DIA), empleando variables locales. Para ello guarda
-- en una variable el nombre de la última atracción celebrada y busca los datos de dicha atracción. 
-- Ten en cuenta limitar con LIMIT el número de filas que devuelva una consulta si no sabes con certeza 
-- que vaya a devolver una única fila y vas a guardar el datos en una variable.

DELIMITER $$
CREATE PROCEDURE atracciones_getUltima()
COMMENT 'Devuelve los datos de la última atracción celebrada'
BEGIN
	DECLARE v_nombreAtraccion varchar(50) default '';	-- El tipo y tamaño debe de coincidir con
						-- el declarado en la tabla. Si no podemos nada, el valor por defecto es NULL
    SELECT nombre_atraccion
    INTO v_nombreAtraccion
    FROM ATRACCION_DIA
    ORDER BY fecha DESC
    LIMIT 1;
    /*
    Si empleáramos subconsultas, podríamos hacer algo como lo siguiente
    SELECT nombre_atraccion
    INTO v_nombreAtraccion
	FROM ATRACCION_DIA
	WHERE fecha = (SELECT MAX(fecha)
                   FROM ATRACCION_DIA)
	LIMIT 1; 
    */
    SELECT *                     -- Devuelve una única fila. No hace falta order by
    FROM ATRACCIONES
    WHERE nombre=v_nombreAtraccion;
END$$
DELIMITER ;


-- EJER 06:Crea un procedimiento de nombre atracciones_getArtistaUltima() que obtenga los datos
-- de la atracción y del artista que trabaja en dicha atracción, cuya fecha de inicio ha empezado
-- más tarde. Emplea dos variables. Una para guardar el nif del artista y otra para guardar el nombre de la atracción.

DELIMITER $$
CREATE PROCEDURE atracciones_getArtistaUltima()
COMMENT 'Devuelve los datos de la atracción y del artista que trabaja en dicha atracción, 
cuya fecha de inicio ha empezado más tarde'
BEGIN
	DECLARE v_nombreAtraccion varchar(50) default '';	-- El tipo y tamaño debe de coincidir con el declarado en la tabla.
	-- Si no podemos nada, el valor por defecto es NULL
	DECLARE v_nifArtista char(9);		-- Al no llevar default el valor por defecto es null y 
	--sería lo que tendríamos que comparar en un if por ejemplo.

    SELECT nombre_atraccion,nif_artista
    INTO v_nombreAtraccion,v_nifArtista
    FROM ATRACCIONES_ARTISTAS
    ORDER BY fecha_inicio DESC
    LIMIT 1;
    
    SELECT *						-- Devuelve una única fila. No hace falta order by
    FROM ATRACCIONES,ARTISTAS
    WHERE ATRACCIONES.nombre=v_nombreAtraccion AND
		  ARTISTAS.nif = v_nifArtista;
END$$
DELIMITER ;


-- ------------------------------  PARAMETROS DE ENTRADA  ----------------------------------

-- EJER 01: Crea un procedimiento de nombre artistas_getAnimalesPorNif que devuelva los animales 
-- que cuida un artista. Llevará como parámetro el nif de artista.

DELIMITER $$ 
CREATE  PROCEDURE artistas_getAnimalesPorNif(nif VARCHAR(9))
COMMENT 'Devuelve la lista de animales que cuida un artista'
BEGIN 
	SELECT a.* FROM ANIMALES a INNER JOIN ANIMALES_ARTISTAS aa ON a.nombre = aa.nombre_animal 
	INNER JOIN ARTISTAS ar ON aa.nif_artista = ar.nif 
	WHERE ar.nif = nif;
END$$ 
DELIMITER ;

CALL artistas_getAnimalesPorNif('22222222B');

-- EJER 02: Crea un procedimiento de nombre artistas_getAnimalesPorNombreApel que devuelva 
-- los animales que cuida un artista. Llevará como parámetro el nombre y apellidos del artista.
-- Suponemos que el nombre y apellidos conforman una clave alternativa.

DELIMITER $$ 
CREATE PROCEDURE artistas_getAnimalesPorNombreApel(nom VARCHAR(45), ape VARCHAR(100))
COMMENT 'Devuelva los animales que cuida un artista. Llevará como parámetro el nombre y apellidos del artista'
BEGIN 
	SELECT a.* FROM ANIMALES a INNER JOIN ANIMALES_ARTISTAS aa ON a.nombre = aa.nombre_animal 
	INNER JOIN ARTISTAS ar ON aa.nif_artista = ar.nif 
	WHERE ar.nombre = nom AND ar.apellidos = ape;
END$$ 
DELIMITER ;

CALL artistas_getAnimalesPorNombreApel('Luis', 'Sanchez');

-- EJER 03: Crea un procedimiento de nombre atracciones_getListConAntiguedad que devuelva los
--  datos de las atracciones que hayan comenzado hace un número de años con respecto a la fecha actual.
-- Tendrás que hacer uso de alguna de las funciones Date Time. Intenta averiguar cual.

DELIMITER $$ 
CREATE PROCEDURE atracciones_getListConAntiguedad(anio INTEGER)
BEGIN
    SELECT *
    FROM ATRACCIONES
    WHERE YEAR (fecha_inicio) > (YEAR(fecha_inicio)-anio)
    ORDER BY nombre;
END$$
DELIMITER ;

CALL atracciones_getListConAntiguedad(1);


-- EJER 04: Crea un procedimiento de nombre artistas_getListMasAnimalesCuida que devuelva
-- los datos del/os artista/s que cuidan a más animales de los indicados (parámetro que se le envía).
-- Los parámetro de entra son un numero de animales;

DELIMITER $$ 
CREATE PROCEDURE p_artistas_getListMasAnimalesCuida (num INT)
COMMENT 'Saca a los cuidadores que cuida más animales que los indicados'
BEGIN 
	SELECT * 
	FROM ARTISTAS a 
	WHERE nif IN (SELECT nif_artista FROM ANIMALES_ARTISTAS
					GROUP BY nif_artista 
					HAVING COUNT(*) > num)
	ORDER BY nif;
END$$
DELIMITER ;

CALL p_artistas_getListMasAnimalesCuida(2);

SELECT nif_artista, COUNT(*)  FROM ANIMALES_ARTISTAS
					GROUP BY nif_artista 
					HAVING COUNT(*) > 1

-- EJER 05: Crea un procedimiento de nombre atracciones_getListPorFecha que devuelva
-- los datos de las atracciones que han comenzado a partir de la fecha indicada.

-- consideraciones: se mostraran las atracciones que desde la fecha indicada hasta la actualidad 
-- se han iniciado. El parámetro de entrada será con el formato fecha 'año-mes-dia'

DELIMITER $$ 
CREATE PROCEDURE p_atracciones_getListPorFecha (fecha DATE)
BEGIN 
	SELECT * FROM ATRACCIONES a WHERE fecha_inicio >= fecha;
END$$

DELIMITER ;

CALL p_atracciones_getListPorFecha ('2002-02-02');
CALL p_atracciones_getListPorFecha(DATE_SUB(curdate(), INTERVAL 3 DAY));

-- EJER 06: Crea un procedimiento de nombre pistas_add y que añada una nueva pista.


DELIMITER $$ 
CREATE PROCEDURE p_pistaAdd (name VARCHAR(50), X INT)
COMMENT 'Añade una nueva pista'
BEGIN 
	INSERT INTO PISTAS VALUES (name, X);
	SELECT ROW_COUNT();
END$$
DELIMITER ;

CALL p_pistaAdd ('GATOS', 20000);


-- EJER 07: Crea un procedimiento de nombre atracciones_update que permita modificar
-- los datos de una atracción (no se permite actualizar su clave primaria).
-- Modifica la fecha de inicio de la atracción 'El gran felino' y ponla un día
-- después de la que tiene ahora mismo.

DELIMITER $$ 
CREATE PROCEDURE p_atraccionesUpdate (name VARCHAR(50), fecha DATE, ganancia DECIMAL(8,2))
COMMENT 'permite la actualizavion de los datos de la tahla atracciones, los parametros son de entrada'
BEGIN 
	UPDATE ATRACCIONES 
	SET fecha_inicio = fecha,
		ganancias = ganancia 
	WHERE nombre = name;
	 SELECT ROW_COUNT();
END$$ 
DELIMITER ;

CALL p_atraccionesUpdate('El gran felino',DATE_ADD(@fecha_inicio,INTERVAL 1 DAY),@ganancias);


CALL p_atraccionesUpdate('El gran felino_no_existe','1890-01-03',1000.34);


-- EJER 08: Crea un procedimiento de nombre pistas_delete que borre una pista por su nombre.
-- Haz que borre en base al patrón nombre% (empleando el Like).

DELIMITER $$
CREATE PROCEDURE p_pistasDelete (name VARCHAR(50))
COMMENT 'Borra las pistas indicando su nombre como parametro'
BEGIN 
	DELETE FROM PISTAS 
	WHERE nombre LIKE CONCAT(nombre,'%');
END$$
DELIMITER ;

CALL p_pistasDelete ('GATO');


