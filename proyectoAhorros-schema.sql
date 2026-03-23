CREATE DATABASE `Ahorros_Sergio` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE DATABASE `Ahorros_Sergio` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `CATEGORIA` (
  `id_categoria` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) DEFAULT NULL,
  `color_icono` varchar(45) DEFAULT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `COMPARA` (
  `id_usuario` int unsigned NOT NULL,
  `id_usuarioComparado` int unsigned NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_usuarioComparado`),
  KEY `fk_COMPARA_U2` (`id_usuarioComparado`),
  CONSTRAINT `fk_COMPARA_U1` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_COMPARA_U2` FOREIGN KEY (`id_usuarioComparado`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `CONSEJO` (
  `id_consejo` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `contenido` varchar(250) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `idiomas_disponibles` set('es','en','fr','pt','de','it') NOT NULL DEFAULT 'es',
  `id_usuarioPublica` int unsigned NOT NULL,
  PRIMARY KEY (`id_consejo`),
  KEY `fk_CONSEJO_USUARIO` (`id_usuarioPublica`),
  CONSTRAINT `fk_CONSEJO_USUARIO` FOREIGN KEY (`id_usuarioPublica`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=504 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `CONSTA_DE` (
  `id_lista` int unsigned NOT NULL,
  `id_categoria` int unsigned NOT NULL,
  PRIMARY KEY (`id_lista`,`id_categoria`),
  KEY `fk_CONSTA_DE_CAT` (`id_categoria`),
  CONSTRAINT `fk_CONSTA_DE_CAT` FOREIGN KEY (`id_categoria`) REFERENCES `CATEGORIA` (`id_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_CONSTA_DE_LISTA` FOREIGN KEY (`id_lista`) REFERENCES `LISTA_PRESUPUESTO` (`id_lista`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `LISTA_PRESUPUESTO` (
  `id_lista` int unsigned NOT NULL AUTO_INCREMENT,
  `cantidad_maxima` decimal(9,2) unsigned DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `id_usuarioRealiza` int unsigned NOT NULL,
  PRIMARY KEY (`id_lista`),
  KEY `fk_LISTA_PRESUPUESTO_USUARIO` (`id_usuarioRealiza`),
  CONSTRAINT `fk_LISTA_PRESUPUESTO_USUARIO` FOREIGN KEY (`id_usuarioRealiza`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=900 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `METAS_AHORRO` (
  `id_meta` int unsigned NOT NULL AUTO_INCREMENT,
  `cantidad_ahorrar` decimal(15,2) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `cantidad_actual` decimal(15,2) DEFAULT NULL,
  `estado` enum('activo','pendiente','inactivo','acabado') DEFAULT 'activo',
  `prioridad` enum('baja','media','alta') NOT NULL DEFAULT 'baja',
  `id_usuarioCreador` int unsigned NOT NULL,
  PRIMARY KEY (`id_meta`),
  KEY `fk_METAS_AHORRO_USUARIO` (`id_usuarioCreador`),
  CONSTRAINT `fk_METAS_AHORRO_USUARIO` FOREIGN KEY (`id_usuarioCreador`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `NOTIFICACIONES` (
  `id_notificacion` int unsigned NOT NULL AUTO_INCREMENT,
  `motivo` varchar(100) DEFAULT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `prioridad` enum('baja','media','alta') NOT NULL DEFAULT 'baja',
  `mensaje` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id_notificacion`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `PRESENTA` (
  `id_consejo` int unsigned NOT NULL,
  `id_categoria` int unsigned NOT NULL,
  PRIMARY KEY (`id_consejo`,`id_categoria`),
  KEY `fk_PRESENTA_CAT` (`id_categoria`),
  CONSTRAINT `fk_PRESENTA_CAT` FOREIGN KEY (`id_categoria`) REFERENCES `CATEGORIA` (`id_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_PRESENTA_CONSEJO` FOREIGN KEY (`id_consejo`) REFERENCES `CONSEJO` (`id_consejo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `RECIBE` (
  `id_usuario` int unsigned NOT NULL,
  `id_notificacion` int unsigned NOT NULL,
  `fecha_notificacion` date NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_notificacion`,`fecha_notificacion`),
  KEY `fk_RECIBE_NOTIF` (`id_notificacion`),
  CONSTRAINT `fk_RECIBE_NOTIF` FOREIGN KEY (`id_notificacion`) REFERENCES `NOTIFICACIONES` (`id_notificacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_RECIBE_USUARIO` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `TRANSACCION` (
  `numero_transaccion` int unsigned NOT NULL,
  `id_usuario` int unsigned NOT NULL,
  `id_meta` int unsigned NOT NULL,
  `cantidad` decimal(15,2) DEFAULT NULL,
  `tipo` enum('ingreso','retirada','transferencia') NOT NULL DEFAULT 'ingreso',
  `fecha_transaccion` date NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_meta`,`numero_transaccion`),
  KEY `fk_TRANSACCION_METAS_AHORRO` (`id_meta`),
  CONSTRAINT `fk_TRANSACCION_METAS_AHORRO` FOREIGN KEY (`id_meta`) REFERENCES `METAS_AHORRO` (`id_meta`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_TRANSACCION_USUARIO` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `USUARIO` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `dni` varchar(100) DEFAULT NULL,
  `nombre_usuario` varchar(100) NOT NULL,
  `contrasenia` varchar(120) NOT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `correo` varchar(100) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `top_ganadores` (
  `id_usuario` int NOT NULL,
  `metas_acabadas` int NOT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `usuarios_metasAcabadas` (
  `id_logro` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int unsigned NOT NULL,
  `idMeta` int unsigned NOT NULL,
  `cantidadF` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id_logro`),
  UNIQUE KEY `idMeta` (`idMeta`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;