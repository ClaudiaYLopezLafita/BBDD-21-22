-- DDL: CREACION DE LAS TABLAS.

CREATE DATABASE proyecto;
USE proyecto;

-- proyecto_BBDD.muestra definition

CREATE TABLE muestra (
  id int ,
  name varchar(40) DEFAULT NULL,
  family varchar(27) DEFAULT NULL,
  genus varchar(16) DEFAULT NULL,
  name_scientific varchar(30) DEFAULT NULL,
  classification varchar(9) DEFAULT NULL,
  weight double DEFAULT NULL,
  PRIMARY KEY (id)
);

-- proyecto_BBDD.area definition

CREATE TABLE area (
  ID varchar(8) NOT NULL,
  sampling varchar(10) DEFAULT NULL,
  latitud double DEFAULT NULL,
  longitude double DEFAULT NULL,
  PRIMARY KEY (ID)
);

-- proyecto_BBDD.laboratorio definition

CREATE TABLE laboratorio (
  IdLab int unsigned AUTO_INCREMENT,
  CIF varchar(20) DEFAULT NULL,
  name varchar(100) DEFAULT NULL,
  phone varchar(15) DEFAULT NULL,
  address varchar(100) DEFAULT NULL,
  city varchar(100) DEFAULT NULL,
  region varchar(100) DEFAULT NULL,
  PRIMARY KEY (IdLab)
);

-- proyecto_BBDD.empleado definition

CREATE TABLE empleado (
  id int NOT NULL,
  firts_name varchar(8)  DEFAULT NULL,
  last_name varchar(10) DEFAULT NULL,
  second_last_name varchar(9) DEFAULT NULL,
  phone varchar(10) DEFAULT NULL,
  email varchar(36) DEFAULT NULL,
  postions varchar(7) DEFAULT NULL,
  Id_jefe int DEFAULT NULL,
  Id_laboratorio int unsigned,
  PRIMARY KEY (id) 
);

ALTER TABLE empleado ADD CONSTRAINT fk_emple_jefe FOREIGN KEY (Id_jefe) REFERENCES empleado (id);
ALTER TABLE empleado ADD CONSTRAINT fk_emple_lab FOREIGN KEY (Id_laboratorio) REFERENCES laboratorio (IdLab);

-- proyecto_BBDD.factorAmbiental definition

CREATE TABLE factorAmbiental (
  cod_factor int NOT NULL,
  fType enum ('fisico','quimico'),
  name varchar(16) DEFAULT NULL,
  average decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (cod_factor)
);

-- proyecto_BBDD.area_recolecta_muestra definition

CREATE TABLE area_recolecta_muestra (
  amount int DEFAULT NULL,
  date date DEFAULT NULL,
  id_area varchar(8) NOT NULL,
  id_muestra int NOT NULL,
  PRIMARY KEY (id_muestra,id_area)
);

ALTER TABLE area_recolecta_muestra ADD CONSTRAINT fk_areamuestra FOREIGN KEY (id_muestra) 
REFERENCES muestra (id);
ALTER TABLE area_recolecta_muestra ADD CONSTRAINT fk_area2 FOREIGN KEY (id_area) REFERENCES area(ID);

-- proyecto_BBDD.lab_aporta_muestra definition

CREATE TABLE lab_aporta_muestra (
  number_samples int DEFAULT NULL,
  contribution_date date DEFAULT NULL,
  id_laboratorio int unsigned NOT NULL,
  id_muestra int NOT NULL,
  PRIMARY KEY (id_laboratorio,id_muestra)    
);

ALTER TABLE lab_aporta_muestra ADD CONSTRAINT lab_aporta_muestra_FK 
FOREIGN KEY (id_laboratorio) REFERENCES laboratorio (IdLab);
ALTER TABLE lab_aporta_muestra ADD CONSTRAINT  lab_aporta_muestra_FK_1 
FOREIGN KEY (id_muestra) REFERENCES muestra (id);

-- proyecto_BBDD.analisis_fauna definition
CREATE TABLE analisis_fauna (
  id_muestra int NOT NULL,
  id_factoAmbiental int NOT NULL,
  id_empleado int NOT NULL,
  legth double DEFAULT NULL,
  wins varchar(2) DEFAULT NULL,
  color varchar(16) DEFAULT NULL,
  PRIMARY KEY (id_muestra,id_factoAmbiental,id_empleado)
);

ALTER TABLE analisis_fauna ADD CONSTRAINT analisis_fauna_FK FOREIGN KEY (id_empleado) REFERENCES empleado (id);
ALTER TABLE analisis_fauna ADD CONSTRAINT analisis_fauna_FK_1 
FOREIGN KEY (id_factoAmbiental) REFERENCES factorAmbiental (cod_factor);
ALTER TABLE analisis_fauna ADD CONSTRAINT analisis_fauna_FK_2 FOREIGN KEY (id_muestra) REFERENCES muestra (id);

-- proyecto_BBDD.analisis_flora definition

CREATE TABLE analisis_flora (
  id_muestra int NOT NULL,
  id_factoAmbiental int NOT NULL,
  id_empleado int NOT NULL,
  carotenos enum('baja','media','alta') DEFAULT NULL,
  amilasa enum('si','no') DEFAULT NULL,
  clorofila enum('baja','media','alta') DEFAULT NULL,
  PRIMARY KEY (id_muestra,id_factoAmbiental,id_empleado)
) ;

ALTER TABLE analisis_flora ADD CONSTRAINT analisis_flora_FK FOREIGN KEY (id_empleado) REFERENCES empleado (id);
ALTER TABLE analisis_flora ADD CONSTRAINT analisis_flora_FK_1 FOREIGN KEY (id_factoAmbiental) 
REFERENCES factorAmbiental (cod_factor);
ALTER TABLE analisis_flora ADD CONSTRAINT analisis_flora_FK_2 FOREIGN KEY (id_muestra) REFERENCES muestra (id);








