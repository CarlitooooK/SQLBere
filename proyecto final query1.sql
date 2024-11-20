CREATE DATABASE VIDEOCLUB
USE VIDEOCLUB

--CREACION TABLAS
CREATE TABLE Cliente(
    ID_Cliente int identity(10,1),
    nombre varchar(30),
    email varchar(30),
    contacto varchar(10),
    direccion varchar(40),
    fecha_nacimiento date, --Atributo derivado en consulta o en atributo edad?
    edad varchar(2)
)

CREATE TABLE Membresia(
    ID_Membresia int identity(10,1),
    tipo varchar(30),
    descuento int,
    costo_mensual money
)

CREATE TABLE Proveedor(
    ID_Proveedor int identity(10,1),
    nombre varchar(30),
    email varchar(30),
    tipo varchar(10)
)

CREATE TABLE Empleado(
	ID_Empleado int identity(10,1),
	nombre varchar(30),
	cargo varchar(30),
	contacto varchar(30)
)

CREATE TABLE Alquiler(
	ID_Alquiler int identity(10,1),
	fecha_alquiler DATE,
	fecha_devolucion DATE,
	monto money --Atributo derivado o en consulta??
)

CREATE TABLE Pelicula(
	ID_Pelicula int identity(10,1),
	titulo varchar(30),
	genero varchar(50),
	duracion TIME,
	año_lanzamiento DATE,
	clasificacion varchar(5),
	director varchar(30)
)

CREATE TABLE Inventario(
    ID_Inventario int identity(10,1),
	fecha_adquisicion DATE,
    estado varchar(15)	
)

--RESTRICCIONES
--Restriccion para Empleado
ALTER TABLE Empleado
	ADD CONSTRAINT CK_Emplea_Cargo UNIQUE (ID_Empleado, cargo) --Empleado solo 1 cargo

--Resticciones para Cliente
 ALTER TABLE Cliente
    ADD CONSTRAINT CK_Nombre CHECK(nombre NOT LIKE '%[^A-Za-z]%'); --Nombre solo letras min y mayus

ALTER TABLE Cliente
    ADD CONSTRAINT CK_Contacto CHECK(contacto NOT LIKE '%[^0-9]%') --Contacto solo numeros(cel)

--Restriccion para Inventario
ALTER TABLE Inventario
	ADD CONSTRAINT CK_Fecha_Adquisicion CHECK(fecha_adquisicion<=GETDATE()) --La fecha de adquisicion no pase de la fecha actual

--Restriccion para Pelicula
ALTER TABLE Pelicula
    ADD CONSTRAINT CK_Duracion CHECK(duracion BETWEEN '01:00:00' AND '04:00:00') --Rango de duracion

--Restriccion para Proveedor
ALTER TABLE Proveedor
ADD CONSTRAINT CK_Email CHECK(email LIKE '%_@__%.__%')
	
--Restricciones para Alquiler
ALTER TABLE Alquiler
    ADD CONSTRAINT CK_FechaAlquiler CHECK(fecha_alquiler<=GETDATE())  --fecha real para alquiler
                                                                                
ALTER TABLE Alquiler
    ADD CONSTRAINT CK_FechaDevolucion CHECK(fecha_devolucion<=GETDATE()) --fecha real devolucion


--AGREGAR VALORES


--MODELO RELACIONAL
ALTER TABLE Inventario ADD id_pelicula int
ALTER TABLE Pelicula ADD CONSTRAINT PK_PELICULA PRIMARY KEY (ID_Pelicula);
ALTER TABLE Inventario ADD CONSTRAINT FK_PeliculaInventario FOREIGN KEY(id_pelicula) REFERENCES Pelicula(ID_Pelicula)
select *  from Inventario


ALTER TABLE Alquiler ADD id_cliente int
ALTER TABLE Cliente ADD CONSTRAINT PK_CLIENTE PRIMARY KEY (ID_Cliente)
ALTER TABLE Alquiler ADD CONSTRAINT FK_ClienteAlquiler FOREIGN KEY(id_cliente) REFERENCES Cliente(ID_Cliente)

ALTER TABLE Alquiler ADD ID_empleado int
ALTER TABLE Empleado ADD CONSTRAINT PK_Empleado PRIMARY KEY (ID_Empleado)
ALTER TABLE Alquiler ADD CONSTRAINT FK_EmpleadoAlquiler FOREIGN KEY(ID_empleado) REFERENCES Empleado(ID_Empleado)

