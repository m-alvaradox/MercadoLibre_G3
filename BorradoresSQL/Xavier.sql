create database IF NOT EXISTS MercadoLibre;
use MercadoLibre;

CREATE TABLE IF NOT EXISTS USUARIO (
  USERID VARCHAR(50) PRIMARY KEY,
  PASS VARCHAR(16) NOT NULL,
  NOMBRE VARCHAR(10) NOT NULL,
  APELLIDO VARCHAR(10) NOT NULL,
  FECHANACIMIENTO DATE NOT NULL,
  ESCLIENTE BOOLEAN NOT NULL,
  ESVENDEDOR BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS CLIENTE (
  USERID VARCHAR(50) PRIMARY KEY,
  FOREIGN KEY (USERID) REFERENCES USUARIO (USERID)
);

CREATE TABLE IF NOT EXISTS VENDEDOR (
  USERID VARCHAR(50) PRIMARY KEY,
   REPUTACION FLOAT,
  FOREIGN KEY (USERID) REFERENCES USUARIO (USERID)
);

CREATE TABLE IF NOT EXISTS PAIS (
  COUNTRYID INT PRIMARY KEY,
  NOMBREPAIS VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS PROVINCIA (
  PROVID INT PRIMARY KEY,
  COUNTRYID INT,
  NOMBREPROVINCIA VARCHAR(10) NOT NULL,
  FOREIGN KEY (COUNTRYID) REFERENCES PAIS (COUNTRYID)
);

CREATE TABLE IF NOT EXISTS CIUDAD (
  NOMBRECIUDAD VARCHAR(50) PRIMARY KEY,
  PROVID INT,
   SIGLAS VARCHAR(5),
  FOREIGN KEY (PROVID) REFERENCES PROVINCIA (PROVID)
);

CREATE TABLE IF NOT EXISTS DIRECCION (
  ID INT PRIMARY KEY,
  CIUDAD VARCHAR(50),
  USERID VARCHAR(50),
  PARROQUIA VARCHAR(50),
  REFERENCIAS VARCHAR(50),
  FOREIGN KEY (USERID) REFERENCES USUARIO (USERID),
  FOREIGN KEY (CIUDAD) REFERENCES CIUDAD (NOMBRECIUDAD)
);

CREATE TABLE IF NOT EXISTS TELEFONO (
  USERID VARCHAR(50) PRIMARY KEY,
  FOREIGN KEY (USERID) REFERENCES USUARIO (USERID),
  NUM_TELEFONO VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS PRODUCTO (
  PRODUCTID INT PRIMARY KEY,
  NOMBRE VARCHAR(10) NOT NULL,
  MARCA VARCHAR(10),
  CATEGORIA VARCHAR(10),
  SUBCATEGORIA VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS PUBLICACION (
  NOPUBLICACION  int   AUTO_INCREMENT,
  DESCRIPCION VARCHAR(100),
  TIPOEXPOSICION ENUM('Gratuita','Clásica','Premium') NOT NULL,
  PRODUCTID INT,
  IDVENDEDOR VARCHAR(50),
  PRIMARY KEY(NOPUBLICACION),
  FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTO (PRODUCTID),
  FOREIGN KEY (IDVENDEDOR) REFERENCES VENDEDOR (USERID)
);

CREATE TABLE IF NOT EXISTS IMAGEN_PUBLICACION (
  PUBID INT PRIMARY KEY,
  IMAGEURL VARCHAR(100) NOT NULL,
  FOREIGN KEY (PUBID) REFERENCES PUBLICACION (NOPUBLICACION)
);

CREATE TABLE IF NOT EXISTS VISUALIZACION_PUBLICACIONES (
  USERID VARCHAR(50),
  NOPUBLICACION  int   AUTO_INCREMENT,
  FECHA DATE,
  PRIMARY KEY (USERID, NOPUBLICACION),
  FOREIGN KEY (USERID) REFERENCES USUARIO (USERID),
  FOREIGN KEY (NOPUBLICACION) REFERENCES PUBLICACION (NOPUBLICACION)
);

CREATE TABLE IF NOT EXISTS DETALLE_CONTACTO (
  CLIENTE_ID VARCHAR(50),
  PUBLICACION  int   AUTO_INCREMENT,
  MENSAJE VARCHAR(100),
  FECHA_HORA DATETIME,  
  PRIMARY KEY (CLIENTE_ID, PUBLICACION),
  FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (USER_ID),
  FOREIGN KEY (PUBLICACION) REFERENCES PUBLICACION (PUBLICACION)
);

CREATE TABLE IF NOT EXISTS PAGO (
  TRANS_ID INT PRIMARY KEY,
  CLIENTE_ID VARCHAR(50),
  MONTO FLOAT NOT NULL,
  METODO ENUM('Depósito','Crédito/Débito') NOT NULL,
  CARD_NUMBER INT,
  CUOTA INT,
  FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (USER_ID)
);

CREATE TABLE IF NOT EXISTS PREGUNTA (
  PREGUNTA_ID int  AUTO_INCREMENT,
  CLIENTE_ID VARCHAR(50),
  NoPUBLICACION  int AUTO_INCREMENT,
  CONTENIDO VARCHAR(70) NOT NULL,
  TIEMPO_ENVIADO DATETIME NOT NULL,
  FECHA_HORA_RESPUESTA DATETIME,
  MENSAJE_RESPUESTA VARCHAR(100),
  PRIMARY KEY(PREGUNTA_ID),
  FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (USER_ID),
  FOREIGN KEY (NoPUBLICACION) REFERENCES PUBLICACION (PUBLICACION)
);

CREATE TABLE IF NOT EXISTS CUPON (
  ID INT PRIMARY KEY,
  NOMBRE VARCHAR(10) NOT NULL,
  DESCUENTO FLOAT NOT NULL,
  FECHA_VENCIMIENTO DATE NOT NULL,
  CLIENTE_ID VARCHAR(50),
  FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (USER_ID)
);

CREATE TABLE IF NOT EXISTS ORDEN (
  ORDEN_ID INT PRIMARY KEY,
  CUPON_ID INT,
  PRODUCT_ID INT,
  PAGO_ID INT,
  CALIFICACION INT,
  CLIENTE_ID VARCHAR(50),
  VENDEDOR_ID VARCHAR(50),
  DIRECCION_ID INT,
  FECHA_CREACION DATE NOT NULL,
  ESTADO ENUM('Pendiente','En curso','Completada') NOT NULL,
  CANTIDAD_PRODUCTO INT NOT NULL,
  PAGO_TOTAL FLOAT NOT NULL,
  COSTO_ENVIO FLOAT,
  FECHA_ENTREGA DATE,
  FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (USER_ID),
  FOREIGN KEY (CUPON_ID) REFERENCES CUPON (ID),
  FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTO (PRODUCT_ID),
  FOREIGN KEY (PAGO_ID) REFERENCES PAGO (TRANSA_ID),
  FOREIGN KEY (CALIFICACION) REFERENCES CALIFICACION_ORDEN (CALIFICACION_ID),
  FOREIGN KEY (VENDEDOR_ID) REFERENCES VENDEDOR (USER_ID),
  FOREIGN KEY (DIRECCION_ID) REFERENCES DIRECCION (ID)
);

CREATE TABLE IF NOT EXISTS CALIFICACION_ORDEN (
  CALIFICACION_ID INT,
  ORDEN_ID INT,
  CLIENTE_ID VARCHAR(50),
  ESTRELLAS_PRODUCTO INT,
  COMENTARIO_PRODUCTO VARCHAR(30),
  CALIFICACION_VENDEDOR ENUM('Positiva','Neutral','Negativa'),
  FOTO_EVIDENCIA VARCHAR(50),
  PRIMARY KEY (CALIFICACION_ID, CLIENTE_ID),
  FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (USER_ID),
  FOREIGN KEY (ORDEN_ID) REFERENCES ORDEN (ORDEN_ID)
);

CREATE TABLE IF NOT EXISTS RECLAMO (
  ID INT PRIMARY KEY,
  CLIENTE_ID VARCHAR(50),
  ORDER_ID INT,
  TIPO VARCHAR(10),
  ESTADO ENUM('Abierto','Cerrado'),
  FOREIGN KEY (CLIENTE_ID) REFERENCES CLIENTE (USER_ID),
  FOREIGN KEY (ORDEN_ID) REFERENCES ORDEN (ORDEN_ID)
);