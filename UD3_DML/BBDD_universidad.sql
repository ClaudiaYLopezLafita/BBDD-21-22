-- MySQL dump 10.13  Distrib 8.0.27, for Linux (x86_64)
--
-- Host: localhost    Database: universidad
-- ------------------------------------------------------
-- Server version	8.0.27-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alumno_se_matricula_asignatura`
--

DROP TABLE IF EXISTS `alumno_se_matricula_asignatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumno_se_matricula_asignatura` (
  `id_alumno` int unsigned NOT NULL,
  `id_asignatura` int unsigned NOT NULL,
  `id_curso_escolar` int unsigned NOT NULL,
  PRIMARY KEY (`id_alumno`,`id_asignatura`,`id_curso_escolar`),
  KEY `id_asignatura` (`id_asignatura`),
  KEY `id_curso_escolar` (`id_curso_escolar`),
  CONSTRAINT `alumno_se_matricula_asignatura_ibfk_1` FOREIGN KEY (`id_alumno`) REFERENCES `persona` (`id`),
  CONSTRAINT `alumno_se_matricula_asignatura_ibfk_2` FOREIGN KEY (`id_asignatura`) REFERENCES `asignatura` (`id`),
  CONSTRAINT `alumno_se_matricula_asignatura_ibfk_3` FOREIGN KEY (`id_curso_escolar`) REFERENCES `curso_escolar` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumno_se_matricula_asignatura`
--