--RELACION ALQUILER INVENTARIO TABLA PIVOTE
CREATE TABLE AlquilerInventario(
	ID_AlquilerInventario int unique identity(10,1),
	ID_Alquiler int,
	ID_inventario int,
	cantidad int
)

ALTER TABLE Inventario ADD CONSTRAINT PK_Inventario PRIMARY KEY (ID_Inventario)
ALTER TABLE Alquiler ADD CONSTRAINT PK_Alquiler PRIMARY KEY (ID_Alquiler)

ALTER TABLE AlquilerInventario ADD CONSTRAINT FK_AlquilerInventario1 FOREIGN KEY(ID_Alquiler) REFERENCES Alquiler(ID_Alquiler)
ALTER TABLE AlquilerInventario ADD CONSTRAINT FK_AlquilerInventario2 FOREIGN KEY(ID_inventario) REFERENCES Inventario(ID_Inventario)

--RELACION CLIENTE MEMBRESIA TABLA PIVOTE
CREATE TABLE ClienteMembresia(
	ID_ClienteMembresia int unique identity(10,1),
	ID_Cliente int,
	ID_Membresia int,
	codigo_Barras varchar(13)
)
--AGREGAR LA LLAVE PRIMARIA A LA TABLA MEMBRESIAS
ALTER TABLE Membresia ADD CONSTRAINT PK_Membresia PRIMARY KEY (ID_Membresia)

ALTER TABLE ClienteMembresia ADD CONSTRAINT FK_ClienteMembresia1 FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
ALTER TABLE ClienteMembresia ADD CONSTRAINT FK_ClienteMembresia2 FOREIGN KEY (ID_Membresia) REFERENCES Membresia(ID_Membresia)

--RELACION PROVEDOR PELICULA TABLA PIVOTE
CREATE TABLE ProveedorPelicula(
	ID_ProveedorPelicula int unique identity(10,1),
	ID_Proveedor int,
	ID_Pelicula int,
	precio money,
	fecha date
)

--AGREGAR LA LLAVE PRIMARIA A LA TABLA PROVEeDORES
ALTER TABLE Proveedor ADD CONSTRAINT PK_Proveedor PRIMARY KEY (ID_Proveedor)
ALTER TABLE ProveedorPelicula ADD CONSTRAINT FK_ProveedorPelicula1 FOREIGN KEY (ID_Proveedor) REFERENCES Proveedor(ID_Proveedor)
ALTER TABLE ProveedorPelicula ADD CONSTRAINT FK_ProveedorPelicula2 FOREIGN KEY (ID_Pelicula) REFERENCES Pelicula(ID_Pelicula)



--CONSULTAS
select * from Cliente
INSERT INTO Cliente (nombre, email, contacto, direccion, fecha_nacimiento, edad)
VALUES 
('Juan Perez', 'juan.perez@example.com', '1234567890', 'Calle 123', '1990-01-01', '34'),
('Ana Lopez', 'ana.lopez@example.com', '1234567891', 'Calle 456', '1985-05-12', '39'),
('Luis Gomez', 'luis.gomez@example.com', '1234567892', 'Calle 789', '1992-07-23', '32'),
('Maria Ruiz', 'maria.ruiz@example.com', '1234567893', 'Calle 321', '1995-02-14', '29'),
('Carlos Santos', 'carlos.santos@example.com', '1234567894', 'Calle 654', '1987-09-10', '37'),
('Elena Martinez', 'elena.martinez@example.com', '1234567895', 'Calle 987', '1993-11-25', '31'),
('Pedro Diaz', 'pedro.diaz@example.com', '1234567896', 'Calle 135', '1989-03-18', '35'),
('Sara Hernandez', 'sara.hernandez@example.com', '1234567897', 'Calle 246', '1991-08-04', '33'),
('Miguel Ortiz', 'miguel.ortiz@example.com', '1234567898', 'Calle 369', '1994-06-30', '30'),
('Laura Chavez', 'laura.chavez@example.com', '1234567899', 'Calle 258', '1988-12-05', '36');


INSERT INTO Membresia (tipo, descuento, costo_mensual)
VALUES 
('Basica', 5, 100.00),
('Estándar', 10, 150.00),
('Premium', 20, 200.00);

