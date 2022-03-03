CREATE DATABASE editorial;
USE editorial;

CREATE TABLE sucursal(
	codSucursal VARCHAR(5) PRIMARY KEY,
	direccion VARCHAR (20),
	telefono VARCHAR (9),
	ciudad VARCHAR(20),
	provincia VARCHAR (20)
);

CREATE TABLE revista (
	numRegisto INT AUTO_INCREMENT PRIMARY KEY,
	titulo VARCHAR (20),
	tipo VARCHAR (20),
	periodicidad ENUM('Semanal', 'Mensula','Anual'),
	codSucursal VARCHAR (5)
); 

ALTER TABLE revista ADD CONSTRAINT fk_sucursal FOREIGN KEY (codSucursal)
REFERENCES sucursal (codSucursal) ON UPDATE CASCADE ON DELETE SET NULL;

CREATE TABLE periodista (
	id INT PRIMARY KEY,
	nombre VARCHAR (20),
	apellido1 VARCHAR (20),
	apellido2 VARCHAR (20),
	telefono VARCHAR (10),
	especialidad VARCHAR (10)
);

drop table periodista;

CREATE TABLE escribe (
	numRegisto INT AUTO_INCREMENT,
	id INT,
	CONSTRAINT pk_escribe PRIMARY KEY (numRegisto, id)
);

ALTER TABLE escribe ADD CONSTRAINT fk_revista FOREIGN KEY (numRegisto) 
REFERENCES revista (numRegisto);

ALTER TABLE escribe ADD CONSTRAINT escribe_FK FOREIGN KEY (id) 
REFERENCES periodista(id);

CREATE TABLE ejemplar(
	numRegisto INT AUTO_INCREMENT,
	fecha DATE DEFAULT(NOW()),
	numPag INT,
	numEjemplares INT,
	PRIMARY KEY (numRegisto, fecha)
);

ALTER TABLE ejemplar ADD CONSTRAINT fk_revista_ejem FOREIGN KEY (numRegisto)
REFERENCES revista (numRegisto);


--- 
ALTER TABLE escribe ADD COLUMN fechaComienzo DATE CHECK(fechaComienzo>('2022-01-01'))
DEFAULT (NOW());

--- 

INSERT INTO sucursal VALUES(
	'23', 'Avenida de la Paz', '55555','Sevilla','Sevilla'
);

ALTER TABLE sucursal MODIFY direccion  VARCHAR(50);

INSERT INTO sucursal VALUES (
	'24', 'Avenida de las ciencias', '66666','Sevilla','Sevilla'
);

INSERT INTO periodista  VALUES(
	'1', 'Abel', 'García','Montes','4444', 'Ciencia'
);
INSERT INTO periodista  VALUES(
	'2', 'Rosa', 'Ortiz','Vera','333', 'Virología'
);

INSERT INTO revista VALUES (
	'725', 'COVID-19', 'Ciencia', 'Mensula', '23'
);
-- Abel y Rosa participan en la revista (numero_registro 725)  desde el 01 de enero de 2020

INSERT INTO escribe VALUES (
	'725','1','2022-01-02'
);
INSERT INTO escribe VALUES (
	'725','2','2022-01-02'
);

--- 

ALTER TABLE revista  MODIFY titulo  VARCHAR(100);

UPDATE revista SET titulo = 'COVID-19 Nuevos retos' WHERE numRegisto = '725';

ALTER TABLE sucursal ADD COLUMN email VARCHAR (50);
UPDATE 



----

SELECT s.codSucursal, s.ciudad, COUNT(r.numRegisto)  
FROM sucursal s INNER JOIN revista r ON s.codSucursal = r.codSucursal 
GROUP BY s.codSucursal; 

CREATE VIEW vista_1 AS (SELECT s.codSucursal, s.ciudad, COUNT(r.numRegisto)  
FROM sucursal s INNER JOIN revista r ON s.codSucursal = r.codSucursal 
GROUP BY s.codSucursal);

SELECT * FROM vista_1;

rea una tabla que contenga los datos sobre los títulos de las revistas y los nombres de los periodistas 
(apellido1, apellido2 y nombre)  que han participado en ellas. 

SELECT r.titulo, p.nombre, p.apellido1, p.apellido2 FROM revista r INNER JOIN escribe e ON r.numRegisto = e.numRegisto 
					INNER JOIN periodista p ON e.id = p.id;

CREATE TABLE informacion_rev AS(SELECT r.titulo, p.nombre, p.apellido1, p.apellido2 FROM revista r INNER JOIN escribe e ON r.numRegisto = e.numRegisto 
					INNER JOIN periodista p ON e.id = p.id
);

DELETE FROM sucursal WHERE codSucursal = '23';




