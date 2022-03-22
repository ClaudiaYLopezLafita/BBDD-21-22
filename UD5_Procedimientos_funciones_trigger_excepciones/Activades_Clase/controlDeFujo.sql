USE CIRCO;

-- ------------- INSTRUCCIONES REPETITIVAS --------- 

/*EJERCICIO 01:
 * Crea un procedimiento de nombre pistas_getSumAforo que devuelva en forma de parámetro de
 *  salida la suma de los aforos de las pistas enviadas como parámetro. 
 * El formato de la lista de pistas es una única cadena: 'pista1,pista2,pista3,....'
 * Deberás, empleando la función SUBSTRING y LOCATE, descomponer el dato en cada una de las pistas
 *  y buscar el aforo de cada una de ellas, devolviendo la suma de los aforos de todas.
 * En case de que alguna pista no exista, deberás de mostrar la cadena 'La pista ZZZZZZ no existe' 
 * por cada pista que no exista.
 * Debemos de controlar que al menos siempre se envíe una pista.
 *  En caso contrario debe de enviarse -1 en el parámetro de salida (emplea la función CHAR_LENGTH).
*/

DELIMITER $$ 
CREATE PROCEDURE pistas_getSumAforo (pista VARCHAR(90), OUT sumaAforo INT)
COMMENT 'Devuelve la suma de los aforos de pistas indicadas'
label_getSumAforo: BEGIN 
	DECLARE v_index,v_pos smallint default 1;
    DECLARE v_aforo smallint;		-- El tipo coincide con el declarado en la tabla
    DECLARE v_nombrePista varchar(50);	-- El tipo coincide con el declarado en la tabla

    SET p_sumaAforo = 0;		-- Por defecto vale null. Como vamos ir acumulando el aforo 
    -- en esta variable no podemos sumar un valor null. Por eso le damos un valor inicial
    
    IF (CHAR_LENGTH(p_pistas)=0) THEN
        SET p_sumaAforo = -1;
        LEAVE label_getSumAforo;
    END IF;
    
    WHILE (v_pos <> 0) DO   -- La función LOCATE devuelve 0 si no encuentra la cadena a buscar 
    -- (la coma que separa cada pista).
        SELECT LOCATE(',',p_pistas,v_index)
        INTO v_pos;
        IF (v_pos <> 0) THEN	-- Encuentra una coma
            SELECT SUBSTRING(p_pistas,v_index,v_pos-v_index)
            INTO v_nombrePista;
            
            set v_index = v_pos+1;
        ELSE    -- Falta la última pista con contar ya que no lleva coma al final
            SELECT SUBSTRING(p_pistas,v_index)
            INTO v_nombrePista;
        END IF;
        
        SET v_aforo = null; -- Para comprobar si la pista existe, podríamos hacer un count(*)
        --  buscando por la pista
                            -- Pero de esta forma nos ahorramos una consulta. Si la pista no
                            -- existe el valor de la variable seguirá valiendo NULL
                            -- En SQL Server podemos hacer uso de la variable @@ROWCOUNT
        SELECT aforo
        INTO v_aforo
        FROM PISTAS
        WHERE nombre = v_nombrePista;
        
        IF (v_aforo IS NULL) THEN 	-- Pista no encontrada
            SELECT CONCAT('La pista ',v_nombrePista,' no existe');
        ELSE
            SET p_sumaAforo = p_sumaAforo + v_aforo;
        END IF;
        
    END WHILE;
END$$
DELIMITER ;

CALL animales_getSumAforo('LATERAL1,LATERAL2,NO EXISTE',@aforo);  -- Una de las pistas no existe
SELECT @aforo;

CALL animales_getSumAforo('SUPER',@aforo);   -- Devuelve el aforo de SUPER
SELECT @aforo;

CALL animales_getSumAforo('',@aforo);   -- Devuelve -1
SELECT @aforo;



