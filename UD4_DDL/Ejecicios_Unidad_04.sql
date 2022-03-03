-- 2.1 MODIFICACION DE TABLAS

-- EJERCICIO 1

DROP DATABASE IF EXISTS empresa;

CREATE DATABASE empresa CHARACTER SET utf8mb4;
USE empresa;

CREATE TABLE personal(
	cod_cliente INTEGER AUTO_INCREMENT PRIMARY KEY,
	dni CHAR(9),
	nombre VARCHAR(50) NOT NULL,
	apellidos VARCHAR(50) NOT NULL,
	salario NUMERIC(10,2) NOT NULL DEFAULT 0);

-- EJERCICIO 2

DROP DATABASE IF EXISTS venta;
CREATE DATABASE venta CHARACTER SET latin1;
USE venta;

CREATE TABLE cliente (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(25),
  primer_apellido VARCHAR(15) NOT NULL,
  ciudad VARCHAR(100),
  categoria INT UNSIGNED
);

CREATE TABLE comercial (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  ciudad VARCHAR(100),
  comision FLOAT
);


-- 1. Modifique la columna nombre de la tabla cliente para que pueda almacenar cadenas de hasta 100 caracteres 
-- y para que no pueda ser NULL.

ALTER TABLE cliente MODIFY nombre VARCHAR(50) NOT NULL;

-- 2. ¿Qué comando puede ejecutar para comprobar que el cambio que se ha realizado en el paso anterior se ha ejecutado 
-- correctamente?

DESCRIBE cliente;

-- 3. Modifique el nombre de la columna primer_apellido y asígnele apellido1. También tendrá que permitir que pueda 
-- almacenar hasta 100 caracteres y que no pueda ser un valor NULL.

ALTER TABLE cliente CHANGE primer_apellido apellido1 VARCHAR(100) NOT NULL;


-- 4. Añada una nueva columna a la tabla cliente para poder almacenar el segundo apellido. La columna se debe llamar 
-- apellido2 debe estar entre la columna apellido1 y ciudad, puede almacenar hasta 100 caracteres y puede ser NULL.

ALTER TABLE cliente ADD apellido2 VARCHAR(100) AFTER apellido1;

-- 5. Elimine la columna categoria de la tabla cliente.

ALTER TABLE cliente DROP categoria;

-- 6. Modifique la columna comision de la tabla comercial para que almacene por defecto el valor 10.

ALTER TABLE comercial MODIFY comision INT DEFAULT 10;
DESCRIBE comercial;




-- EJERCICIOS 2.3. DEL MODELO RACIONAL AL FÍSICO

-- 1. Ejercicio 1 (ej1.sql) A partir del modelo relacional, realiza el diseño de tablas en SQL asignándole a 
-- los campos el tipo de datos que consideres más adecuado sin poner nombres a las restricciones.
	-- alter table empleado add foreign key (IdDEP) references departamento (ID) ON DELETE CASCADA ON UPDATE CASCADE;

CREATE TABLE departamento (
id INT PRIMARY KEY,
nombre VARCHAR(10),
ubicacion VARCHAR(100));

CREATE  TABLE empleado (
ID int PRIMARY KEY,
dni VARCHAR(10) UNIQUE,
nombre VARCHAR(20),
salario DECIMAL (8,2),
telefonos VARCHAR(10),
IdDEP INT FOREIGN KEY (IdDEP) REFERENCES departamento (ID)
);

-- 2. Ejercicio 2 (ej2.sql) A partir del modelo relacional, realiza el diseño de tablas en SQL asignándole a 
-- los campos el tipo de datos que consideres más adecuado sin poner nombres a las restricciones.

CREATE TABLE region (
CodRegion INT PRIMARY KEY,
Nombre VARCHAR (10));

DROP TABLE region;

CREATE TABLE provincia (
CodProvincia INT PRIMARY KEY,
Nombre VARCHAR(45),
CodR INT, 
FOREIGN KEY(CodR) REFERENCES region(CodRegion));

CREATE TABLE localidad (
CodLocalidad INT PRIMARY KEY,
Nombre VARCHAR(50),
CodP INT,
FOREIGN KEY(CodP) REFERENCES provincia(CodProvincia));

CREATE TABLE empleado (
ID INT PRIMARY KEY,
DNI VARCHAR(10) UNIQUE,
Nombre VARCHAR(10),
FechaNac DATE,
Telefono VARCHAR(9),
Salario DECIMAL (8,2),
CodL INT,
FOREIGN KEY(CodL) REFERENCES localidad(CodLocalidad));

