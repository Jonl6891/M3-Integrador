-- Script de consultas y pruebas

/*
	-- Se requiere ejecutar el script BD_Centro_Medico_Script.sql para crear la base de datos (tablas, procedimientos y vistas)
	-- Una vez creada toda la base de datos, proceder con las pruebas de este script.  
*/

-- Consulta para chequear tablas
/*
	SELECT * FROM Paciente
	SELECT * FROM Medico
	SELECT * FROM Especialidad
	SELECT * FROM MedicoEspecialidad
	SELECT * FROM Turno
	SELECT * FROM TurnoEstado
	SELECT * FROM HistoriaClinica
	SELECT * FROM Pago
*/

-- Lista de procedimientos (por tabla)
/*
-- Tabla Medico
EXEC I_Medico 
EXEC UPD_Medico 

-- Tabla Especialidad
EXEC I_Especialidad 
EXEC I_MedicoEspecialidad

-- Tabla Paciente
EXEC I_Paciente  
EXEC UPD_Paciente  

-- Tabla Turno
EXEC I_Turno 
EXEC UPD_TurnosVencidos -- (no recibe parámetros)
EXEC UPD_CancelarTurno 

-- Tabla HistoriaClinica
EXEC I_HistoriaClinica 
EXEC S_ConsultarHistorialPaciente 

-- Tabla Pago
EXEC I_RegistrarPago 

-- TurnoEstado
EXEC UPD_FinalizarTurno 
*/



-- Uso de procedimientos y precarga de datos para pruebas

/*
	-- Para probar que los procedimientos de inserción no admiten duplicados, intentar ejecutar dos veces seguidas dichos procedimientos.
	-- Para probar filtros de validación, intentar ingresar números de IDs inexistentes.
	-- Los procedimientos de actualización, si ya fueron ejecutados sobre un mismo registro, devuelven valor 0.
*/
		
/* ----- Se recomienda (al menos, inicialmente) cargar los datos y ejecutar los procedimientos en el orden sugerido ----- */ 


-- Precarga de pacientes
/*
	EXEC I_Paciente '30265489', 'Pablo', 'Pisculichi', 'Viamonte 703', '19800419', '1122334455', 'piscupablo256@gmail.com' 
	EXEC I_Paciente '36205415', 'Manuel', 'Almiron', 'Pichincha 250', '19880723', '1138431256', 'manualmiron2000@gmail.com' 
	EXEC I_Paciente '28265489', 'Monica', 'Verduchesqui', 'Viamonte 1500', '19780305', '1198642351', 'moniverdu1978@gmail.com' 
	EXEC I_Paciente '31956465', 'Roberto', 'Miura', 'Santa Fe 875', '19830517', '1147821953', 'robermiura433@gmail.com' 
	EXEC I_Paciente '27486794', 'Victoria', 'Minetta', 'Entre Rios 900', '19770528', '1195861347', 'vikiminetta180@gmail.com' 
	EXEC I_Paciente '26421748', 'Ruben', 'Molina', 'Suipacha 600', '19760802', '1173916482', 'rubenmolina1324@gmail.com' 
	EXEC I_Paciente '31867432', 'Elisa', 'Bizancio', 'Belgrano 1100', '19830418', '1156719823', 'elibizan3030@gmail.com' 

	-- Para probar filtro de seguridad ante duplicados, intentar ingresar los registros por segunda vez.

	-- Modificar dirección y número de celular del paciente Roberto Miura (IDPaciente 4 según el orden sugerido)
	EXEC UPD_Paciente 4. '31956465', 'Roberto', 'Miura', 'Alem 1253', '19830517', '1171293845', 'robermiura433@gmail.com'
*/


-- Precarga de médicos
/*
	EXEC I_Medico '22446578', 'Lorenzo', 'Montenegro', '1178896452', 'lorenzomontenegro444@gmail.com' 
	EXEC I_Medico '20648192', 'Martin', 'Galarzza', '1169381754', 'galarzzamartin41@gmail.com' 
	EXEC I_Medico '25419678', 'Felicia', 'Mondragon', '1165324978', 'felimondragon88@email.com' 

	-- Para probar filtro de seguridad ante duplicados, intentar ingresar los registros por segunda vez.

	-- Modificar número de celular de la médica Felicia Mondragon (IDMedico 3 según el orden sugerido)
	EXEC UPD_Medico 3, '25419678', 'Felicia', 'Mondragon', '1164319758', 'felimondragon88@email.com' 
*/


-- Precarga de especialidades
/*
	EXEC I_Especialidad 'Clínica Médica' -- Por Identity: IDEspecialidad 1 (según orden sugerido)
	EXEC I_Especialidad 'Cirugía'		 -- Por Identity: IDEspecialidad 2 (según orden sugerido)
	EXEC I_Especialidad 'Traumatología'  -- Por Identity: IDEspecialidad 3 (según orden sugerido)

	-- Para probar filtro de seguridad ante duplicados, intentar ingresar los registros por segunda vez.
*/


-- Vincular médicos con especialidades
/*
	EXEC I_MedicoEspecialidad 1, 1   -- Lorenzo Montenegro (Clínico)
	EXEC I_MedicoEspecialidad 2, 2   -- Martin Galarzza (Cirujano) 
	EXEC I_MedicoEspecialidad 3, 3   -- Felicia Mondragon (Traumatóloga)

	-- Para probar filtro de seguridad ante duplicados, intentar ingresar los registros por segunda vez.
*/


