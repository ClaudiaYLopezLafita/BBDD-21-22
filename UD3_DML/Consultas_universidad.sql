/*
 * CONSULTAS
 */

-- 1.5.5 Consultas multitabla (Composición interna)
-- 1.5.5.1 Devuelve un listado con los datos de todas las alumnas que se han matriculado alguna vez en el 
-- Grado en Ingeniería Informática (Plan 2015).

SELECT p.*
FROM persona p INNER JOIN alumno_se_matricula_asignatura asma 
					ON p.id = asma.id_alumno 
				INNER JOIN asignatura a 
					ON  asma.id_asignatura = a.id 
				INNER JOIN grado g 
					ON a.id_grado = g.id 
WHERE p.sexo LIKE 'M' AND g.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)';


-- 1.5.5.2 Devuelve un listado con todas las asignaturas ofertadas en el Grado en Ingeniería Informática (Plan 2015).

SELECT a.*
FROM asignatura a INNER JOIN grado g 
				ON a.id_grado = g.id 
WHERE g.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)';

-- 1.5.5.3 Devuelve un listado de los profesores junto con el nombre del departamento al que están vinculados. 
-- El listado debe devolver cuatro columnas, primer apellido, segundo apellido, nombre y nombre del departamento. 
-- El resultado estará ordenado alfabéticamente de menor a mayor por los apellidos y el nombre.

SELECT p2.apellido1, p2.apellido2, p2.nombre, d.nombre 
FROM persona p2 INNER JOIN profesor p 
					ON p2.id = p.id_profesor 
				INNER JOIN departamento d 
					ON p.id_departamento = d.id
ORDER BY p2.apellido1, p2.apellido2, p2.nombre DESC;

-- 1.5.5.4 Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del 
-- alumno con nif 26902806M.

SELECT a.nombre, ce.anyo_inicio, ce.anyo_fin 
FROM  persona p INNER JOIN alumno_se_matricula_asignatura asma 
						ON p.id = asma.id_alumno 
				INNER JOIN asignatura a 
						ON asma.id_asignatura = a.id 
				INNER JOIN curso_escolar ce 
						ON asma.id_curso_escolar = ce.id
WHERE p.nif LIKE '26902806M';

-- 1.5.5.5 Devuelve un listado con el nombre de todos los departamentos que tienen profesores 
-- que imparten alguna asignatura en el Grado en Ingeniería Informática (Plan 2015).

SELECT DISTINCT p.nombre, d.nombre, g.nombre 
FROM persona p INNER JOIN profesor p2 
					ON p.id = p2.id_profesor 
			   INNER JOIN departamento d 
			   		ON p2.id_departamento = d.id 
			   INNER JOIN asignatura a 
			   		ON p2.id_profesor = a.id_profesor 
			   INNER JOIN grado g 
			   		ON a.id_grado = g.id 
WHERE g.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)' AND p.tipo LIKE 'profesor'

-- 1.5.5.6 Devuelve un listado con todos los alumnos que se han matriculado en alguna 
-- asignatura durante el curso escolar 2018/2019.

SELECT DISTINCT p.*
FROM persona p INNER JOIN alumno_se_matricula_asignatura asma 
					ON p.id = asma.id_alumno 
			   INNER JOIN curso_escolar ce 
			   		ON asma.id_curso_escolar = ce.id 
WHERE p.tipo LIKE 'alumno' AND ce.anyo_inicio LIKE 2018 AND ce.anyo_fin LIKE 2019;



-- 1.5.6 Consultas multitabla (Composición externa)
-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN.

-- 1.5.6.1 Devuelve un listado con los nombres de todos los profesores y los departamentos que tienen vinculados. 
-- El listado también debe mostrar aquellos profesores que no tienen ningún departamento asociado. 
-- El listado debe devolver cuatro columnas, nombre del departamento, primer apellido, segundo apellido 
-- y nombre del profesor. El resultado estará ordenado alfabéticamente de menor a mayor por el nombre 
-- del departamento, apellidos y el nombre.

SELECT d.nombre, p.apellido1, p.apellido2, p.nombre 
FROM persona p RIGHT JOIN profesor p2 
					ON p.id = p2.id_profesor 
			   LEFT JOIN departamento d 
			   		ON p2.id_departamento = d.id
WHERE p.tipo LIKE 'profesor'
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre DESC ; 


