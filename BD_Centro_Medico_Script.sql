-- Script de toda la base de datos Centro_Medico

------------------------------ Creación de la base de datos Centro_Medico -------------------------------------------------
CREATE DATABASE Centro_Medico
GO

-- Usar la base de datos creada
USE Centro_Medico
GO


------------------------------ Creación de tablas para la base de datos --------------------------------------------------

-- Tabla Paciente
CREATE TABLE Paciente (
		IDPaciente INT IDENTITY(1,1) PRIMARY KEY,
		DNI CHAR(10) UNIQUE NOT NULL,
		Nombre VARCHAR(50) NOT NULL,
		Apellido VARCHAR(50) NOT NULL,
		Direccion VARCHAR(100),
		FechaNacimiento DATE,
		Telefono VARCHAR(20),
		Email VARCHAR(50)
)
GO

-- Tabla Medico
CREATE TABLE Medico (
		IDMedico INT IDENTITY(1,1) PRIMARY KEY,
		DNI CHAR(10) UNIQUE NOT NULL,
		Nombre VARCHAR(50) NOT NULL,
		Apellido VARCHAR(50) NOT NULL,
		Telefono VARCHAR(20),
		Email VARCHAR(50)
)
GO

-- Tabla Especialidad
CREATE TABLE Especialidad (
		IDEspecialidad INT IDENTITY(1,1) PRIMARY KEY,
		Especialidad VARCHAR(100)
)
GO

-- Tabla MedicoEspecialidad
CREATE TABLE MedicoEspecialidad (
		IDMedico INT FOREIGN KEY REFERENCES Medico(IDMedico),
		IDEspecialidad INT FOREIGN KEY REFERENCES Especialidad(IDEspecialidad),
		CONSTRAINT PK_MedicoEspecialidad PRIMARY KEY (IDMedico, IDEspecialidad)
)
GO

-- Tabla Turno
CREATE TABLE Turno (
		IDTurno INT IDENTITY(1,1) PRIMARY KEY,
		IDPaciente INT FOREIGN KEY REFERENCES Paciente(IDPaciente),
		IDMedico INT FOREIGN KEY REFERENCES Medico(IDMedico),
		IDEspecialidad INT FOREIGN KEY REFERENCES Especialidad(IDEspecialidad),
		FechaTurno DATETIME NOT NULL,
		Observacion VARCHAR(1000) DEFAULT '',		
)
GO

-- Tabla Pago
CREATE TABLE Pago (
		IDPago INT IDENTITY(1,1) PRIMARY KEY,
		IDTurno INT UNIQUE FOREIGN KEY REFERENCES Turno(IDTurno),
		IDPaciente INT FOREIGN KEY REFERENCES Paciente(IDPaciente),
		Monto DECIMAL(10, 2),
		FechaPago DATETIME,
		MetodoPago VARCHAR(50), -- Efectivo, Tarjeta, Transferencia		
)
GO

-- Tabla TurnoEstado
CREATE TABLE TurnoEstado (
		IDEstado INT IDENTITY(1,1) PRIMARY KEY,
		IDTurno INT FOREIGN KEY REFERENCES Turno(IDTurno),
		IDPago INT FOREIGN KEY REFERENCES Pago(IDPago),
		EstadoTurno VARCHAR(20) DEFAULT 'Vigente',
		EstadoPago VARCHAR(20) DEFAULT 'Pendiente'
)
GO

-- Tabla HistoriaClinica
CREATE TABLE HistoriaClinica (
		IDHistoria INT IDENTITY(1,1) PRIMARY KEY,
		IDPaciente INT FOREIGN KEY REFERENCES Paciente(IDPaciente),
		IDMedico INT FOREIGN KEY REFERENCES Medico(IDMedico),
		FechaHistoria DATETIME,
		Descripcion VARCHAR(1000),	
)
GO


------------------------------ Procedimientos almacenados ----------------------------------------------------------------

-- Procedimiento para ingresar médicos
CREATE PROC I_Medico (
		@dni VARCHAR(10),
		@nombre VARCHAR(50),
		@apellido VARCHAR(50),
		@tel VARCHAR(20),
		@email VARCHAR(50)
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Medico WHERE DNI = @dni)
		INSERT INTO Medico (DNI, Nombre, Apellido, Telefono, Email)
		VALUES (@dni, @nombre, @apellido, @tel, @email)
	ELSE
		print 'El médico ya existe.'
