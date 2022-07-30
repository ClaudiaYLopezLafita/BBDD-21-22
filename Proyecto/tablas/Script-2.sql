DROP DATABASE IF EXISTS instituto;
CREATE DATABASE instituto CHARACTER SET utf8mb4;
USE instituto;
 
CREATE TABLE departamento (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE persona (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nif VARCHAR(9) UNIQUE,
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('H', 'M') NOT NULL,
    tipo ENUM('profesor', 'alumno') NOT NULL
);
 
CREATE TABLE profesor (
    id_profesor INT UNSIGNED PRIMARY KEY,
    id_departamento INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_profesor) REFERENCES persona(id),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);
 
 CREATE TABLE curso (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
 
CREATE TABLE modulo (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos INT UNSIGNED NOT NULL,
    id_profesor INT UNSIGNED,
    id_curso INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY(id_curso) REFERENCES curso(id)
);
 
CREATE TABLE curso_escolar (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    anio YEAR NOT NULL
);

CREATE TABLE alumno_se_matricula_modulo (
    id_alumno INT UNSIGNED NOT NULL,
    id_modulo INT UNSIGNED NOT NULL,
    id_curso_escolar INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_alumno, id_modulo, id_curso_escolar),
    FOREIGN KEY (id_alumno) REFERENCES persona(id),
    FOREIGN KEY (id_modulo) REFERENCES modulo(id),
    FOREIGN KEY (id_curso_escolar) REFERENCES curso_escolar(id)
);
 
 /* Departamento */
INSERT INTO departamento VALUES (1, 'Desarrollo');
INSERT INTO departamento VALUES (2, 'Sistemas');
INSERT INTO departamento VALUES (3, 'Redes');
INSERT INTO departamento VALUES (4, 'Seguridad');
INSERT INTO departamento VALUES (5, 'Disenio');
 
 /* Persona */
INSERT INTO persona VALUES (1, '26902806M', 'Salvador', 'Sánchez', 'Pérez', 'Almería', 'C/ Real del barrio alto', '950254837', '1991/03/28', 'H', 'alumno');
INSERT INTO persona VALUES (2, '89542419S', 'Juan', 'Saez', 'Vega', 'Almería', 'C/ Mercurio', '618253876', '1992/08/08', 'H', 'alumno');
INSERT INTO persona VALUES (3, '11105554G', 'Zoe', 'Ramirez', 'Gea', 'Almería', 'C/ Marte', '618223876', '1979/08/19', 'M', 'profesor');
INSERT INTO persona VALUES (4, '17105885A', 'Pedro', 'Heller', 'Pagac', 'Almería', 'C/ Estrella fugaz', NULL, '2000/10/05', 'H', 'alumno');
INSERT INTO persona VALUES (5, '38223286T', 'David', 'Schmidt', 'Fisher', 'Almería', 'C/ Venus', '678516294', '1978/01/19', 'H', 'profesor');
INSERT INTO persona VALUES (6, '04233869Y', 'José', 'Koss', 'Bayer', 'Almería', 'C/ Júpiter', '628349590', '1998/01/28', 'H', 'alumno');
INSERT INTO persona VALUES (7, '97258166K', 'Ismael', 'Strosin', 'Turcotte', 'Almería', 'C/ Neptuno', NULL, '1999/05/24', 'H', 'alumno');
INSERT INTO persona VALUES (8, '79503962T', 'Cristina', 'Lemke', 'Rutherford', 'Almería', 'C/ Saturno', '669162534', '1977/08/21', 'M', 'profesor');
INSERT INTO persona VALUES (9, '82842571K', 'Ramón', 'Herzog', 'Tremblay', 'Almería', 'C/ Urano', '626351429', '1996/11/21', 'H', 'alumno');
INSERT INTO persona VALUES (10, '61142000L', 'Esther', 'Spencer', 'Lakin', 'Almería', 'C/ Plutón', NULL, '1977/05/19', 'M', 'profesor');
INSERT INTO persona VALUES (11, '46900725E', 'Daniel', 'Herman', 'Pacocha', 'Almería', 'C/ Andarax', '679837625', '1997/04/26', 'H', 'alumno');
INSERT INTO persona VALUES (12, '85366986W', 'Carmen', 'Streich', 'Hirthe', 'Almería', 'C/ Almanzora', NULL, '1971-04-29', 'M', 'profesor');
INSERT INTO persona VALUES (13, '73571384L', 'Alfredo', 'Stiedemann', 'Morissette', 'Almería', 'C/ Guadalquivir', '950896725', '1980/02/01', 'H', 'profesor');
INSERT INTO persona VALUES (14, '82937751G', 'Manolo', 'Hamill', 'Kozey', 'Almería', 'C/ Duero', '950263514', '1977/01/02', 'H', 'profesor');
INSERT INTO persona VALUES (15, '80502866Z', 'Alejandro', 'Kohler', 'Schoen', 'Almería', 'C/ Tajo', '668726354', '1980/03/14', 'H', 'profesor');
INSERT INTO persona VALUES (16, '10485008K', 'Antonio', 'Fahey', 'Considine', 'Almería', 'C/ Sierra de los Filabres', NULL, '1982/03/18', 'H', 'profesor');
INSERT INTO persona VALUES (17, '85869555K', 'Guillermo', 'Ruecker', 'Upton', 'Almería', 'C/ Sierra de Gádor', NULL, '1973/05/05', 'H', 'profesor');
INSERT INTO persona VALUES (18, '04326833G', 'Micaela', 'Monahan', 'Murray', 'Almería', 'C/ Veleta', '662765413', '1976/02/25', 'H', 'profesor');
INSERT INTO persona VALUES (19, '11578526G', 'Inma', 'Lakin', 'Yundt', 'Almería', 'C/ Picos de Europa', '678652431', '1998/09/01', 'M', 'alumno');
INSERT INTO persona VALUES (20, '79221403L', 'Francesca', 'Schowalter', 'Muller', 'Almería', 'C/ Quinto pino', NULL, '1980/10/31', 'H', 'profesor');
INSERT INTO persona VALUES (21, '79089577Y', 'Juan', 'Gutiérrez', 'López', 'Almería', 'C/ Los pinos', '678652431', '1998/01/01', 'H', 'alumno');
INSERT INTO persona VALUES (22, '41491230N', 'Antonio', 'Domínguez', 'Guerrero', 'Almería', 'C/ Cabo de Gata', '626652498', '1999/02/11', 'H', 'alumno');
INSERT INTO persona VALUES (23, '64753215G', 'Irene', 'Hernández', 'Martínez', 'Almería', 'C/ Zapillo', '628452384', '1996/03/12', 'M', 'alumno');
INSERT INTO persona VALUES (24, '85135690V', 'Sonia', 'Gea', 'Ruiz', 'Almería', 'C/ Mercurio', '678812017', '1995/04/13', 'M', 'alumno');
 
