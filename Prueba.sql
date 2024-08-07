CREATE DATABASE "prueba-matias-moncada-888";


-- DROP commands
Drop Table peliculas_tags, tags, peliculas;
Drop Table Respuestas, Usuarios, Preguntas;

-- 1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves primarias, foráneas y tipos de datos.
-- Crear Tabla de Peliculas
CREATE TABLE peliculas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    anno INTEGER
);

-- Crear Tabla de Tags
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    tag VARCHAR(32)
);

-- Creamos la Tabla de similitudes q une Peliculas con Tags
CREATE TABLE peliculas_tags (
    id SERIAL PRIMARY KEY,
    pelicula_id INTEGER,
    tag_id INTEGER,
    pelicula_nombre VARCHAR(255),
    tag_nombre VARCHAR(255),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- 2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la segunda película debe tener 2 tags asociados.
-- Insertamos los valores a la Tabla Peliculas
INSERT INTO peliculas (id, nombre, anno) VALUES (1, 'Deadpool', 2016),
(2, 'Fast and Furious 7', 2015),
(3, 'Blood and Bone', 2009),
(4, 'Taken 1', 2008),
(5, 'John Wick 1', 2014);

SELECT * FROM peliculas;

-- Insertamos los valores a la Tabla Tags
INSERT INTO tags (id, tag) VALUES (1, 'Action'),
(2, 'Comedy'),
(3, 'Superhero'),
(4, 'Thriller'),
(5, 'Adventure');

SELECT * FROM tags;

-- Insertamos los valores a la tercera Tabla de peliculas_tags
INSERT INTO peliculas_tags (pelicula_id, tag_id, pelicula_nombre, tag_nombre) VALUES (1, 1, 'Deadpool', 'Action'),
(1, 2, 'Deadpool', 'Comedy'),
(1, 3, 'Deadpool', 'Superhero'),
(2, 1, 'Fast and Furious 7', 'Action'),
(2, 4, 'Fast and Furious 7', 'Thriller');

SELECT * FROM peliculas_tags;

-- 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
-- Comando para contar los tags de cada pelicula
SELECT p.nombre, COUNT(pt.tag_id) AS tag_count -- Se busca los datos q queremos recuperar, nombre de pelicula y se cuenta los tags asociados. Alias.
FROM peliculas p -- Basado de la tabla peliculas con el alias p
LEFT JOIN peliculas_tags pt ON p.id = pt.pelicula_id -- Left join con peliculas_tags table, filas de peliculas table se vera en el resultado. 
GROUP BY p.nombre, p.id -- ON es condicion tags deben hacer match. -- Agrupamos los resultados por su nombre y por su id
ORDER BY p.id ASC; -- Nos basamos en el id para ordenarlas en forma ascendente, es decir del 1 al 5.


-- 4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.
-- Ahora creamos otras tablas...
--  Creamos la Tabla Preguntas 
CREATE TABLE preguntas (
    id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

-- Creamos la Tabla Usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    edad INT -- CHECK (edad >= 18) -- Agregamos de paso la restriccion de edad minima 18 años
);

-- Creamos la 3era Tabla de Respuestas
CREATE TABLE respuestas (
    id SERIAL PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id) ON DELETE CASCADE
);


-- 5. Agrega 5 usuarios y 5 preguntas. 
-- a. La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
-- b. La segunda pregunta debe estar contestada correctamente solo por un usuario.
-- c. Las otras tres preguntas deben tener respuestas incorrectas.
-- Contestada correctamente significa que la respuesta indicada en la tabla respuestas es exactamente igual al texto indicado en la tabla de preguntas.

