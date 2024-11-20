
 CREATE DATABASE VIDEOCLUB

    USE VIDEOCLUB

--CREACION TABLAS
CREATE TABLE Cliente(
    ID_Cliente int primary key identity(10,1),
    nombre varchar(30),
    email varchar(30),
    contacto varchar(10),
    direccion varchar(40),
    fecha_nacimiento date, --Atributo derivado en consulta o en atributo edad?
    edad varchar(2)
)

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
    ID_Cliente int,
    ID_Empleado int
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
    ID_Pelicula int	
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
ADD CONSTRAINT CK_Nombre CHECK(nombre NOT LIKE '%[^A-Za-z ]%');

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
INSERT INTO Cliente (nombre, email, contacto, direccion, fecha_nacimiento, edad) VALUES
('Carlos Perez', 'carlos.perez@gmail.com', '5512345678', 'Av. Central 123', '1995-05-12', '29'),
('Maria Lopez', 'maria.lopez@yahoo.com', '5567891234', 'Calle Sur 456', '1988-08-20', '36'),
('Juan Torres', 'juan.torres@outlook.com', '5534567890', 'Calle Norte 789', '2000-12-15', '23'),
('Ana Garcia', 'ana.garcia@gmail.es', '5543219876', 'Av. Oriente 321', '1993-03-10', '31'),
('Pedro Sanchez', 'pedro.sanchez@gmail.com', '5519876543', 'Calle Poniente 987', '1985-11-02', '39'),
('Laura Martinez', 'laura.martinez@yahoo.es', '5523456789', 'Av. Revolución 654', '1990-07-19', '34'),
('Sofia Fernandez', 'sofia.fernandez@gmail.com', '5565432198', 'Calle Progreso 432', '1998-10-25', '26'),
('Diego Ramirez', 'diego.ramirez@outlook.es', '5532198765', 'Av. Libertad 876', '1983-09-30', '41'),
('Valeria Gomez', 'valeria.gomez@gmail.com', '5521987654', 'Calle Unión 765', '1992-04-17', '32'),
('Miguel Herrera', 'miguel.herrera@yahoo.com', '5545678912', 'Av. Paz 567', '1997-06-05', '27'),
('Fernanda Morales', 'fernanda.morales@gmail.com', '5534567891', 'Calle Luz 234', '1994-02-28', '30'),
('Luis Dominguez', 'luis.dominguez@outlook.com', '5561237890', 'Av. Horizonte 123', '1991-01-01', '33'),
('Gloria Alvarez', 'gloria.alvarez@yahoo.com', '5556781234', 'Calle Lluvia 321', '1989-11-11', '35'),
('Sebastian Vega', 'sebastian.vega@gmail.es', '5543218765', 'Calle Brisa 654', '2002-03-21', '22'),
('Natalia Ruiz', 'natalia.ruiz@gmail.com', '5576543219', 'Av. Rayo 987', '1987-10-18', '37');

INSERT INTO Membresia (tipo, descuento, costo_mensual) VALUES
('Basica', 10, 99.99),
('VIP', 20, 199.99),
('Premium', 30, 299.99);


select * from Membresia
delete from Membresia

INSERT INTO Proveedor (nombre, email, tipo) VALUES
('Tech Solutions', 'techsol@gmail.com', 'digital'),
('BluMedia Inc', 'blumedia@yahoo.com', 'bluray'),
('Vision Discs', 'vision@outlook.com', 'dvd'),
('Digital Innovations', 'digital@gmail.com', 'digital'),
('MediaWorld', 'mediaw@yahoo.es', 'bluray'),
('OpticWare', 'optic@outlook.es', 'dvd'),
('CinemaPro', 'cinema@gmail.es', 'digital'),
('PrimeTech', 'prime@gmail.com', 'bluray'),
('SuperDiscs', 'superd@yahoo.com', 'dvd'),
('NextGen Media', 'nextgen@outlook.com', 'digital'),
('GlobalTech', 'global@gmail.es', 'bluray'),
('Distribuidora XYZ', 'distxyz@yahoo.es', 'dvd'),
('Innovative Studios', 'innova@outlook.es', 'digital'),
('CinemaShop', 'cinema@gmail.com', 'bluray'),
('ProMedia Solutions', 'promedia@yahoo.com', 'dvd');


