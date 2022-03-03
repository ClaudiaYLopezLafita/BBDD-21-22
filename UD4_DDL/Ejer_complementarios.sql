
CREATE DATABASE esquema02;
USE esquema02;

CREATE TABLE alumno (
	numMatricula INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	fechaNacimiento DATE,
	telefono VARCHAR (10)
);

CREATE TABLE profesor(
	IdProfesor INT AUTO_INCREMENT PRIMARY KEY,
	nifP VARCHAR(10) UNIQUE,
	nombre VARCHAR (50),
	Especialidad VARCHAR (50),
	telefono VARCHAR (10)
);

CREATE TABLE asignatura (
	CodAsignatura VARCHAR (7) PRIMARY KEY,
	nombre VARCHAR (20),
	IdProfesor INT,
	CONSTRAINT fk_profesor FOREIGN KEY (IdProfesor) REFERENCES profesor (IdProfesor)
);

CREATE TABLE recibe (
	numMatricula INT,
	CodAsignatura VARCHAR (7),
	cursoEscolar VARCHAR (9),
	PRIMARY KEY (numMatricula, CodAsignatura, cursoEscolar),
	CONSTRAINT fk_alum FOREIGN KEY (numMatricula) REFERENCES alumno (numMatricula),
	CONSTRAINT fk_asig FOREIGN KEY (CodAsignatura) REFERENCES asignatura  (CodAsignatura)
);

----------------------------------------------

CREATE DATABASE esquema01;
USE esquema01;

CREATE TABLE region (
	CodRegion VARCHAR(5) PRIMARY KEY,
	nombre VARCHAR (10)
);

CREATE TABLE provincia (
	CodProvincia VARCHAR(5) PRIMARY KEY,
	nombre VARCHAR (10),
	CodRegion VARCHAR(5),
	CONSTRAINT fk_region FOREIGN KEY (CodRegion) REFERENCES region (CodRegion)
);

CREATE TABLE localidad (
	CodLocalidad VARCHAR (5) PRIMARY KEY,
	nombre VARCHAR (10),
	CodProvincia VARCHAR(5),
	CONSTRAINT fk_prov FOREIGN KEY (CodProvincia) REFERENCES provincia (CodProvincia)
);

CREATE TABLE empleado (
	ID INT PRIMARY KEY,
	dni VARCHAR (9) UNIQUE NOT NULL,
	nombre VARCHAR (50),
	fechaNac DATE,
	telefono VARCHAR(10),
	salario DECIMAL(6,2),
	CodLocalidad VARCHAR (5),
	CONSTRAINT fk_localidad FOREIGN KEY (CodLocalidad) REFERENCES localidad (CodLocalidad)
);

----------------------------------------- 

CREATE DATABASE esquema03;
USE esquema03;

CREATE TABLE departamento (
	ID INT AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR (20),
	ubicacion VARCHAR (10)
);

CREATE TABLE jefe(
	ID INT AUTO_INCREMENT PRIMARY KEY,
	dni VARCHAR (9) UNIQUE,
	nombre VARCHAR (50),
	salario DECIMAL (6,2) UNSIGNED,
	telefono VARCHAR (10),
	IdDep INT UNIQUE,
	CONSTRAINT fk_dep_j FOREIGN KEY (IdDep) REFERENCES departamento (ID)
);

CREATE TABLE empleado (
	ID INT PRIMARY KEY,
	dni VARCHAR (9) UNIQUE,
	nombre VARCHAR (50),
	salario DECIMAL (6,2) UNSIGNED,
	telefono VARCHAR (10),
	IdDep INT,
	CONSTRAINT fk_dep_E FOREIGN KEY (IdDep) REFERENCES departamento (ID)
);

---------- 

CREATE DATABASE esquema06;
USE esquema06;

CREATE TABLE periodita (
	dni VARCHAR (9) PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	direccion VARCHAR (100),
	telefono VARCHAR (9),
	especialista VARCHAR (10)
);

CREATE TABLE sucursal (
	Codigo VARCHAR (4) PRIMARY KEY, 
	direccion VARCHAR (100),
	telefono VARCHAR (9)
);

CREATE TABLE empleado (
	dni VARCHAR (9) PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	direccion VARCHAR (100),
	telefono VARCHAR (9),
	sucursal VARCHAR (4),
	CONSTRAINT fk_sucursal FOREIGN KEY (sucursal) REFERENCES sucursal (Codigo)
);