/* Profesor */
INSERT INTO profesor VALUES (3, 1);
INSERT INTO profesor VALUES (5, 2);
INSERT INTO profesor VALUES (8, 3);
INSERT INTO profesor VALUES (10, 4);
INSERT INTO profesor VALUES (12, 4);
INSERT INTO profesor VALUES (13, 5);
INSERT INTO profesor VALUES (14, 1);
INSERT INTO profesor VALUES (15, 2);
INSERT INTO profesor VALUES (16, 3);
INSERT INTO profesor VALUES (17, 4);
INSERT INTO profesor VALUES (18, 5);
INSERT INTO profesor VALUES (20, 5);
 
 /* Curso */
INSERT INTO curso VALUES (1, 'DAW1');
INSERT INTO curso VALUES (2, 'DAW2');
INSERT INTO curso VALUES (3, 'SMR1');
INSERT INTO curso VALUES (4, 'SMR2');;
 
/* Módulo */
INSERT INTO modulo VALUES (1, 'Programación', 500, 3, 1);
INSERT INTO modulo VALUES (2, 'Bases De Datos', 400, 5, 1);
INSERT INTO modulo VALUES (3, 'Diseño de Interfaces Web', 300, 8, 2);
INSERT INTO modulo VALUES (4, 'Seguridad Informática', 300, 10, 4);
INSERT INTO modulo VALUES (5, 'Sistemas Informáticos', 400, 10, 1);

/* Curso escolar */
INSERT INTO curso_escolar VALUES (1, 2021);
INSERT INTO curso_escolar VALUES (2, 2022);
INSERT INTO curso_escolar VALUES (3, 2023);


/* Alumno se matricula en modulo */
INSERT INTO alumno_se_matricula_modulo VALUES (6, 1, 1);
INSERT INTO alumno_se_matricula_modulo VALUES (7, 2, 1);
INSERT INTO alumno_se_matricula_modulo VALUES (6, 1, 2);
INSERT INTO alumno_se_matricula_modulo VALUES (7, 2, 2);
INSERT INTO alumno_se_matricula_modulo VALUES (22, 3, 2);
INSERT INTO alumno_se_matricula_modulo VALUES (23, 4, 2);
INSERT INTO alumno_se_matricula_modulo VALUES (1, 1, 3);
INSERT INTO alumno_se_matricula_modulo VALUES (1, 2, 3);
INSERT INTO alumno_se_matricula_modulo VALUES (2, 3, 3);
INSERT INTO alumno_se_matricula_modulo VALUES (4, 4, 3);