/*EJER 02
 * Crea un procedimiento de nombre atracciones_getGananciasSupuestas en el que se le pase 
 * como datos el nombre de una atracción y 2 números. Deberá de mostrar los días en los que
 *  se celebró la atracción junto con su número de espectadores y ganancia así como las ganancias
 *  que tendríamos si la entrada costara diferentes precios. Los precios deben variar desde
 *  el primer número enviado hasta el segundo, con una diferencia de 5 euros entre ellos.
 *  Es decir, si envío los datos 'pista1',20,30 deberá mostrar que ganancia tenemos con
 *  un precio de entrada de 20,25 y 30 (se debe mostrar cada precio en una nueva consulta,
 *  es decir, una consulta mostrará 'atraccion1', 100, 3000 (estos serían los datos actuales),
 *  20x100 (con un precio de 20 euros por entrada), la siguiente consulta debe mostrar lo mismo
 *  pero con 25x100 y la tercera consulta debe mostrar lo mismo pero 30x100).
 * Debes controlar que los números enviados sean múltiplo de 5 y que el segundo es
 *  mayor que el primero. Si no se cumplen las condiciones, debe mostrar un texto aclarando el error.
 * En caso de que la atracción no exista o que la atracción existe pero no ha tenido representaciones,
 *  también debe informar del error.
 */

DELIMITER $$ 
CREATE PROCEDURE atracciones_getGananciasSupuestas (pista VARCHAR(50), minimo INT, maximo INT )
COMMENT 'mostrar los días en los quese celebró la atracción junto con su número de espectadores
 y ganancia así como las ganancias'
label_getGananciaSupuestas: BEGIN 
	 DECLARE v_precio tinyint default 0;
    DECLARE v_atraccionExiste tinyint;	-- Para comprobar si la atraccion existe

    SELECT COUNT(*)			-- Comprobamos si la atraccion existe
    INTO v_atraccionExiste
    FROM ATRACCIONES
    WHERE nombre = p_nombreAtraccion;
    IF (v_atraccionExiste=0) THEN
        SELECT 'La atracción no existe';
        LEAVE label_getGananciasSupuestas; 
    END IF;

    SELECT COUNT(*)			-- Comprobamos si tiene alguna atraccion
    INTO v_atraccionExiste
    FROM ATRACCION_DIA
    WHERE nombre_atraccion = p_nombreAtraccion;
    IF (v_atraccionExiste=0) THEN
        SELECT 'La atracción no ha celebrado ninguna actuación';
        LEAVE label_getGananciasSupuestas; 
    END IF;

    IF (p_precioInferior > p_precioSuperior) THEN
        SELECT 'El precio inferior no puede ser superior al segundo número';
        LEAVE label_getGananciasSupuestas;
    END IF;
    IF ((p_precioInferior % 5)<>0 OR (p_precioSuperior%5)<>0) THEN
        SELECT 'Los dos números deben ser múltiplos de 5';
        LEAVE label_getGananciasSupuestas;
    END IF;
    
    SET v_precio = p_precioInferior;
    REPEAT
        SELECT nombre_atraccion, num_espectadores, ganancias, num_espectadores*v_precio as gananciaSimulada
        FROM ATRACCION_DIA
        WHERE nombre_atraccion = p_nombreAtraccion;
        
        SET v_precio = v_precio + 5;    
    UNTIL v_precio > p_precioSuperior
    END REPEAT;
END$$
DELIMITER ;


CALL atracciones_getGananciasSupuestas('El orangután',12,20);  
CALL atracciones_getGananciasSupuestas('El orangután',10,20); 
CALL atracciones_getGananciasSupuestas('El gran felino',10,20);  



/* EJER 03
 * Crea un procedimiento de nombre utilidades_getNumImpares al que se le pasen tres números 
 * y devuelva en forma de parámetro de salida cuanto números hay entre los dos primeros
 *  números que son divisibles por el tercero. Se deben incluir los dos primeros números 
 * a la hora de contar. No importa el orden en el que se envíen los dos primeros números.

Por ejemplo: 5,1,2 => Busca los números múltiplos de 2 entre 1 y 5 (inclúidos) => Mostrará: 2
 */

