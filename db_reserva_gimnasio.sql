CREATE DATABASE db_reserva_gimnasio;

USE db_reserva_gimnasio;
SET LANGUAGE us_english;
--Creación de tablas
CREATE TABLE GestionSocio(
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(100),
	apellido VARCHAR(100),
	telefono CHAR(9),
	correo VARCHAR(100)
);

CREATE TABLE Pago(
	id INT PRIMARY KEY IDENTITY, 
	titular VARCHAR(100),
	fecha_pago DATE,
	num_tarjeta VARCHAR(20),
	fecha_vencimiento DATE,
	codigo_verificacion CHAR(6),
	id_membresia INT NOT NULL
);

CREATE TABLE Entrenador(
	id INT PRIMARY KEY IDENTITY, 
	nombre VARCHAR(100),
	apellido VARCHAR(100), 
	id_clase INT NOT NULL
);

CREATE TABLE Clase(
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(100),
	dia VARCHAR(20),
	id_categoria INT NOT NULL,
	id_espacio INT NOT NULL
);


CREATE TABLE Membresia(
	id INT PRIMARY KEY IDENTITY,
	tipo VARCHAR(20),
	fecha_inicio DATE,
	fecha_fin DATE,
	costo MONEY,
	id_gestion_socio INT NOT NULL
);


CREATE TABLE Categoria(
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(100),
	descripcion VARCHAR(100)
);


CREATE TABLE Espacio(
	id INT PRIMARY KEY IDENTITY, 
	num_sala INT, 
	capacidad INT, 
);


CREATE TABLE Reserva(
	id INT PRIMARY KEY IDENTITY,
	fecha_reserva DATE,
	hora_inicio DATETIME, 
	hora_fin DATETIME, 
	fecha_sesion DATE, 
	estado VARCHAR(100),
	id_clase INT NOT NULL
);


CREATE TABLE CategoriaXEspacio(
	id_categoria INT,
	id_espacio INT
);

SELECT * FROM GestionSocioXEntrenador;
CREATE TABLE GestionSocioXEntrenador(
	id_gestion_socio INT, 
	id_entrenador INT
);

CREATE TABLE GestionSocioXReserva(
	id_gestion_socio INT, 
	id_reserva INT
);

ALTER TABLE Membresia ADD CONSTRAINT fk_gestion_socio
FOREIGN KEY (id_gestion_socio) REFERENCES GestionSocio(id);

ALTER TABLE Pago ADD CONSTRAINT fk_membresia
FOREIGN KEY(id_membresia) REFERENCES Membresia(id);

ALTER TABLE Entrenador ADD CONSTRAINT fk_clase
FOREIGN KEY (id_clase) REFERENCES Clase(id);

ALTER TABLE Reserva ADD CONSTRAINT fk_clase_reserva
FOREIGN KEY (id_clase) REFERENCES Clase(id);

ALTER TABLE Clase ADD CONSTRAINT fk_categoria
FOREIGN KEY (id_categoria) REFERENCES Categoria(id);

ALTER TABLE Clase ADD CONSTRAINT fk_espacio
FOREIGN KEY (id_espacio) REFERENCES GestorClase.Espacio(id);

ALTER TABLE GestionSocioXEntrenador ADD CONSTRAINT fk_GXE_entrenador
FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id);

ALTER TABLE GestionSocioXEntrenador ADD CONSTRAINT fk_GXE_gestion_socio
FOREIGN KEY (id_gestion_socio) REFERENCES GestionSocio(id);

ALTER TABLE GestionSocioXReserva ADD CONSTRAINT fk_GXR_reserva
FOREIGN KEY (id_reserva) REFERENCES Reserva(id);

ALTER TABLE GestionSocioXReserva ADD CONSTRAINT fk_GXR_gestion_socio
FOREIGN KEY (id_gestion_socio) REFERENCES GestionSocio(id);

ALTER TABLE CategoriaXEspacio ADD CONSTRAINT fk_CXE_categoria
FOREIGN KEY (id_categoria) REFERENCES Categoria(id);