-- -- 3.. Ejercicio 3 (ej3.sql) A partir del modelo relacional, realiza el diseño de tablas en SQL asignándole a 
-- los campos el tipo de datos que consideres más adecuado sin poner nombres a las restricciones.

DROP DATABASE IF EXISTS ej3DDL;
CREATE DATABASE ej3DDL CHARACTER SET utf8mb4;
USE ej3DDL;

CREATE TABLE clientes ( 
NIF INT PRIMARY KEY,
nombre VARCHAR(10),
Direccion VARCHAR(50),
Telefono VARCHAR(10)
);

CREATE TABLE montador (
NIF INT PRIMARY key,
Nombre VARCHAR(10),
Direccion VARCHAR(50),
Telefono VARCHAR(10)
);

CREATE TABLE modelo_dormitorio (
Cod INT PRIMARY KEY
);

CREATE TABLE compra (
nif_C INT,
Modelo VARCHAR(50),
Fecha_Compra DATE,
PRIMARY KEY (nif_C, Modelo, Fecha_Compra),
FOREIGN KEY (nif_C) REFERENCES cliente (NIF),
FOREIGN KEY (Modelo) REFERENCES modelo_dormitorio (Cod)
);

CREATE TABLE monta (
Modelo VARCHAR(50)
nif_M INT,
Fecha_Montaje,
PRIMARY KEY (Modelo, nif_M, Fecha_Montaje),
FOREIGN KEY (Modelo) REFERENCES compra (Modelo),
FOREIGN KEY (nif_M) REFERENCES montador (NIF)
);

Drop table cliente;

-- 4. Ejercicio 4 (ej4.sql) A partir del modelo relacional, realiza el diseño de tablas en SQL asignándole 
-- a los campos el tipo de datos que consideres más adecuado poniendo nombres a las restricciones en claves 
-- compuestas y de integridad referencial. No pueden ser nulos los siguientes campos: Nombre de Cliente, 
-- Marca y Modelo de Coche.

DROP DATABASE IF EXISTS ej4DDL;
CREATE DATABASE ej4DDL CHARACTER SET utf8mb4;
USE ej4DDL;

CREATE TABLE cliente (
CodCliente INT PRIMARY KEY,
dni VARCHAR(10) UNIQUE,
Nombre VARCHAR(10),
Direccion VARCHAR(50),
Telefono VARCHAR(10)
);

CREATE TABLE reserva (
Numero INT PRIMARY KEY,
FechaInicio DATE,
FechaFin DATE,
PrecioTotal DECIMAL (6,2),
CodCliente INT,
FOREIGN KEY (CodCliente) REFERENCES cliente (CodCliente)
);

CREATE TABLE coche (
Matricula VARCHAR(10) PRIMARY KEY,
Marca VARCHAR(20),
Modelo VARCHAR(10),
Color VARCHAR(10),
PrecioHora DECIMAL(4,2)
);

CREATE TABLE incluye (
Numero INT,
Matricula VARCHAR(10),
litrosGas DECIMAL (3,1),
PRIMARY KEY (Numero, Matricula),
FOREIGN KEY (Numero) REFERENCES reserva (Numero),
FOREIGN KEY (Matricula) REFERENCES coche (Matricula)
);

CREATE TABLE avala (
Avalado INT,
Avalador INT, 
PRIMARY KEY (Avalado),
FOREIGN KEY (Avalado) REFERENCES cliente (CodCliente),
FOREIGN key (Avalador) REFERENCES cliente (CodCliente)
);

-- Ejercicio 5 (ej5.sql)
/* Dada la siguiente definición de tablas, define las siguientes restricciones a nivel de campo:

El color de los coches es verde, rojo o azul.
La marca y el modelo del coche no pueden dejarse en blanco. OK
El precio de un coche está entre 10000 y 40000. ok
Las horas de mano de obra de una operación nunca pasan de 10.OK */

DROP DATABASE IF EXISTS ej5DDL;
CREATE DATABASE ej5DDL CHARACTER SET utf8mb4;
USE ej5DDL;

CREATE TABLE CLIENTE(  
COD       INTEGER PRIMARY KEY,
NIF       CHAR(9) UNIQUE,
NOMBRE    VARCHAR(50),
DIRECCION VARCHAR(100),
TELEFONO  CHAR(9),
CIUDAD    VARCHAR(20)
); 

