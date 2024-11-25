 CREATE DATABASE VIDEOCLUB
    USE VIDEOCLUB
    
DROP DATABASE VIDEOCLUB

--CREACION TABLAS
CREATE TABLE Cliente(
    ID_Cliente int primary key identity(10,1),
    nombre varchar(30),
    email varchar(30),
    contacto varchar(10),
    direccion varchar(40),
    fecha_nacimiento date,
    edad AS DATEDIFF(YEAR,fecha_nacimiento,GETDATE()) -
				CASE WHEN MONTH(fecha_nacimiento)>MONTH(GETDATE()) OR
						  (MONTH(fecha_nacimiento)=MONTH(GETDATE()) AND
						  DAY(fecha_nacimiento)>DAY(GETDATE()))
						  THEN 1
						  ELSE 0 
						  END 
)

--DBCC CHECKIDENT ('nombre_tabla', RESEED, nueva_semilla);
CREATE TABLE Membresia(
    ID_Membresia int primary key identity(10,1),
    tipo varchar(30),
    descuento int,
    costo_mensual money
)

CREATE TABLE Proveedor(
    ID_Proveedor int PRIMARY KEY identity(10,1),
    nombre varchar(30),
    email varchar(30),
    tipo varchar(10)
)

CREATE TABLE Empleado(
	ID_Empleado int primary key identity(10,1),
	nombre varchar(30),
	cargo varchar(30),
	contacto varchar(30)
)

CREATE TABLE Alquiler(
	ID_Alquiler int  PRIMARY KEY identity(10,1),
	fecha_alquiler DATE,
	fecha_devolucion DATE,
	monto AS (DATEDIFF(DAY,fecha_alquiler,fecha_devolucion)*12.0) PERSISTED,
    ID_Cliente INT,
    ID_Empleado INT
)

CREATE TABLE Pelicula(
	ID_Pelicula int primary key identity(10,1),
	titulo varchar(30),
	genero varchar(50),
	duracion TIME,
	año_lanzamiento DATE,
	clasificacion varchar(5),
	director varchar(30)
)

CREATE TABLE Inventario(
    ID_Inventario int PRIMARY KEY identity(10,1),
	fecha_adquisicion DATE,
    estado varchar(15),
    ID_Pelicula INT
)

CREATE TABLE Alquiler_Inventario(
    ID_Alquiler int,
    ID_Inventario int,
    cantidad int
)

CREATE TABLE Proveedor_Pelicula(
    ID_Proveedor int,
    ID_Pelicula int,
    precio money,
    fecha_proveedor DATE
)

CREATE TABLE Cliente_Membresia(
    ID_Membresia int,
    ID_Cliente int,
    codigo_barras varchar(30)
)

--RESTRICCIONES
--Restriccion para Empleado
ALTER TABLE Empleado
	ADD CONSTRAINT CK_Emplea_Cargo UNIQUE (ID_Empleado, cargo) --Empleado solo 1 cargo

--Resticciones para Cliente
 ALTER TABLE Cliente
    ADD CONSTRAINT CK_Nombre CHECK(nombre NOT LIKE '%[^A-Za-z ]%'); --Nombre solo letras min y mayus

ALTER TABLE Cliente
    ADD CONSTRAINT CK_Contacto CHECK(contacto NOT LIKE '%[^0-9]%') --Contacto solo numeros(cel)

--Restriccion para Inventario
ALTER TABLE Inventario
	ADD CONSTRAINT CK_Fecha_Adquisicion CHECK(fecha_adquisicion<=GETDATE()) --La fecha de adquisicion no pase de la fecha actual

--Restriccion para Pelicula
ALTER TABLE Pelicula
    ADD CONSTRAINT CK_Duracion CHECK(duracion BETWEEN '01:00:00' AND '04:00:00') --Rango de duracion

--Restricciones para Proveedor
ALTER TABLE Proveedor
    ADD CONSTRAINT CK_Email CHECK (
        email LIKE '%_@gmail.com' OR
        email LIKE '%_@yahoo.com' OR
        email LIKE '%_@outlook.com' OR
        email LIKE '%_@gmail.es' OR
        email LIKE '%_@yahoo.es' OR
        email LIKE '%_@outlook.es'
    )	
