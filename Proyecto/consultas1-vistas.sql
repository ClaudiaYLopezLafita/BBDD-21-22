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