DELIMITER $$
CREATE PROCEDURE utilidades_getNumImpares (p_numero1 int, p_numero2 int,p_multiplo int, OUT p_numMultiplos int)		
COMMENT 'Muestra cuanto números múltiplos por el tercer número hay entre los 
dos primeros (incluidos los dos números enviados)'
BEGIN
    DECLARE v_temporal int default 0;
    
    IF (p_numero1 > p_numero2) THEN		-- Intercambiamos los números si el segundo es inferior al primero
        SET v_temporal = p_numero2;
        SET p_numero2 = p_numero1;
        SET p_numero1 = v_temporal;
    END IF;
    
    SET p_numMultiplos = 0;
    
    etiqueta_bucle: LOOP	-- Probamos con LOOP. Valdría WHILE o REPEAT
        IF (p_numero1%p_multiplo=0) THEN 		-- Es un número IMPAR
            SET p_numMultiplos = p_numMultiplos + 1;
        END IF;
        SET p_numero1 = p_numero1 + 1;
        IF (p_numero1 > p_numero2) THEN
            LEAVE etiqueta_bucle;
        END IF;
    END LOOP;
END $$
DELIMITER ;


-- ----------- INSTRUCCIONES CONDICIONALES -------


/* EJERCICIO 01
 * Crea un procedimiento de nombre pistas_getAnimales que devuelva los animales (nombre, peso y anhos) 
 * que trabajen en la pista indicada. En caso de que no haya animales deberá devolver SIN ANIMALES
 *  y en el caso de que no exista la pista, ESA PISTA NO EXISTE.
 */

DELIMITER $$
CREATE PROCEDURE pistas_getListAnimales(p_nombrePista varchar(50))		
    COMMENT 'Devuelve los animales (nombre, peso y edad) que trabajen en la pista indicada.'
BEGIN
    DECLARE v_result int; -- reutilizaremos la variable
    
    SELECT COUNT(*) -- compruebo que la pista existe
    INTO v_result
    FROM PISTAS
    WHERE nombre = p_nombrePista;
    
    if (v_result=0) THEN
        SELECT 'La pista no existe';
    ELSE
        SELECT COUNT(*) -- cuento los animales que hay en la pista de interes
        INTO v_result
        FROM ANIMALES
        WHERE nombre_pista = p_nombrePista;
        
        IF (v_result =0) THEN
            SELECT 'Pista sin animales';
        ELSE
            SELECT nombre, peso, anhos
            FROM ANIMALES
            WHERE nombre_pista = p_nombrePista
            ORDER BY nombre;
        END IF;
    END IF;
    
END$$
DELIMITER ;

CALL pistas_getListAnimales('NOEXISTE'); -- Pista que no existe
CALL pistas_getListAnimales('La grande'); -- Pista sin animales
CALL pistas_getListAnimales('LATERAL1');  -- Pista con aniamles


/*EJER 02:
 * Crea un procedimiento de nombre atracciones_getNumeroPorFecha que devuelva el
 *  número de atracciones que se celebraron en la fecha indicada. En caso de que
 *  no hubiera atracciones ese día debe devolver el número -1.

Haz dos variantes de este ejercicio. Una en la que la información se devuelva
 en un SELECT y otra en la que se emplee un parámetro de salida.
 */


DROP PROCEDURE IF EXISTS atracciones_getNumeroPorFecha;
DELIMITER $$
CREATE PROCEDURE atracciones_getNumeroPorFecha(fecha date)		
    COMMENT 'Devuelve el número de atracciones que se celebraron en la fecha indicada.
 En caso de que no hubiera atracciones ese día debe devolver el número -1.'
BEGIN
   	DECLARE 
   	SELECT COUNT(*)
    INTO v_numAtrac
    FROM ATRACCION_DIA
    WHERE fecha = fecha;
    
    if (v_numAtrac=0) THEN
        SELECT -1;
    ELSE
        SELECT v_numAtrac;
    END IF;
    
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS atracciones_getNumeroPorFecha2;
DELIMITER $$
CREATE PROCEDURE atracciones_getNumeroPorFecha(fecha date)		
    COMMENT 'Devuelve el número de atracciones que se celebraron en la fecha indicada.
 En caso de que no hubiera atracciones ese día debe devolver el número -1.'
BEGIN
    DECLARE v_numAtrac int;		
    
    SELECT IF(COUNT(*)>0,COUNT(*),-1)		-- Simplificamos el código con la función IF
    FROM ATRACCION_DIA
    WHERE fecha = fecha;

END$$
DELIMITER ;

CALL atracciones_getNumeroPorFecha('2001-04-01');		-- Hay atracciones
CALL atracciones_getNumeroPorFecha('2001-05-01');		-- No hay atracciones