--Restricciones para Alquiler
ALTER TABLE Alquiler
    ADD CONSTRAINT CK_FechaAlquiler CHECK(fecha_alquiler<=GETDATE())  --fecha real para alquiler
                                                                                
ALTER TABLE Alquiler
    ADD CONSTRAINT CK_FechaDevolucion CHECK(fecha_devolucion<=GETDATE()) --fecha real devolucion

ALTER TABLE Membresia
    ADD CONSTRAINT CK_Membresia CHECK(tipo in ('Basica','VIP','Premium')) 

--MODELO RELACIONAL
ALTER TABLE Inventario
    ADD FOREIGN KEY (ID_Pelicula) REFERENCES Pelicula(ID_Pelicula) 

ALTER TABLE Alquiler
    ADD FOREIGN KEY (ID_Empleado) REFERENCES Empleado(ID_Empleado) 

ALTER TABLE Alquiler
    ADD FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente) 

ALTER TABLE Alquiler_Inventario
    ADD FOREIGN KEY (ID_Alquiler) REFERENCES Alquiler(ID_Alquiler) 

ALTER TABLE Alquiler_Inventario
    ADD FOREIGN KEY (ID_Inventario) REFERENCES Inventario(ID_Inventario) 

ALTER TABLE Proveedor_Pelicula
    ADD FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor)

ALTER TABLE Proveedor_Pelicula
    ADD FOREIGN KEY (ID_Pelicula) REFERENCES Pelicula(ID_Pelicula)

ALTER TABLE Cliente_Membresia
    ADD FOREIGN KEY (ID_Membresia) REFERENCES Membresia(ID_Membresia)

ALTER TABLE Cliente_Membresia
    ADD FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)

--AGREGAR VALORES
INSERT INTO Cliente (nombre, email, contacto, direccion, fecha_nacimiento) VALUES
('Carlos Perez', 'carlos.perez@gmail.com', '5512345678', 'Av. Central 123', '1995-05-12'),
('Maria Lopez', 'maria.lopez@yahoo.com', '5567891234', 'Calle Sur 456', '1988-08-20'),
('Juan Torres', 'juan.torres@outlook.com', '5534567890', 'Calle Norte 789', '2000-12-15'),
('Ana Garcia', 'ana.garcia@gmail.es', '5543219876', 'Av. Oriente 321', '1993-03-10'),
('Pedro Sanchez', 'pedro.sanchez@gmail.com', '5519876543', 'Calle Poniente 987', '1985-11-02'),
('Laura Martinez', 'laura.martinez@yahoo.es', '5523456789', 'Av. Revolución 654', '1990-07-19'),
('Sofia Fernandez', 'sofia.fernandez@gmail.com', '5565432198', 'Calle Progreso 432', '1998-10-25'),
('Diego Ramirez', 'diego.ramirez@outlook.es', '5532198765', 'Av. Libertad 876', '1983-09-30'),
('Valeria Gomez', 'valeria.gomez@gmail.com', '5521987654', 'Calle Unión 765', '1992-04-17'),
('Miguel Herrera', 'miguel.herrera@yahoo.com', '5545678912', 'Av. Paz 567', '1997-06-05'),
('Fernanda Morales', 'fernanda.morales@gmail.com', '5534567891', 'Calle Luz 234', '1994-02-28'),
('Luis Dominguez', 'luis.dominguez@outlook.com', '5561237890', 'Av. Horizonte 123', '1991-01-01'),
('Gloria Alvarez', 'gloria.alvarez@yahoo.com', '5556781234', 'Calle Lluvia 321', '1989-11-11'),
('Sebastian Vega', 'sebastian.vega@gmail.es', '5543218765', 'Calle Brisa 654', '2002-03-21'),
('Natalia Ruiz', 'natalia.ruiz@gmail.com', '5576543219', 'Av. Rayo 987', '1987-10-18');

INSERT INTO Membresia (tipo, descuento, costo_mensual) VALUES
('Basica', 10, 99.99),
('VIP', 20, 199.99),
('Premium', 30, 299.99);