SELECT *  FROM Membresia

INSERT INTO ClienteMembresia (ID_Cliente, ID_Membresia, codigo_Barras)
VALUES 
(12, 20, '1234567890123'),
(21, 21, '1234567890124'),
(13, 22, '1234567890125'),
(14, 22, '1234567890126'),
(15, 22, '1234567890127'),
(16, 20, '1234567890128'),
(17, 21, '1234567890129'),
(18, 20, '1234567890130'),
(19, 20, '1234567890131'),
(20, 20, '1234567890132');


INSERT INTO Pelicula (titulo, genero, duracion, año_lanzamiento, clasificacion, director)
VALUES 
('El Padrino', 'Drama', '03:00:00', '1972-03-24', 'R', 'Francis Ford Coppola'),
('El Señor de los Anillos', 'Fantasía', '03:20:00', '2001-12-19', 'PG-13', 'Peter Jackson'),
('Inception', 'Ciencia Ficción', '02:28:00', '2010-07-16', 'PG-13', 'Christopher Nolan'),
('Titanic', 'Romance', '03:15:00', '1997-12-19', 'PG-13', 'James Cameron'),
('Gladiador', 'Acción', '02:35:00', '2000-05-05', 'R', 'Ridley Scott'),
('Matrix', 'Ciencia Ficción', '02:16:00', '1999-03-31', 'R', 'Lana Wachowski'),
('Toy Story', 'Animación', '01:21:00', '1995-11-22', 'G', 'John Lasseter'),
('Joker', 'Drama', '02:02:00', '2019-10-04', 'R', 'Todd Phillips'),
('Avatar', 'Aventura', '02:42:00', '2009-12-18', 'PG-13', 'James Cameron'),
('Interestelar', 'Ciencia Ficción', '02:49:00', '2014-11-07', 'PG-13', 'Christopher Nolan');

INSERT INTO Inventario (fecha_adquisicion, estado)
VALUES 
('2024-01-15', 'disponible'),
('2024-02-10', 'rentada'),
('2024-03-05', 'apartada'),
('2024-04-20', 'disponible'),
('2024-05-25', 'rentada'),
('2024-06-30', 'apartada'),
('2024-07-12', 'disponible'),
('2024-08-18', 'rentada'),
('2024-09-22', 'apartada'),
('2024-10-29', 'disponible');


INSERT INTO Proveedor (nombre, email, tipo)
VALUES 
('Distribuciones del Norte', 'contacto@distnorte.com', 'regional'),
('Exportaciones Globales', 'ventas@exportglobal.com', 'global'),
('Proveedora Mexicana', 'info@proveedormex.com', 'nacional'),
('Soluciones Industriales', 'contacto@solind.com', 'local'),
('Comercio Exterior S.A.', 'soporte@comercioext.com', 'global'),
('Alimentos Selectos', 'ventas@alimselectos.com', 'nacional'),
('Importadora Universal', 'contacto@importuniversal.com', 'global'),
('Servicios Logísticos', 'servicios@logisticos.com', 'local'),
('Transporte Internacional', 'info@transinter.com', 'global'),
('Suministros y Más', 'ventas@suministrosmas.com', 'local');

INSERT INTO Empleado (nombre, cargo, contacto)
VALUES 
('Juan Pérez', 'Vendedor', 'juan.perez@empresa.com'),
('Ana Gómez', 'Vendedora Senior', 'ana.gomez@empresa.com'),
('Carlos Ramírez', 'Vendedor Corporativo', 'carlos.ramirez@empresa.com'),
('Marta López', 'Vendedora', 'marta.lopez@empresa.com'),
('Luis Martínez', 'Director de Ventas', 'luis.martinez@empresa.com'),
('Elena Sánchez', 'Encargada de Marketing', 'elena.sanchez@empresa.com'),
('Ricardo Díaz', 'Vendedor Regional', 'ricardo.diaz@empresa.com'),
('Patricia Cruz', 'Vendedora Junior', 'patricia.cruz@empresa.com'),
('José Rodríguez', 'Jefe de TI', 'jose.rodriguez@empresa.com'),
('Laura Fernández', 'Gerente de Recursos Humanos', 'laura.fernandez@empresa.com');