COMMIT;



-- CONSULTAS 



        -- 1) Mostrar todos los datos de los profesores que dan clase en ″DAW1″.

SELECT *
FROM persona p INNER JOIN profesor p2 
ON p.id = p2.id_profesor 
INNER JOIN modulo m ON p2.id_profesor = m.id_profesor 
INNER JOIN curso c ON m.id_curso = c.id 
WHERE c.nombre = 'DAW1';


         -- 2) Devuelve un listado con los datos de los alumnos nacidos antes de 1996 que se hayan matriculado alguna vez en ″Programación″ de 1º de DAW.
       
SELECT *
FROM persona p INNER JOIN alumno_se_matricula_modulo asmm 
ON p.id = asmm.id_alumno 
INNER JOIN modulo m ON m.id = asmm.id_modulo 
INNER JOIN curso c ON c.id = m.id_curso 
WHERE YEAR(p.fecha_nacimiento) < 1996 AND c.nombre = 'DAW1' AND m.nombre = 'Programación';

-- 3) Número de profesores adscritos por cada departamento, ordenado por el departamento que posee mayor número de profesores.

SELECT d.nombre, COUNT(p.id_profesor) AS numProfesores
FROM departamento d INNER JOIN profesor p 
ON d.id  = p.id_departamento
GROUP BY d.nombre 
ORDER BY COUNT(p.id_profesor) DESC;

         -- 4) Año del curso con menor número de alumnos matriculados.

SELECT ce.anio, COUNT(asmm.id_alumno) AS numAlumnos
FROM curso_escolar ce INNER JOIN alumno_se_matricula_modulo asmm 
GROUP BY ce.anio 
ORDER BY COUNT(asmm.id_alumno) ASC 
LIMIT 1;

         -- 5) Crear una vista llamada NumAlumnos que obtenga por cada curso escolar el número de alumnos matriculados, ordenado por curso.

CREATE VIEW NumAlumnos AS (SELECT ce.anio, c.nombre  ,COUNT(asmm.id_alumno) 
FROM curso_escolar ce INNER JOIN alumno_se_matricula_modulo asmm 
ON ce.id = asmm.id_curso_escolar 
INNER JOIN modulo m ON asmm.id_modulo = m.id 
INNER JOIN curso c ON c.id = m.id_curso
GROUP BY ce.anio, c.nombre);

SELECT * FROM NumAlumnos;

SELECT ce.anio, c.nombre  ,COUNT(asmm.id_alumno) 
FROM curso_escolar ce INNER JOIN alumno_se_matricula_modulo asmm 
ON ce.id = asmm.id_curso_escolar 
INNER JOIN modulo m ON asmm.id_modulo = m.id 
INNER JOIN curso c ON c.id = m.id_curso
GROUP BY ce.anio, c.nombre;


-- FUNCIONES Y PROCEDIMIENTOS

        -- 1) Función "profesor_modulo" que reciba como parámetro el número identificativo del módulo profesional y 
        -- devuelva el nombre completo del profesor que lo imparte. Si el id no existe o no posee profesor asignado al módulo devolverá -1.

       --  2) Trigger que no permita insertar más de 3 profesores en un mismo departamento.

DELIMITER $$
CREATE TRIGGER maximo_pedido_cliente
BEFORE INSERT ON profesor
FOR EACH ROW 
BEGIN 
	DECLARE numProfesores INT;

      SELECT COUNT(id_profesor)
      INTO numProfesores
      from profesor p
      WHERE id_profesor = NEW.id_profesor AND id_departamento = NEW.id_departamento;

      IF (numProfesores >= 3) THEN
        SIGNAL SQLSTATE '45001' SET message_text='EL DEPARTAMENTO YA TIENE TRES PROFESORES';
      END IF;
END$$
DELIMITER ;

-- Introducimos una nueva persona

INSERT INTO persona VALUES (
	100, '12345678Q','prueba','prueba1','prueba2','prueba','prueba','123456789',
	'1994-02-25','M', 'alumno'
);

INSERT INTO profesor VALUES(
	100 , 4
);

SELECT d.nombre, COUNT(p.id_profesor) AS numProfesores
FROM departamento d INNER JOIN profesor p 
ON d.id  = p.id_departamento
GROUP BY d.nombre 
ORDER BY COUNT(p.id_profesor) DESC;



       --  3) Trigger que no permita insertar un alumno que ya está matriculado en el módulo y curso.
-- 
       --  4) Procedimiento "mostrar_informe" que dado el número identificativo del alumno, muestre el nombre completo del alumno 
       -- y el nombre de los módulos matriculados en cada curso.

