CALL atracciones_getNumeroPorFecha2('2001-04-01');		-- Hay atracciones
CALL atracciones_getNumeroPorFecha2('2001-05-01');		-- No hay atracciones



/* EJER 03
 * Crea un procedimiento de nombre animales_updateCuidador al que se le pase el nombre de
 *  un animal y si dicho animal no está cuidado por un artista (table ANIMALES_ARTISTAS)
 *  deben ser asignados al cuidador que cuide a menos animales. El procedimiento debe
 *  devolver con un parámetro de salida el nif del cuidador al que se le ha asignado
 *  al animal y en forma de registro (con un SELECT) a cuantos animales está cuidando,
 *  contando el actual, tiene asignados el cuidador. En caso de que el animal no exista,
 *  el nif tendrá de valor y el select mandará -1. En caso de que ya tenga cuidador,
 *  se devolverá el nif del cuidador actual y 0 en el SELECT.
 */

DELIMITER $$
CREATE PROCEDURE animales_updateCuidador(p_nombreAnimal varchar(50), OUT p_nifCuidador char(9))		
    COMMENT 'Asigna un cuidador (el que tenga menos animales asignados) a un animal.
 Devuelve el nif del cuidador'
BEGIN
    DECLARE v_numAnimalesAsignados int;
    
    SET p_nifCuidador = '';	-- Valor por defecto
    
    IF (SELECT COUNT(*)
        FROM ANIMALES
        WHERE nombre = p_nombreAnimal)=0 THEN       -- El animal no existe

        SELECT -1;
    ELSE
        SELECT nif_artista
        INTO p_nifCuidador
        FROM ANIMALES_ARTISTAS
        WHERE nombre_animal = p_nombreAnimal
        LIMIT 1;  -- Puede haber varios artistas cuidando de un mismo animal

        IF (p_nifCuidador = '') THEN  -- No tiene cuidador actual ya que no encontró 
        -- cuidador y por tanto mantiene el valor asignado previamente
            -- Buscamos el cuidador que tiene menos animales asignados.
            SELECT nif_artista,COUNT(*) as numero
            INTO p_nifCuidador,v_numAnimalesAsignados
            FROM ANIMALES_ARTISTAS
            GROUP BY nif_artista
            ORDER BY numero ASC
            LIMIT 1;

            INSERT INTO ANIMALES_ARTISTAS (nombre_animal,nif_artista)
            VALUES (p_nombreAnimal,p_nifCuidador);
            
            SET v_numAnimalesAsignados = v_numAnimalesAsignados +1;
            SELECT v_numAnimalesAsignados;
            
        ELSE    -- Tiene cuidador y está guardado en p_nifCuidador
            SELECT 0;
        END IF;
    END IF;
    
END$$
DELIMITER ;

ALL animales_updateCuidador('NO EXISTE',@nifCuidador);  -- Animal que no existe
SELECT @nifCuidador;

CALL animales_updateCuidador('Caiman',@nifCuidador);    -- Animal con cuidadores ya asignados
SELECT @nifCuidador;

CALL animales_updateCuidador('Sant',@nifCuidador);       -- Nuevo animal añadido de nombre Sant, 
-- se asigna al nif 44444444D
SELECT @nifCuidador;

-- -----
/*EJER 04
 * Crea un procedimiento de nombre atracciones_getCantidadPorFechas al que se le pase dos fechas 
 * y devuelva en forma de parámetro de salida, el número de atracciones celebradas entre las dos
 *  fechas indicadas (incluídas ambas). En caso de que el formato de las fechas no sea correcto
 *  (por ejemplo, enviamos 1990-45-66) o que la primera fecha sea mayor que la segunda,
 *  en el parámetro devolverá -1 y mostrará la cadena FECHAS INCORRECTAS. En el caso de que no
 *  haya atracciones entre las fechas indicadas el parámetro de salida debe devolver 0 y mostrar
 *  la cadena SIN ATRACCIONES ENTRE LAS FECHAS INDICADAS.
 * Para chequear que las fechas tengan un formato correcto podéis emplear la función DATE que
 *  aplicada a una fecha devolverá null si la fecha no tiene un formato correcto.
 */
DROP PROCEDURE atracciones_getCantidadPorFechas;