-- 1.5.6.2 Devuelve un listado con los profesores que no están asociados a un departamento.

SELECT p.*
FROM profesor p LEFT JOIN departamento d 
				ON p.id_departamento = d.id
WHERE p.id_departamento IS NULL;
			-- SALE VACIA XQ TODOS LOS PROFESORRES DEBEN TENER UN DEPARTAMENTO ASIGNADO (NOT NULL TRUE)

-- 1.5.6.3 Devuelve un listado con los departamentos que no tienen profesores asociados.

SELECT d.*
FROM profesor p RIGHT JOIN departamento d 
				ON p.id_departamento = d.id
WHERE p.id_profesor IS NULL;

-- 1.5.6.4 Devuelve un listado con los profesores que no imparten ninguna asignatura.

SELECT p.id_departamento, p2.*
FROM profesor p LEFT JOIN asignatura a 
				ON p.id_profesor = a.id_profesor
				INNER JOIN persona p2 
				ON p.id_profesor = p2.id 
WHERE a.id IS NULL;

-- 1.5.6.5 Devuelve un listado con las asignaturas que no tienen un profesor asignado.

SELECT a.*
FROM profesor p RIGHT JOIN asignatura a 
					ON p.id_profesor = a.id_profesor
WHERE a.id_profesor IS NULL;

-- 1.5.6.6 Devuelve un listado con todos los departamentos que tienen alguna asignatura que no se haya impartido 
-- en ningún curso escolar. El resultado debe mostrar el nombre del departamento y el nombre de la asignatura que
-- no se haya impartido nunca.

SELECT d.*, a.*
FROM departamento d INNER JOIN profesor p 
							ON d.id = p.id_departamento 
					INNER JOIN asignatura a 
							ON p.id_profesor = a.id_profesor 
					LEFT JOIN alumno_se_matricula_asignatura asma 
							ON a.id = asma.id_asignatura AND asma.id_curso_escolar IS not NULL
					LEFT join alumno_se_matricula_asignatura asma2 
							ON a.id = asma2.id_asignatura AND asma2.id_curso_escolar IS NULL
														AND asma2.id_curso_escolar <> asma.id_curso_escolar;
					
					
-- 1.5.7 Consultas resumen
-- 1.5.7.1 Devuelve el número total de alumnas que hay.
													
SELECT COUNT(p.id) 
FROM persona p 
WHERE p.tipo LIKE 'alumno' AND p.sexo LIKE 'M' ;

-- 1.5.7.2 Calcula cuántos alumnos nacieron en 1999.

SELECT COUNT(p.id) 
FROM persona p 
WHERE p.tipo LIKE 'alumno' AND YEAR(p.fecha_nacimiento) = 1999

-- 1.5.7.3 Calcula cuántos profesores hay en cada departamento. El resultado sólo debe mostrar dos columnas, 
-- una con el nombre del departamento y otra con el número de profesores que hay en ese departamento. 
-- El resultado sólo debe incluir los departamentos que tienen profesores asociados y deberá estar ordenado 
-- de mayor a menor por el número de profesores.

SELECT d.nombre, COUNT(p.id_profesor) 
FROM profesor p INNER JOIN departamento d 
					ON p.id_departamento = d.id 
GROUP BY d.nombre
ORDER BY COUNT(p.id_profesor) DESC;

-- 1.5.7.4 Devuelve un listado con todos los departamentos y el número de profesores que hay en cada uno de ellos. 
-- Tenga en cuenta que pueden existir departamentos que no tienen profesores asociados. 
-- Estos departamentos también tienen que aparecer en el listado.

SELECT d.nombre,  COUNT(p.id_profesor) 
FROM profesor p RIGHT JOIN departamento d 
					ON p.id_departamento  = d.id 
GROUP BY d.id;

-- 1.5.7.5 Devuelve un listado con el nombre de todos los grados existentes en la base de datos y 
-- el número de asignaturas que tiene cada uno. Tenga en cuenta que pueden existir grados que no tienen 
-- asignaturas asociadas. Estos grados también tienen que aparecer en el listado. 
-- El resultado deberá estar ordenado de mayor a menor por el número de asignaturas.

SELECT g.nombre, COUNT(a.id) 
FROM grado g LEFT JOIN asignatura a 	
					ON g.id = a.id_grado 
GROUP BY g.nombre 
ORDER BY COUNT(a.id) DESC;