CREATE TABLE COCHE(
MATRICULA  CHAR(7) PRIMARY KEY,
MARCA      VARCHAR(20) NOT NULL,
MODELO     VARCHAR(20) NOT NULL,
COLOR      VARCHAR(20) CHECK (COLOR = "VERDER" OR COLOR = "ROJOR" OR COLOR ="AZUL"),
PVP        NUMERIC(5,2) CHECK (PVP < 10000 AND PVP > 40000),
CODCLIENTE INTEGER,
FOREIGN KEY (CODCLIENTE) REFERENCES CLIENTE (COD)
);

CREATE TABLE REVISION(
COD        INTEGER(7) PRIMARY KEY,
FECHA      DATE,
MATRICULA  CHAR(7),
CONSTRAINT FK_REVISION_COCHE FOREIGN KEY(MATRICULA) REFERENCES COCHE(MATRICULA)
);

CREATE TABLE OPERACION(
COD          INTEGER(3) PRIMARY KEY,
DESCRIPCION  VARCHAR(100),
HORAS        INTEGER CHECK (HORAS <= 10)
);

CREATE TABLE CONSTA(
CODREVISION  INTEGER(7) REFERENCES REVISION,
CODOPERACION INTEGER(3) REFERENCES OPERACION,
PRIMARY KEY (CODREVISION,CODOPERACION),
FOREIGN KEY (CODREVISION) REFERENCES REVISION(COD),
FOREIGN KEY (CODOPERACION) REFERENCES OPERACION(COD)
);

CREATE TABLE MATERIAL(
COD    INTEGER PRIMARY KEY,
NOMBRE VARCHAR(50),
PRECIO NUMERIC(5,2)
);

CREATE TABLE NECESITA(
CODOPERACION INTEGER(3) REFERENCES OPERACION,
CODMATERIAL  INTEGER REFERENCES MATERIAL,
CONSTRAINT PK_NECESITA PRIMARY KEY (CODOPERACION,CODMATERIAL),
CONSTRAINT FK_NECESITA_OPERACION FOREIGN KEY (CODOPERACION) REFERENCES OPERACION(COD),
CONSTRAINT FK_NECESITA_MATERIAL FOREIGN KEY (CODMATERIAL) REFERENCES MATERIAL(COD)
);


-- EJERCICIO 6. Completa el siguiente diseño de tablas en SQL definiendo las restricciones de 
-- clave primaria y de integridad referencial adecuadas:

DROP DATABASE IF EXISTS ej6;
CREATE DATABASE ej6 CHARACTER SET utf8mb4;
USE ej6;

CREATE TABLE EQUIPO(
ID INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
NOMBRE VARCHAR(50) UNIQUE NOT NULL,
PATROCINADOR VARCHAR(50),
COLOR1 VARCHAR(50) NOT NULL,
COLOR2 VARCHAR(50) NOT NULL,
CATEGORIA ENUM ('FORMACIÓN PROFESIONAL', 'BACHILLERATO')
);

CREATE TABLE JUGADOR(
ID INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
NOMBRE VARCHAR(50) NOT NULL,
APELLIDOS VARCHAR(50),
DIRECCION VARCHAR(100),
TELEFONO VARCHAR(12) NOT NULL,
FECHA_NACIMIENTO DATE NOT NULL,
ID_EQUIPO INTEGER UNSIGNED,
FOREIGN KEY (ID_EQUIPO) REFERENCES EQUIPO (ID)
);

CREATE TABLE PARTIDO(
ID INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
CAMPO VARCHAR(50) NOT NULL,
ARBITRO VARCHAR(50) NOT NULL,
INCIDENCIAS VARCHAR(500)
);

CREATE TABLE EQUIPO_PARTIDO(
ID_EQUIPO INTEGER UNSIGNED,
ID_PARTIDO INTEGER UNSIGNED,
CONDICION ENUM ('LOCAL', 'VISITANTE'),
GOLES INTEGER UNSIGNED DEFAULT 0,
PRIMARY KEY (ID_EQUIPO, ID_PARTIDO),
FOREIGN KEY (ID_EQUIPO) REFERENCES EQUIPO(ID),
FOREIGN KEY (ID_PARTIDO) REFERENCES PARTIDO(ID)
);