INSERT INTO Empleado (nombre, cargo, contacto) VALUES
('Luis Gomez', 'Gerente', '5532145678'),
('Ana Perez', 'Cajero', '5545678932'),
('Maria Torres', 'Administrador', '5538765432'),
('Juan Sanchez', 'Supervisor', '5523456789'),
('Carla Fernandez', 'Encargado', '5545678943'),
('Diego Ramirez', 'Cajero', '5556789210'),
('Laura Alvarez', 'Supervisor', '5549876543'),
('Pedro Vega', 'Gerente', '5521123456'),
('Sofia Morales', 'Administrador', '5543219876'),
('Fernando Lopez', 'Encargado', '5567894321'),
('Miguel Herrera', 'Supervisor', '5523456123'),
('Natalia Garcia', 'Cajero', '5565432198'),
('Sebastian Cruz', 'Administrador', '5545678910'),
('Valeria Ruiz', 'Encargado', '5551234567'),
('Gloria Dominguez', 'Cajero', '5532147896');

INSERT INTO Inventario (fecha_adquisicion, estado, ID_Pelicula) VALUES
('2024-01-10', 'Disponible', 15),
('2024-02-15', 'Disponible', 16),
('2024-03-20', 'Rentado', 17),
('2024-04-05', 'Rentado', 18),
('2024-05-10', 'Apartado', 19),
('2024-06-25', 'Disponible', 20),
('2024-07-14', 'Disponible', 21),
('2024-08-01', 'Rentado', 22),
('2024-09-18', 'Rentado', 23),
('2024-10-22', 'Apartado', 24),
('2024-11-05', 'Disponible', 25),
('2024-11-12', 'Disponible', 26),
('2024-11-17', 'Rentado', 27),
('2024-11-18', 'Rentado', 28),
('2024-11-19', 'Disponible', 29);

select * from Inventario
select * from Pelicula
delete from Inventario
select * from Cliente  
select * from Empleado
DELETE from		Alquiler
select * from Alquiler

INSERT INTO Alquiler (fecha_alquiler, fecha_devolucion, ID_Cliente, ID_Empleado) VALUES
('2024-11-01', '2024-11-05', 12, 11),
('2024-11-02', '2024-11-06', 13, 11),
('2024-11-03', '2024-11-07', 14, 15),
('2024-11-04', '2024-11-08', 15, 15),
('2024-11-05', '2024-11-09', 16, 11),
('2024-11-06', '2024-11-10', 17, 15),
('2024-11-07', '2024-11-11', 18, 21),
('2024-11-08', '2024-11-12', 19, 21),
('2024-11-09', '2024-11-13', 20, 21),
('2024-11-10', '2024-11-14', 21, 24),
('2024-11-11', '2024-11-15', 22, 24),
('2024-11-12', '2024-11-16', 23, 15),
('2024-11-13', '2024-11-17', 24, 11),
('2024-11-14', '2024-11-18', 23, 21),
('2024-11-15', '2024-11-19', 24, 24);



-- Tabla Pelicula
INSERT INTO Pelicula (titulo, genero, duracion, año_lanzamiento, clasificacion, director) VALUES
('El Padrino', 'Drama', '02:55:00', '1972-03-24', 'R', 'Francis Ford Coppola'),
('El Señor de los Anillos', 'Fantasía', '03:48:00', '2001-12-19', 'PG-13', 'Peter Jackson'),
('Pulp Fiction', 'Crimen', '02:34:00', '1994-10-14', 'R', 'Quentin Tarantino'),
('Forest Gump', 'Drama', '02:22:00', '1994-07-06', 'PG-13', 'Robert Zemeckis'),
('Matrix', 'Ciencia Ficción', '02:16:00', '1999-03-31', 'R', 'Lana Wachowski'),
('Jurassic Park', 'Aventura', '02:07:00', '1993-06-11', 'PG-13', 'Steven Spielberg'),
('Titanic', 'Drama', '03:14:00', '1997-12-19', 'PG-13', 'James Cameron'),
('Gladiador', 'Acción', '02:35:00', '2000-05-01', 'R', 'Ridley Scott'),
('Inception', 'Thriller', '02:28:00', '2010-07-16', 'PG-13', 'Christopher Nolan'),
('Star Wars: Una Nueva Esperanza', 'Fantasía', '02:01:00', '1977-05-25', 'PG', 'George Lucas'),
('El Caballero de la Noche', 'Acción', '02:32:00', '2008-07-18', 'PG-13', 'Christopher Nolan'),
('Avengers: Endgame', 'Acción', '03:01:00', '2019-04-26', 'PG-13', 'Anthony Russo, Joe Russo'),
('Coco', 'Animación', '01:45:00', '2017-10-27', 'PG', 'Lee Unkrich, Adrian Molina'),
('Toy Story', 'Animación', '01:21:00', '1995-11-22', 'G', 'John Lasseter'),
('Avatar', 'Ciencia Ficción', '02:42:00', '2009-12-18', 'PG-13', 'James Cameron');


