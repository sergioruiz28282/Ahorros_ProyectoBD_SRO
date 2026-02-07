CREATE DATABASE `Ahorros_sergio` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE DATABASE `Ahorros_sergio` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `CATEGORIA` (
  `id_categoria` int NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `color_icono` varchar(45) DEFAULT NULL,
  `descripción` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `COMPARA` (
  `id_usuario` int NOT NULL,
  `id_usuarioComparado` int NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_usuarioComparado`),
  KEY `fk_USUARIO_has_USUARIO_USUARIO1_idx` (`id_usuarioComparado`),
  KEY `fk_USUARIO_has_USUARIO_USUARIO_idx` (`id_usuario`),
  CONSTRAINT `fk_USUARIO_has_USUARIO_USUARIO` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`),
  CONSTRAINT `fk_USUARIO_has_USUARIO_USUARIO1` FOREIGN KEY (`id_usuarioComparado`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `CONSEJO` (
  `id_consejo` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `descripción` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `contenido` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `idiomas_disponibles` set('es','en','fr','pt','de','it') NOT NULL DEFAULT 'es',
  `id_usuarioPublica` int NOT NULL,
  PRIMARY KEY (`id_consejo`),
  KEY `fk_CONSEJO_USUARIO1_idx` (`id_usuarioPublica`),
  CONSTRAINT `fk_CONSEJO_USUARIO1` FOREIGN KEY (`id_usuarioPublica`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `CONSTA_DE` (
  `id_lista` int NOT NULL,
  `id_categoria` int NOT NULL,
  PRIMARY KEY (`id_lista`,`id_categoria`),
  KEY `fk_LISTA_PRESUPUESTO_has_CATEGORÍA_CATEGORÍA1_idx` (`id_categoria`),
  KEY `fk_LISTA_PRESUPUESTO_has_CATEGORÍA_LISTA_PRESUPUESTO1_idx` (`id_lista`),
  CONSTRAINT `fk_LISTA_PRESUPUESTO_has_CATEGORÍA_CATEGORÍA1` FOREIGN KEY (`id_categoria`) REFERENCES `CATEGORIA` (`id_categoria`),
  CONSTRAINT `fk_LISTA_PRESUPUESTO_has_CATEGORÍA_LISTA_PRESUPUESTO1` FOREIGN KEY (`id_lista`) REFERENCES `LISTA_PRESUPUESTO` (`id_lista`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `LISTA_PRESUPUESTO` (
  `id_lista` int NOT NULL,
  `cantidad_maxima` decimal(9,2) DEFAULT NULL,
  `descripcion` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `id_usuarioRealiza` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_lista`),
  KEY `fk_LISTA_PRESUPUESTO_USUARIO1_idx` (`id_usuarioRealiza`),
  CONSTRAINT `fk_LISTA_PRESUPUESTO_USUARIO1` FOREIGN KEY (`id_usuarioRealiza`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `METAS_AHORRO` (
  `id_meta` int NOT NULL,
  `cantidad_ahorrar` decimal(7,2) DEFAULT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cantidad_actual` decimal(7,2) DEFAULT NULL,
  `estado` enum('activo','pendiente','inactivo') NOT NULL DEFAULT 'inactivo',
  `prioridad` enum('baja','media','alta') NOT NULL DEFAULT 'baja',
  `id_usuarioCreador` int NOT NULL,
  PRIMARY KEY (`id_meta`),
  KEY `fk_METAS_AHORRO_USUARIO1_idx` (`id_usuarioCreador`),
  CONSTRAINT `fk_METAS_AHORRO_USUARIO1` FOREIGN KEY (`id_usuarioCreador`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `NOTIFICACIONES` (
  `id_notificacion` int NOT NULL,
  `motivo` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `titulo` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `mensaje` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `prioridad` enum('baja','media','alta') NOT NULL DEFAULT 'baja',
  PRIMARY KEY (`id_notificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `PRESENTA` (
  `id_consejo` int NOT NULL,
  `id_categoria` int NOT NULL,
  PRIMARY KEY (`id_consejo`,`id_categoria`),
  KEY `fk_CONSEJO_has_CATEGORÍA_CATEGORÍA1_idx` (`id_categoria`),
  KEY `fk_CONSEJO_has_CATEGORÍA_CONSEJO1_idx` (`id_consejo`),
  CONSTRAINT `fk_CONSEJO_has_CATEGORÍA_CATEGORÍA1` FOREIGN KEY (`id_categoria`) REFERENCES `CATEGORIA` (`id_categoria`),
  CONSTRAINT `fk_CONSEJO_has_CATEGORÍA_CONSEJO1` FOREIGN KEY (`id_consejo`) REFERENCES `CONSEJO` (`id_consejo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `RECIBE` (
  `id_usuario` int NOT NULL,
  `id_notificacion` int NOT NULL,
  `fecha_notificacion` date NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_notificacion`,`fecha_notificacion`),
  KEY `fk_USUARIO_has_NOTIFICACIONES_NOTIFICACIONES1_idx` (`id_notificacion`),
  KEY `fk_USUARIO_has_NOTIFICACIONES_USUARIO1_idx` (`id_usuario`),
  CONSTRAINT `fk_USUARIO_has_NOTIFICACIONES_NOTIFICACIONES1` FOREIGN KEY (`id_notificacion`) REFERENCES `NOTIFICACIONES` (`id_notificacion`),
  CONSTRAINT `fk_USUARIO_has_NOTIFICACIONES_USUARIO1` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `TRANSACCION` (
  `numero_transaccion` int NOT NULL,
  `cantidad` decimal(9,2) DEFAULT NULL,
  `tipo` enum('compra','venta','transferencia') NOT NULL DEFAULT 'compra',
  `fecha_transaccion` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `METAS_AHORRO_id_meta` int NOT NULL,
  `id_usuario` int NOT NULL,
  PRIMARY KEY (`numero_transaccion`,`id_usuario`),
  KEY `fk_TRANSACCION_METAS_AHORRO1_idx` (`METAS_AHORRO_id_meta`),
  KEY `fk_TRANSACCION_USUARIO1_idx` (`id_usuario`),
  CONSTRAINT `fk_TRANSACCION_METAS_AHORRO1` FOREIGN KEY (`METAS_AHORRO_id_meta`) REFERENCES `METAS_AHORRO` (`id_meta`),
  CONSTRAINT `fk_TRANSACCION_USUARIO1` FOREIGN KEY (`id_usuario`) REFERENCES `USUARIO` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `USUARIO` (
  `id_usuario` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `apellidos` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `dni` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `nombre_usuario` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `contraseña` varchar(120) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `país` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `correo` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;