--- EJERCICIO 7 Completa el siguiente diseño de tablas en SQL definiendo las restricciones de 
-- clave primaria y de integridad referencial adecuadas:

DROP DATABASE IF EXISTS ej7;
CREATE DATABASE ej7 CHARACTER SET utf8mb4;
USE ej7;

CREATE TABLE EMPRESA(
CIF       CHAR(9) UNIQUE PRIMARY KEY,
NOMBRE    VARCHAR(50),
DIRECCION VARCHAR(50),
TELEFONO  CHAR(9)
);

CREATE TABLE ALUMNO(
DNI        CHAR(9) UNIQUE PRIMARY KEY,
NOMBRE     VARCHAR(50),
APELLIDO1  VARCHAR(50),
APELLIDO2  VARCHAR(50),
TELEFONO   CHAR(9),
EDAD       INTEGER,
CIF        CHAR(9),
FOREIGN KEY (CIF) REFERENCES EMPRESA (CIF)
);

CREATE TABLE PROFESOR(
DNI_PROF   CHAR(9) UNIQUE PRIMARY KEY,
NOMBRE     VARCHAR(50),
APELLIDO1  VARCHAR(50),
APELLIDO2  VARCHAR(50),
DIRECCION  VARCHAR(50),
TELEFONO   CHAR(9)
);

CREATE TABLE TIPO_CURSO(
COD_TIPO_CURSO NUMERIC(2) UNIQUE PRIMARY KEY,
TITULO         VARCHAR(50),
DURACION       INTEGER
);

CREATE TABLE CURSO(
N_CURSO         NUMERIC(3) UNIQUE PRIMARY KEY,
FECHA_INICIO    DATE,
FECHA_FIN       DATE,
DNI_PROF        CHAR(9),
COD_TIPO_CURSO  NUMERIC(2),
FOREIGN KEY (DNI_PROF) REFERENCES PROFESOR (DNI_PROF),
FOREIGN KEY (COD_TIPO_CURSO) REFERENCES TIPO_CURSO (COD_TIPO_CURSO)
);

CREATE TABLE ASISTIR(
N_CURSO     NUMERIC(3),
DNI_ALUMNO  CHAR(9),
NOTA        INTEGER,
PRIMARY KEY (N_CURSO, DNI_ALUMNO),
FOREIGN KEY (N_CURSO) REFERENCES CURSO (N_CURSO),
FOREIGN KEY (DNI_ALUMNO) REFERENCES ALUMNO (DNI)
);

/*
 EJERCICIO 8
 A partir del modelo relacional, realiza el diseño de tablas en SQL asignándole a los campos el tipo de datos que consideres más adecuado. Ten en cuenta los siguientes aspectos:

Pon nombres a las restricciones, al menos, en claves compuestas y de integridad referencial.
No pueden ser nulos todos los campos de Persona y los siguientes campos de las otras tablas: NombreVía, Número de Vivienda, Nombre de Municipio.
Sexo toma los valores H o M.
Por defecto si no se indica nada el TipoVia es: CALLE.
El número de la vivienda debe ser un valor positivo.
El nombre de la persona deberá ser en mayúsculas.
 */
 
DROP DATABASE IF EXISTS ej8;
CREATE DATABASE ej8 CHARACTER SET utf8mb4;
USE ej8;

CREATE TABLE municipio (
ID INT UNIQUE AUTO_INCREMENT PRIMARY KEY, 
Nombre VARCHAR(20) NOT NULL,
CodPostal INT, 
Provincia VARCHAR(10)
);

CREATE TABLE vivienda (
ID INT UNIQUE AUTO_INCREMENT PRIMARY KEY,
TipoVia VARCHAR(10) DEFAULT 'Calle',
NombreVía VARCHAR(20) NOT NULL,
Numero INT UNSIGNED NOT NULL,
IDMunicipio INT,
FOREIGN KEY (IDMunicipio) REFERENCES municipio (ID)
);

CREATE TABLE persona (
DNI VARCHAR(10) UNIQUE NOT NULL PRIMARY KEY,
Nombre VARCHAR(10) CONSTRAINT Nombre_UPPER CHECK (BINARY UPPER(Nombre) = BINARY Nombre) NOT NULL, -- usar CAST
FechaNac DATE NOT NULL, 
Sexo ENUM('H','M'),
IDVivienda INT,
FOREIGN KEY (IDVivienda) REFERENCES vivienda (ID)
);

