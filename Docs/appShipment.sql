/*alter session set "_ORACLE_SCRIPT"=true;

CREATE USER AS_ADMIN IDENTIFIED BY oracle12c;
GRANT ALL PRIVILEGES TO AS_ADMIN;*/

/* DROPS!
*/
DROP TABLE transp_vehiculos;
DROP TABLE vehiculos;
DROP TABLE tipos_vehiculo;
DROP TABLE usuarios;
DROP TABLE transportadores;
DROP TABLE servicios;
DROP TABLE localizaciones;
DROP TABLE personas;
DROP TABLE dimensiones;
DROP TABLE paquetes;


CREATE TABLE personas (
  id_persona NUMERIC GENERATED ALWAYS AS IDENTITY (START WITH 1001 INCREMENT BY 1) PRIMARY KEY,
  tipo_id VARCHAR2(2),
  nm_id NUMERIC,
  nm_celular NUMERIC,
  nombre VARCHAR2(50),
  apellido VARCHAR2(50),
  email VARCHAR2(50),
  password VARCHAR2(50),
  fecha_registro DATE,
  calificacion NUMERIC(3,2),
  activo VARCHAR2(1) DEFAULT 'N' CHECK (activo IN('S', 'N'))
);

CREATE TABLE usuarios (
  id_usuario NUMERIC NOT NULL,
  
  CONSTRAINT id_persona_FK FOREIGN KEY (id_usuario) REFERENCES personas (id_persona)
);

CREATE TABLE transportadores (
  id_transportador NUMERIC NOT NULL,
  estado VARCHAR2(1) DEFAULT 'S' CHECK (estado IN ('S', 'A', 'I')),
  
  CONSTRAINT id_persona_FK2 FOREIGN KEY (id_transportador) REFERENCES personas (id_persona)
);

CREATE TABLE tipos_vehiculo (
  id_tipo NUMERIC PRIMARY KEY,
  nombre varchar2(20)
);

CREATE TABLE vehiculos (
  id_vehiculo NUMERIC GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
  tipo NUMERIC,
  marca varchar2(20),
  referencia varchar2(20),
  placa varchar2(10),
  modelo number,
  fecha_registro DATE,
  
  CONSTRAINT tipo_vehiculo_FK FOREIGN KEY (tipo) REFERENCES tipos_vehiculo (id_tipo)
);

CREATE TABLE transp_vehiculos (
  id_transp NUMERIC NOT NULL,
  id_vehiculo NUMERIC NOT NULL,
  
  CONSTRAINT transp_vehiculos_PK PRIMARY KEY (id_transp, id_vehiculo),
  CONSTRAINT id_transp_FK FOREIGN KEY (id_transp) REFERENCES personas (id_persona),
  CONSTRAINT id_vehiculo_FK FOREIGN KEY (id_vehiculo) REFERENCES  vehiculos (id_vehiculo)
);

CREATE TABLE localizaciones (
  id_localizacion NUMERIC NOT NULL,
  latitud NUMERIC(12,8),
  longitud NUMERIC(12,8),
  fecha_actualizacion DATE,
  
  CONSTRAINT id_user_tranps_PK FOREIGN KEY (id_localizacion) REFERENCES personas (id_persona)
);

CREATE TABLE servicios (
  id_servicio  NUMERIC GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  id_usuario NUMERIC,
  id_transportador NUMERIC,
  origen_lat NUMERIC(12,8),
  origen_lng NUMERIC(12,8),
  destino_lat NUMERIC(12,8),
  destino_lng NUMERIC(12,8),
  estado VARCHAR2(2),
  fecha_inicio DATE,
  fecha_fin DATE,
  tipo_servicio VARCHAR2(2) DEFAULT 'A' CHECK (tipo_servicio IN ('I', 'P')),
  
  CONSTRAINT servicios_PK PRIMARY KEY (id_servicio, id_usuario, id_transportador),
  CONSTRAINT id_usuario_FK FOREIGN KEY (id_usuario) REFERENCES personas (id_persona),
  CONSTRAINT id_transportador_FK FOREIGN KEY (id_transportador) REFERENCES personas (id_persona)
);

CREATE TABLE dimensiones (
  id_dimensiones NUMERIC GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
  volumen_min NUMERIC,
  volumen_max NUMERIC,
  descripcion VARCHAR(10)
);

CREATE TABLE paquetes (
  id_paquete NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  id_servicio NUMERIC,
  id_usuario NUMERIC,
  id_transportador NUMERIC,
  nombre_destinatario VARCHAR2(50),
  tipo_id_destinatario VARCHAR2(2),
  nm_id_destinatario NUMERIC,
  tel_destinatario NUMERIC,
  declaracion_contenido VARCHAR2(150),
  valor_declarado NUMERIC,
  peso NUMERIC,
  id_dimensiones NUMBER,
  
  CONSTRAINT paquetes_PK PRIMARY KEY (id_paquete),
  CONSTRAINT id_dimensiones_paquetes_FK  FOREIGN KEY (id_dimensiones) REFERENCES dimensiones (id_dimensiones),
  CONSTRAINT id_servicio_paquetes_FK  FOREIGN KEY (id_servicio, id_usuario, id_transportador) REFERENCES servicios (id_servicio, id_usuario, id_transportador)
);