INSERT INTO Proveedor (nombre, email, tipo) VALUES
('Carlos Perez', 'carlos.perez@gmail.com', 'Peliculas'),
('Maria Lopez', 'maria.lopez@yahoo.com', 'Series'),
('Juan Torres', 'juan.torres@outlook.com', 'Series'),
('Ana Garcia', 'ana.garcia@gmail.es', 'Documnts'), -- Abreviación de Documentales
('Pedro Sanchez', 'pedro.sanchez@gmail.com', 'Peliculas'),
('Laura Martinez', 'laura.martinez@yahoo.es', 'Series'),
('Sofia Fernandez', 'sofia.fernandez@gmail.com', 'Documnts'),
('Diego Ramirez', 'diego.ramirez@outlook.es', 'Peliculas'),
('Valeria Gomez', 'valeria.gomez@gmail.com', 'Series'),
('Miguel Herrera', 'miguel.herrera@yahoo.com', 'Documnts'),
('Fernanda Morales', 'fernanda.morales@gmail.com', 'Peliculas'),
('Luis Dominguez', 'luis.dominguez@outlook.com', 'Series'),
('Gloria Alvarez', 'gloria.alvarez@yahoo.com', 'Peliculas'),
('Sebastian Vega', 'sebastian.vega@gmail.es', 'Series'),
('Natalia Ruiz', 'natalia.ruiz@gmail.com', 'Documnts');

INSERT INTO Empleado (nombre, cargo, contacto) VALUES
('Luis Gomez', 'Gerente', '5532145678'),
('Ana Perez', 'Cajero', '5545678932'),
('Maria Torres', 'Administrador', '5538765432'),
('Juan Sanchez', 'Supervisor', '5523456789'),
('Carla Fernandez', 'Encargado', '5545678943'),
('Diego Ramirez', 'Cajero', '5556789210'),
('Laura Alvarez', 'Ventas', '5549876543'),
('Pedro Vega', 'Ventas', '5521123456'),
('Sofia Morales', 'Ventas', '5543219876'),
('Fernando Lopez', 'Ventas', '5567894321'),
('Miguel Herrera', 'Ventas', '5523456123'),
('Natalia Garcia', 'Cajero', '5565432198'),
('Sebastian Cruz', 'Administrador', '5545678910'),
('Valeria Ruiz', 'Ventas', '5551234567'),
('Gloria Dominguez', 'Cajero', '5532147896');

INSERT INTO Pelicula (titulo, genero, duracion, año_lanzamiento, clasificacion, director) VALUES
('El Padrino', 'Drama/Crimen', '02:55:00', '1972-03-24', 'R', 'Francis Coppola'),
('El Señor Anillos', 'Fantasía/Aventura', '03:48:00', '2001-12-19', 'PG-13', 'Peter Jackson'),
('Pulp Fiction', 'Drama/Crimen', '02:34:00', '1994-10-14', 'R', 'Quentin Tarantino'),
('Forest Gump', 'Drama/Romance', '02:22:00', '1994-07-06', 'PG-13', 'Robert Zemeckis'),
('Matrix', 'Ciencia Fic./Acción', '02:16:00', '1999-03-31', 'R', 'Lana Wachowski'),
('Jurassic Park', 'Ciencia Fic./Aventura', '02:07:00', '1993-06-11', 'PG-13', 'Steven Spielberg'),
('Titanic', 'Drama/Romance', '03:14:00', '1997-12-19', 'PG-13', 'James Cameron'),
('Gladiador', 'Acción/Drama', '02:35:00', '2000-05-01', 'R', 'Ridley Scott'),
('Inception', 'Ciencia Fic./Thriller', '02:28:00', '2010-07-16', 'PG-13', 'Christopher Nolan'),
('Star Wars: Hope', 'Fantasía/Aventura', '02:01:00', '1977-05-25', 'PG', 'George Lucas'),
('Caballero Noche', 'Acción/Crimen', '02:32:00', '2008-07-18', 'PG-13', 'Christopher Nolan'),
('Avengers Endgame', 'Acción/Ciencia Fic.', '03:01:00', '2019-04-26', 'PG-13', 'Anthony Russo'),
('Coco', 'Animación/Familia', '01:45:00', '2017-10-27', 'PG', 'Lee Unkrich'),
('Toy Story', 'Animación/Familia', '01:21:00', '1995-11-22', 'G', 'John Lasseter'),
('Avatar', 'Ciencia Fic./Aventura', '02:42:00', '2009-12-18', 'PG-13', 'James Cameron');