ALTER TABLE CategoriaXEspacio ADD CONSTRAINT fk_CXE_espacio
FOREIGN KEY (id_espacio) REFERENCES GestorClase.Espacio(id);

--Actualización de datos 
UPDATE Membresia set fecha_fin = DATEADD(year,1,fecha_inicio)where tipo='Anual';
UPDATE Membresia set fecha_fin = DATEADD(month,6,fecha_inicio)where tipo='Semestral';
UPDATE Membresia set fecha_fin = DATEADD(month,3,fecha_inicio)where tipo='Trimestral';
UPDATE Membresia set fecha_fin = DATEADD(month,1,fecha_inicio)where tipo='Mensual';

UPDATE Membresia set costo = 200.00 where tipo='Anual';
UPDATE Membresia set costo = 150.00 where tipo='Semestral';
UPDATE Membresia set costo = 100.00 where tipo='Trimestral';
UPDATE Membresia set costo = 50.00 where tipo='Mensual';

USE master;
--Creando Logins con sus contraseñas
CREATE LOGIN L_Supervisor WITH PASSWORD = 'Supervisor123'; 
CREATE LOGIN L_Recepcionista WITH PASSWORD = 'Recepcionista123';
CREATE LOGIN L_Entrenador WITH PASSWORD = 'Entrenador123';
CREATE LOGIN L_GestorClases WITH PASSWORD = 'GestorClases123';
CREATE LOGIN L_Administrador WITH PASSWORD = 'Administrador123';


USE db_reserva_gimnasio;
--Crear el usuario supervisor para el usuario
CREATE USER U_Supervisor FOR LOGIN L_Supervisor;

CREATE ROLE R_Supervisor;
--Dando accesos al rol.
GRANT SELECT, INSERT, EXECUTE ON SCHEMA::dbo TO R_Supervisor;
DENY UPDATE, DELETE ON SCHEMA::dbo TO R_Supervisor;
DENY CREATE TABLE, CREATE PROCEDURE, CREATE FUNCTION, CREATE VIEW TO R_Supervisor;

ALTER ROLE R_Supervisor ADD MEMBER U_Supervisor;

CREATE USER U_Recepcionista FOR LOGIN L_Recepcionista;

CREATE ROLE R_Recepcionista;

GRANT SELECT ON Categoria TO R_Recepcionista;
GRANT SELECT ON Clase TO R_Recepcionista;
GRANT SELECT ON Espacio TO R_Recepcionista;
GRANT SELECT, UPDATE, INSERT ON GestionSocio TO R_Recepcionista;
GRANT SELECT, UPDATE, INSERT ON Membresia TO R_Recepcionista;
GRANT SELECT, INSERT ON Pago TO R_Recepcionista;
GRANT SELECT, UPDATE, INSERT ON Reserva TO R_Recepcionista;

DENY UPDATE, INSERT ON Categoria TO R_Recepcionista;
DENY UPDATE, INSERT ON Clase TO R_Recepcionista;
DENY UPDATE, INSERT, SELECT ON Entrenador TO R_Recepcionista;
DENY UPDATE, INSERT ON Espacio TO R_Recepcionista;
DENY UPDATE ON Pago TO R_Recepcionista;
DENY DELETE, EXECUTE ON SCHEMA::dbo TO R_Recepcionista;
DENY CREATE TABLE, CREATE PROCEDURE, CREATE FUNCTION, CREATE VIEW TO R_Recepcionista;

ALTER ROLE R_Recepcionista ADD MEMBER U_Recepcionista;

CREATE USER U_Entrenador FOR LOGIN L_Entrenador;

CREATE ROLE R_Entrenador;

GRANT SELECT ON Categoria TO R_Entrenador;
GRANT SELECT ON Clase TO R_Entrenador;
GRANT SELECT ON Espacio TO R_Entrenador;
GRANT SELECT ON GestionSocio TO R_Entrenador;
GRANT SELECT, UPDATE ON Reserva TO R_Entrenador;
GRANT SELECT ON GestionSocioXEntrenador TO R_Entrenador;
GRANT SELECT ON CategoriaXEspacio TO R_Entrenador;