END
GO



-- Procedimiento para actualizar datos de un médico
CREATE PROC UPD_Medico (
		@idmedico INT,
		@dni VARCHAR(10),
		@nombre VARCHAR(50),
		@apellido VARCHAR(50),
		@tel VARCHAR(20),
		@email VARCHAR(50)
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Medico WHERE IDMedico = @idmedico)
		UPDATE Medico SET DNI = @dni, Nombre = @nombre, Apellido = @apellido, Telefono = @tel, Email = @email
		WHERE IDMedico = @idmedico
	ELSE
		print 'El médico no figura registrado.'
END
GO



-- Procedimiento para insertar nueva especialidad
CREATE PROC I_Especialidad (
		@esp VARCHAR(100)
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE Especialidad = @esp)
		INSERT INTO Especialidad (Especialidad) VALUES (@esp)
	ELSE 
		print 'La especialidad ya está registrada.'
END
GO



-- Procedimiento para vincular una especialidad con un médico (insertar regisro en MedicoEspecialidad)
CREATE PROC I_MedicoEspecialidad (
		@idmedico INT,
		@idesp INT
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM MedicoEspecialidad WHERE IDMedico = @idmedico AND IDEspecialidad = @idesp)
		INSERT INTO MedicoEspecialidad (IDMedico, IDEspecialidad) VALUES (@idmedico, @idesp)
	ELSE
		print 'Ya existe esta especialidad vínculada a este médico.'
END
GO



-- Procedimiento para ingresar pacientes
CREATE PROC I_Paciente (
		@dni CHAR(10),
		@nombre VARCHAR(50),
		@apellido VARCHAR(50),
		@direccion VARCHAR(100),
		@fechaNac DATE,
		@tel VARCHAR(20),
		@email VARCHAR(50)
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Paciente WHERE DNI = @dni)
		INSERT INTO Paciente (DNI, Nombre, Apellido, Direccion, FechaNacimiento, Telefono, Email)
		VALUES (@dni, @nombre, @apellido, @direccion, @fechaNac, @tel, @email)
	ELSE
	print 'El paciente ya existe.'
END
GO



-- Procedimiento para actualizar datos de un paciente
CREATE PROC UPD_Paciente (
		@idpaciente INT,
		@dni CHAR(10),
		@nombre VARCHAR(50),
		@apellido VARCHAR(50),
		@direccion VARCHAR(100),
		@fechaNac DATE,
		@tel VARCHAR(20),
		@email VARCHAR(50)
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Paciente WHERE IDPaciente = @idpaciente)
		UPDATE Paciente SET DNI = @dni, Nombre = @nombre, Apellido = @apellido, Direccion = @direccion, 
						FechaNacimiento = @fechaNac, Telefono = @tel, Email = @email
		WHERE IDPaciente = @idpaciente
	ELSE
	print 'El paciente no figura registrado.'
END
GO



-- Procedimiento para ingresar un nuevo turno
CREATE PROC I_Turno (
		@idpaciente INT,
		@idmedico INT,
		@idesp INT,
		@fechaturno DATETIME,
		@obs VARCHAR(1000)
)
AS
BEGIN
	-- Verificar que existe el paciente
	IF NOT EXISTS (SELECT 1 FROM Paciente WHERE IDPaciente = @idpaciente)
	BEGIN
		print 'El paciente no está registrado.'
		return
	END
	
	-- Verificar que el médico este asociado correctamente a su especialidad
	IF NOT EXISTS (SELECT 1 FROM MedicoEspecialidad WHERE IDMedico = @idmedico AND IDEspecialidad = @idesp)
	BEGIN
		print 'Médico o especialidad incorrecta.'
		return
	END

	-- Verficar que ese médico no tenga turnos en la fecha dada y que no se solape con un turno que ya tenga
	IF NOT EXISTS (SELECT 1 FROM Turno WHERE IDMedico = @idmedico 
					AND @fechaturno BETWEEN FechaTurno AND DATEADD(mi, 30, FechaTurno))
	BEGIN
		INSERT INTO Turno (IDPaciente, IDMedico, IDEspecialidad, FechaTurno, Observacion)
		VALUES (@idpaciente, @idmedico, @idesp, @fechaturno, @obs)
	
		DECLARE @idturno INT = SCOPE_IDENTITY() -- Capturar el IDTurno generado por IDENTITY
		INSERT INTO TurnoEstado (IDTurno) VALUES (@idturno) -- Crear registro en TurnoEstado con ese IDTurno
	END
	ELSE
		print 'Turno no disponible.'

    -- Se busca evitar que a un mismo médico se le asigne un turno en un horario demasiado cercano a uno que ya tenga asignado.
	-- El registro en la tabla TurnoEstado se creará con valores por defecto excepto los campos IDTurno e IDPago.
	-- IDPago quedará con valor NULL en el registro hasta que, efectivamente, se registre un pago. 
	-- Ya sea que el turno exista (duplicado) o que se intente asignar un horario en el rango restringido, el turno será rechazado.
