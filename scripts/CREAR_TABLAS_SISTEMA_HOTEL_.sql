-- ============================================================
-- PROYECTO: SISTEMA DE GESTION DE HOTEL
-- ASIGNATURA: TALLER DE BASE DE DATOS
--
-- SCRIPT DE CREACION DE TABLAS
-- Version 3 - Modelo inicial mejorado
--
-- Objetivo:
-- Crear la estructura principal de la base de datos de un hotel,
-- aplicando normalizacion, claves primarias, claves foraneas,
-- restricciones UNIQUE, NOT NULL y CHECK.
--
-- Las reglas que necesitan consultar varias filas, como:
--   * evitar reservas superpuestas
--   * controlar el total pagado
--   * validar cambios de estado
-- se trabajaran posteriormente con PL/SQL.
-- ============================================================


-- ============================================================
-- 1. LIMPIEZA DE TABLAS
-- ============================================================
-- Esta seccion se utiliza cuando las tablas ya existen.
-- Si se ejecuta por primera vez y las tablas no existen,
-- Oracle mostrara ORA-00942 en estos DROP.
-- En ese caso se pueden comentar temporalmente.

DROP TABLE pago CASCADE CONSTRAINTS;
DROP TABLE cuenta_cobro CASCADE CONSTRAINTS;
DROP TABLE consumo_servicio CASCADE CONSTRAINTS;
DROP TABLE servicio_adicional CASCADE CONSTRAINTS;
DROP TABLE categoria_servicio CASCADE CONSTRAINTS;
DROP TABLE ocupante_estadia CASCADE CONSTRAINTS;
DROP TABLE estadia CASCADE CONSTRAINTS;
DROP TABLE auditoria_reserva CASCADE CONSTRAINTS;
DROP TABLE detalle_reserva CASCADE CONSTRAINTS;
DROP TABLE reserva CASCADE CONSTRAINTS;
DROP TABLE tarifa_habitacion CASCADE CONSTRAINTS;
DROP TABLE temporada CASCADE CONSTRAINTS;
DROP TABLE habitacion CASCADE CONSTRAINTS;
DROP TABLE estado_habitacion CASCADE CONSTRAINTS;
DROP TABLE tipo_habitacion CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE huesped CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE pais CASCADE CONSTRAINTS;
DROP TABLE tipo_documento CASCADE CONSTRAINTS;
DROP TABLE metodo_pago CASCADE CONSTRAINTS;
DROP TABLE estado_reserva CASCADE CONSTRAINTS;


-- ============================================================
-- 2. TABLAS DE APOYO / CATALOGOS
-- ============================================================

CREATE TABLE pais (
    id_pais NUMBER NOT NULL,
    nombre_pais VARCHAR2(50) NOT NULL
);

CREATE TABLE ciudad (
    id_ciudad NUMBER NOT NULL,
    id_pais NUMBER NOT NULL,
    nombre_ciudad VARCHAR2(50) NOT NULL
);

CREATE TABLE tipo_documento (
    id_tipo_doc NUMBER NOT NULL,
    nombre_doc VARCHAR2(50) NOT NULL
);

CREATE TABLE estado_habitacion (
    id_estado_hab NUMBER NOT NULL,
    nombre_estado VARCHAR2(50) NOT NULL
);

CREATE TABLE estado_reserva (
    id_estado_res NUMBER NOT NULL,
    nombre_estado VARCHAR2(50) NOT NULL
);

CREATE TABLE categoria_servicio (
    id_categoria NUMBER NOT NULL,
    nombre_categoria VARCHAR2(50) NOT NULL
);

CREATE TABLE metodo_pago (
    id_metodo_pago NUMBER NOT NULL,
    nombre_metodo VARCHAR2(50) NOT NULL
);

