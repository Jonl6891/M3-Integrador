Instrucciones

Proyecto Final: Gestión de una Clínica Médica

Descripción del Proyecto:
El objetivo de este proyecto es diseñar, implementar y gestionar una base de datos para la gestión de una clínica médica. 
El proyecto deberá incluir la creación de diversas tablas que reflejen la estructura de la clínica, incluyendo pacientes, 
médicos, historias clínicas, turnos, pagos, entre otros. Adicionalmente, se deberá implementar un conjunto de procedimientos 
almacenados y consultas que permitan la gestión eficiente de los datos.

Requisitos:
Diseño de la Base de Datos:

Diseñar el modelo entidad-relación (ERD) para representar las entidades y sus relaciones.
Crear las tablas necesarias en SQL Server siguiendo las mejores prácticas de normalización.
Tablas:

Crear las siguientes tablas:
Paciente: Incluir campos como DNI, nombre, apellido, dirección, fecha de nacimiento, entre otros.
Medico: Incluir campos como DNI, nombre, apellido, especialidad, entre otros.
Historias Clínicas: Registrar información relevante sobre las consultas médicas.
Turnos: Registro de citas entre pacientes y médicos.
Pagos: Registrar los pagos realizados por los pacientes.
Relaciones:

Definir correctamente las relaciones entre las tablas, incluyendo las claves primarias y foráneas necesarias.
Asegurarse de manejar relaciones uno a uno, uno a muchos, y muchos a muchos según corresponda.
Procedimientos Almacenados:

Crear procedimientos almacenados para:
Insertar nuevos pacientes, médicos, y turnos.
Consultar el historial de un paciente.
Realizar pagos y asociarlos correctamente a los turnos y pacientes.
Actualizar la información de un paciente o médico.
Consultas:

Realizar consultas para:
Obtener todos los turnos de un paciente en un rango de fechas.
Calcular el total de pagos realizados por un paciente.
Obtener la especialidad de un médico específico.
Listar los pacientes que aún no han pagado sus turnos.
Validaciones y Restricciones:

Implementar validaciones en los procedimientos almacenados para asegurar la integridad de los datos.
Asegurarse de que no se puedan insertar registros duplicados y que todas las referencias sean válidas.
Optimización:

Utilizar índices y otros mecanismos de optimización para mejorar el rendimiento de las consultas.
Documentación:

Incluir una breve documentación explicando el diseño de la base de datos y los procedimientos almacenados creados.
Incluir ejemplos de uso para los procedimientos almacenados y consultas.

Formato de entrega: 
Entrega un enlace a tu repositorio de GitHub del script SQL con la creación de las tablas, procedimientos almacenados, y consultas. 
Incluir UN archivo README con la documentación.
¡Éxitos!