END
GO



-- Procedimiento para actualizar estado de un turno de 'Vigente' a 'Vencido'
CREATE PROC UPD_TurnosVencidos
AS
BEGIN
	IF EXISTS (SELECT 1 FROM TurnoEstado te INNER JOIN Turno t ON t.IDTurno = te.IDTurno
			   WHERE te.EstadoTurno = 'Vigente' AND t.FechaTurno < GETDATE())
	BEGIN
		UPDATE TurnoEstado SET EstadoTurno = 'Vencido', EstadoPago = 'Anulado'
		FROM TurnoEstado te INNER JOIN Turno t ON t.IDTurno = te.IDTurno
		WHERE te.EstadoTurno = 'Vigente' AND t.FechaTurno < GETDATE()
	END
	ELSE 
		SELECT 0 AS Resultado
END
GO



-- Procedimiento para cancelar un turno vigente
CREATE PROC UPD_CancelarTurno (
		@idturno INT
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM TurnoEstado te INNER JOIN Turno t ON te.IDTurno = t.IDTurno
				WHERE t.IDTurno = @idturno AND te.EstadoTurno = 'Vigente' AND t.FechaTurno >= GETDATE())
    BEGIN
        UPDATE TurnoEstado SET EstadoTurno = 'Cancelado', EstadoPago = 'Anulado' 
		WHERE IDTurno = @idturno
        print 'Turno cancelado correctamente.'
    END
	ELSE 
		SELECT 0 AS Resultado
END
GO



-- Procedimiento para insertar nuevo registro de historia clínica
CREATE PROC I_HistoriaClinica (
		@idpaciente INT,
		@idmedico INT,
		@fechahistoria DATETIME,
		@descripcion VARCHAR(1000)
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM HistoriaClinica WHERE IDPaciente = @idpaciente AND IDMedico = @idmedico AND FechaHistoria = @fechahistoria)
		INSERT INTO HistoriaClinica (IDPaciente, IDMedico, FechaHistoria, Descripcion)
		VALUES (@idpaciente, @idmedico, @fechahistoria, @descripcion)
	ELSE
		print 'Ya existe una entrada asociada a ese paciente, médico y fecha dada.'
END
GO



-- Procedimiento para consultar historia clínica de un paciente
CREATE PROC S_ConsultarHistorialPaciente (
			@idpaciente INT
)
AS
BEGIN
	SELECT hc.IDHistoria, hc.IDPaciente, hc.FechaHistoria, m.IDMedico, m.Nombre + ' ' + m.Apellido AS Medico, hc.Descripcion
	FROM HistoriaClinica hc
	INNER JOIN Medico m ON m.IDMedico = hc.IDMedico 
	WHERE hc.IDPaciente = @idpaciente 
	ORDER BY hc.FechaHistoria DESC
END
GO