DENY UPDATE ON Categoria TO R_Entrenador;
DENY UPDATE ON Clase TO R_Entrenador;
DENY UPDATE,SELECT ON Entrenador TO R_Entrenador;
DENY UPDATE ON Espacio TO R_Entrenador;
DENY UPDATE ON GestionSocio TO R_Entrenador;
DENY UPDATE,SELECT ON Membresia TO R_Entrenador;
DENY UPDATE,SELECT ON Pago TO R_Entrenador;
DENY UPDATE ON GestionSocioXEntrenador TO R_Entrenador;
DENY UPDATE ON CategoriaXEspacio TO R_Entrenador;
DENY DELETE, EXECUTE, INSERT ON SCHEMA::dbo TO R_Entrenador;
DENY CREATE TABLE, CREATE PROCEDURE, CREATE FUNCTION, CREATE VIEW TO R_Entrenador;

ALTER ROLE R_Entrenador ADD MEMBER U_Entrenador;


CREATE USER U_GestorClases FOR LOGIN L_GestorClases;

CREATE ROLE R_GestorClases;

GRANT SELECT,UPDATE, DELETE, INSERT ON Categoria TO R_GestorClases;
GRANT SELECT,UPDATE, INSERT ON Clase TO R_GestorClases;
GRANT SELECT,UPDATE, DELETE, INSERT ON Espacio TO R_GestorClases;
GRANT SELECT,UPDATE, DELETE, INSERT ON CategoriaXEspacio TO R_GestorClases;
GRANT SELECT ON Reserva TO R_GestorClases;
GRANT SELECT ON GestionSocioXEntrenador TO R_GestorClases;

DENY DELETE ON Clase TO R_GestorClases;
DENY SELECT, INSERT, UPDATE, DELETE ON Entrenador TO R_GestorClases;
DENY SELECT, INSERT, UPDATE, DELETE ON GestionSocio TO R_GestorClases;
DENY SELECT, INSERT, UPDATE, DELETE ON Membresia TO R_GestorClases;
DENY SELECT, INSERT, UPDATE, DELETE ON Pago TO R_GestorClases;
DENY INSERT, UPDATE, DELETE ON Reserva TO R_GestorClases;
DENY INSERT, UPDATE, DELETE ON GestionSocioXEntrenador TO R_GestorClases;
DENY EXECUTE ON SCHEMA::dbo TO R_GestorClases;
DENY CREATE TABLE, CREATE PROCEDURE, CREATE FUNCTION, CREATE VIEW TO R_GestorClases;

ALTER ROLE R_GestorClases ADD MEMBER U_GestorClases;

CREATE USER U_Administrador FOR LOGIN L_Administrador;

CREATE ROLE R_Administrador;

GRANT SELECT,UPDATE, DELETE, INSERT,EXECUTE ON SCHEMA::dbo TO R_Administrador;
GRANT CREATE TABLE, CREATE PROCEDURE, CREATE FUNCTION, CREATE VIEW TO R_GestorClases;

ALTER ROLE R_Administrador ADD MEMBER U_Administrador;


--update para inicio
update Membresia set fecha_inicio = DATEADD(MONTH,-10, fecha_inicio) where id between 1 and 100;
update Membresia set fecha_inicio = DATEADD(MONTH,-9, fecha_inicio) where id between 101 and 200;
update Membresia set fecha_inicio = DATEADD(MONTH,-8, fecha_inicio) where id between 201 and 300;
update Membresia set fecha_inicio = DATEADD(MONTH,-7, fecha_inicio) where id between 301 and 400;
update Membresia set fecha_inicio = DATEADD(MONTH,-6, fecha_inicio) where id between 401 and 500;
update Membresia set fecha_inicio = DATEADD(MONTH,-5, fecha_inicio) where id between 501 and 600;
update Membresia set fecha_inicio = DATEADD(MONTH,-4, fecha_inicio) where id between 601 and 700;
update Membresia set fecha_inicio = DATEADD(MONTH,-3, fecha_inicio) where id between 701 and 800;
update Membresia set fecha_inicio = DATEADD(MONTH,-2, fecha_inicio) where id between 801 and 900;
update Membresia set fecha_inicio = DATEADD(MONTH,-1, fecha_inicio) where id between 901 and 1000;