INSERT INTO Alquiler_Inventario (ID_Alquiler, ID_Inventario, cantidad) VALUES
(68, 41, 1),
(69, 42, 1),
(70, 43, 1),
(71, 44, 1),
(72, 45, 1),
(73, 46, 1),
(74, 47, 1),
(75, 48, 1),
(76, 49, 1),
(77, 50, 1),
(78, 51, 1),
(79, 52, 1),
(80, 53, 1),
(81, 54, 1),
(82, 55, 1);

select * from Alquiler  select * from Inventario

select * from Inventario
select * from Pelicula
select * from Proveedor

INSERT INTO Proveedor_Pelicula (ID_Proveedor, ID_Pelicula, precio, fecha_proveedor) VALUES
(16, 15, 120.00, '2024-01-10'),
(17, 16, 130.00, '2024-02-15'),
(18, 17, 140.00, '2024-03-20'),
(19, 18, 150.00, '2024-04-05'),
(20, 19, 160.00, '2024-05-10'),
(21, 20, 170.00, '2024-06-25'),
(22, 21, 180.00, '2024-07-14'),
(23, 22, 190.00, '2024-08-01'),
(24, 23, 200.00, '2024-09-18'),
(25, 24, 210.00, '2024-10-22'),
(26, 22, 220.00, '2024-11-05'),
(27, 26, 230.00, '2024-11-12'),
(28, 27, 240.00, '2024-11-17'),
(29, 28, 250.00, '2024-11-18'),
(30, 29, 260.00, '2024-11-19');

INSERT INTO Cliente_Membresia (ID_Membresia, ID_Cliente, codigo_barras) VALUES
(25, 12, '123456789012345'),
(25, 13, '123456789112345'),
(26, 14, '123456789212345'),
(27, 15, '123456789312345'),
(26, 16, '123456789412345'),
(27, 17, '123456789512345'),
(27, 18, '123456789612345'),
(25, 19, '123456789712345'),
(25, 20, '123456789812345'),
(26, 21, '123456789912345'),
(26, 22, '123456789013245'),
(26, 23, '123456789113245'),
(25, 24, '123456789213245'),
(27, 25, '123456789313245'),
(26, 26, '123456789413245');

--CONSULTAS
--Peliculas que no han sido alquiladas
select titulo,estado  from Inventario inner join Pelicula on Pelicula.ID_Pelicula=Inventario.id_pelicula where estado = 'Disponible' --hh

--EMPLEADOS CON LOS TITULOS DE LAS PELICULAS QUE HAN ALQUILADO

select titulo,nombre from Alquiler_Inventario inner join Inventario ON Inventario.ID_Inventario = Alquiler_Inventario.ID_Inventario inner join Pelicula on Pelicula.ID_Pelicula=Inventario.id_pelicula inner join Alquiler on Alquiler.ID_Alquiler=Alquiler_Inventario.ID_Alquiler inner join Empleado on Empleado.ID_Empleado=Alquiler.ID_empleado

--Membresia menos adquirida

select TOP 1 count(tipo) as Membresias,tipo from Cliente_Membresia inner join Membresia on Membresia.ID_Membresia=Cliente_Membresia.ID_Membresia group by tipo order by Membresias ASC