CREATE TABLE cabezaFamilia (
DNI VARCHAR(10) PRIMARY KEY,
IDVivienda INT UNIQUE,
FOREIGN KEY (DNI) REFERENCES persona (DNI),
FOREIGN KEY (IDVivienda) REFERENCES vivienda (ID) 
);

CREATE TABLE posee (
DNI VARCHAR(10),
IDVivienda INT,
PRIMARY KEY (DNI, IDVivienda),
FOREIGN KEY (DNI) REFERENCES persona (DNI),
FOREIGN KEY (IDVivienda) REFERENCES vivienda (ID)
);




-- 							EJERCICIOS MANIPULACION DE DATOS  


-- ejercicio consultora.sql

DROP DATABASE IF EXISTS CONSULTORA;
CREATE DATABASE CONSULTORA CHARACTER SET utf8mb4;
USE CONSULTORA;

-- Creación de tablas

CREATE TABLE DEPARTAMENTO (
     DEPTO_NO INTEGER NOT NULL PRIMARY KEY,
     NOMBRE_DEPTO VARCHAR(50) NOT NULL,
     LOCALIZACION VARCHAR(100)
);

CREATE TABLE EMPLEADO (
    IDEMPLEADO VARCHAR(16) NOT NULL,
    NOMBRE VARCHAR(50) NOT NULL,
    EDAD NUMERIC(2),
    OFICIO VARCHAR(50),
    SALARIO NUMERIC(8,2),
    COMISION NUMERIC(6,2) DEFAULT 0,
    DEPTO_NO INTEGER,
      CONSTRAINT PK_EMPLEADO PRIMARY KEY (IDEMPLEADO),
      CONSTRAINT FK_EMP_DEP FOREIGN KEY (DEPTO_NO) REFERENCES DEPARTAMENTO(DEPTO_NO) ON UPDATE CASCADE ON DELETE SET NULL,
	  CONSTRAINT CK_OFICIO CHECK (OFICIO IN ('DIRECTOR','PRESIDENTE','TÉCNICO','VENDEDOR','ANALISTA'))
);

-- Inserción de registros

INSERT INTO DEPARTAMENTO VALUES (10,'DESARROLLO SOFTWARE','HUELVA');
INSERT INTO DEPARTAMENTO VALUES (20,'ANALISIS SISTEMAS','SEVILLA');
INSERT INTO DEPARTAMENTO VALUES (30,'CONTABILIDAD','HUELVA');
INSERT INTO DEPARTAMENTO VALUES (40,'VENTAS','SEVILLA');
INSERT INTO DEPARTAMENTO VALUES (50,'MANTENIMIENTO SISTEMAS','CÁDIZ');

INSERT INTO EMPLEADO VALUES('281-160483-0005F','ROCHA HECTOR',27,'VENDEDOR',12000,0,40);
INSERT INTO EMPLEADO VALUES('281-040483-0056P','LÓPEZ JULIO',27,'ANALISTA',13000,1500,20);
INSERT INTO EMPLEADO VALUES('081-130678-0004S','ESQUIVEL MANUEL',31,'DIRECTOR',20000,1200,30);
INSERT INTO EMPLEADO VALUES('281-160473-0005F','DELGADO CARMEN',37,'VENDEDOR',13400,0,40);
INSERT INTO EMPLEADO VALUES('281-160493-0005F','CASTILLO LUIS',18,'VENDEDOR',16309,1000,40);
INSERT INTO EMPLEADO VALUES('281-240784-0004Y','ESQUIVEL ALFONSO',27,'PRESIDENTE',15000,0,30);
INSERT INTO EMPLEADO VALUES('281-161277-0006R','QUEVEDO LUIS',32,'TÉCNICO',16890,0,10);
INSERT INTO EMPLEADO VALUES('282-240782-0005E','SOSA MARIA',28,'TÉCNICO',16890,0,50);
INSERT INTO EMPLEADO VALUES('282-240782-0006P','MARTIN MANUEL',33,'TÉCNICO',16890,0,50);

COMMIT;

-- 1. Insertar en la tabla EMPLEADO un empleado cuyo código 081-220678-008U, nombre 'SOTELO CARLOS' de 32 años,
-- oficio Analista, su salario es 15600, no tiene comisión y pertenece al departamento 20.

INSERT  INTO EMPLEADO VALUES ('081-220678-008U', 'SOTELO CARLOS', 32, 'ANALISTA', 15600,0,20 );