SELECT * FROM Reserva;

--update para fin
update Membresia set fecha_fin = DATEADD(YEAR,1, fecha_inicio) where id between 1 and 1000 and tipo = 'Anual';
update Membresia set fecha_fin = DATEADD(MONTH,6, fecha_inicio) where id between 1 and 1000 and tipo = 'Semestral';
update Membresia set fecha_fin = DATEADD(MONTH,3, fecha_inicio) where id between 1 and 1000 and tipo = 'Trimestral';
update Membresia set fecha_fin = DATEADD(MONTH,1, fecha_inicio) where id between 1 and 1000 and tipo = 'Mensual';

--update de hora_inicio, hora fin y fecha_sesion en tabla reserva

UPDATE Reserva
SET 
    fecha_sesion = DATEADD(
        DAY, 
        (ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 42), 
        '2025-11-20'
    ),
    hora_inicio = DATEADD(
        MINUTE,
        ((ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 4) * 15), 
        DATEADD(
            HOUR, 
            (ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 10) + 6, 
            CAST(
                DATEADD(
                    DAY, 
                    (ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 42),
                    '2025-11-20'
                ) AS DATETIME
            )
        )
    ),
    hora_fin = DATEADD(HOUR, 1, 
        DATEADD(
            MINUTE,
            ((ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 4) * 15),
            DATEADD(
                HOUR, 
                (ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 10) + 6,
                CAST(
                    DATEADD(
                        DAY, 
                        (ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 42),
                        '2025-11-20'
                    ) AS DATETIME
                )
            )
        )
    )
WHERE 
    DATEADD(DAY, (ABS(CHECKSUM(CAST(id AS VARCHAR(10)))) % 42), '2025-11-20')
    NOT IN ('2025-12-25', '2025-12-31');

UPDATE Reserva
SET 
    fecha_sesion = '2025-12-10',
    hora_inicio  = '2025-12-10T10:00:00',
    hora_fin     = '2025-12-10T11:00:00'
WHERE id = 2;

--Funciones ventanas
--Número de asistentes por mes.
SELECT 
    YEAR(r.fecha_sesion) AS año,
    MONTH(r.fecha_sesion) AS mes,
    r.id_clase AS Numero_clase,
    c.nombre AS nombre_clase,
    COUNT(gsxr.id_gestion_socio) AS asistentes_mes,
    SUM(COUNT(gsxr.id_gestion_socio)) OVER (
        PARTITION BY YEAR(r.fecha_sesion), MONTH(r.fecha_sesion)
    ) AS total_asistentes_mes
FROM Reserva r
INNER JOIN Clase cl ON r.id_clase = cl.id
INNER JOIN Categoria c ON cl.id_categoria = c.id
INNER JOIN GestionSocioXReserva gsxr ON r.id = gsxr.id_reserva
WHERE r.estado = 'Confirmada'
GROUP BY YEAR(r.fecha_sesion), MONTH(r.fecha_sesion), r.id_clase, c.nombre
ORDER BY año, mes, asistentes_mes DESC;

CREATE NONCLUSTERED INDEX IX_Reserva_Clase_Estado 
ON Reserva(id_clase, estado);

CREATE NONCLUSTERED INDEX IX_Categoria_nombre ON Categoria(nombre);

--Sobre el día de la semana que se hace más reservas.
SELECT 
	r.id_clase AS "Id Clase",
    c.dia AS "Dia",
    COUNT(*) AS reservas_por_clase,
    COUNT(*) OVER (
        PARTITION BY c.dia
    ) AS "Total de reservas por dia"
FROM Reserva r
INNER JOIN Clase c ON r.id_clase = c.id
GROUP BY c.dia, r.id_clase
ORDER BY "Total de reservas por dia", reservas_por_clase DESC;

CREATE NONCLUSTERED INDEX IX_Clase_dia ON Clase(dia);