CREATE TABLE revista (
	NumReg INT PRIMARY KEY,
	titulo VARCHAR (20) NOT NULL,
	periodicidad ENUM ('Semanal', 'Quincenal','Mensual','Trimestral','Anual') DEFAULT 'Mensual',
	sucursal VARCHAR (4),
	CONSTRAINT fk_sucursal_rev FOREIGN KEY (sucursal) REFERENCES sucursal (Codigo)
);

DROP TABLE revista;

CREATE TABLE escribe (
	NumReg INT,
	dni_Per VARCHAR (9),
	PRIMARY KEY (NumReg, dni_Per),
	CONSTRAINT fk_sucursal_rev FOREIGN KEY (NumReg) REFERENCES revista  (NumReg),
	CONSTRAINT fk_sucursal_rev FOREIGN KEY (dni_Per) REFERENCES periodita  (dni)
);

CREATE TABLE numRevista(
	NumReg INT,
	numero INT,
	NumPag INT CHECK(NumPag>0),
	fecha DATE,
	cantVendidas INT,
	PRIMARY KEY (NumReg, numero),
	CONSTRAINT fk_revista FOREIGN KEY (NumReg) REFERENCES revista (NumReg)
);


---------------------------------------- 

CREATE DATABASE esquema07;
USE esquema07;

CREATE TABLE director (
	nombre VARCHAR (20) PRIMARY KEY,
	nacionalidad VARCHAR (10)
);

CREATE TABLE pelicula (
	ID VARCHAR (6) PRIMARY KEY,
	titulo VARCHAR (10) NOT NULL,
	productora VARCHAR (10),
	nacionalidad VARCHAR (10),
	fecha DATE,
	director VARCHAR (20),
	CONSTRAINT fk_director FOREIGN KEY (director) REFERENCES director (nombre)
);

CREATE TABLE ejemplar (
	ID_peli VARCHAR (6),
	numero INT,
	estado VARCHAR (10),
	PRIMARY KEY (ID_peli, numero),
	CONSTRAINT fk_peli FOREIGN KEY (ID_peli) REFERENCES pelicula (ID)
);

CREATE TABLE actores(
	nombre VARCHAR (10) PRIMARY  KEY,
	nacionalidad VARCHAR (15),
	sexo ENUM ('H','M')
);

CREATE TABLE actua(
	actor VARCHAR (10),
	ID_peli VARCHAR (6),
	prota ENUM ('S', 'N') DEFAULT 'N',
	CONSTRAINT pk_actua PRIMARY KEY (actor, ID_peli),
	CONSTRAINT fk_pelicula FOREIGN KEY (ID_peli) REFERENCES pelicula (ID),
	CONSTRAINT fk_actor FOREIGN KEY (actor) REFERENCES actores (nombre)
);

DROP TABLE socio;

CREATE TABLE socio(
	dni VARCHAR (9) PRIMARY KEY,
	nombre VARCHAR (20) NOT NULL,
	direccion VARCHAR (50),
	telefono VARCHAR (9),
	avala VARCHAR (9)
);

ALTER TABLE socio ADD CONSTRAINT fk_avala FOREIGN KEY (avala) REFERENCES socio (dni);

CREATE TABLE alquila (
	dni VARCHAR (9),
	ID_peli VARCHAR (5),
	numeroE INT,
	fechaAlquiler DATE,
	fechaDevolucion DATE,
	PRIMARY KEY (dni, ID_peli, numeroE, fechaAlquiler)
);

ALTER TABLE alquila ADD CONSTRAINT fk_socio FOREIGN KEY (dni) REFERENCES socio  (dni);
ALTER TABLE alquila ADD CONSTRAINT fk_ejemplar FOREIGN KEY (ID_peli) REFERENCES ejemplar (ID_peli);
ALTER TABLE ejemplar ADD INDEX ejemplar_index (numero);
ALTER TABLE alquila DROP  INDEX ejemplar_index
ALTER TABLE alquila ADD INDEX ejemplar_index_FK (numeroE);
ALTER TABLE alquila ADD CONSTRAINT fk_alquila_ej FOREIGN KEY (numeroE) REFERENCES ejemplar (numero);

DROP CONSTRAINT fk_alquila_ej;

DROP TABLE alquila ;

ALTER TABLE alquila
DROP FOREIGN KEY alquila_ibfk_1; 



--------- 
CREATE DATABASE esquema08;
USE esquema08;

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

*---------------------- 