/* 
 * Lo que dice de usar el DATE para ver si se tiene el formato correcto dentro del procedure esta bien
 * , pero los parametros no pueden ser DATE, debido a que al tener un formato incorrecto casca,
 * entonces se ha optado por poner pNombre de fecha de tipo VARCHAR(50) para evitar este casque
 * Se ha creado las variables fechaIn y fechaF de tipo Date, estas variables cogeran los valores
 * de DATE(pfechaIn) y DATE(pfechaF) en el caso de que ambos valores sean diferentes de null
 */
DELIMITER $$ 
CREATE PROCEDURE atracciones_getCantidadPorFechas(pfechaIn VARCHAR(50), pfechaF VARCHAR(50))
COMMENT 'Devulve el numero de atracciones dadas entre las dos fechas'
BEGIN 
	DECLARE fechaIn DATE;
	DECLARE fechaF DATE;
	DECLARE v_fechaOk INT DEFAULT 0;
	DECLARE v_ordenFechas INT DEFAULT 0;
	DECLARE v_numAtracciones INT DEFAULT 0;
	
	-- Si alguno de los parametros de tipo varchar de entrada no cumplen con el formato fecha v_fechaOk sera 0
	IF DATE(pfechaIn) IS NULL OR DATE(pfechaF) IS NULL THEN 
		SET v_fechaOk =0;
	ELSE 
		-- Si los dos cumplen el formato fecha. fechaIn sera igual a DATE(pfechaIn), con la fechaF igual
		SET v_fechaOk =1;
		SET fechaIn = DATE(pfechaIn);
		SET fechaF = DATE(pFechaF);
	END IF;

	-- Si las dos fechas tienen el formato correcto, aplicamos el DATEDIFF para saber si la fecha fin es mayor que la fecha inicio
	IF v_fechaOk = 1 AND DATEDIFF(fechaF, fechaIn ) > 0 THEN 
		SET v_ordenFechas  = 1;
	ELSE 
		SET v_ordenFechas  = 0;
	END IF;

    -- Si esta mal el formato fecha o el orden de la fecha imprimimos -1
	IF v_fechaOk = 0 OR v_ordenFechas = 0 THEN 
		SELECT -1;
	ELSE 
		-- Si no contamos el numero de atracciones
		SELECT COUNT(*)  INTO v_numAtracciones 
		FROM ATRACCION_DIA ad 
		WHERE ad.fecha BETWEEN fechaIn  AND fechaF ;
		
	   -- Puede que poner esto de abajo sea innecesario. ESTA BIEN PARA PROBAR
		/*IF v_numAtracciones = 0 THEN
			SELECT -1;
		ELSE
			SELECT v_numAtracciones;
		END IF;*/
	
	END IF;	

	-- Imprimimos ambos valores para ver si esta bien
	SELECT v_fechaOk, v_ordenFechas; 

	CASE
		-- En el CASE WHEN se puede poner OR
		WHEN v_fechaOk = 0 OR v_ordenFechas = 0 THEN
			-- Esto de abajo es control de errores
			SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT='FECHA INCORRECTA';
		
        -- Se puede poner otro WHEN para otra variable con condicion tal y como se ve aqui
        -- Al final va un ELSE
        WHEN v_numAtracciones = 0 THEN 
        	SELECT 0;
   			SIGNAL SQLSTATE '45100' 
                SET MESSAGE_TEXT='NO HAY ATRACCIONES';
        ELSE 
        	-- En el case WHEN se pone ELSE con un SELECT (en el caso de que sea necesario el Select)
        	-- Se puede poner solamente ELSE      BEGIN END;    END CASE;    en el caso de que no sea necesario SELECT
			
        	-- Como en este caso, cuando no cumple ninguno de los WHEN hay que imprimir el v_numAtracciones se pone el ELSE con el SELECT
        	SELECT v_numAtracciones;
        -- En CASE WHEN Al final del todo se pone BEGIN END; END CASE;
       BEGIN END;
    END CASE;

END$$ 
DELIMITER ;

CALL atracciones_getCantidadPorFechas ('1955-90-90', '2000-03-01');
CALL atracciones_getCantidadPorFechas ('2000-03-01', '1999-11-01');
CALL atracciones_getCantidadPorFechas ('1999-11-01', '2000-03-01');

SELECT DATE('1955-90-90');
select date('1999-01-01');