CREATE NONCLUSTERED INDEX IX_Reserva_Clase ON Reserva(id_clase);

--Ranking por frecuencia de pago
SELECT 
    m.tipo AS membresia,
    COUNT(p.id) AS total_pagos,
    SUM(m.costo) AS ingresos_totales,
    RANK() OVER (
        ORDER BY COUNT(p.id) DESC
    ) AS ranking_frecuencia_pagos
FROM Membresia m
INNER JOIN Administrador.Pago p ON m.id = p.id_membresia
GROUP BY m.tipo
ORDER BY ranking_frecuencia_pagos DESC;

CREATE NONCLUSTERED INDEX IX_Membresia_Tipo ON Membresia(Tipo);


--Backup de la base de datos.
ALTER DATABASE db_reserva_gimnasio SET 
RECOVERY FULL;

BACKUP DATABASE db_reserva_gimnasio
TO DISK = 'C:\Backup\db_reserva_gimnasio_FULL.bak'
WITH INIT, COMPRESSION, STATS = 5;

BACKUP DATABASE db_reserva_gimnasio
TO DISK = 'C:\Backup\db_reserva_gimnasio_DIFF.bak'
WITH DIFFERENTIAL, COMPRESSION, STATS= 5;

BACKUP LOG db_reserva_gimnasio
TO DISK = 'C:\Backup\db_reserva_gimnasio_LOG.trn'
WITH INIT, COMPRESSION, STATS = 5;

--Esquemas
CREATE SCHEMA Administrador AUTHORIZATION U_Administrador;
CREATE SCHEMA GestorClase AUTHORIZATION U_GestorClases;

ALTER SCHEMA Administrador TRANSFER Pago;
ALTER SCHEMA GestorClase TRANSFER Espacio;

SELECT COUNT(*) AS ObjetosEnAdmin
FROM sys.objects o 
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE s.name = 'Administrador';

SELECT COUNT(*) AS ObjetosEnAdmin
FROM sys.objects o 
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE s.name = 'GestorClase';

--Auditorias y especificaciones de auditorias.
USE master;
CREATE SERVER AUDIT Audit_Gimnasio
TO FILE (
FILEPATH = 'C:\SQL_Audit\audit_gimnasio', 
MAXSIZE = 100 MB, 
MAX_ROLLOVER_FILES = 1000)
WITH (ON_FAILURE = CONTINUE);
ALTER SERVER AUDIT Audit_Gimnasio WITH (STATE = ON);

USE db_reserva_gimnasio;
CREATE DATABASE AUDIT SPECIFICATION Audit_DB_Administrador
FOR SERVER AUDIT Audit_Gimnasio
ADD (DELETE, INSERT ON OBJECT::Administrador.Pago BY PUBLIC)
WITH (STATE = ON);

USE master;
CREATE SERVER AUDIT Audit_Reserva_Gimnasio
TO FILE (
FILEPATH = 'C:\SQL_Audit\audit_gimnasio', 
MAXSIZE = 100 MB, 
MAX_ROLLOVER_FILES = 1000)
WITH (ON_FAILURE = CONTINUE);
ALTER SERVER AUDIT Audit_Reserva_Gimnasio WITH (STATE = ON);

USE db_reserva_gimnasio;
CREATE DATABASE AUDIT SPECIFICATION Audit_DB_GestorClase
FOR SERVER AUDIT Audit_Reserva_Gimnasio
ADD (DELETE, INSERT ON OBJECT::GestorClase.Espacio BY PUBLIC)
WITH (STATE = ON);

--Migración de datos e importación de datos.
CREATE VIEW dbo.vEspacioCarga
AS
SELECT 
    num_sala,
    capacidad
FROM dbo.Espacio;
GO

TRUNCATE TABLE dbo.Espacio;

BULK INSERT dbo.vEspacioCarga        
FROM 'C:\Backup\EspacioDatos.csv'
WITH (
    FIELDTERMINATOR = ',',           
    ROWTERMINATOR   = '\n',       
    FIRSTROW        = 1,          
    CODEPAGE        = '65001'
);




