DROP DATABASE IF EXISTS sistema_inventario;
CREATE database sistema_inventario  CHARACTER SET 'UTF8' COLLATE 'utf8_general_ci';
use sistema_inventario;

CREATE TABLE persona(
    ci VARCHAR(13) NOT NULL primary key,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    estado CHAR(1) NOT NULL,
    dirrecion VARCHAR(512) NOT NULL,
    telefono VARCHAR(12) NULL,
    celular VARCHAR(10) NOT NULL
);
CREATE TABLE acceso_user(
    id_acceso_user int AUTO_INCREMENT primary key,
    id VARCHAR(20) NOT NULL,
    contrasena VARCHAR(350) NOT NULL,
    estado CHAR(1) NOT NULL,
    ci VARCHAR(50),
    FOREIGN KEY (ci) REFERENCES persona(ci)
);

CREATE TABLE proveedor(
    id_proveedor  int AUTO_INCREMENT primary key,
    nombre VARCHAR(350) NOT NULL,
    dirrecion VARCHAR(350) NOT NULL,
    telefono VARCHAR(350) NOT NULL,
    estado char(1) NOT NULL
);
CREATE TABLE entrada(
    id_entrada  int AUTO_INCREMENT primary key,
    fecha DATETIME NOT NULL,
    cantidad int NOT NULL,
    id_proveedor int NOT NULL,
    id_acceso_user int NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_acceso_user) REFERENCES acceso_user(id_acceso_user)
);
CREATE TABLE categoria(
    id_categoria int AUTO_INCREMENT primary key,
    descripcion VARCHAR(350) NOT NULL,
    estado char(1)
);
CREATE TABLE producto(
    id_producto  int AUTO_INCREMENT primary key,
    nombre VARCHAR(350) NOT NULL,
    descripcion VARCHAR(350) NOT NULL,
    estado char(1) NOT NULL,
    id_categoria int NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);
CREATE TABLE detalle(
    id_detalle int AUTO_INCREMENT,
    cantidad int NOT NULL,
    precio_unitario double NOT NULL,
    precio_total double NOT NULL,
    id_producto int NOT NULL,
    id_entrada int NOT NULL,
    primary key(id_detalle,id_entrada),
    FOREIGN KEY (id_entrada) REFERENCES entrada(id_entrada),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
CREATE TABLE stock(
    descripcion VARCHAR(350) NOT NULL,
    cantidad int NOT NULL,
    estado char(1) NOT NULL,
    id_producto int AUTO_INCREMENT primary key
);
CREATE TABLE cliente(
    id_cliente int AUTO_INCREMENT primary key,
    ci VARCHAR(13) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    celular VARCHAR(10) NOT NULL,
    estado CHAR(1) NOT NULL
);
CREATE TABLE venta(
    id_venta int AUTO_INCREMENT primary key,
    fecha DATETIME NOT NULL,
    precio_unitario double NOT NULL,
    precio_total double NOT NULL,
    estado CHAR(1),
    id_cliente int NOT NULL,
    id_acceso_user int NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_acceso_user) REFERENCES acceso_user(id_acceso_user)
);
CREATE TABLE producto_venta(
    cantidad int NOT NULL,
    id_venta int NOT NULL,
    id_producto int NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta)
);
CREATE TABLE recibo(
    nit VARCHAR(50) NULL,
    codigo_control VARCHAR(50) NOT NULL,
    id_venta int,
    primary key(id_venta),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta)
);



DROP PROCEDURE IF EXISTS añadir_usuario;
 DELIMITER //
  CREATE PROCEDURE añadir_usuario(
      in ci VARCHAR(13),
      nombre VARCHAR(50),
      apellido VARCHAR(50),
      dirrecion VARCHAR(512),
      telefono VARCHAR(12),
      celular VARCHAR(10),
      id VARCHAR(20),
      contrasena VARCHAR(350))
 BEGIN
  DECLARE verificar varchar(50);
  /*SELECT ci,nombre,apellido,dirrecion,telefono,celular,id,contrasena;*/
  SET verificar = (SELECT persona.ci FROM persona WHERE persona.ci=ci LIMIT 1);
  /*SELECT verificar;*/
  IF verificar IS NULL THEN
    INSERT INTO persona(
        ci,
        nombre,
        apellido,
        dirrecion,
        telefono,
        celular,
        estado
        ) VALUES(
            ci,
            nombre,
            apellido,
            dirrecion,
            telefono,
            celular,
            '1'
        );
    INSERT INTO acceso_user(
        id,
        contrasena,
        estado,
        ci
        ) VALUES(
            id,
            contrasena,
            '1',
            ci);
    SET verificar ='usuario registrado';
  ELSE
   SET verificar ='ci ya existe';
  END IF;
  SELECT verificar;
  END //

call añadir_usuario("8966478","ali stiven","lovera","barrio toborochi","","7569755","alistiven","12345");
/*proveedor*/
INSERT INTO proveedor( nombre, dirrecion, telefono, estado) VALUES ("importadora seracruz"," por ahi","5555555","1");
/*categoria*/
INSERT INTO categoria(descripcion,estado) VALUES ("bebidas","1");
/*productos*/
INSERT INTO producto(nombre,descripcion,estado,id_categoria) VALUES ("coca cola","retornable de 2.5lt","1","1");
INSERT INTO producto(nombre,descripcion,estado,id_categoria) VALUES ("sprite","retornable de 2.5lt","1","1");
INSERT INTO producto(nombre,descripcion,estado,id_categoria) VALUES ("fanta","retornable de 2.5lt","1","1");
/*entrada*/
INSERT INTO entrada(fecha,cantidad,id_proveedor,id_acceso_user) VALUES (NOW(),"3","1","1");
/*detalle entrada*/
INSERT INTO detalle(cantidad,precio_unitario,precio_total,id_producto,id_entrada) VALUES ("50","7","350","1","1");
INSERT INTO detalle(cantidad,precio_unitario,precio_total,id_producto,id_entrada) VALUES ("50","7","350","2","1");
INSERT INTO detalle(cantidad,precio_unitario,precio_total,id_producto,id_entrada) VALUES ("50","7","350","3","1");



SELECT entrada.fecha as fecha_entrada, producto.nombre,producto.descripcion,detalle.precio_unitario,detalle.cantidad FROM entrada inner JOIN detalle inner JOIN producto on entrada.id_entrada=detalle.id_entrada and detalle.id_producto=producto.id_producto  