INSERT INTO Alquiler (fecha_alquiler, fecha_devolucion, ID_Cliente, ID_Empleado) VALUES
('2024-11-01', '2024-11-10', 10, 11),
('2024-11-02', '2024-11-06', 11, 11),
('2024-11-03', '2024-11-22', 12, 15),
('2024-11-04', '2024-11-06', 13, 21),
('2024-11-05', '2024-11-11', 14, 16),
('2024-11-11', '2024-11-23', 15, 17),
('2024-11-02', '2024-11-11', 16, 18),
('2024-11-08', '2024-11-12', 17, 19),
('2024-11-09', '2024-11-13', 18, 20),
('2024-11-10', '2024-11-11', 19, 20),
('2024-11-21', '2024-11-22', 20, 23),
('2024-11-01', '2024-11-16', 21, 11),
('2024-11-01', '2024-11-17', 22, 24),
('2024-11-02', '2024-11-18', 23, 16),
('2024-11-15', '2024-11-19', 24, 11);

INSERT INTO Inventario (fecha_adquisicion, estado, ID_Pelicula) VALUES  
('2024-01-10', 'Disponible', 10),
('2024-02-15', 'Disponible', 11),
('2024-03-20', 'Rentado', 12),
('2024-04-05', 'Rentado', 13),
('2024-05-10', 'En Reparación', 14),
('2024-06-25', 'Disponible', 15),
('2024-07-14', 'Disponible', 16),
('2024-08-01', 'Rentado', 17),
('2024-09-18', 'Rentado', 18),
('2024-10-22', 'En Reparación', 19),
('2024-11-05', 'Disponible', 20),
('2024-11-12', 'Disponible', 21),
('2024-11-17', 'Rentado', 22),
('2024-11-18', 'Rentado', 23),
('2024-11-19', 'Disponible', 24);

INSERT INTO Alquiler_Inventario (ID_Alquiler, ID_Inventario, cantidad) VALUES 
(10, 10, 1),
(11, 11, 1),
(12, 12, 1),
(13, 13, 1),
(14, 14, 1),
(15, 15, 1),
(16, 16, 1),
(17, 17, 1),
(18, 18, 1),
(19, 19, 1),
(20, 20, 1),
(21, 21, 1),
(22, 22, 1),
(23, 23, 1),
(24, 24, 1);

INSERT INTO Proveedor_Pelicula (ID_Proveedor, ID_Pelicula, precio, fecha_proveedor) VALUES
(10, 10, 120.00, '2024-01-10'),
(11, 11, 130.00, '2024-02-15'),
(12, 12, 140.00, '2024-03-20'),
(13, 13, 150.00, '2024-04-05'),
(14, 14, 160.00, '2024-05-10'),
(15, 15, 170.00, '2024-06-25'),
(16, 16, 180.00, '2024-07-14'),
(17, 17, 190.00, '2024-08-01'),
(18, 18, 200.00, '2024-09-18'),
(19, 19, 210.00, '2024-10-22'),
(20, 20, 220.00, '2024-11-05'),
(21, 21, 230.00, '2024-11-12'),
(22, 22, 240.00, '2024-11-17'),
(23, 23, 250.00, '2024-11-18'),
(24, 24, 260.00, '2024-11-19');

INSERT INTO Cliente_Membresia (ID_Membresia, ID_Cliente, codigo_barras) VALUES
(10, 10, '123456789012345'),
(10, 11, '123456789112345'),
(10, 12, '123456789212345'),
(10, 13, '123456789312345'),
(11, 14, '123456789412345'),
(12, 15, '123456789512345'),
(10, 16, '123456789612345'),
(11, 17, '123456789712345'),
(11, 18, '123456789812345'),
(12, 19, '123456789912345'),
(12, 20, '123456789013245'),
(11, 21, '123456789113245'),
(10, 22, '123456789213245'),
(10, 23, '123456789313245'),
(10, 24, '123456789413245');

SELECT * FROM Cliente
SELECT * FROM Cliente_Membresia
SELECT * FROM Membresia
SELECT * FROM Empleado
SELECT * FROM Proveedor
SELECT * FROM Proveedor_Pelicula
SELECT * FROM Alquiler
SELECT * FROM Alquiler_Inventario
SELECT * FROM Inventario
SELECT * FROM Pelicula

