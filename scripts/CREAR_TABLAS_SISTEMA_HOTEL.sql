-- =====================================================================
-- 1. LIMPIEZA DE TABLAS (PREVENCIÓN DE ERRORES)
-- =====================================================================
DROP TABLE pago CASCADE CONSTRAINTS;
DROP TABLE cuenta_cobro CASCADE CONSTRAINTS;
DROP TABLE consumo_servicio CASCADE CONSTRAINTS;
DROP TABLE servicio_adicional CASCADE CONSTRAINTS;
DROP TABLE ocupante_estadia CASCADE CONSTRAINTS;
DROP TABLE estadia CASCADE CONSTRAINTS;
DROP TABLE auditoria_reserva CASCADE CONSTRAINTS;
DROP TABLE detalle_reserva CASCADE CONSTRAINTS;
DROP TABLE reserva CASCADE CONSTRAINTS;
DROP TABLE tarifa_habitacion CASCADE CONSTRAINTS;
DROP TABLE habitacion CASCADE CONSTRAINTS;
DROP TABLE tipo_habitacion CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE huesped CASCADE CONSTRAINTS;
DROP TABLE temporada CASCADE CONSTRAINTS;
DROP TABLE metodo_pago CASCADE CONSTRAINTS;
DROP TABLE categoria_servicio CASCADE CONSTRAINTS;
DROP TABLE estado_reserva CASCADE CONSTRAINTS;
DROP TABLE estado_habitacion CASCADE CONSTRAINTS;
DROP TABLE tipo_documento CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE pais CASCADE CONSTRAINTS;

-- =====================================================================
-- 2. CREACIÓN DE TABLAS BASE (ESTRUCTURA Y NOT NULL)
-- =====================================================================

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
    nombre_temporada VARCHAR2(50) NOT NULL
);

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