-- Ahora vamos con el insert de valores para la Tabla preguntas
INSERT INTO preguntas (id, pregunta, respuesta_correcta) VALUES
(1, 'Cual es el actor que juega el papel de DeadPool?', 'Ryan Reynolds'),
(2, 'Que ocurre con el actor de Paul Walker en la vida real durante esta pelicula?', 'Muere en un choque'),
(3, 'Michael Jai White sabe artes marciales en la vida real?', 'Si'),
(4, 'Cual es el nombre de la actriz que juega el rol de la niña raptada en Taken?', 'Maggie Grace'),
(5, 'Por que John Wick comienza a matar denuevo?', 'Matan a su perro');

SELECT * FROM preguntas;

-- Ahora hacemos el insert de los valores para la Tabla respuestas
INSERT INTO usuarios (id, nombre, edad) VALUES
(1, 'Santiago', 21),
(2, 'Ignacia', 22),
(3, 'Jaime', 31),
(4, 'Maria', 27),
(5, 'Michael', 35);

SELECT * FROM usuarios;

-- Ahora hacemos el insert de los valores para la Tabla de las respuestas segun parametros de lo solicitado
INSERT INTO respuestas (id, respuesta, usuario_id, pregunta_id) VALUES
(1, 'Ryan Reynolds', 1, 1),
(2, 'Ryan Reynolds', 2, 1),
(3, 'Se casa con Toreto', 3, 2),
(4, 'Muere en un choque', 4, 2),
(5, 'No', 1, 3),
(6, 'Solo es show', 2, 3),
(7, 'Kim', 3, 4),
(8, 'Johanna', 4, 4),
(9, 'Matan al hijo', 5, 5);

SELECT * FROM respuestas;

--  6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).

SELECT u.id AS usuario_id, u.nombre, COUNT(r.id) AS correct_answers -- Select id de usuarios renombramos. Select nombre de usuario u.nombre.
FROM usuarios u -- Hacemos count de id en respuestas TABLE, display como correct_answers. -- FROM Nos basamos en la tabla usuarios.
LEFT JOIN respuestas r ON u.id = r.usuario_id -- Se vera todos los datos de usuarios y se mostrara con lo q haga match de respuestas TABLE. 
LEFT JOIN preguntas p ON r.pregunta_id = p.id -- Permite acceso a respuestas correctas asociadas con las preguntas. 
WHERE r.respuesta = p.respuesta_correcta -- Condicion que define que campos deben ser iguales para dar respuesta correcta.
GROUP BY u.id, u.nombre -- Agrupar por id y nombre de tabla usuarios.
ORDER BY u.id; -- Ordenar por id de usuarios. 

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.

SELECT p.id AS pregunta_id, p.pregunta, COUNT(r.usuario_id) AS correct_users -- Select de las columnas q traeremos de la DB. Traemos id y text de preguntas.
FROM preguntas p -- contamos los usuarios que dieron respuestas correctas. -- FROM tabla preguntas. La p es el alias q le damos.
LEFT JOIN respuestas r ON p.id = r.pregunta_id -- Todos los datos seleccionados de preguntas hacemos join con los match de la tabla respuestas. ON especifica los dos campos q deben hacer match para q ocurra el join.
WHERE r.respuesta = p.respuesta_correcta -- Condicion donde tiene q haber match perfecto.
GROUP BY p.id, p.pregunta -- Agrupamos bor id y texto de pregunta. 
ORDER BY p.id; -- Ordenamos por id de pregunta.

-- 8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.

DELETE FROM usuarios WHERE id = 1; -- Borramos de tabla usuario el id 1 y todo aquello que esta linkeado a el por una FK se borrara automaticamente.
-- Verificamos ahora las tablas para ver que se borrara exitosamente.
SELECT * FROM respuestas;
SELECT * FROM usuarios; 


-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
-- Ahora probamos la restriccion e intentamos agregar un usuario menor de edad
ALTER TABLE Usuarios                    
ADD CONSTRAINT edad_mayor_igual_a_18    
CHECK (edad >= 18);
INSERT INTO usuarios (id, nombre, edad) VALUES (6, 'Jonatan', 13);

-- 10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.

ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

SELECT * FROM usuarios;