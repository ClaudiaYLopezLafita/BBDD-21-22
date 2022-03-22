USE CIRCO;

-- EJER 01: Crea una función de nombre utilidades_getMesEnLetra a la que se le pase un número
-- y devuelva el nombre del mes. En caso de que el número no se corresponda con ningún mes,
--  debe devolver null.

DELIMITER $$
CREATE FUNCTION utilidades_getMesEnLetra (mes INTEGER )
RETURNS VARCHAR(10) DETERMINISTIC 
    COMMENT 'Devuelve el nombre del mes que corresponde con su numero de mes'
BEGIN
	DECLARE name_mes varchar(10);		-- Valor por defecto NULL

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

SELECT utilidades_getMesEnLetra(5);

-- Llama a la función directamente y guarda el resultado en una variable de sesión.
SET @mes = utilidades_getMesEnLetra(10);
SELECT @mes;

-- Llama a la función para que muestre los meses en letra en los que se celebró la atracción 'El gran felino'.
SELECT DISTINCT MONTH(fecha) as mesNumero, utilidades_getMesEnLetra(MONTH(fecha)) as mesCadena
FROM ATRACCION_DIA
WHERE nombre_atraccion='El gran felino'
ORDER BY mesNumero;

-- Llama a la función para que muestre las atracciones que se celebraron en ABRIL (busca por la cadena ABRIL
SELECT * FROM ATRACCION_DIA 
WHERE utilidades_getMesEnLetra(MONTH(fecha)) = 'ABRIL' COLLATE 'utf8mb4_spanish2_ci'
ORDER BY nombre_atraccion, fecha;


-- EJER 02:  Modifica un ejercicio anterior en el que creamos el procedimiento de nombre
-- 'atracciones_getNumPorMes' y crea una función de nombre utilidades_getMesEnNumero a la
-- que se le pase el nombre de un mes y devuelva el número que se corresponde con ese nombre.
-- Si el mes no existe debe devolver -1. Modifica el procedimiento para que haga uso de la función.

ELIMITER $$
CREATE FUNCTION utilidades_getMesEnNumero (mes varchar(10))
RETURNS INTEGER DETERMINISTIC		 
    COMMENT 'Devuelve el número de mes que se corresponde con el nombre del mes'
BEGIN
	DECLARE numMes int default -1; -- Valor por defecto de -1 para el caso de enviar un mes que no exista

	CASE mes
		WHEN 'ENERO' THEN SET numMes = 1;
		WHEN 'FEBRERO' THEN	SET numMes = 2;
		WHEN 'MARZO' THEN SET numMes = 3;
		WHEN 'ABRIL' THEN SET numMes = 4;
		WHEN 'MAYO' THEN SET numMes = 5;
		WHEN 'JUNIO' THEN SET numMes = 6;
		WHEN 'JULIO' THEN SET numMes = 7;
		WHEN 'AGOSTO' THEN SET numMes = 8;
		WHEN 'SEPTIEMBRE' THEN SET numMes = 9;
		WHEN 'OCTUBRE' THEN SET numMes = 10;
		WHEN 'NOVIEMBRE' THEN SET numMes = 11;
		WHEN 'DICIEMBRE' THEN SET numMes = 12;
	END CASE;
	
	RETURN numMes;
END $$
DELIMITER ;

SELECT utilidades_getMesEnNumero('FEBRERO');

/*
 *EJER 03:  Crea una función de nombre animales_getEstadoPorAnhos que devuelva la cadena:

Si tipo = León
anhos < 2: 'JOVEN'
anhos >=2 y <=5: 'MADURO'
anhos > 5: 'VIEJO'

Cualquier otro tipo:
anhos < 1: 'JOVEN'
anhos >=1 y <=3: 'MADURO'
anhos > 3: 'VIEJO'
 */

DELIMITER $$
CREATE FUNCTION animales_getEstadoPorAnios (tipo varchar(9), anios INTEGER )	
RETURNS VARCHAR (6)	DETERMINISTIC
    COMMENT 'Devuelve una cadena indicativa de la edad en función de la edad y tipo de animal'
BEGIN
	DECLARE edad VARCHAR (6) default '';

	IF (tipo='León') THEN
		CASE 
			WHEN anios < 2 THEN SET edad = 'JOVEN';
			WHEN anios >= 2 AND anios <= 5 THEN SET edad = 'MADURO';
			WHEN anios > 5 THEN SET edad = 'VIEJO';
		END CASE;
    ELSE
		CASE
			WHEN anios < 1 THEN SET edad = 'JOVEN';
			WHEN anios >= 1 AND anios <= 3 THEN SET edad = 'MADURO';
			WHEN anios > 3 THEN SET edad = 'VIEJO';
		END CASE;
    END IF;

	RETURN edad;
END $$
DELIMITER ;

SELECT *,animales_getEstadoPorAnios(tipo,anhos) as ClasificacionEdad
FROM ANIMALES
ORDER BY nombre;


/*
 * EJER 04: Crea una función de nombre pistas_getDiferenciaAforo al que se le pase el nuevo
 *  aforo de una pista y devuelva la diferencia entre el aforo nuevo y el aforo anterior.
 * 
Si la diferencia < 100 debe devolver la cadena 'PEQUEÑA menor que 100'
Si la diferencia está entre 100 y 500 debe devolver la cadena 'REGULAR entre 100 y 500'
Si la diferencia > 500 debe devolver la cadena 'ABISMAL mayor que 500'

	Por ejemplo: PISTA1, 150 => Si la pista tiene actualmente un aforo de 100,
	 debe devolver 150-100 = 50 => PEQUEÑA menor que 100
Si la pista no existe debe devolver null.

Acordaos de añadir los modificadores adecuados a la creación de la función.
 */

DELIMITER $$
CREATE FUNCTION pistas_getDiferenciaAforo (nombrePista varchar(50), aforo smallint)
RETURNS varchar(100) DETERMINISTIC
    COMMENT 'Devuelve la diferencia entre el nuevo aforo y el antiguo'
BEGIN
    DECLARE aforoAntiguo smallint default -1;
    DECLARE cadena varchar(100) default 'No existe esta pista';
    DECLARE diferenciaAforo smallint default 0;

    SELECT aforo
    INTO aforoAntiguo -- a la varible aforoAntiguo le asigno el aforo de la pista que me interesa
    FROM PISTAS
    WHERE nombre = nombrePista;
    
    IF (aforoAntiguo=-1) THEN	-- en caso de que la pista no exista devucel cadena que esta vacia
        RETURN cadena;
    END IF;
    
    SET diferenciaAforo = aforo-aforoAntiguo;
    CASE 
        WHEN diferenciaAforo < 100 THEN 
            SET cadena = 'PEQUEÑA menor que 100';
        WHEN diferenciaAforo >= 100 AND diferenciaAforo <= 500  THEN 
            SET cadena = 'REGULAR entre 100 y 500';
        WHEN diferenciaAforo > 500 THEN 
        SET cadena = 'ABISMAL mayor que 500';
    END CASE;
    
   RETURN cadena;

END $$
DELIMITER ;

SELECT *,pistas_getDiferenciaAforo(nombre,600) as estado
FROM PISTAS
ORDER BY nombre;

use CIRCO ;
-- EJER 05: Crea una función de nombre pistas_getNumAtracciones que dada una pista
-- devuelva el número de veces que se celebró cada atraccion.
-- Llama a dicha función por cada una de las pistas.

DELIMITER $$ 
CREATE FUNCTION pistas_getNumAtracciones (name VARCHAR(50))
RETURNS INT DETERMINISTIC 
COMMENT 'Numero de atracciones que se han realizados en una pista dada'
BEGIN 
	DECLARE v_cantidad INT DEFAULT 0;
	
	SELECT COUNT(*) INTO v_cantidad  
	FROM PISTAS p INNER JOIN ANIMALES a 
					ON p.nombre = a.nombre_pista
	WHERE p.nombre = name;
	RETURN (v_cantidad);			
END$$
DELIMITER ;

SELECT pistas_getNumAtracciones ('LATERAL2')

/* con unir pista con animales podemos ver las atraccciones que realizar y realizar un coun de las mismas
 * por el nombre de la pisya,. 
SELECT COUNT(*)  FROM PISTAS p INNER JOIN ANIMALES a 
						ON p.nombre = a.nombre_pista
WHERE p.nombre = 'LATERAL1'*/ 


-- EJER 06: Crea una función de nombre atracciones_getListEntreFechas que muestre las
-- atracciones que se celebraron entre dos fechas dadas, y devuelva el número
-- de atracciones que se celebraron.

-- Se debe comprobar que las fechas tienen el formato correcto y que primero se envía
-- la fecha menor. En caso contrario debe mostrar un mensaje explicando el error
--  y debe devolver el valor -1.

DELIMITER $$ 

CREATE FUNCTION atracciones_getListEntreFechas(x DATE, y DATE)
RETURN INTEGER DETERMINISTIC
BEGIN 
	DECLARE fechaOk BOOLEAN;
	DECLARE ordenFecha BOOLEAN ;
	
	IF date_format(fecha, "%Y-%m-%d") THEN
		fechaOk SET TRUE;
	ELSE 
		fechaOk SET FALSE;
	END IF;
	
	IF DATEDIFF(x, y) > 0 THEN
		ordenFecha SET TRUE;
	ELSE 
		ordenFecha SET FALSE;
	END IF;
	
	IF (fechaOk = TRUE AND ordenFecha = TRUE)  THEN 	
		
	ELSE 
		RETURN -1
	END IF;
		
END $$ 
DELIMITER ;

SELECT COUNT(*)
FROM ATRACCION_DIA ad 
WHERE ad.fecha BETWEEN ('1999-11-01','2000-01-01')
GROUP BY fecha ;

USE CIRCO;


-- EJER 07: Crea una función de nombre artistas_getNumAnimales al que
-- se le pase el nif de un artista y devuelva a cuantos animales cuida.
-- En caso de que no exista el artista debe devolver -1.

DELIMITER $$ 
CREATE FUNCTION artistas_getNumAnimales (nif CHAR(9))
RETURNS INT DETERMINISTIC 
COMMENT 'Devuelve la cantidad de animales que cuida una artista'
BEGIN 
	DECLARE v_salida INT DEFAULT 0;
	DECLARE v_existeArtista INT DEFAULT 0;

	SELECT COUNT(*) INTO v_existeArtista 
	FROM ARTISTAS a
	WHERE a.nif = nif;

	IF v_existeArtista = 0 THEN
		SET v_salida = -1;
	ELSE 
		SET v_salida = ( SELECT COUNT(aa.nombre_animal)
		FROM  ANIMALES_ARTISTAS aa 
		WHERE aa.nif_artista = nif );
	END IF;

	RETURN (v_salida);
END$$ 
DELIMITER ;

SELECT artistas_getNumAnimales ('77111111A');

/*Select unicamente en la table animales-artistas dado que ahi se puede hacer un count con los datos que nos interesa.
 * SELECT COUNT(aa.nombre_animal) 
FROM  ANIMALES_ARTISTAS aa 
WHERE aa.nif_artista = '22222222B'*/


/*
 * EJER 08: Crea una función de nombre utilidades_getEstacionPorMes que en
 *  función del mes que se le envíe como dato, devuelva al estación en la que se encuentre.

Llama a dicha función con el valor 7 y guarda el resultado en una variable de sesión. Muestra su valor.
Muestra las atracciones que empezaran en PRIMAVERA (tabla ATRACCIONES).
Muestra las ganancias por estación.
 */

DROP FUNCTION utilidades_getEstacionPorMes;

DELIMITER $$ 
CREATE FUNCTION utilidades_getEstacionPorMes (mes INT)
RETURNS VARCHAR(50) DETERMINISTIC 
BEGIN 
	DECLARE estacion varchar(10) DEFAULT -1;		

	CASE mes
		WHEN 1 THEN SET estacion = 'INVERNO';
		WHEN 2 THEN	SET estacion = 'INVERNO';
		WHEN 3 THEN SET estacion = 'PRIMAVERA';
		WHEN 4 THEN SET estacion = 'PRIMAVERA';
		WHEN 5 THEN SET estacion = 'PRIMAVERA';
		WHEN 6 THEN SET estacion = 'VERANO';
		WHEN 7 THEN SET estacion = 'VERANO';
		WHEN 8 THEN SET estacion = 'VERANO';
		WHEN 9 THEN SET estacion = 'OTOÑO';
		WHEN 10 THEN SET estacion = 'OTOÑO';
		WHEN 11 THEN SET estacion = 'OTOÑO';
		WHEN 12 THEN SET estacion = 'INVERNO';
	END CASE;
	RETURN estacion ;
END$$
DELIMITER ;

SELECT utilidades_getEstacionPorMes (7);

-- Muestra las atracciones que empezaran en PRIMAVERA (tabla ATRACCIONES).

SELECT * FROM ATRACCIONES
WHERE fecha_inicio IS NOT NULL AND
utilidades_getEstacionPorMes (MONTH(fecha_inicio)) = 'PRIMAVERA' COLLATE 'utf8mb4_spanish2_ci'
ORDER BY nombre, fecha_inicio ;