-- Insertar en la tabla DEPARTAMENTO y en una única instrucción:
-- Un departamento con número 60 de nombre GENERAL y localización en SEVILLA.
-- Un departamento con número 70 de nombre PRUEBAS y localización CÁDIZ.

INSERT INTO DEPARTAMENTO VALUES (60,'GENERAL','SEVILLA');
INSERT INTO DEPARTAMENTO VALUES (70,'PRUEBAS','CÁDIZ');

-- 3. Crear la tabla VENDEDOR con campos IDEMPLEADO y NUM_VENTAS con valor por defecto a 0, insertando en la 
-- tabla los empleados que sean vendedores. Recuerda establecer las restricciones adecuadas de clave primaria y 
-- de integridad referencial con política de actualización en cascada.

CREATE TABLE VENDEDOR AS (SELECT e.IDEMPLEADO FROM EMPLEADO e WHERE e.OFICIO = 'VENDEDOR');

ALTER TABLE VENDEDOR ADD CONSTRAINT PK_VENDEDOR PRIMARY KEY (IDEMPLEADO);
ALTER TABLE VENDEDOR ADD CONSTRAINT FK_VENDEDOR FOREIGN KEY (IDEMPLEADO) REFERENCES EMPLEADO (IDEMPLEADO)
ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE VENDEDOR ADD NUM_VENTAS INT UNSIGNED DEFAULT 0;

ALTER TABLE CONSULTORA.VENDEDOR DROP FOREIGN KEY FK_VENDEDOR;
ALTER TABLE CONSULTORA.VENDEDOR ADD CONSTRAINT FK_VENDEDOR FOREIGN KEY (IDEMPLEADO) 
REFERENCES CONSULTORA.EMPLEADO(IDEMPLEADO) ON DELETE CASCADE ON UPDATE CASCADE;

-- 4. Asignar todos los empleados del departamento 30 al departamento 20 y comprobar que ya no existe ningún
-- empleado en el departamento 30.

UPDATE EMPLEADO SET DEPTO_NO = 20 WHERE DEPTO_NO =30;
SELECT * FROM EMPLEADO e WHERE DEPTO_NO  = 30;


-- 5. Modificar la localidad del departamento número 10 a Sevilla.

SELECT * FROM DEPARTAMENTO d;

UPDATE DEPARTAMENTO SET LOCALIZACION = 'SEVILLA' WHERE DEPTO_NO  =10;

-- 6.- Duplicar la comisión a todos los empleados del departamento número 20 que tengan una comisión mayor de 100€.
SELECT * FROM EMPLEADO e ;

UPDATE EMPLEADO SET COMISION = (COMISION*2) WHERE DEPTO_NO = 20 AND COMISION>100;

-- 7.- Incrementar en un 10% el salario de los empleados del departamento 10.

UPDATE EMPLEADO SET SALARIO = (SALARIO +(SALARIO*0.1)) WHERE DEPTO_NO = 10;

-- 8.- Asignar una comisión por desplazamiento de 100€ a los empleados que pertenezcan a Huelva y Cádiz.


SELECT * FROM EMPLEADO e INNER JOIN DEPARTAMENTO d ON e.DEPTO_NO = d.DEPTO_NO;

UPDATE EMPLEADO SET COMISION = COMISION +100 
WHERE DEPTO_NO IN (
SELECT DEPTO_NO FROM DEPARTAMENTO 
WHERE LOCALIZACION IN ('HUELVA', 'CÁDIZ'));

-- 9.- Reducir la comisión a un 10% de aquellos empleados que cobran más que la media. NO ENTRA

-- consulta normal
SELECT IDEMPLEADO
FROM EMPLEADO
WHERE SALARIO > (SELECT AVG(e.SALARIO) FROM EMPLEADO e); 

-- actualización con sbconulta,
SELECT AVG(SALARIO) INTO @MEDIA FROM EMPLEADO;
UPDATE EMPLEADO SET COMISION = (COMISION -(COMISION *0.10))
WHERE  SALARIO > (@MEDIA);
SELECT @MEDIA; 
				


-- 10.- Borrar el departamento número 40, comprobando que ha ocurrido con los empleados que estaban en 
-- ese departamento.

DELETE FROM DEPARTAMENTO WHERE DEPTO_NO = 40;

-- 11.- Borrar los empleados que sean analistas y del departamento número 20.