SELECT COUNT(*)  
FROM ATRACCION_DIA ad 
WHERE ad.fecha BETWEEN '1999-11-01' AND '2000-03-01';

SELECT DATEDIFF('2002-02-01','2001-11-01');
SELECT DATE('2002-02-01');

/* EJER 05
 * Crea un procedimiento de nombre de nombre pistas_getListPorAforo al que se
 *  le pase un aforo y devuelva, empleando el mismo parámetro,
 *  cuantas pistas tienen un aforo superior al enviado. Al mismo tiempo
 *  debe mostrar los nombres de las pistas. En caso de que no haya pistas,
 *  debe devolver -1 y mostrar el texto SIN PISTAS.
 */

DELIMITER $$ 
CREATE PROCEDURE pistas_getListPorAforo (aforo INT)
BEGIN 
	DECLARE v_existePista INT DEFAULT 0;
	
	SELECT COUNT(*) INTO v_existePista 
	FROM PISTAS p 
	WHERE p.aforo = aforo;

	IF v_existePista = 0 THEN 
		SELECT '-1. SIN PISTAS';
	ELSE
		SELECT p.nombre 
		FROM PISTAS p 
		WHERE p.aforo > aforo ;
	END IF;
END$$
DELIMITER ;

CALL pistas_getListPorAforo(550);

SELECT CONCAT(*) 
FROM PISTAS p 
WHERE p.aforo > 550;

/*EJER 06: Crea un procedimiento de nombre artistas_getListPorAtraccion al que se
 *  le pase un nif de un artista y dos fechas y devuelva en forma de parámetro
 *  de salida, en cuantas atracciones trabajó ese artista entre las dos fechas indicadas.

EXACEPCIONES: En caso de que el artista no exista, el parámetro de salida debe devolver -1
y mostrar la cadena NO EXISTE ESE ARTISTA.
En caso de que las fechas no tenga un formato correcto, el parámetro de salida
 debe devolver -1 y mostrar la cadena FECHAS INCORRECTAS.
Si existe el artista y hay atracciones, el procedimiento también debe mostrar
 el nombre de las atracciones (sin repetirse) ordenadas alfabéticamente.
 */

DELIMITER $$ 
CREATE PROCEDURE artistas_getListPorAtraccion(nif VARCHAR(9), fechaIni DATE, fechaFin DATE)
COMMENT 'Devuelve la cantidad de atracciones donde trabajo en artistas entre dichas fechas'
BEGIN 
	DECLARE v_existeArt INT DEFAULT 0;
	DECLARE v_fechaOk BOOLEAN;
		
	SELECT COUNT(*) INTO v_existeArt  
	FROM ARTISTAS a 
	WHERE a.nif = nif;
	
	IF date_format(fechaIni, "%Y-%m-%d") OR DATE_FORMAT(fechaFin, "%Y-%m-%d")  THEN
		SET v_fechaOk = TRUE;
	ELSE 
		SET v_fechaOk = FALSE;
	END IF;

	IF v_existeArt = 0 THEN 
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT='NO EXISTE EL ARTISTA';
	ELSEIF v_fechaOk = FALSE THEN 
		-- SELECT -1	
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT='FECHA INCORRECTA';
	ELSE 
		SELECT DISTINCT aa.nombre_atraccion 
		FROM ARTISTAS a INNER JOIN ATRACCIONES_ARTISTAS aa 
		ON a.nif = aa.nif_artista 
		WHERE a.nif = nif  AND aa.fecha_inicio BETWEEN fechaIni  AND  fechaFin 
		ORDER BY aa.nombre_atraccion ASC;	
	END IF;
END$$
DELIMITER ;

CALL artistas_getListPorAtraccion ('33333333C', '1999','2000-03-04')

SELECT DISTINCT aa.nombre_atraccion 
FROM ARTISTAS a INNER JOIN ATRACCIONES_ARTISTAS aa 
ON a.nif = aa.nif_artista 
WHERE a.nif = '33333333C' AND aa.fecha_inicio BETWEEN '1999-01-11' AND  '2001-04-01'
ORDER BY aa.nombre_atraccion ASC;


-- 