CREATE TABLE reserva (
    id_reserva NUMBER NOT NULL,
    id_huesped NUMBER NOT NULL,
    id_empleado NUMBER NOT NULL,
    id_estado_res NUMBER NOT NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE detalle_reserva (
    id_detalle NUMBER NOT NULL,
    id_reserva NUMBER NOT NULL,
    id_habitacion NUMBER NOT NULL,
    fec_ingreso DATE NOT NULL,
    fec_salida DATE NOT NULL,
    precio_aplicado NUMBER NOT NULL
);

CREATE TABLE auditoria_reserva (
    id_auditoria NUMBER NOT NULL,
    id_reserva NUMBER NOT NULL,
    estado_anterior VARCHAR2(50) NOT NULL,
    estado_nuevo VARCHAR2(50) NOT NULL,
    fecha_cambio DATE NOT NULL
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
    fecha_pago DATE NOT NULL
);

-- =====================================================================
-- 3. CLAVES PRIMARIAS (PK) Y RESTRICCIONES ÚNICAS (UNIQUE)
-- =====================================================================

ALTER TABLE pais ADD CONSTRAINT pk_pais PRIMARY KEY (id_pais);
ALTER TABLE pais ADD CONSTRAINT uq_pais_nombre UNIQUE (nombre_pais);

ALTER TABLE ciudad ADD CONSTRAINT pk_ciudad PRIMARY KEY (id_ciudad);

ALTER TABLE tipo_documento ADD CONSTRAINT pk_tipo_doc PRIMARY KEY (id_tipo_doc);
ALTER TABLE tipo_documento ADD CONSTRAINT uq_tipo_doc_nom UNIQUE (nombre_doc);

ALTER TABLE estado_habitacion ADD CONSTRAINT pk_estado_hab PRIMARY KEY (id_estado_hab);
ALTER TABLE estado_habitacion ADD CONSTRAINT uq_estado_hab_nom UNIQUE (nombre_estado);

ALTER TABLE estado_reserva ADD CONSTRAINT pk_estado_res PRIMARY KEY (id_estado_res);
ALTER TABLE estado_reserva ADD CONSTRAINT uq_estado_res_nom UNIQUE (nombre_estado);

ALTER TABLE categoria_servicio ADD CONSTRAINT pk_categoria PRIMARY KEY (id_categoria);
ALTER TABLE categoria_servicio ADD CONSTRAINT uq_categoria_nom UNIQUE (nombre_categoria);

ALTER TABLE metodo_pago ADD CONSTRAINT pk_metodo_pago PRIMARY KEY (id_metodo_pago);
ALTER TABLE metodo_pago ADD CONSTRAINT uq_metodo_nom UNIQUE (nombre_metodo);

ALTER TABLE temporada ADD CONSTRAINT pk_temporada PRIMARY KEY (id_temporada);
ALTER TABLE temporada ADD CONSTRAINT uq_temporada_nom UNIQUE (nombre_temporada);

ALTER TABLE huesped ADD CONSTRAINT pk_huesped PRIMARY KEY (id_huesped);
ALTER TABLE huesped ADD CONSTRAINT uq_huesped_doc UNIQUE (num_doc);

ALTER TABLE empleado ADD CONSTRAINT pk_empleado PRIMARY KEY (id_empleado);
ALTER TABLE empleado ADD CONSTRAINT uq_empleado_rut UNIQUE (rut_empleado);

ALTER TABLE tipo_habitacion ADD CONSTRAINT pk_tipo_hab PRIMARY KEY (id_tipo_hab);
ALTER TABLE tipo_habitacion ADD CONSTRAINT uq_tipo_hab_nom UNIQUE (nombre_tipo);

ALTER TABLE habitacion ADD CONSTRAINT pk_habitacion PRIMARY KEY (id_habitacion);
ALTER TABLE habitacion ADD CONSTRAINT uq_habitacion_num UNIQUE (numero_hab);

ALTER TABLE tarifa_habitacion ADD CONSTRAINT pk_tarifa PRIMARY KEY (id_tarifa);

ALTER TABLE reserva ADD CONSTRAINT pk_reserva PRIMARY KEY (id_reserva);

ALTER TABLE detalle_reserva ADD CONSTRAINT pk_detalle PRIMARY KEY (id_detalle);

ALTER TABLE auditoria_reserva ADD CONSTRAINT pk_auditoria PRIMARY KEY (id_auditoria);

ALTER TABLE estadia ADD CONSTRAINT pk_estadia PRIMARY KEY (id_estadia);
ALTER TABLE estadia ADD CONSTRAINT uq_estadia_detalle UNIQUE (id_detalle);

ALTER TABLE ocupante_estadia ADD CONSTRAINT pk_ocupante PRIMARY KEY (id_ocupante);

ALTER TABLE servicio_adicional ADD CONSTRAINT pk_servicio PRIMARY KEY (id_servicio);

ALTER TABLE consumo_servicio ADD CONSTRAINT pk_consumo PRIMARY KEY (id_consumo);

ALTER TABLE cuenta_cobro ADD CONSTRAINT pk_cuenta PRIMARY KEY (id_cuenta);
ALTER TABLE cuenta_cobro ADD CONSTRAINT uq_cuenta_estadia UNIQUE (id_estadia);

ALTER TABLE pago ADD CONSTRAINT pk_pago PRIMARY KEY (id_pago);

-- =====================================================================
-- 4. CLAVES FORÁNEAS (FK) - CREANDO LAS RELACIONES
-- =====================================================================

ALTER TABLE ciudad ADD CONSTRAINT fk_ciudad_pais FOREIGN KEY (id_pais) REFERENCES pais (id_pais);
ALTER TABLE huesped ADD CONSTRAINT fk_huesped_doc FOREIGN KEY (id_tipo_doc) REFERENCES tipo_documento (id_tipo_doc);
ALTER TABLE huesped ADD CONSTRAINT fk_huesped_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad);
ALTER TABLE habitacion ADD CONSTRAINT fk_hab_tipo FOREIGN KEY (id_tipo_hab) REFERENCES tipo_habitacion (id_tipo_hab);
ALTER TABLE habitacion ADD CONSTRAINT fk_hab_estado FOREIGN KEY (id_estado_hab) REFERENCES estado_habitacion (id_estado_hab);
ALTER TABLE tarifa_habitacion ADD CONSTRAINT fk_tarifa_tipo FOREIGN KEY (id_tipo_hab) REFERENCES tipo_habitacion (id_tipo_hab);
ALTER TABLE tarifa_habitacion ADD CONSTRAINT fk_tarifa_temp FOREIGN KEY (id_temporada) REFERENCES temporada (id_temporada);
ALTER TABLE reserva ADD CONSTRAINT fk_reserva_huesped FOREIGN KEY (id_huesped) REFERENCES huesped (id_huesped);
ALTER TABLE reserva ADD CONSTRAINT fk_reserva_empleado FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado);
ALTER TABLE reserva ADD CONSTRAINT fk_reserva_estado FOREIGN KEY (id_estado_res) REFERENCES estado_reserva (id_estado_res);
ALTER TABLE detalle_reserva ADD CONSTRAINT fk_detalle_reserva FOREIGN KEY (id_reserva) REFERENCES reserva (id_reserva);
ALTER TABLE detalle_reserva ADD CONSTRAINT fk_detalle_hab FOREIGN KEY (id_habitacion) REFERENCES habitacion (id_habitacion);
ALTER TABLE auditoria_reserva ADD CONSTRAINT fk_auditoria_reserva FOREIGN KEY (id_reserva) REFERENCES reserva (id_reserva);
ALTER TABLE estadia ADD CONSTRAINT fk_estadia_detalle FOREIGN KEY (id_detalle) REFERENCES detalle_reserva (id_detalle);
ALTER TABLE ocupante_estadia ADD CONSTRAINT fk_ocupante_estadia FOREIGN KEY (id_estadia) REFERENCES estadia (id_estadia);
ALTER TABLE servicio_adicional ADD CONSTRAINT fk_servicio_cat FOREIGN KEY (id_categoria) REFERENCES categoria_servicio (id_categoria);
ALTER TABLE consumo_servicio ADD CONSTRAINT fk_consumo_estadia FOREIGN KEY (id_estadia) REFERENCES estadia (id_estadia);
ALTER TABLE consumo_servicio ADD CONSTRAINT fk_consumo_servicio FOREIGN KEY (id_servicio) REFERENCES servicio_adicional (id_servicio);
ALTER TABLE cuenta_cobro ADD CONSTRAINT fk_cuenta_estadia FOREIGN KEY (id_estadia) REFERENCES estadia (id_estadia);
ALTER TABLE pago ADD CONSTRAINT fk_pago_cuenta FOREIGN KEY (id_cuenta) REFERENCES cuenta_cobro (id_cuenta);
ALTER TABLE pago ADD CONSTRAINT fk_pago_metodo FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago (id_metodo_pago);