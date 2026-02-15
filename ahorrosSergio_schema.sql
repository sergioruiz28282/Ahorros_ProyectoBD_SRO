CREATE DATABASE `Ahorros_Sergio` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE DATABASE `Ahorros_Sergio` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `CATEGORIA` (
  `id_categoria` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  `color_icono` varchar(45) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `COMPARA` (
  `id_usuario` int unsigned NOT NULL,
  `id_usuarioComparado` int unsigned NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_usuarioComparado`),
  KEY `id_usuarioComparado` (`id_usuarioComparado`),
  CONSTRAINT `COMPARA_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`),
  CONSTRAINT `COMPARA_ibfk_2` FOREIGN KEY (`id_usuarioComparado`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `CONSEJO` (
  `id_consejo` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `contenido` varchar(250) DEFAULT NULL,
  `idiomas_disponibles` set('es','en','fr','pt','de','it') NOT NULL DEFAULT 'es',
  `id_usuarioPublica` int unsigned NOT NULL,
  PRIMARY KEY (`id_consejo`),
  KEY `fk_CONSEJO_USUARIO` (`id_usuarioPublica`),
  CONSTRAINT `fk_CONSEJO_USUARIO` FOREIGN KEY (`id_usuarioPublica`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `CONSTA_DE` (
  `id_lista` int unsigned NOT NULL,
  `id_categoria` int unsigned NOT NULL,
  PRIMARY KEY (`id_lista`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `CONSTA_DE_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `CATEGORIA` (`id_categoria`),
  CONSTRAINT `CONSTA_DE_ibfk_2` FOREIGN KEY (`id_lista`) REFERENCES `LISTA_PRESUPUESTO` (`id_lista`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `LISTA_PRESUPUESTO` (
  `id_lista` int unsigned NOT NULL AUTO_INCREMENT,
  `cantidad_maxima` decimal(9,2) unsigned DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `id_usuarioRealiza` int unsigned NOT NULL,
  PRIMARY KEY (`id_lista`),
  KEY `fk_LISTA_PRESUPUESTO_USUARIO` (`id_usuarioRealiza`),
  CONSTRAINT `fk_LISTA_PRESUPUESTO_USUARIO` FOREIGN KEY (`id_usuarioRealiza`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `METAS_AHORRO` (
  `id_meta` int unsigned NOT NULL AUTO_INCREMENT,
  `cantidad_ahorrar` decimal(9,2) unsigned DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `cantidad_actual` decimal(9,2) unsigned DEFAULT NULL,
  `estado` enum('activo','pendiente','inactivo') NOT NULL DEFAULT 'inactivo',
  `prioridad` enum('baja','media','alta') NOT NULL DEFAULT 'baja',
  `id_usuarioCreador` int unsigned NOT NULL,
  PRIMARY KEY (`id_meta`),
  KEY `fk_METAS_AHORRO_USUARIO` (`id_usuarioCreador`),
  CONSTRAINT `fk_METAS_AHORRO_USUARIO` FOREIGN KEY (`id_usuarioCreador`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `NOTIFICACIONES` (
  `id_notificacion` int unsigned NOT NULL AUTO_INCREMENT,
  `motivo` varchar(100) DEFAULT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `mensaje` varchar(200) DEFAULT NULL,
  `prioridad` enum('baja','media','alta') NOT NULL DEFAULT 'baja',
  PRIMARY KEY (`id_notificacion`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `PRESENTA` (
  `id_consejo` int unsigned NOT NULL,
  `id_categoria` int unsigned NOT NULL,
  PRIMARY KEY (`id_consejo`,`id_categoria`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `PRESENTA_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `CATEGORIA` (`id_categoria`),
  CONSTRAINT `PRESENTA_ibfk_2` FOREIGN KEY (`id_consejo`) REFERENCES `CONSEJO` (`id_consejo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `RECIBE` (
  `id_usuario` int unsigned NOT NULL,
  `id_notificacion` int unsigned NOT NULL,
  `fecha_notificacion` date NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_notificacion`,`fecha_notificacion`),
  KEY `id_notificacion` (`id_notificacion`),
  CONSTRAINT `RECIBE_ibfk_1` FOREIGN KEY (`id_notificacion`) REFERENCES `NOTIFICACIONES` (`id_notificacion`),
  CONSTRAINT `RECIBE_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `TRANSACCION` (
  `numero_transaccion` int unsigned NOT NULL, 
  `id_usuario` int unsigned NOT NULL,
  `cantidad` decimal(9,2) unsigned DEFAULT NULL,
  `tipo` enum('ingreso','retirada','transferencia') NOT NULL DEFAULT 'ingreso',
  `fecha_transaccion` date NOT NULL,
  `METAS_AHORRO_id_meta` int unsigned NOT NULL,
  PRIMARY KEY (`id_usuario`, `numero_transaccion`), 
  CONSTRAINT `fk_TRANSACCION_USUARIO` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `fk_TRANSACCION_METAS_AHORRO` FOREIGN KEY (`METAS_AHORRO_id_meta`) REFERENCES `METAS_AHORRO` (`id_meta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `USUARIO` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `dni` varchar(100) DEFAULT NULL,
  `nombre_usuario` varchar(100) NOT NULL,
  `contraseña` varchar(120) NOT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `correo` varchar(100) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8mb3;