-- Precarga de turnos para pruebas
/*
	-- Utilizar fechas y horas vigentes para estos registros
	EXEC I_Turno 1, 1, 1, '20250528 12:30', ''  
	EXEC I_Turno 2, 2, 2, '20250528 14:30', ''
	EXEC I_Turno 3, 3, 3, '20250528 15:00', ''

	-- Turno para cancelar (procedimiento UPD_CancelarTurno)
	EXEC I_Turno 4, 1, 1, '20250624 15:00', '' 

	-- Datos para probar turnos vencidos (mes de abril)
	EXEC I_Turno 5, 1, 1, '20250425 10:30', '' 
	EXEC I_Turno 6, 2, 2, '20250427 14:30', ''
	EXEC I_Turno 7, 2, 2, '20250428 11:30', ''  

	-- Para probar filtro de seguridad ante duplicados, intentar ingresar los registros por segunda vez.

	-- Al correr el procedimiento UPD_TurnosVencidos se actualizarán todos los turnos con fecha vencida a la vez 
	EXEC UPD_TurnosVencidos

	-- Cancelar el turno del paciente Roberto Miura (IDTurno 4 según el orden sugerido)
	EXEC UPD_CancelarTurno 4
*/


-- Precarga de historias clínicas
/*
	-- Ingresar historia clíica de Pablo Pisculichi (IDPaciente 1) atendido por Dr. Lorenzo Montenegro (IDMedico 1)
	EXEC I_HistoriaClinica 1, 1, '20250522 13:00', 'Chequeo de rutina (laboratorio completo + electrocardiograma).'   

	-- Ingresar historia clíica de Manuel ALmiron (IDPaciente 2) atendido por Dr. Martin Galarzza (IDMedico 2)
	EXEC I_HistoriaClinica 2, 2, '20250523 15:00', 'Paciente con estudios pre-quirúrgicos para colecistectomía laparoscópica programada.'

	-- Ingresar historia clínica de Monica Verduchesqui (IDPaciente 3) atendida por Dra. Felicia Mondragon (IDMedico 3)
	EXEC I_HistoriaClinica 3, 3, '20250524 15:30', 'Paciente con esguince en el tobillo. Se solicita estudio de Radiografía.'

	-- Para probar filtro de seguridad ante duplicados, intentar ingresar los registros por segunda vez.

	-- Consultar historia clínica de Pablo Pisculichi (IDPaciente 1 según orden sugerido)
	EXEC S_ConsultarHistorialPaciente 1
*/


-- Precarga de pagos
/*
	-- Según el roden sugerido, sólo los pacientes 1, 2 y 3 llegan a abonar su atención médica 
	EXEC I_RegistrarPago 1, 1, 20000,'20250522 13:00', 'Transferencia'
	EXEC I_RegistrarPago 2, 2, 20000, '20250523 15:00', 'Débito'
	EXEC I_RegistrarPago 3, 3, 20000, '20250524 15:30', 'Efectivo'

	-- Para probar filtro de seguridad ante duplicados, intentar ingresar los registros por segunda vez.
*/


-- Finalizar turnos completados y pagados (procedimiento UPD_FinalizarTurno)
/*
	-- Según el orden sugerido, sólo los pacientes 1, 2 y 3 completan su atención médica.
	EXEC UPD_FinalizarTurno 1
	EXEC UPD_FinalizarTurno 2
	EXEC UPD_FinalizarTurno 3
*/


-- Consultas (prueba de Vistas creadas)
/*
	-- Vista FechaTurno: obtiene todos los turnos de un paciente en un rango de fechas.
	SELECT * FROM TurnosEnRango WHERE FechaTurno BETWEEN '20250501' AND '20250601' 

	-- Vista TotalPagoPaciente: suma el total de pagos realizados por paciente
	SELECT * FROM TotalPagoPaciente  -- Devuelve todos los pacientes con sus totales de pago
	SELECT * FROM TotalPagoPaciente WHERE IDPaciente = 1  -- Devuelve total de pagos de un solo paciente

	-- Vista ObtenerEspecialidad: obtiene la especialidad de todos los médicos
	SELECT * FROM ObtenerEspecialidad  -- Devuelve todas especialidades con sus médicos asociados
	SELECT * FROM ObtenerEspecialidad WHERE IDMedico = 1  --Devuelve la especialidad de un ´médico en particular

	-- Vista PacientePagoPendiente: lista los pacientes que aún no han pagado sus turnos.
	SELECT * FROM PacientePagoPendiente
*/



-----------------------------------------------------------------------------------------------------------------



-- Código para limpiar todas las tablas después de hacer pruebas
/*

-- 1. Borrar registros (orden inverso según dependencias)
DELETE FROM TurnoEstado      -- Depende de Turno y Pago
DELETE FROM Pago            -- Depende de Turno
DELETE FROM Turno           -- Depende de Paciente, Medico y Especialidad
DELETE FROM MedicoEspecialidad -- Depende de Medico y Especialidad
DELETE FROM HistoriaClinica -- Depende de Paciente y Medico
DELETE FROM Paciente        -- Tabla base
DELETE FROM Medico          -- Tabla base
DELETE FROM Especialidad    -- Tabla base

-- 2. Resetear IDENTITY (solo tablas con IDENTITY)
DBCC CHECKIDENT ('TurnoEstado', RESEED, 0)
DBCC CHECKIDENT ('Pago', RESEED, 0)
DBCC CHECKIDENT ('Turno', RESEED, 0)
DBCC CHECKIDENT ('HistoriaClinica', RESEED, 0)
DBCC CHECKIDENT ('Paciente', RESEED, 0)
DBCC CHECKIDENT ('Medico', RESEED, 0)
DBCC CHECKIDENT ('Especialidad', RESEED, 0)

*/