DELETE FROM EMPLEADO WHERE OFICIO = 'ANALISTA' AND DEPTO_NO = 20;

-- 12.- Borrar los empleados asignados a departamentos de Huelva.

DELETE FROM EMPLEADO WHERE DEPTO_NO IN (SELECT DEPTO_NO FROM DEPARTAMENTO WHERE LOCALIZACION ='HUELVA'); 


-- 13. Mostrar el numero de empledos por departamentos 


SELECT COUNT(e.IDEMPLEADO), d.NOMBRE_DEPTO  
FROM EMPLEADO e INNER JOIN DEPARTAMENTO d 
ON e.DEPTO_NO = d.DEPTO_NO 
GROUP BY d.DEPTO_NO;

-- 14 mostrar los departamentos cuyos empleaods cobren mas de 20000 de salario.

SELECT * FROM DEPARTAMENTO d INNER JOIN EMPLEADO e ON d.DEPTO_NO = e.DEPTO_NO 
WHERE e.COMISION > 2000;

SELECT d.NOMBRE_DEPTO  
FROM DEPARTAMENTO d INNER JOIN EMPLEADO e 
ON d.DEPTO_NO = e.DEPTO_NO 
GROUP BY d.DEPTO_NO 
HAVING SUM(e.COMISION)> 2000;
-- 15. mostrar los empleaods  que cobran menos que la media 

SELECT *
FROM EMPLEADO
WHERE SALARIO < (SELECT AVG(e.SALARIO) FROM EMPLEADO e); 

-- 16 nobre del empleado y departamento que mas comisicno cobra sin usar limit

SELECT e.NOMBRE , d.NOMBRE_DEPTO FROM EMPLEADO e INNER JOIN DEPARTAMENTO d ON e.DEPTO_NO = d.DEPTO_NO 
WHERE e.SALARIO  = (SELECT MAX(SALARIO) FROM EMPLEADO e2)

-- 17 muestra la informacion de los departamente tal y cmo sigue:
	-- El depatamento xxx gasta xxx en salario y xxx en comisiones
SELECT CONCAT_WS(' ', 'El departamento ', d.NOMBRE_DEPTO, ' gasta ', 
SUM(SALARIO), ' en salario y ', SUM(COMISION), ' en comisiones') 
FROM EMPLEADO e INNER JOIN DEPARTAMENTO d ON e.DEPTO_NO = d.DEPTO_NO 
GROUP BY d.DEPTO_NO;




------ 2.2 CRACION DE TABLAS 

CREATE DATABASE academia;
USE academia;

CREATE TABLE provincia (
	cod_provinvia NUMERIC(2) PRIMARY KEY,
	nombre VARCHAR(25) NOT NULL,
	pais ENUM('España', 'Portugal','Italia')
);

CREATE TABLE continente(
	cod_continente NUMERIC PRIMARY KEY,
	nombre VARCHAR (20) DEFAULT 'Europa' NOT NULL
);

CREATE TABLE empresa(
	cod_empresa NUMERIC (2) PRIMARY KEY,
	nombre VARCHAR (20) DEFAULT 'EMPRESA1' NOT NULL,
	fecha_crea DATE DEFAULT (NOW())
);

CREATE TABLE alumnos (
	codigo NUMERIC(3) PRIMARY KEY,
	nombre VARCHAR (21) NOT NULL,
	apellido VARCHAR (30) CHECK(BINARY UPPER(apellido) = BINARY apellido),
	curso ENUM('1','2','3'),
	fecha_matri DATE DEFAULT (NOW())
);

CREATE TABLE empleado (
	cod_emple NUMERIC(2) PRIMARY  KEY,
	nombre VARCHAR (20) NOT NULL,
	apellido VARCHAR (25),
	salario DECIMAL (7,2) CHECK (salario > 0)
);

ALTER TABLE empleado ADD COLUMN provincia NUMERIC(2);
ALTER TABLE empleado ADD COLUMN empresa NUMERIC(2);

ALTER TABLE empleado ADD CONSTRAINT fk_prov FOREIGN KEY (provincia) 
REFERENCES provincia (cod_provinvia) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE empleado ADD CONSTRAINT fk_empresa FOREIGN KEY (empresa) 
REFERENCES empresa (cod_empresa) ON UPDATE CASCADE ON DELETE CASCADE;

SHOW CREATE TABLE empleado;


