-- Procedimiento para registrar pagos
CREATE PROC I_RegistrarPago (
	@idturno INT,
	@idpaciente INT,
	@monto DECIMAL(10, 2),
	@fechapago DATETIME,
	@metodopago VARCHAR(50)
)
AS
BEGIN
	-- Validar que el turno exista 
	IF NOT EXISTS (SELECT 1 FROM Turno WHERE IDTurno = @idturno AND IDPaciente = @idpaciente)
	BEGIN
		print 'El turno no existe o no pertenece a este paciente.'
		return
	END

    -- Validar que no exista ya un pago para este turno
	IF EXISTS (SELECT 1 FROM Pago WHERE IDTurno = @idturno)
	BEGIN
		print 'El pago para este turno ya fue registrado.'
		return
	END

    -- Si los filtros anteriores fueron superados, registrar pago y actualizar estado
	BEGIN TRY
		BEGIN TRAN
        
		INSERT INTO Pago (IDTurno, IDPaciente, Monto, FechaPago, MetodoPago)
		VALUES (@idturno, @idpaciente, @monto, @fechapago, @metodopago)
        
		DECLARE @idpago INT = SCOPE_IDENTITY() -- Captura el IDPago generado por IDENTITY
        
        -- Actualizar EstadoPago en la tabla TurnoEstado 
		UPDATE TurnoEstado SET EstadoPago = 'Realizado', IDPago = @idpago WHERE IDTurno = @idturno
        
		COMMIT TRAN
		print 'Pago registrado con éxito.'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		print 'Error al registrar pago: ' + ERROR_MESSAGE()
	END CATCH
END
GO



-- Procedimiento para finalizar un turno
CREATE PROC UPD_FinalizarTurno (
    @idturno INT
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM TurnoEstado WHERE IDTurno = @idturno AND EstadoPago = 'Realizado'
											   AND EstadoTurno = 'Vigente')
    BEGIN
        UPDATE TurnoEstado SET EstadoTurno = 'Finalizado'
        WHERE IDTurno = @idturno
		print 'Turno finalizado correctamente.'
    END
	ELSE
		SELECT 0 AS Resultado
END
GO



------------------------------ Consultas complejas (vistas) ----------------------------------------------------------------

-- Obtener todos los turnos de un paciente en un rango de fechas.
CREATE VIEW TurnosEnRango AS
SELECT p.IDPaciente, p.Nombre, p.Apellido, t.IDTurno, t.FechaTurno, te.EstadoTurno, te.EstadoPago 
FROM Paciente p 
INNER JOIN Turno t ON t.IDPaciente = p.IDPaciente
INNER JOIN TurnoEstado te ON te.IDTurno = t.IDTurno

-- Se puede consultar la vista directamente filtrando por el rango de fechas de interés
/*
-- Ejemplo
SELECT * FROM TurnosEnRango WHERE FechaTurno BETWEEN '20250501' AND '20250601' 
*/

GO


-- Calcular el total de pagos realizados por un paciente.
CREATE VIEW TotalPagoPaciente AS
SELECT IDPaciente, SUM(Monto) AS TotalPagos FROM Pago 
GROUP BY IDPaciente

-- Se puede consultar la vista filtrando por un IDPaciente en concreto para conocer el total de pagos de ese paciente.
/*
-- Ejemplo
SELECT * FROM TotalPagoPaciente WHERE IDPaciente = 1
*/
GO


-- Obtener la especialidad de un médico específico.
CREATE VIEW ObtenerEspecialidad AS
SELECT m.IDMedico, m.Nombre, m.Apellido, e.Especialidad  FROM Medico m 
INNER JOIN MedicoEspecialidad me ON m.IDMedico = me.IDMedico
INNER JOIN Especialidad e ON e.IDEspecialidad = me.IDEspecialidad

-- Se puede consultar la vista para obtener la especialidad de un médico en particular.
/*
-- Ejemplo
SELECT * FROM ObtenerEspecialidad WHERE IDMedico = 1
*/
GO


-- Listar los pacientes que aún no han pagado sus turnos.
CREATE VIEW PacientePagoPendiente AS
SELECT p.IDPaciente, p.DNI, p.Nombre, p.Apellido, p.Telefono, p.Email, te.EstadoTurno, te.EstadoPago  
FROM Paciente p
INNER JOIN Turno t ON t.IDPaciente = p.IDPaciente
INNER JOIN TurnoEstado te ON te.IDTurno = t.IDTurno
WHERE te.EstadoPago = 'Pendiente'
GO