/* 
 * Crea un procedimiento de nombre pistas_getSumAforo que devuelva en
 *  forma de parámetro de salida la suma de los aforos de las pistas 
 * enviadas como parámetro. El formato de la lista de pistas es una
 *  única cadena: 'pista1,pista2,pista3,....'
Deberás, empleando la función SUBSTRING y CHAR_LENGTH, descomponer el dato
 en cada una de las pistas y buscar el aforo de cada una de ellas, devolviendo
  la suma de los aforos de todas.
En de que alguna pista no exista, deberás de mostrar la cadena 'La pista ZZZZZZ
 no existe' por cada pista que no exista.
Debemos de controlar que al menos siempre se envíe una pista. En caso contrario
 debe de enviarse -1 en el parámetro de salida.
 */

DELIMITER $$
CREATE PROCEDURE animales_getSumAforo (p_pistas varchar(100),OUT p_sumaAforo int)		
    COMMENT 'Devuelva en forma de parámetro de salida la suma de los aforos de las pistas enviadas como parámetro con formato pista1,pista2,...'
label_getSumAforo: BEGIN
    DECLARE v_index,v_pos smallint default 1;
    DECLARE v_aforo smallint;		-- El tipo coincide con el declarado en la tabla
    DECLARE v_nombrePista varchar(50);	-- El tipo coincide con el declarado en la tabla

    SET p_sumaAforo = 0;		-- Por defecto vale null. Como vamos ir acumulando el aforo en esta variable no podemos sumar un valor null. Por eso le damos un valor inicial
    
    IF (CHAR_LENGTH(p_pistas)=0) THEN
        SET p_sumaAforo = -1;
        LEAVE label_getSumAforo;
    END IF;
    
    WHILE (v_pos <> 0) DO   -- La función LOCATE devuelve 0 si no encuentra la cadena a buscar (la coma que separa cada pista).
        SELECT LOCATE(',',p_pistas,v_index)
        INTO v_pos;
        IF (v_pos <> 0) THEN	-- Encuentra una coma
            SELECT SUBSTRING(p_pistas,v_index,v_pos-v_index)
            INTO v_nombrePista;
            
            set v_index = v_pos+1;
        ELSE    -- Falta la última pista con contar ya que no lleva coma al final
            SELECT SUBSTRING(p_pistas,v_index)
            INTO v_nombrePista;
        END IF;
        
        SET v_aforo = null; -- Para comprobar si la pista existe, podríamos hacer un count(*) buscando por la pista
                            -- Pero de esta forma nos ahorramos una consulta. Si la pista no existe el valor de la variable seguirá valiendo NULL
                            -- En SQL Server podemos hacer uso de la variable @@ROWCOUNT
        SELECT aforo
        INTO v_aforo
        FROM PISTAS
        WHERE nombre = v_nombrePista;
        
        IF (v_aforo IS NULL) THEN 	-- Pista no encontrada
            SELECT CONCAT('La pista ',v_nombrePista,' no existe');
        ELSE
            SET p_sumaAforo = p_sumaAforo + v_aforo;
        END IF;       
    END WHILE;
END $$
DELIMITER ;

CALL animales_getSumAforo('LATERAL1,LATERAL2,NO EXISTE',@aforo);  -- Una de las pistas no existe
SELECT @aforo;

CALL animales_getSumAforo('SUPER',@aforo);   -- Devuelve el aforo de SUPER
SELECT @aforo;

CALL animales_getSumAforo('',@aforo);   -- Devuelve -1
SELECT @aforo;


/*Crea un procedimiento de nombre atracciones_getGananciasSupuestas
 *  en el que se le pase como datos el nombre de una atracción y 2 números.
 *  Deberá de mostrar los días en los que se celebró la atracción junto con su
 *  número de espectadores y ganancia así como las ganancias que tendríamos si 
 * la entrada costara diferentes precios. Los precios deben variar desde el primer
 *  número enviado hasta el segundo, con una diferencia de 5 euros entre ellos.
 *  Es decir, imaginemos que la atracción1 se celebró estos días:
 */

DELIMITER $$
CREATE PROCEDURE atracciones_getGananciasSupuestas (p_nombreAtraccion varchar(50),p_precioInferior tinyint, p_precioSuperior tinyint)		
    COMMENT 'Muestra los días en los que se celebró la atracción junto con su número de espectadores y ganancia así como las ganancias que tendríamos si la entrada costara diferentes precios'