INSERT INTO personas (tipo_id, nm_id, nm_celular, nombre, apellido, email, password, fecha_registro, calificacion, activo) VALUES ('CC', 1234, 3003216598, 'Fizz', 'Seajoker', 'fizz@seajoker.com', 'fizz', null, 4.32, 'S');
INSERT INTO personas (tipo_id, nm_id, nm_celular, nombre, apellido, email, password, fecha_registro, calificacion, activo) VALUES ('CC', 4321, 3009876544, 'Jax', 'Handmaster', 'jax@handmaster.com', 'jax', null, 4.21, 'S');
INSERT INTO usuarios (ID_USUARIO) VALUES (1001);
INSERT INTO transportadores (ID_USUARIO, ESTADO) VALUES (1002, 'S');

INSERT INTO personas (tipo_id, nm_id, nm_celular, nombre, apellido, email, password, fecha_registro, calificacion, activo) VALUES ('CC', 5451, 3009876544, 'Kata', 'Rina', 'kata@rina.com', 'kata', null, 4.21, 'S');
INSERT INTO personas (tipo_id, nm_id, nm_celular, nombre, apellido, email, password, fecha_registro, calificacion, activo) VALUES ('CC', 9584, 3009876544, 'Diana', 'Moonlight', 'diana@moonlight.com', 'diana', null, 4.21, 'S');
INSERT INTO personas (tipo_id, nm_id, nm_celular, nombre, apellido, email, password, fecha_registro, calificacion, activo) VALUES ('CC', 1354, 3009876544, 'Twisted', 'Fate', 'twisted@fate.com', 'twisted', null, 4.21, 'S');
INSERT INTO transportadores (ID_TRANSPORTADOR,ESTADO) VALUES (1003, 'S');
INSERT INTO transportadores (ID_TRANSPORTADOR,ESTADO) VALUES (1004, 'S');
INSERT INTO transportadores (ID_TRANSPORTADOR,ESTADO) VALUES (1005, 'S');

INSERT INTO TIPOS_VEHICULO (ID_TIPO,NOMBRE) VALUES (1, 'Carro');
INSERT INTO TIPOS_VEHICULO (ID_TIPO,NOMBRE) VALUES (2, 'Camion');
INSERT INTO TIPOS_VEHICULO (ID_TIPO,NOMBRE) VALUES (3, 'Moto');
INSERT INTO TIPOS_VEHICULO (ID_TIPO,NOMBRE) VALUES (4, 'Bici');

INSERT INTO VEHICULOS (TIPO, MARCA, REFERENCIA, PLACA, MODELO, FECHA_REGISTRO) VALUES (1, 'Hyundai', 'i35', 'ABC-123', 2015, null);
INSERT INTO VEHICULOS (TIPO, MARCA, REFERENCIA, PLACA, MODELO, FECHA_REGISTRO) VALUES (1, 'BMW', '321', 'QWE-456', 2015, null);
INSERT INTO VEHICULOS (TIPO, MARCA, REFERENCIA, PLACA, MODELO, FECHA_REGISTRO) VALUES (1, 'KIA', 'Cerato', 'ZXC-678', 2015, null);
INSERT INTO VEHICULOS (TIPO, MARCA, REFERENCIA, PLACA, MODELO, FECHA_REGISTRO) VALUES (1, 'Chevrolet', 'Sail', 'QAZ-890', 2015, null);

INSERT INTO TRANSP_VEHICULOS (ID_TRANSP, ID_VEHICULO) VALUES (1002, 1);
INSERT INTO TRANSP_VEHICULOS (ID_TRANSP, ID_VEHICULO) VALUES (1022, 2);
INSERT INTO TRANSP_VEHICULOS (ID_TRANSP, ID_VEHICULO) VALUES (1023, 3);
INSERT INTO TRANSP_VEHICULOS (ID_TRANSP, ID_VEHICULO) VALUES (1025, 4);

INSERT INTO LOCALIZACIONES (ID_LOCALIZACION, LATITUD, LONGITUD, FECHA_ACTUALIZACION) VALUES (1002, 4.744522, -74.066414,null);
INSERT INTO LOCALIZACIONES (ID_LOCALIZACION, LATITUD, LONGITUD, FECHA_ACTUALIZACION) VALUES (1022, 4.751023, -74.066414,null);
INSERT INTO LOCALIZACIONES (ID_LOCALIZACION, LATITUD, LONGITUD, FECHA_ACTUALIZACION) VALUES (1023, 4.756540, -74.063782,null);
INSERT INTO LOCALIZACIONES (ID_LOCALIZACION, LATITUD, LONGITUD, FECHA_ACTUALIZACION) VALUES (1025, 4.752590, -74.049896,null);