-- Consultar el promedio de duracion de las peliculas
    SELECT CONVERT(VARCHAR, DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', duracion)), '00:00:00'), 108) AS 'DURACION PROMEDIO DE LAS PELICULAS'
    FROM Pelicula

--Consulta para encontrar el empleado con el mayor número de alquileres en el mes
	SELECT TOP 1 nombre AS NOMBRE, COUNT(Alquiler.ID_Alquiler)as TOTAL_ALQUILERES 
		FROM Empleado RIGHT JOIN Alquiler ON Alquiler.ID_Empleado = Empleado.ID_Empleado GROUP BY Empleado.nombre ORDER BY TOTAL_ALQUILERES DESC

--Consultar cuál es la membresía menos adquirida
	SELECT tipo, COUNT(Cliente_Membresia.ID_Cliente) AS MENOS_ADQUIRIDA 
		FROM Membresia LEFT JOIN Cliente_Membresia ON Cliente_Membresia.ID_Membresia = Membresia.ID_Membresia GROUP BY tipo 
			HAVING COUNT(Cliente_Membresia.ID_Cliente) = 
				(SELECT MIN(MENOS_ADQUIRIDA) FROM (SELECT COUNT(Cliente_Membresia.ID_Cliente) AS MENOS_ADQUIRIDA 
					FROM Membresia LEFT JOIN Cliente_Membresia ON Cliente_Membresia.ID_Membresia = Membresia.ID_Membresia GROUP BY tipo) AS ConteoMembresias)

--Consultar los distintos géneros de las películas
	SELECT DISTINCT genero AS GENEROS_PELICULAS FROM Pelicula

--Consultar la fechas de duración del alquiler
	SELECT ID_Alquiler, fecha_alquiler, fecha_devolucion, DATEDIFF(DAY, fecha_alquiler, fecha_devolucion) AS duracion_dias FROM Alquiler
    
--Consulta para obtener el total de ingresos en un mes específico
	DECLARE @Mes INT = 11; -- Noviembre 
	DECLARE @Año INT = 2024; -- Año 2024

	SELECT SUM(monto) AS INGRESOS_MES FROM Alquiler WHERE MONTH(fecha_alquiler) = @Mes AND YEAR(fecha_alquiler) = @Año
--FALTA UNA CONSULTA DE VARIABLES TEMPORALES !!


--Consulta para mostrar todas las películas que aún no han sido alquiladas
SELECT titulo FROM Pelicula LEFT JOIN Inventario ON Pelicula.ID_Pelicula = Inventario.ID_Pelicula LEFT JOIN Alquiler_Inventario ON Inventario.ID_Inventario = Alquiler_Inventario.ID_Inventario
	WHERE Inventario.estado = 'Disponible' OR Inventario.estado = 'En Reparación'
    
--Consultar los nombres de los empleados con los titulos de las películas que han alquiladoo
	SELECT E.nombre, P.titulo FROM Empleado E
			INNER JOIN Alquiler ON E.ID_Empleado = Alquiler.ID_Empleado
			INNER JOIN Alquiler_Inventario AlqIn ON Alquiler.ID_Alquiler = AlqIn.ID_Alquiler
			INNER JOIN Inventario I ON AlqIn.ID_Inventario = I.ID_Inventario
			INNER JOIN Pelicula P ON I.ID_Pelicula = P.ID_Pelicula
				GROUP BY E.nombre, P.titulo

-- Consultar los proveedores y las peliculas que han suministrado
	SELECT Pr.nombre AS PROVEDOR , P.titulo AS PELICULA_SUMINISTRADA FROM Proveedor Pr
	RIGHT JOIN Proveedor_Pelicula PP ON Pr.ID_Proveedor = PP.ID_Proveedor
	RIGHT JOIN Pelicula P ON PP.ID_Pelicula = P.ID_Pelicula

-- Consultar todos los clientes y sus membresias
	SELECT Cliente.nombre AS CLIENTE, Membresia.tipo AS MEMBRESIA FROM Cliente
	FULL OUTER JOIN Cliente_Membresia ON Cliente.ID_Cliente = Cliente_Membresia.ID_Cliente
	FULL OUTER JOIN Membresia ON Cliente_Membresia.ID_Membresia = Membresia.ID_Membresia