CREATE TABLE temporada (
    id_temporada NUMBER NOT NULL,
    nombre_temporada VARCHAR2(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);


-- ============================================================
-- 3. DATOS DEL HUESPED Y EMPLEADO
-- ============================================================

CREATE TABLE huesped (
    id_huesped NUMBER NOT NULL,
    id_tipo_doc NUMBER NOT NULL,
    id_ciudad NUMBER NOT NULL,
    num_doc VARCHAR2(20) NOT NULL,
    nombre_completo VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(20) NOT NULL
);

CREATE TABLE empleado (
    id_empleado NUMBER NOT NULL,
    rut_empleado VARCHAR2(20) NOT NULL,
    nombre_completo VARCHAR2(100) NOT NULL,
    cargo VARCHAR2(50) NOT NULL
);


-- ============================================================
-- 4. HABITACIONES Y TARIFAS
-- ============================================================

CREATE TABLE tipo_habitacion (
    id_tipo_hab NUMBER NOT NULL,
    nombre_tipo VARCHAR2(50) NOT NULL,
    capacidad_max NUMBER NOT NULL
);

CREATE TABLE habitacion (
    id_habitacion NUMBER NOT NULL,
    id_tipo_hab NUMBER NOT NULL,
    id_estado_hab NUMBER NOT NULL,
    numero_hab VARCHAR2(10) NOT NULL,
    piso NUMBER NOT NULL
);

CREATE TABLE tarifa_habitacion (
    id_tarifa NUMBER NOT NULL,
    id_tipo_hab NUMBER NOT NULL,
    id_temporada NUMBER NOT NULL,
    precio_noche NUMBER NOT NULL
);


-- ============================================================
-- 5. RESERVAS Y ESTADIAS
-- ============================================================

CREATE TABLE reserva (
    id_reserva NUMBER NOT NULL,
    id_huesped NUMBER NOT NULL,
    id_empleado NUMBER NOT NULL,
    id_estado_res NUMBER NOT NULL,
    fecha_registro DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE detalle_reserva (
    id_detalle NUMBER NOT NULL,
    id_reserva NUMBER NOT NULL,
    id_habitacion NUMBER NOT NULL,
    fec_ingreso DATE NOT NULL,
    fec_salida DATE NOT NULL,
    precio_aplicado NUMBER NOT NULL
);

CREATE TABLE estadia (
    id_estadia NUMBER NOT NULL,
    id_detalle NUMBER NOT NULL,
    checkin_real DATE NOT NULL,
    checkout_real DATE
);

CREATE TABLE ocupante_estadia (
    id_ocupante NUMBER NOT NULL,
    id_estadia NUMBER NOT NULL,
    num_doc_ocupante VARCHAR2(50) NOT NULL,
    nombre_ocupante VARCHAR2(100) NOT NULL
);


-- ============================================================
-- 6. AUDITORIA DE RESERVAS
-- ============================================================
-- Guarda el historial de cambios de estado de una reserva.
--
-- id_empleado se agrega desde ahora para saber quien realizo
-- el cambio. Posteriormente un TRIGGER PL/SQL podra llenar
-- esta tabla automaticamente.
-- ============================================================

CREATE TABLE auditoria_reserva (
    id_auditoria NUMBER NOT NULL,
    id_reserva NUMBER NOT NULL,
    id_empleado NUMBER NOT NULL,
    estado_anterior VARCHAR2(50) NOT NULL,
    estado_nuevo VARCHAR2(50) NOT NULL,
    fecha_cambio DATE DEFAULT SYSDATE NOT NULL
);


-- ============================================================
-- 7. SERVICIOS
-- ============================================================

CREATE TABLE servicio_adicional (
    id_servicio NUMBER NOT NULL,
    id_categoria NUMBER NOT NULL,
    nombre_servicio VARCHAR2(100) NOT NULL,
    precio_actual NUMBER NOT NULL
);

CREATE TABLE consumo_servicio (
    id_consumo NUMBER NOT NULL,
    id_estadia NUMBER NOT NULL,
    id_servicio NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    precio_cobrado NUMBER NOT NULL
);


-- ============================================================
-- 8. CUENTA Y PAGOS
-- ============================================================

CREATE TABLE cuenta_cobro (
    id_cuenta NUMBER NOT NULL,
    id_estadia NUMBER NOT NULL,
    subtotal_hab NUMBER NOT NULL,
    subtotal_serv NUMBER NOT NULL,
    monto_total NUMBER NOT NULL
);

CREATE TABLE pago (
    id_pago NUMBER NOT NULL,
    id_cuenta NUMBER NOT NULL,
    id_metodo_pago NUMBER NOT NULL,
    monto_pagado NUMBER NOT NULL,
    fecha_pago DATE DEFAULT SYSDATE NOT NULL
);


-- ============================================================
-- 9. CLAVES PRIMARIAS
-- ============================================================

ALTER TABLE pais
    ADD CONSTRAINT pk_pais PRIMARY KEY (id_pais);

ALTER TABLE ciudad
    ADD CONSTRAINT pk_ciudad PRIMARY KEY (id_ciudad);

ALTER TABLE tipo_documento
    ADD CONSTRAINT pk_tipo_doc PRIMARY KEY (id_tipo_doc);

ALTER TABLE estado_habitacion
    ADD CONSTRAINT pk_estado_hab PRIMARY KEY (id_estado_hab);

ALTER TABLE estado_reserva
    ADD CONSTRAINT pk_estado_res PRIMARY KEY (id_estado_res);

ALTER TABLE categoria_servicio
    ADD CONSTRAINT pk_categoria PRIMARY KEY (id_categoria);

ALTER TABLE metodo_pago
    ADD CONSTRAINT pk_metodo_pago PRIMARY KEY (id_metodo_pago);

ALTER TABLE temporada
    ADD CONSTRAINT pk_temporada PRIMARY KEY (id_temporada);

ALTER TABLE huesped
    ADD CONSTRAINT pk_huesped PRIMARY KEY (id_huesped);

ALTER TABLE empleado
    ADD CONSTRAINT pk_empleado PRIMARY KEY (id_empleado);

ALTER TABLE tipo_habitacion
    ADD CONSTRAINT pk_tipo_hab PRIMARY KEY (id_tipo_hab);

ALTER TABLE habitacion
    ADD CONSTRAINT pk_habitacion PRIMARY KEY (id_habitacion);

ALTER TABLE tarifa_habitacion
    ADD CONSTRAINT pk_tarifa PRIMARY KEY (id_tarifa);

ALTER TABLE reserva
    ADD CONSTRAINT pk_reserva PRIMARY KEY (id_reserva);

ALTER TABLE detalle_reserva
    ADD CONSTRAINT pk_detalle PRIMARY KEY (id_detalle);

ALTER TABLE estadia
    ADD CONSTRAINT pk_estadia PRIMARY KEY (id_estadia);

ALTER TABLE ocupante_estadia
    ADD CONSTRAINT pk_ocupante PRIMARY KEY (id_ocupante);

ALTER TABLE auditoria_reserva
    ADD CONSTRAINT pk_auditoria PRIMARY KEY (id_auditoria);

ALTER TABLE servicio_adicional
    ADD CONSTRAINT pk_servicio PRIMARY KEY (id_servicio);

ALTER TABLE consumo_servicio
    ADD CONSTRAINT pk_consumo PRIMARY KEY (id_consumo);

ALTER TABLE cuenta_cobro
    ADD CONSTRAINT pk_cuenta PRIMARY KEY (id_cuenta);

ALTER TABLE pago
    ADD CONSTRAINT pk_pago PRIMARY KEY (id_pago);


-- ============================================================
-- 10. RESTRICCIONES UNIQUE
-- ============================================================

-- No repetir el nombre de un pais.
ALTER TABLE pais
    ADD CONSTRAINT uq_pais_nombre
    UNIQUE (nombre_pais);

-- No repetir una ciudad dentro del mismo pais.
ALTER TABLE ciudad
    ADD CONSTRAINT uq_ciudad_pais_nombre
    UNIQUE (id_pais, nombre_ciudad);

-- No repetir tipos de documento.
ALTER TABLE tipo_documento
    ADD CONSTRAINT uq_tipo_doc_nombre
    UNIQUE (nombre_doc);

-- No repetir estados de habitacion.
ALTER TABLE estado_habitacion
    ADD CONSTRAINT uq_estado_hab_nombre
    UNIQUE (nombre_estado);

-- No repetir estados de reserva.
ALTER TABLE estado_reserva
    ADD CONSTRAINT uq_estado_res_nombre
    UNIQUE (nombre_estado);

-- No repetir categorias de servicio.
ALTER TABLE categoria_servicio
    ADD CONSTRAINT uq_categoria_nombre
    UNIQUE (nombre_categoria);

-- No repetir metodos de pago.
ALTER TABLE metodo_pago
    ADD CONSTRAINT uq_metodo_pago_nombre
    UNIQUE (nombre_metodo);

-- No registrar dos veces exactamente la misma temporada.
ALTER TABLE temporada
    ADD CONSTRAINT uq_temporada_periodo
    UNIQUE (nombre_temporada, fecha_inicio, fecha_fin);

-- El documento se identifica por tipo + numero.
ALTER TABLE huesped
    ADD CONSTRAINT uq_huesped_documento
    UNIQUE (id_tipo_doc, num_doc);

-- El RUT del empleado debe ser unico.
ALTER TABLE empleado
    ADD CONSTRAINT uq_empleado_rut
    UNIQUE (rut_empleado);

-- No repetir tipos de habitacion.
ALTER TABLE tipo_habitacion
    ADD CONSTRAINT uq_tipo_hab_nombre
    UNIQUE (nombre_tipo);

-- El numero de habitacion debe ser unico.
ALTER TABLE habitacion
    ADD CONSTRAINT uq_habitacion_numero
    UNIQUE (numero_hab);

-- Un tipo de habitacion tiene una sola tarifa por temporada.
ALTER TABLE tarifa_habitacion
    ADD CONSTRAINT uq_tarifa_tipo_temporada
    UNIQUE (id_tipo_hab, id_temporada);

-- Un detalle de reserva puede generar como maximo una estadia.
ALTER TABLE estadia
    ADD CONSTRAINT uq_estadia_detalle
    UNIQUE (id_detalle);

-- No repetir el nombre de un servicio.
ALTER TABLE servicio_adicional
    ADD CONSTRAINT uq_servicio_nombre
    UNIQUE (nombre_servicio);

-- Una estadia tiene una sola cuenta de cobro.
ALTER TABLE cuenta_cobro
    ADD CONSTRAINT uq_cuenta_estadia
    UNIQUE (id_estadia);


-- ============================================================
-- 11. CLAVES FORANEAS
-- ============================================================

ALTER TABLE ciudad
    ADD CONSTRAINT fk_ciudad_pais
    FOREIGN KEY (id_pais)
    REFERENCES pais (id_pais);

ALTER TABLE huesped
    ADD CONSTRAINT fk_huesped_tipo_doc
    FOREIGN KEY (id_tipo_doc)
    REFERENCES tipo_documento (id_tipo_doc);

ALTER TABLE huesped
    ADD CONSTRAINT fk_huesped_ciudad
    FOREIGN KEY (id_ciudad)
    REFERENCES ciudad (id_ciudad);

ALTER TABLE habitacion
    ADD CONSTRAINT fk_habitacion_tipo
    FOREIGN KEY (id_tipo_hab)
    REFERENCES tipo_habitacion (id_tipo_hab);

ALTER TABLE habitacion
    ADD CONSTRAINT fk_habitacion_estado
    FOREIGN KEY (id_estado_hab)
    REFERENCES estado_habitacion (id_estado_hab);

ALTER TABLE tarifa_habitacion
    ADD CONSTRAINT fk_tarifa_tipo
    FOREIGN KEY (id_tipo_hab)
    REFERENCES tipo_habitacion (id_tipo_hab);

ALTER TABLE tarifa_habitacion
    ADD CONSTRAINT fk_tarifa_temporada
    FOREIGN KEY (id_temporada)
    REFERENCES temporada (id_temporada);

ALTER TABLE reserva
    ADD CONSTRAINT fk_reserva_huesped
    FOREIGN KEY (id_huesped)
    REFERENCES huesped (id_huesped);

ALTER TABLE reserva
    ADD CONSTRAINT fk_reserva_empleado
    FOREIGN KEY (id_empleado)
    REFERENCES empleado (id_empleado);

ALTER TABLE reserva
    ADD CONSTRAINT fk_reserva_estado
    FOREIGN KEY (id_estado_res)
    REFERENCES estado_reserva (id_estado_res);

ALTER TABLE detalle_reserva
    ADD CONSTRAINT fk_detalle_reserva
    FOREIGN KEY (id_reserva)
    REFERENCES reserva (id_reserva);

ALTER TABLE detalle_reserva
    ADD CONSTRAINT fk_detalle_habitacion
    FOREIGN KEY (id_habitacion)
    REFERENCES habitacion (id_habitacion);

ALTER TABLE estadia
    ADD CONSTRAINT fk_estadia_detalle
    FOREIGN KEY (id_detalle)
    REFERENCES detalle_reserva (id_detalle);

ALTER TABLE ocupante_estadia
    ADD CONSTRAINT fk_ocupante_estadia
    FOREIGN KEY (id_estadia)
    REFERENCES estadia (id_estadia);

ALTER TABLE auditoria_reserva
    ADD CONSTRAINT fk_auditoria_reserva
    FOREIGN KEY (id_reserva)
    REFERENCES reserva (id_reserva);

-- Permite saber que empleado realizo el cambio de estado.
ALTER TABLE auditoria_reserva
    ADD CONSTRAINT fk_auditoria_empleado
    FOREIGN KEY (id_empleado)
    REFERENCES empleado (id_empleado);

ALTER TABLE servicio_adicional
    ADD CONSTRAINT fk_servicio_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES categoria_servicio (id_categoria);

ALTER TABLE consumo_servicio
    ADD CONSTRAINT fk_consumo_estadia
    FOREIGN KEY (id_estadia)
    REFERENCES estadia (id_estadia);

ALTER TABLE consumo_servicio
    ADD CONSTRAINT fk_consumo_servicio
    FOREIGN KEY (id_servicio)
    REFERENCES servicio_adicional (id_servicio);

ALTER TABLE cuenta_cobro
    ADD CONSTRAINT fk_cuenta_estadia
    FOREIGN KEY (id_estadia)
    REFERENCES estadia (id_estadia);

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_cuenta
    FOREIGN KEY (id_cuenta)
    REFERENCES cuenta_cobro (id_cuenta);

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_metodo
    FOREIGN KEY (id_metodo_pago)
    REFERENCES metodo_pago (id_metodo_pago);


-- ============================================================
-- 12. RESTRICCIONES CHECK
-- ============================================================

-- Una habitacion debe tener capacidad positiva.
ALTER TABLE tipo_habitacion
    ADD CONSTRAINT ck_tipo_hab_capacidad
    CHECK (capacidad_max > 0);

-- Una tarifa no puede tener precio negativo.
ALTER TABLE tarifa_habitacion
    ADD CONSTRAINT ck_tarifa_precio
    CHECK (precio_noche >= 0);

-- La temporada debe tener las fechas en orden.
ALTER TABLE temporada
    ADD CONSTRAINT ck_temporada_fechas
    CHECK (fecha_fin > fecha_inicio);

-- La salida debe ser posterior al ingreso.
ALTER TABLE detalle_reserva
    ADD CONSTRAINT ck_detalle_fechas
    CHECK (fec_salida > fec_ingreso);

-- El precio aplicado a una reserva no puede ser negativo.
ALTER TABLE detalle_reserva
    ADD CONSTRAINT ck_detalle_precio
    CHECK (precio_aplicado >= 0);

-- El precio actual de un servicio no puede ser negativo.
ALTER TABLE servicio_adicional
    ADD CONSTRAINT ck_servicio_precio
    CHECK (precio_actual >= 0);

-- La cantidad consumida debe ser mayor que cero.
ALTER TABLE consumo_servicio
    ADD CONSTRAINT ck_consumo_cantidad
    CHECK (cantidad > 0);

-- El precio cobrado por un consumo no puede ser negativo.
ALTER TABLE consumo_servicio
    ADD CONSTRAINT ck_consumo_precio
    CHECK (precio_cobrado >= 0);

-- Los valores de la cuenta no pueden ser negativos.
ALTER TABLE cuenta_cobro
    ADD CONSTRAINT ck_cuenta_subtotal_hab
    CHECK (subtotal_hab >= 0);

ALTER TABLE cuenta_cobro
    ADD CONSTRAINT ck_cuenta_subtotal_serv
    CHECK (subtotal_serv >= 0);

ALTER TABLE cuenta_cobro
    ADD CONSTRAINT ck_cuenta_total
    CHECK (monto_total >= 0);

-- Un pago debe tener un monto mayor que cero.
ALTER TABLE pago
    ADD CONSTRAINT ck_pago_monto
    CHECK (monto_pagado > 0);

-- El checkout puede ser NULL mientras la estadia siga activa.
-- Si existe, no puede ser anterior al checkin.
ALTER TABLE estadia
    ADD CONSTRAINT ck_estadia_fechas
    CHECK (
        checkout_real IS NULL
        OR checkout_real >= checkin_real
    );


-- ============================================================
-- 13. REGLAS QUE QUEDAN PARA LA ETAPA DE PL/SQL
-- ============================================================
--
-- Estas reglas necesitan consultar otras filas de las tablas,
-- por eso se implementaran posteriormente con PL/SQL.
--
-- 1. No permitir dos reservas que se crucen para la misma
--    habitacion.
--
-- 2. No permitir realizar check-in si la reserva esta
--    cancelada.
--
-- 3. No permitir realizar checkout si no existe check-in.
--
-- 4. Controlar que la suma de los pagos no supere el
--    monto total de la cuenta.
--
-- 5. Calcular y controlar los valores de la cuenta de cobro.
--
-- 6. Registrar automaticamente en AUDITORIA_RESERVA los
--    cambios de estado de una reserva.
--
-- 7. Registrar en la auditoria el empleado responsable
--    del cambio mediante ID_EMPLEADO.
--
-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
