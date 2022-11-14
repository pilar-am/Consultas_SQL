-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--


-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.

SELECT apellido1, apellido2, nombre FROM persona WHERE tipo LIKE 'alumno' ORDER BY apellido1 DESC, apellido2 DESC, nombre DESC;


-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.

SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo LIKE 'alumno' AND telefono IS NULL;


-- 3. Retorna el llistat dels alumnes que van néixer en 1999.

SELECT * FROM persona WHERE tipo LIKE 'alumno' AND year(fecha_nacimiento)='1999';


-- 4. Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.

SELECT nombre, apellido1, apellido2, nif FROM persona WHERE tipo LIKE 'profesor' AND telefono IS NULL AND nif LIKE '%K'


-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.

SELECT nombre FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;


-- 6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.

SELECT p.apellido1, p.apellido2, p.nombre, d.nombre FROM persona p, profesor f, departamento d WHERE p.id=f.id_profesor AND f.id_departamento=d.id ORDER BY p.apellido1 DESC, p.apellido2 DESC, p.nombre DESC;


-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.

SELECT a.nombre, c.anyo_inicio, c.anyo_fin FROM persona e, asignatura a, alumno_se_matricula_asignatura m, curso_escolar c WHERE e.id=m.id_alumno AND a.id=m.id_asignatura AND m.id_curso_escolar=c.id AND e.nif='26902806M';


-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).

SELECT DISTINCT d.nombre FROM departamento d, profesor p, asignatura a, grado g WHERE d.id=p.id_departamento AND p.id_profesor=a.id_profesor AND a.id_grado=g.id AND g.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)';


-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.

SELECT DISTINCT p.apellido1, p.apellido2, p.nombre FROM persona p, alumno_se_matricula_asignatura a, curso_escolar c WHERE p.id=a.id_alumno AND a.id_curso_escolar=c.id AND year(c.anyo_inicio)='2018';




-- LEFT JOIN/ RIGHT JOIN

-- 1. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.

SELECT p.apellido1, p.apellido2, p.nombre, d.nombre FROM persona p LEFT JOIN profesor f ON p.id=f.id_profesor JOIN departamento d ON f.id_departamento=d.id ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;


-- 2. Retorna un llistat amb els professors/es que no estan associats a un departament.

SELECT p.apellido1, p.apellido2, p.nombre, d.nombre FROM persona p LEFT JOIN profesor f ON p.id=f.id_profesor LEFT JOIN departamento d ON f.id_departamento=d.id WHERE p.tipo LIKE 'profesor' AND d.id IS NULL;


-- 3. Retorna un llistat amb els departaments que no tenen professors/es associats.

SELECT d.nombre FROM departamento d LEFT JOIN profesor p ON d.id=p.id_departamento WHERE p.id_departamento IS NULL;


-- 4. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.

SELECT p.nombre FROM persona p LEFT JOIN profesor f ON p.id=f.id_profesor LEFT JOIN asignatura a ON f.id_profesor=a.id_profesor WHERE a.id_profesor IS NULL;


-- 5. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.

SELECT a.nombre FROM asignatura a LEFT JOIN profesor f ON a.id_profesor=f.id_profesor WHERE a.id_profesor IS NULL;


-- 6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.

SELECT DISTINCT d.id, d.nombre FROM departamento d LEFT JOIN profesor f ON d.id=f.id_departamento LEFT JOIN asignatura a ON f.id_profesor=a.id_profesor LEFT JOIN alumno_se_matricula_asignatura m ON a.id=m.id_asignatura LEFT JOIN curso_escolar r ON m.id_curso_escolar=r.id WHERE a.id_profesor IS NULL;




-- CONSULTES RESUM

-- 1. Retorna el nombre total d'alumnes que hi ha.

SELECT COUNT(*) AS nombre_alumnes FROM persona WHERE tipo LIKE 'alumno';


-- 2. Calcula quants alumnes van néixer en 1999.

SELECT COUNT(*) AS Nascuts_1999 FROM persona WHERE tipo LIKE 'alumno' AND year(fecha_nacimiento)='1999'


-- 3. Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.

SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS num_profesores FROM departamento d INNER JOIN profesor p ON d.id=p.id_departamento GROUP BY d.nombre ORDER BY COUNT(p.id_profesor) DESC;


-- 4. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat. 

SELECT d.nombre AS departamento, COUNT(p.id_profesor) AS num_profesores FROM departamento d LEFT JOIN profesor p ON d.id=p.id_departamento GROUP BY d.nombre ORDER BY COUNT(p.id_profesor) DESC;


-- 5. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.

SELECT g.nombre AS grado, COUNT(a.id) AS num_asignaturas FROM grado g LEFT JOIN asignatura a ON g.id=a.id_grado GROUP BY g.nombre ORDER BY COUNT(a.id) DESC;


-- 6. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.

SELECT g.nombre AS grado, COUNT(a.id) AS num_asignaturas FROM grado g LEFT JOIN asignatura a ON g.id=a.id_grado GROUP BY g.nombre HAVING COUNT(a.id) > 40;


-- 7. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.

SELECT g.nombre AS grado, a.tipo, SUM(a.creditos) FROM grado g, asignatura a WHERE g.id=a.id_grado GROUP BY g.nombre, a.tipo;


-- 8. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.

SELECT c.anyo_inicio, COUNT(DISTINCT a.id_alumno) AS quantitat_alumnes FROM curso_escolar c LEFT JOIN alumno_se_matricula_asignatura a ON c.id=a.id_curso_escolar GROUP BY c.anyo_inicio;


-- 9. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.

SELECT p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS nombre_assignatures FROM persona p JOIN profesor f ON p.id=f.id_profesor LEFT JOIN asignatura a ON f.id_profesor=a.id_profesor GROUP BY p.id;


-- 10. Retorna totes les dades de l'alumne/a més jove.

SELECT * FROM persona WHERE tipo LIKE 'alumno' ORDER BY fecha_nacimiento DESC LIMIT 1


-- 11. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.

SELECT DISTINCT p.nombre, p.apellido1, p.apellido2, p.id FROM persona p JOIN profesor f ON p.id=f.id_profesor LEFT JOIN asignatura a ON f.id_profesor=a.id_profesor WHERE a.id_profesor IS NULL;