label_getGananciasSupuestas: BEGIN
    DECLARE v_precio tinyint default 0;
    DECLARE v_atraccionExiste tinyint;	-- Para comprobar si la atraccion existe

    SELECT COUNT(*)			-- Comprobamos si la atraccion existe
    INTO v_atraccionExiste
    FROM ATRACCIONES
    WHERE nombre = p_nombreAtraccion;
    IF (v_atraccionExiste=0) THEN
        SELECT 'La atracción no existe';
        LEAVE label_getGananciasSupuestas; 
    END IF;

    SELECT COUNT(*)			-- Comprobamos si tiene alguna atraccion
    INTO v_atraccionExiste
    FROM ATRACCION_DIA
    WHERE nombre_atraccion = p_nombreAtraccion;
    IF (v_atraccionExiste=0) THEN
        SELECT 'La atracción no ha celebrado ninguna actuación';
        LEAVE label_getGananciasSupuestas; 
    END IF;

    IF (p_precioInferior > p_precioSuperior) THEN
        SELECT 'El precio inferior no puede ser superior al segundo número';
        LEAVE label_getGananciasSupuestas;
    END IF;
    IF ((p_precioInferior % 5)<>0 OR (p_precioSuperior%5)<>0) THEN
        SELECT 'Los dos números deben ser múltiplos de 5';
        LEAVE label_getGananciasSupuestas;
    END IF;
    
    SET v_precio = p_precioInferior;
    REPEAT
        SELECT nombre_atraccion, num_espectadores, ganancias, num_espectadores*v_precio as gananciaSimulada
        FROM ATRACCION_DIA
        WHERE nombre_atraccion = p_nombreAtraccion;
        
        SET v_precio = v_precio + 5;    
    UNTIL v_precio > p_precioSuperior
    END REPEAT;
END $$
DELIMITER ;


CALL atracciones_getGananciasSupuestas('El orangután',12,20); 
-- Muestra mensaje de error ya que los precios no son múltiplos de 5

CALL atracciones_getGananciasSupuestas('El orangután',10,20);  
-- Muestra mensaje de error ya que esa atracción no se ha celebrado nunca.

CALL atracciones_getGananciasSupuestas('El gran felino',10,20); 
-- Muestra tres pestañas cada una con todas las celebraciones y ganancias simuladas


/*EJER 03: 
 * Crea un procedimiento de nombre utilidades_getNumImpares al que se le pasen tres números 
 * y devuelva en forma de parámetro de salida cuanto números hay entre los dos primeros números
 *  que son divisibles por el tercero. Se deben incluir los dos primeros números a la hora de contar.

No importa el orden en el que se envíen los dos primeros números.
Por ejemplo: 5,1,2 => Busca los números múltiplos de 2 entre 1 y 5 (inclúidos) => Mostrará: 2
*/
DELIMITER $$
CREATE PROCEDURE utilidades_getNumImpares (p_numero1 int, p_numero2 int,p_multiplo int, 
OUT p_numMultiplos int)		
    COMMENT 'Muestra cuanto números múltiplos por el tercer número hay entre los dos primeros (incluidos los dos números enviados)'
BEGIN
    DECLARE v_temporal int default 0;
    
    IF (p_numero1 > p_numero2) THEN		-- Intercambiamos los números si el segundo es inferior al primero
        SET v_temporal = p_numero2;
        SET p_numero2 = p_numero1;
        SET p_numero1 = v_temporal;
    END IF;
    
    SET p_numMultiplos = 0;
    
    etiqueta_bucle: LOOP	-- Probamos con LOOP. Valdría WHILE o REPEAT
        IF (p_numero1%p_multiplo=0) THEN 		-- Es un número IMPAR
            SET p_numMultiplos = p_numMultiplos + 1;
        END IF;
        SET p_numero1 = p_numero1 + 1;
        IF (p_numero1 > p_numero2) THEN
            LEAVE etiqueta_bucle;
        END IF;
    END LOOP;
END $$
DELIMITER ;

CALL utilidades_getNumImpares(5,1,3,@numMultiplos);  -- Busca múltiplos de 3
SELECT @numMultiplos;

CALL utilidades_getNumImpares(25,2,2,@numMultiplos);   -- Busca múltiplos de 2
SELECT @numMultiplos;