LOCK TABLES `alumno_se_matricula_asignatura` WRITE;
/*!40000 ALTER TABLE `alumno_se_matricula_asignatura` DISABLE KEYS */;
INSERT INTO `alumno_se_matricula_asignatura` VALUES (1,1,1),(2,1,1),(4,1,1),(19,1,5),(23,1,5),(24,1,5),(1,2,1),(2,2,1),(4,2,1),(19,2,5),(23,2,5),(24,2,5),(1,3,1),(2,3,1),(4,3,1),(19,3,5),(23,3,5),(24,3,5),(19,4,5),(23,4,5),(24,4,5),(19,5,5),(23,5,5),(24,5,5),(19,6,5),(23,6,5),(24,6,5),(19,7,5),(23,7,5),(24,7,5),(19,8,5),(23,8,5),(24,8,5),(19,9,5),(23,9,5),(24,9,5),(19,10,5),(23,10,5),(24,10,5);
/*!40000 ALTER TABLE `alumno_se_matricula_asignatura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asignatura`
--

DROP TABLE IF EXISTS `asignatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asignatura` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `creditos` float unsigned NOT NULL,
  `tipo` enum('b??sica','obligatoria','optativa') NOT NULL,
  `curso` tinyint unsigned NOT NULL,
  `cuatrimestre` tinyint unsigned NOT NULL,
  `id_profesor` int unsigned DEFAULT NULL,
  `id_grado` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_profesor` (`id_profesor`),
  KEY `id_grado` (`id_grado`),
  CONSTRAINT `asignatura_ibfk_1` FOREIGN KEY (`id_profesor`) REFERENCES `profesor` (`id_profesor`),
  CONSTRAINT `asignatura_ibfk_2` FOREIGN KEY (`id_grado`) REFERENCES `grado` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignatura`
--

LOCK TABLES `asignatura` WRITE;
/*!40000 ALTER TABLE `asignatura` DISABLE KEYS */;
INSERT INTO `asignatura` VALUES (1,'??lgegra lineal y matem??tica discreta',6,'b??sica',1,1,3,4),(2,'C??lculo',6,'b??sica',1,1,14,4),(3,'F??sica para inform??tica',6,'b??sica',1,1,3,4),(4,'Introducci??n a la programaci??n',6,'b??sica',1,1,14,4),(5,'Organizaci??n y gesti??n de empresas',6,'b??sica',1,1,3,4),(6,'Estad??stica',6,'b??sica',1,2,14,4),(7,'Estructura y tecnolog??a de computadores',6,'b??sica',1,2,3,4),(8,'Fundamentos de electr??nica',6,'b??sica',1,2,14,4),(9,'L??gica y algor??tmica',6,'b??sica',1,2,3,4),(10,'Metodolog??a de la programaci??n',6,'b??sica',1,2,14,4),(11,'Arquitectura de Computadores',6,'b??sica',2,1,3,4),(12,'Estructura de Datos y Algoritmos I',6,'obligatoria',2,1,3,4),(13,'Ingenier??a del Software',6,'obligatoria',2,1,14,4),(14,'Sistemas Inteligentes',6,'obligatoria',2,1,3,4),(15,'Sistemas Operativos',6,'obligatoria',2,1,14,4),(16,'Bases de Datos',6,'b??sica',2,2,14,4),(17,'Estructura de Datos y Algoritmos II',6,'obligatoria',2,2,14,4),(18,'Fundamentos de Redes de Computadores',6,'obligatoria',2,2,3,4),(19,'Planificaci??n y Gesti??n de Proyectos Inform??ticos',6,'obligatoria',2,2,3,4),(20,'Programaci??n de Servicios Software',6,'obligatoria',2,2,14,4),(21,'Desarrollo de interfaces de usuario',6,'obligatoria',3,1,14,4),(22,'Ingenier??a de Requisitos',6,'optativa',3,1,NULL,4),(23,'Integraci??n de las Tecnolog??as de la Informaci??n en las Organizaciones',6,'optativa',3,1,NULL,4),(24,'Modelado y Dise??o del Software 1',6,'optativa',3,1,NULL,4),(25,'Multiprocesadores',6,'optativa',3,1,NULL,4),(26,'Seguridad y cumplimiento normativo',6,'optativa',3,1,NULL,4),(27,'Sistema de Informaci??n para las Organizaciones',6,'optativa',3,1,NULL,4),(28,'Tecnolog??as web',6,'optativa',3,1,NULL,4),(29,'Teor??a de c??digos y criptograf??a',6,'optativa',3,1,NULL,4),(30,'Administraci??n de bases de datos',6,'optativa',3,2,NULL,4),(31,'Herramientas y M??todos de Ingenier??a del Software',6,'optativa',3,2,NULL,4),(32,'Inform??tica industrial y rob??tica',6,'optativa',3,2,NULL,4),(33,'Ingenier??a de Sistemas de Informaci??n',6,'optativa',3,2,NULL,4),(34,'Modelado y Dise??o del Software 2',6,'optativa',3,2,NULL,4),(35,'Negocio Electr??nico',6,'optativa',3,2,NULL,4),(36,'Perif??ricos e interfaces',6,'optativa',3,2,NULL,4),(37,'Sistemas de tiempo real',6,'optativa',3,2,NULL,4),(38,'Tecnolog??as de acceso a red',6,'optativa',3,2,NULL,4),(39,'Tratamiento digital de im??genes',6,'optativa',3,2,NULL,4),(40,'Administraci??n de redes y sistemas operativos',6,'optativa',4,1,NULL,4),(41,'Almacenes de Datos',6,'optativa',4,1,NULL,4),(42,'Fiabilidad y Gesti??n de Riesgos',6,'optativa',4,1,NULL,4),(43,'L??neas de Productos Software',6,'optativa',4,1,NULL,4),(44,'Procesos de Ingenier??a del Software 1',6,'optativa',4,1,NULL,4),(45,'Tecnolog??as multimedia',6,'optativa',4,1,NULL,4),(46,'An??lisis y planificaci??n de las TI',6,'optativa',4,2,NULL,4),(47,'Desarrollo R??pido de Aplicaciones',6,'optativa',4,2,NULL,4),(48,'Gesti??n de la Calidad y de la Innovaci??n Tecnol??gica',6,'optativa',4,2,NULL,4),(49,'Inteligencia del Negocio',6,'optativa',4,2,NULL,4),(50,'Procesos de Ingenier??a del Software 2',6,'optativa',4,2,NULL,4),(51,'Seguridad Inform??tica',6,'optativa',4,2,NULL,4),(52,'Biologia celular',6,'b??sica',1,1,NULL,7),(53,'F??sica',6,'b??sica',1,1,NULL,7),(54,'Matem??ticas I',6,'b??sica',1,1,NULL,7),(55,'Qu??mica general',6,'b??sica',1,1,NULL,7),(56,'Qu??mica org??nica',6,'b??sica',1,1,NULL,7),(57,'Biolog??a vegetal y animal',6,'b??sica',1,2,NULL,7),(58,'Bioqu??mica',6,'b??sica',1,2,NULL,7),(59,'Gen??tica',6,'b??sica',1,2,NULL,7),(60,'Matem??ticas II',6,'b??sica',1,2,NULL,7),(61,'Microbiolog??a',6,'b??sica',1,2,NULL,7),(62,'Bot??nica agr??cola',6,'obligatoria',2,1,NULL,7),(63,'Fisiolog??a vegetal',6,'obligatoria',2,1,NULL,7),(64,'Gen??tica molecular',6,'obligatoria',2,1,NULL,7),(65,'Ingenier??a bioqu??mica',6,'obligatoria',2,1,NULL,7),(66,'Termodin??mica y cin??tica qu??mica aplicada',6,'obligatoria',2,1,NULL,7),(67,'Biorreactores',6,'obligatoria',2,2,NULL,7),(68,'Biotecnolog??a microbiana',6,'obligatoria',2,2,NULL,7),(69,'Ingenier??a gen??tica',6,'obligatoria',2,2,NULL,7),(70,'Inmunolog??a',6,'obligatoria',2,2,NULL,7),(71,'Virolog??a',6,'obligatoria',2,2,NULL,7),(72,'Bases moleculares del desarrollo vegetal',4.5,'obligatoria',3,1,NULL,7),(73,'Fisiolog??a animal',4.5,'obligatoria',3,1,NULL,7),(74,'Metabolismo y bios??ntesis de biomol??culas',6,'obligatoria',3,1,NULL,7),(75,'Operaciones de separaci??n',6,'obligatoria',3,1,NULL,7),(76,'Patolog??a molecular de plantas',4.5,'obligatoria',3,1,NULL,7),(77,'T??cnicas instrumentales b??sicas',4.5,'obligatoria',3,1,NULL,7),(78,'Bioinform??tica',4.5,'obligatoria',3,2,NULL,7),(79,'Biotecnolog??a de los productos hortofrut??culas',4.5,'obligatoria',3,2,NULL,7),(80,'Biotecnolog??a vegetal',6,'obligatoria',3,2,NULL,7),(81,'Gen??mica y prote??mica',4.5,'obligatoria',3,2,NULL,7),(82,'Procesos biotecnol??gicos',6,'obligatoria',3,2,NULL,7),(83,'T??cnicas instrumentales avanzadas',4.5,'obligatoria',3,2,NULL,7);
/*!40000 ALTER TABLE `asignatura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curso_escolar`
--

DROP TABLE IF EXISTS `curso_escolar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curso_escolar` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `anyo_inicio` year NOT NULL,
  `anyo_fin` year NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curso_escolar`
--

LOCK TABLES `curso_escolar` WRITE;
/*!40000 ALTER TABLE `curso_escolar` DISABLE KEYS */;
INSERT INTO `curso_escolar` VALUES (1,2014,2015),(2,2015,2016),(3,2016,2017),(4,2017,2018),(5,2018,2019);
/*!40000 ALTER TABLE `curso_escolar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departamento`
--

DROP TABLE IF EXISTS `departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departamento` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departamento`
--

LOCK TABLES `departamento` WRITE;
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
INSERT INTO `departamento` VALUES (1,'Inform??tica'),(2,'Matem??ticas'),(3,'Econom??a y Empresa'),(4,'Educaci??n'),(5,'Agronom??a'),(6,'Qu??mica y F??sica'),(7,'Filolog??a'),(8,'Derecho'),(9,'Biolog??a y Geolog??a');
/*!40000 ALTER TABLE `departamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grado`
--

DROP TABLE IF EXISTS `grado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grado` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grado`
--

LOCK TABLES `grado` WRITE;
/*!40000 ALTER TABLE `grado` DISABLE KEYS */;
INSERT INTO `grado` VALUES (1,'Grado en Ingenier??a Agr??cola (Plan 2015)'),(2,'Grado en Ingenier??a El??ctrica (Plan 2014)'),(3,'Grado en Ingenier??a Electr??nica Industrial (Plan 2010)'),(4,'Grado en Ingenier??a Inform??tica (Plan 2015)'),(5,'Grado en Ingenier??a Mec??nica (Plan 2010)'),(6,'Grado en Ingenier??a Qu??mica Industrial (Plan 2010)'),(7,'Grado en Biotecnolog??a (Plan 2015)'),(8,'Grado en Ciencias Ambientales (Plan 2009)'),(9,'Grado en Matem??ticas (Plan 2010)'),(10,'Grado en Qu??mica (Plan 2009)');
/*!40000 ALTER TABLE `grado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persona`
--

DROP TABLE IF EXISTS `persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persona` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `nif` varchar(9) DEFAULT NULL,
  `nombre` varchar(25) NOT NULL,
  `apellido1` varchar(50) NOT NULL,
  `apellido2` varchar(50) DEFAULT NULL,
  `ciudad` varchar(25) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `telefono` varchar(9) DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `sexo` enum('H','M') NOT NULL,
  `tipo` enum('profesor','alumno') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nif` (`nif`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persona`
--

LOCK TABLES `persona` WRITE;
/*!40000 ALTER TABLE `persona` DISABLE KEYS */;
INSERT INTO `persona` VALUES (1,'26902806M','Salvador','S??nchez','P??rez','Almer??a','C/ Real del barrio alto','950254837','1991-03-28','H','alumno'),(2,'89542419S','Juan','Saez','Vega','Almer??a','C/ Mercurio','618253876','1992-08-08','H','alumno'),(3,'11105554G','Zoe','Ramirez','Gea','Almer??a','C/ Marte','618223876','1979-08-19','M','profesor'),(4,'17105885A','Pedro','Heller','Pagac','Almer??a','C/ Estrella fugaz',NULL,'2000-10-05','H','alumno'),(5,'38223286T','David','Schmidt','Fisher','Almer??a','C/ Venus','678516294','1978-01-19','H','profesor'),(6,'04233869Y','Jos??','Koss','Bayer','Almer??a','C/ J??piter','628349590','1998-01-28','H','alumno'),(7,'97258166K','Ismael','Strosin','Turcotte','Almer??a','C/ Neptuno',NULL,'1999-05-24','H','alumno'),(8,'79503962T','Cristina','Lemke','Rutherford','Almer??a','C/ Saturno','669162534','1977-08-21','M','profesor'),(9,'82842571K','Ram??n','Herzog','Tremblay','Almer??a','C/ Urano','626351429','1996-11-21','H','alumno'),(10,'61142000L','Esther','Spencer','Lakin','Almer??a','C/ Plut??n',NULL,'1977-05-19','M','profesor'),(11,'46900725E','Daniel','Herman','Pacocha','Almer??a','C/ Andarax','679837625','1997-04-26','H','alumno'),(12,'85366986W','Carmen','Streich','Hirthe','Almer??a','C/ Almanzora',NULL,'1971-04-29','M','profesor'),(13,'73571384L','Alfredo','Stiedemann','Morissette','Almer??a','C/ Guadalquivir','950896725','1980-02-01','H','profesor'),(14,'82937751G','Manolo','Hamill','Kozey','Almer??a','C/ Duero','950263514','1977-01-02','H','profesor'),(15,'80502866Z','Alejandro','Kohler','Schoen','Almer??a','C/ Tajo','668726354','1980-03-14','H','profesor'),(16,'10485008K','Antonio','Fahey','Considine','Almer??a','C/ Sierra de los Filabres',NULL,'1982-03-18','H','profesor'),(17,'85869555K','Guillermo','Ruecker','Upton','Almer??a','C/ Sierra de G??dor',NULL,'1973-05-05','H','profesor'),(18,'04326833G','Micaela','Monahan','Murray','Almer??a','C/ Veleta','662765413','1976-02-25','H','profesor'),(19,'11578526G','Inma','Lakin','Yundt','Almer??a','C/ Picos de Europa','678652431','1998-09-01','M','alumno'),(20,'79221403L','Francesca','Schowalter','Muller','Almer??a','C/ Quinto pino',NULL,'1980-10-31','H','profesor'),(21,'79089577Y','Juan','Guti??rrez','L??pez','Almer??a','C/ Los pinos','678652431','1998-01-01','H','alumno'),(22,'41491230N','Antonio','Dom??nguez','Guerrero','Almer??a','C/ Cabo de Gata','626652498','1999-02-11','H','alumno'),(23,'64753215G','Irene','Hern??ndez','Mart??nez','Almer??a','C/ Zapillo','628452384','1996-03-12','M','alumno'),(24,'85135690V','Sonia','Gea','Ruiz','Almer??a','C/ Mercurio','678812017','1995-04-13','M','alumno');
/*!40000 ALTER TABLE `persona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profesor`
--

DROP TABLE IF EXISTS `profesor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profesor` (
  `id_profesor` int unsigned NOT NULL,
  `id_departamento` int unsigned NOT NULL,
  PRIMARY KEY (`id_profesor`),
  KEY `id_departamento` (`id_departamento`),
  CONSTRAINT `profesor_ibfk_1` FOREIGN KEY (`id_profesor`) REFERENCES `persona` (`id`),
  CONSTRAINT `profesor_ibfk_2` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profesor`
--

LOCK TABLES `profesor` WRITE;
/*!40000 ALTER TABLE `profesor` DISABLE KEYS */;
INSERT INTO `profesor` VALUES (3,1),(14,1),(5,2),(15,2),(8,3),(16,3),(10,4),(12,4),(17,4),(18,5),(13,6),(20,6);
/*!40000 ALTER TABLE `profesor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-20 10:31:43