-- 1.5.7.6 Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de
-- asignaturas que tiene cada uno, de los grados que tengan más de 40 asignaturas asociadas.

SELECT g.nombre, COUNT(a.id) 
FROM grado g LEFT JOIN asignatura a 	
					ON g.id = a.id_grado 
GROUP BY g.nombre 
HAVING  COUNT(a.id) > 40
ORDER BY COUNT(a.id) DESC;

-- 1.5.7.7 Devuelve un listado que muestre el nombre de los grados y la suma del número total de créditos que
--  hay para cada tipo de asignatura. El resultado debe tener tres columnas: nombre del grado, tipo de asignatura 
-- y la suma de los créditos de todas las asignaturas que hay de ese tipo. Ordene el resultado de mayor a menor por 
-- el número total de crédidos.

SELECT g.nombre, a.tipo, SUM(IFNULL(a.creditos,0))
FROM grado g LEFT JOIN asignatura a 
			 ON g.id = a.id_grado 
GROUP BY g.nombre, a.tipo 
ORDER BY  SUM(IFNULL(a.creditos,0)) DESC;

-- 1.5.7.8 Devuelve un listado que muestre cuántos alumnos se han matriculado de alguna asignatura en cada uno de 
-- los cursos escolares. El resultado deberá mostrar dos columnas, una columna con el año de inicio del curso escolar 
-- y otra con el número de alumnos matriculados.

SELECT ce.anyo_inicio, COUNT(p .id) 
FROM persona p INNER JOIN alumno_se_matricula_asignatura asma 
						ON p.id = asma.id_alumno 
			  INNER JOIN curso_escolar ce 
			  			ON asma.id_curso_escolar = ce.id 
WHERE p.tipo LIKE 'alumno'
GROUP BY ce.anyo_inicio;	   

-- 1.5.7.9 Devuelve un listado con el número de asignaturas que imparte cada profesor. 
-- El listado debe tener en cuenta aquellos profesores que no imparten ninguna asignatura. 
-- El resultado mostrará cinco columnas: id, nombre, primer apellido, segundo apellido y número de asignaturas.
-- El resultado estará ordenado de mayor a menor por el número de asignaturas.
					
SELECT p.id_profesor, p2.nombre, p2.apellido1, p2.apellido2, COUNT(a.id) 
FROM asignatura a RIGHT JOIN profesor p 
						ON a.id_profesor = p.id_profesor 	
				  INNER JOIN persona p2 
				  		ON p.id_profesor = p2.id 
WHERE p2.tipo LIKE 'profesor'
GROUP BY p.id_profesor
ORDER BY COUNT(a.id)  ASC ;




-- 1.5.8 Subconsultas
-- 1.5.8.1 Devuelve todos los datos del alumno más joven.

SELECT p.*
FROM persona p
WHERE p.tipo LIKE  'alumno' AND p.fecha_nacimiento =  (SELECT MAX(p2.fecha_nacimiento)
													FROM persona p2)

-- 1.5.8.2 Devuelve un listado con los profesores que no están asociados a un departamento.
													
SELECT p.*
FROM profesor p 
WHERE p.id_profesor != ALL (SELECT p2.id_profesor 
						FROM departamento d  RIGHT JOIN profesor p2
											ON d.id = p2.id_departamento)
		-- Sale vacia porque todos los profesores tiene que tener un departamento asociado.
																	
-- 1.5.8.3 Devuelve un listado con los departamentos que no tienen profesores asociados.
											
SELECT d2.*
FROM departamento d2 
WHERE d2.id = ANY (SELECT d.id 
				FROM departamento d  LEFT JOIN profesor p2
									ON d.id = p2.id_departamento
				WHERE p2.id_profesor IS NULL)	
														
-- 1.5.8.4 Devuelve un listado con los profesores que tienen un departamento asociado y que no imparten ninguna asignatura.
				
SELECT DISTINCT p.*
FROM profesor p LEFT JOIN asignatura a 
				ON p.id_profesor = a.id_profesor 
				INNER JOIN departamento d 
				ON p.id_departamento = d.id;
WHERE a.id IS NULL

				
-- 1.5.8.5  Devuelve un listado con las asignaturas que no tienen un profesor asignado.

SELECT a.*
FROM profesor p RIGHT JOIN asignatura a 
					ON p.id_profesor = a.id_profesor 
WHERE p.id_profesor IS NULL;
