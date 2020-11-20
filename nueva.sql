-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-11-2020 a las 00:54:27
-- Versión del servidor: 10.4.13-MariaDB
-- Versión de PHP: 7.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `nueva`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `activos` (OUT `a` INT, OUT `b` INT)  BEGIN
	SELECT COUNT(*) INTO a FROM usuarios WHERE estado = 'Activo';
    SELECT COUNT(*) INTO b FROM usuarios WHERE estado = 'Inactivo';
    SELECT a AS Activos, b AS Inactivos;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CUOSER` (OUT `a` INT, OUT `b` INT, OUT `c` INT)  BEGIN
	SELECT COUNT(*) INTO a FROM usuarios WHERE cargo_idcargo = 1;
    SELECT COUNT(*) INTO b FROM usuarios WHERE cargo_idcargo = 2;
    SELECT COUNT(*) INTO c FROM usuarios WHERE cargo_idcargo = 3;
    SELECT a AS UsersAdmin, b AS UsersCocina, c AS UsersZona;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findMerma` (IN `idRest` INT)  BEGIN
	SELECT idmerma, idproducto, nombreProducto, idtipoMerma, tipoMerma, perdida, cantidadMerma, motivoMerma, fechaMerma FROM merma INNER JOIN producto ON merma.producto_idproducto = producto.idproducto INNER JOIN tipomerma ON merma.tipoMerma_idtipoMerma = tipomerma.idtipoMerma WHERE restaurante_idrestaurante = idRest ORDER BY nombreProducto ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findMermaDate` (IN `idRest` INT, IN `fechaIni` DATE, IN `fechaFin` DATE)  BEGIN

SELECT idmerma, idproducto, nombreProducto, idtipoMerma, tipoMerma, perdida, cantidadMerma, motivoMerma, fechaMerma FROM merma INNER JOIN producto ON merma.producto_idproducto = producto.idproducto INNER JOIN tipomerma ON merma.tipoMerma_idtipoMerma = tipomerma.idtipoMerma WHERE restaurante_idrestaurante = idRest AND fechaMerma BETWEEN fechaIni AND fechaFin ORDER BY nombreProducto ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findMermaID` (IN `idRest` INT, IN `id` INT)  BEGIN

SELECT idmerma, nombreProducto, cantidadMerma,perdida, motivoMerma, tipoMerma_idtipoMerma, producto_idproducto FROM merma INNER JOIN producto ON merma.producto_idproducto = producto.idproducto WHERE restaurante_idrestaurante = idRest AND idmerma = id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findProFec` (IN `fechaI` DATE, IN `fechaF` DATE, IN `idres` INT)  NO SQL
SELECT p.nombreProducto,SUM(vhp.cantidadVendida)Total, SUM(vhp.cantProyectada)Totalproy FROM venta INNER JOIN venta_has_producto as vhp ON idventa = venta_idventa AND restaurante_idrestaurante=idres INNER JOIN producto as p ON idproducto=producto_idproducto WHERE fechaVenta BETWEEN fechaI AND fechaF AND proyectadoA BETWEEN (DATE_ADD(fechaI,INTERVAL 7 DAY)) AND (DATE_ADD(fechaF, INTERVAL 7 DAY)) GROUP BY idproducto$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findStock` (IN `idRest` INT)  BEGIN
	SELECT idproducto, nombreProducto, cantidadProducto, fechaVencimiento, lote FROM restaurante_has_producto 		INNER JOIN producto ON restaurante_has_producto.producto_idproducto = producto.idproducto
    WHERE restaurante_idrestaurante = idRest ORDER BY nombreProducto ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findStockID` (IN `id` INT, IN `rest` INT)  BEGIN
	SELECT cantidadProducto, fechaVencimiento, lote, idproducto, nombreProducto FROM restaurante_has_producto INNER JOIN producto ON 					
    restaurante_has_producto.producto_idproducto = producto.idproducto WHERE restaurante_idrestaurante = rest AND producto_idproducto = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findUserID` (IN `id` INT)  BEGIN
	SELECT idusuarios, nombre ,apellido, email, contrasena, estado, idrestaurante, nombreRestaurante, direccionRestaurante, idcargo, nombreCargo from usuarios INNER JOIN restaurante ON usuarios.restaurante_idrestaurante = restaurante.idrestaurante INNER JOIN cargo ON usuarios.cargo_idcargo = cargo.idcargo WHERE idusuarios = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findUsuarios` ()  BEGIN
SELECT idusuarios, nombre, apellido, email, contrasena, estado, cargo.nombreCargo, restaurante.nombreRestaurante FROM usuarios INNER JOIN cargo ON usuarios.cargo_idcargo=cargo.idcargo INNER JOIN restaurante ON usuarios.restaurante_idrestaurante=restaurante.idrestaurante;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almuerzopersonal`
--

CREATE TABLE `almuerzopersonal` (
  `idalmuerzoPersonal` int(11) NOT NULL,
  `fechaAlmuerzo` date NOT NULL,
  `cantidadPersonas` int(11) NOT NULL,
  `restaurante_idrestaurante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `almuerzopersonal`
--

INSERT INTO `almuerzopersonal` (`idalmuerzoPersonal`, `fechaAlmuerzo`, `cantidadPersonas`, `restaurante_idrestaurante`) VALUES
(1, '2020-08-17', 5, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almuerzopersonal_has_producto`
--

CREATE TABLE `almuerzopersonal_has_producto` (
  `almuerzoPersonal_idalmuerzoPersonal` int(11) NOT NULL,
  `producto_idproducto` int(11) NOT NULL,
  `cantidadProducto` int(11) NOT NULL,
  `cantidadIndividual` float NOT NULL,
  `precioProducto` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `almuerzopersonal_has_producto`
--

INSERT INTO `almuerzopersonal_has_producto` (`almuerzoPersonal_idalmuerzoPersonal`, `producto_idproducto`, `cantidadProducto`, `cantidadIndividual`, `precioProducto`) VALUES
(1, 2, 5, 1, 25000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivos`
--

CREATE TABLE `archivos` (
  `idArchivo` int(255) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `document` varchar(100) NOT NULL,
  `idUser` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `archivos`
--

INSERT INTO `archivos` (`idArchivo`, `descripcion`, `document`, `idUser`) VALUES
(8, 'GG', 'CLUB-DEPORTIVO-LA-EQUIDAD.docx', 4),
(13, 'tecno', 'tecnologia_sistemas_abril_2019-convertido.pdf', 1),
(14, 'ficha ', 'chart.pdf', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargo`
--

CREATE TABLE `cargo` (
  `idcargo` int(11) NOT NULL,
  `nombreCargo` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cargo`
--

INSERT INTO `cargo` (`idcargo`, `nombreCargo`) VALUES
(1, 'Administrador'),
(2, 'Jefe de Cocina'),
(3, 'Jefe de Zona');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrega`
--

CREATE TABLE `entrega` (
  `identrega` int(11) NOT NULL,
  `entregaProgramada` tinyint(4) DEFAULT NULL,
  `fechaEntrega` date DEFAULT NULL,
  `pedido_idpedido` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventualidad`
--

CREATE TABLE `eventualidad` (
  `ideventualidad` int(11) NOT NULL,
  `fechaEventualidad` date NOT NULL,
  `descripcionEventualidad` varchar(45) NOT NULL,
  `tipoEvento_idtipoEvento` int(11) NOT NULL,
  `restaurante_idrestaurante` int(11) NOT NULL,
  `menaje_idmenaje` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menaje`
--

CREATE TABLE `menaje` (
  `idmenaje` int(11) NOT NULL,
  `nombreMenaje` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `merma`
--

CREATE TABLE `merma` (
  `idmerma` int(11) NOT NULL,
  `cantidadMerma` int(11) NOT NULL,
  `perdida` float DEFAULT NULL,
  `fechaMerma` date NOT NULL,
  `motivoMerma` varchar(45) NOT NULL,
  `tipoMerma_idtipoMerma` int(11) NOT NULL,
  `restaurante_idrestaurante` int(11) NOT NULL,
  `producto_idproducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `merma`
--

INSERT INTO `merma` (`idmerma`, `cantidadMerma`, `perdida`, `fechaMerma`, `motivoMerma`, `tipoMerma_idtipoMerma`, `restaurante_idrestaurante`, `producto_idproducto`) VALUES
(1, 6, 5700, '2019-09-15', 'Motivo 1', 1, 2, 1),
(2, 4, 4800, '2019-09-16', 'Motivo 2', 1, 2, 2),
(3, 1, 900, '2019-09-15', 'Motivo 3', 1, 2, 4),
(4, 5, 0, '2019-09-18', 'Reutilizado como salsa', 2, 2, 5),
(5, 5, 3500, '2019-09-15', 'Motivo 3', 1, 2, 8),
(10, 2, 0, '2019-09-15', 'fff', 2, 2, 6),
(13, 4, 3000, '2019-09-20', 'vencimiento', 1, 2, 5),
(14, 3, 3600, '2019-09-23', 'ss', 1, 2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `idpedido` int(11) NOT NULL,
  `fechaPedido` date NOT NULL,
  `restaurante_idrestaurante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `pedido`
--

INSERT INTO `pedido` (`idpedido`, `fechaPedido`, `restaurante_idrestaurante`) VALUES
(1, '2019-09-01', 2),
(2, '2019-09-26', 2),
(3, '2020-11-12', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_has_producto`
--

CREATE TABLE `pedido_has_producto` (
  `pedido_idpedido` int(11) NOT NULL,
  `producto_idproducto` int(11) NOT NULL,
  `cantidadProdPed` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `pedido_has_producto`
--

INSERT INTO `pedido_has_producto` (`pedido_idpedido`, `producto_idproducto`, `cantidadProdPed`) VALUES
(1, 1, 2),
(1, 2, 35),
(1, 5, 6),
(3, 2, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `idprestamo` int(11) NOT NULL,
  `fechaPrestamo` date NOT NULL,
  `fechaDevolucion` date DEFAULT NULL,
  `descripcionPrestamo` varchar(100) NOT NULL,
  `menaje_idmenaje` int(11) NOT NULL,
  `restaurante_idrestaurante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idproducto` int(11) NOT NULL,
  `nombreProducto` varchar(45) NOT NULL,
  `precioProducto` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idproducto`, `nombreProducto`, `precioProducto`) VALUES
(1, 'Papa', 700),
(2, 'Tocineta', 5000),
(3, 'Arroz', 1800),
(4, 'Cebolla', 900),
(5, 'Tomate', 750),
(6, 'Frijol', 1300),
(7, 'Carne', 2500),
(8, 'Platano', 700),
(9, 'lechuga', 2000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyeccionventa`
--

CREATE TABLE `proyeccionventa` (
  `idproyeccionVenta` int(11) NOT NULL,
  `fechaProyeccion` date NOT NULL,
  `venta_idventa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyeccionventa_has_producto`
--

CREATE TABLE `proyeccionventa_has_producto` (
  `proyeccionVenta_idproyeccionVenta` int(11) NOT NULL,
  `producto_idproducto` int(11) NOT NULL,
  `cantidadProyectada` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `restaurante`
--

CREATE TABLE `restaurante` (
  `idrestaurante` int(11) NOT NULL,
  `nombreRestaurante` varchar(45) NOT NULL,
  `direccionRestaurante` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `restaurante`
--

INSERT INTO `restaurante` (`idrestaurante`, `nombreRestaurante`, `direccionRestaurante`) VALUES
(1, 'Amistad china', 'Cra. 51 #5224, Itagüi,'),
(2, 'burguer+', 'CR 50'),
(3, 'Domino\'s Pizza', 'Domino\'s Pizza'),
(4, 'Kamaos', 'Cl. 65 #No 46a 04'),
(6, 'Juanjo\'s Parrilla', 'Cra. 48 ##45-39, Itagüi');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `restaurante_has_menaje`
--

CREATE TABLE `restaurante_has_menaje` (
  `restaurante_idrestaurante` int(11) NOT NULL,
  `menaje_idmenaje` int(11) NOT NULL,
  `cantidadMenaje` int(11) NOT NULL,
  `vidaUtil` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `restaurante_has_producto`
--

CREATE TABLE `restaurante_has_producto` (
  `restaurante_idrestaurante` int(11) NOT NULL,
  `producto_idproducto` int(11) NOT NULL,
  `cantidadProducto` int(11) NOT NULL,
  `fechaVencimiento` date NOT NULL,
  `lote` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `restaurante_has_producto`
--

INSERT INTO `restaurante_has_producto` (`restaurante_idrestaurante`, `producto_idproducto`, `cantidadProducto`, `fechaVencimiento`, `lote`) VALUES
(1, 2, 88, '2019-09-30', 748596),
(1, 3, 66, '2019-09-22', 52524),
(1, 4, 33, '2019-09-25', 85962),
(2, 1, 25, '2020-08-21', 251414),
(2, 2, 25, '2019-09-28', 69596),
(2, 3, 91, '2020-12-05', 95623),
(2, 4, 84, '2019-09-27', 475847),
(2, 5, 2, '2020-11-19', 2),
(2, 6, 33, '2019-09-27', 452365),
(2, 7, 50, '2019-09-27', 625362);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoevento`
--

CREATE TABLE `tipoevento` (
  `idtipoEvento` int(11) NOT NULL,
  `tipoEvento` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipomerma`
--

CREATE TABLE `tipomerma` (
  `idtipoMerma` int(11) NOT NULL,
  `tipoMerma` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipomerma`
--

INSERT INTO `tipomerma` (`idtipoMerma`, `tipoMerma`) VALUES
(1, 'Baja'),
(2, 'Reproceso');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuarios` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) NOT NULL,
  `contrasena` varchar(45) NOT NULL,
  `cargo_idcargo` int(11) NOT NULL,
  `restaurante_idrestaurante` int(11) NOT NULL,
  `estado` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuarios`, `nombre`, `apellido`, `contrasena`, `cargo_idcargo`, `restaurante_idrestaurante`, `estado`, `email`) VALUES
(1, 'stephany', 'Otalvaro Rivera', '333', 1, 2, 'Activo', 'Estefa20039@gmail.com'),
(2, 'Diego', 'Gil Rios ', '12345', 2, 2, 'Activo', 'diegogil324@gmail.com'),
(3, 'Jhoan ', 'Agudelo ', '48625', 3, 2, 'Activo', 'johan802010@gmail.com'),
(4, 'Camilo', 'Suarez', '15324', 3, 2, 'Activo', 'casuarez484@misena.edu.co'),
(5, 'Angelica', 'Neiza', '6asd85as', 2, 1, 'Inactivo', 'angelica@gmail.com'),
(6, 'Juan', 'Rendon', '9865847ff', 3, 1, 'Activo', 'juanrendon@gmail.com'),
(7, 'Nicolas', 'Moreno', '584ff854', 2, 1, 'Activo', 'nicolasMoreno@gmail.com'),
(8, 'Andrea', 'Moreno', '584hh854', 3, 1, 'Activo', 'andreaMoreno@gmail.com'),
(9, 'Pepito', 'Perez', '12345', 2, 3, 'Inactivo', 'pepito@gmail.com'),
(10, 'Brayan', 'Sepulveda', '695847', 3, 6, 'Inactivo', 'brayanSepulveda@gmail.com'),
(11, 'Mauricio ', 'Arias', '222', 2, 2, 'Activo', 'mauricio@gmail.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `idventa` int(11) NOT NULL,
  `fechaVenta` date NOT NULL,
  `restaurante_idrestaurante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `venta`
--

INSERT INTO `venta` (`idventa`, `fechaVenta`, `restaurante_idrestaurante`) VALUES
(1, '2019-09-27', 2),
(2, '2019-10-14', 2),
(3, '2020-08-17', 2),
(4, '2020-11-01', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_has_producto`
--

CREATE TABLE `venta_has_producto` (
  `venta_idventa` int(11) NOT NULL,
  `producto_idproducto` int(11) NOT NULL,
  `cantidadVendida` int(11) NOT NULL,
  `proyectadoA` date DEFAULT NULL,
  `cantProyectada` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `venta_has_producto`
--

INSERT INTO `venta_has_producto` (`venta_idventa`, `producto_idproducto`, `cantidadVendida`, `proyectadoA`, `cantProyectada`) VALUES
(1, 1, 12, '2019-10-04', 15),
(1, 4, 15, '2019-10-04', 18),
(1, 5, 8, '2019-10-04', 10),
(1, 6, 10, '2019-10-04', 12),
(2, 3, 8, '2019-10-21', 10),
(2, 6, 5, '2019-10-21', 6);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almuerzopersonal`
--
ALTER TABLE `almuerzopersonal`
  ADD PRIMARY KEY (`idalmuerzoPersonal`),
  ADD KEY `fk_almuerzoPersonal_restaurante1_idx` (`restaurante_idrestaurante`);

--
-- Indices de la tabla `almuerzopersonal_has_producto`
--
ALTER TABLE `almuerzopersonal_has_producto`
  ADD PRIMARY KEY (`almuerzoPersonal_idalmuerzoPersonal`,`producto_idproducto`),
  ADD KEY `fk_almuerzoPersonal_has_producto_producto1_idx` (`producto_idproducto`),
  ADD KEY `fk_almuerzoPersonal_has_producto_almuerzoPersonal1_idx` (`almuerzoPersonal_idalmuerzoPersonal`);

--
-- Indices de la tabla `archivos`
--
ALTER TABLE `archivos`
  ADD PRIMARY KEY (`idArchivo`),
  ADD KEY `fk_usuarios` (`idUser`);

--
-- Indices de la tabla `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`idcargo`);

--
-- Indices de la tabla `entrega`
--
ALTER TABLE `entrega`
  ADD PRIMARY KEY (`identrega`),
  ADD KEY `fk_entrega_pedido1_idx` (`pedido_idpedido`);

--
-- Indices de la tabla `eventualidad`
--
ALTER TABLE `eventualidad`
  ADD PRIMARY KEY (`ideventualidad`),
  ADD KEY `fk_eventualidad_tipoEvento1_idx` (`tipoEvento_idtipoEvento`),
  ADD KEY `fk_eventualidad_restaurante1_idx` (`restaurante_idrestaurante`),
  ADD KEY `fk_eventualidad_menaje1_idx` (`menaje_idmenaje`);

--
-- Indices de la tabla `menaje`
--
ALTER TABLE `menaje`
  ADD PRIMARY KEY (`idmenaje`);

--
-- Indices de la tabla `merma`
--
ALTER TABLE `merma`
  ADD PRIMARY KEY (`idmerma`),
  ADD KEY `fk_merma_tipoMerma1_idx` (`tipoMerma_idtipoMerma`),
  ADD KEY `fk_merma_restaurante1_idx` (`restaurante_idrestaurante`),
  ADD KEY `fk_merma_producto1_idx` (`producto_idproducto`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`idpedido`),
  ADD KEY `fk_pedido_restaurante1_idx` (`restaurante_idrestaurante`);

--
-- Indices de la tabla `pedido_has_producto`
--
ALTER TABLE `pedido_has_producto`
  ADD PRIMARY KEY (`pedido_idpedido`,`producto_idproducto`),
  ADD KEY `fk_pedido_has_producto_producto1_idx` (`producto_idproducto`),
  ADD KEY `fk_pedido_has_producto_pedido1_idx` (`pedido_idpedido`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`idprestamo`),
  ADD KEY `fk_prestamo_menaje1_idx` (`menaje_idmenaje`),
  ADD KEY `fk_prestamo_restaurante1_idx` (`restaurante_idrestaurante`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idproducto`);

--
-- Indices de la tabla `proyeccionventa`
--
ALTER TABLE `proyeccionventa`
  ADD PRIMARY KEY (`idproyeccionVenta`),
  ADD KEY `fk_proyeccionVenta_venta1_idx` (`venta_idventa`);

--
-- Indices de la tabla `proyeccionventa_has_producto`
--
ALTER TABLE `proyeccionventa_has_producto`
  ADD PRIMARY KEY (`proyeccionVenta_idproyeccionVenta`,`producto_idproducto`),
  ADD KEY `fk_proyeccionVenta_has_producto_producto1_idx` (`producto_idproducto`),
  ADD KEY `fk_proyeccionVenta_has_producto_proyeccionVenta1_idx` (`proyeccionVenta_idproyeccionVenta`);

--
-- Indices de la tabla `restaurante`
--
ALTER TABLE `restaurante`
  ADD PRIMARY KEY (`idrestaurante`);

--
-- Indices de la tabla `restaurante_has_menaje`
--
ALTER TABLE `restaurante_has_menaje`
  ADD PRIMARY KEY (`restaurante_idrestaurante`,`menaje_idmenaje`),
  ADD KEY `fk_restaurante_has_menaje_menaje1_idx` (`menaje_idmenaje`),
  ADD KEY `fk_restaurante_has_menaje_restaurante1_idx` (`restaurante_idrestaurante`);

--
-- Indices de la tabla `restaurante_has_producto`
--
ALTER TABLE `restaurante_has_producto`
  ADD PRIMARY KEY (`restaurante_idrestaurante`,`producto_idproducto`),
  ADD KEY `fk_restaurante_has_producto_producto1_idx` (`producto_idproducto`),
  ADD KEY `fk_restaurante_has_producto_restaurante1_idx` (`restaurante_idrestaurante`);

--
-- Indices de la tabla `tipoevento`
--
ALTER TABLE `tipoevento`
  ADD PRIMARY KEY (`idtipoEvento`);

--
-- Indices de la tabla `tipomerma`
--
ALTER TABLE `tipomerma`
  ADD PRIMARY KEY (`idtipoMerma`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuarios`),
  ADD KEY `fk_usuarios_cargo_idx` (`cargo_idcargo`),
  ADD KEY `fk_usuarios_restaurante1_idx` (`restaurante_idrestaurante`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`idventa`),
  ADD KEY `fk_venta_restaurante1_idx` (`restaurante_idrestaurante`);

--
-- Indices de la tabla `venta_has_producto`
--
ALTER TABLE `venta_has_producto`
  ADD PRIMARY KEY (`venta_idventa`,`producto_idproducto`),
  ADD KEY `fk_venta_has_producto_producto1_idx` (`producto_idproducto`),
  ADD KEY `fk_venta_has_producto_venta1_idx` (`venta_idventa`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almuerzopersonal`
--
ALTER TABLE `almuerzopersonal`
  MODIFY `idalmuerzoPersonal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `archivos`
--
ALTER TABLE `archivos`
  MODIFY `idArchivo` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `cargo`
--
ALTER TABLE `cargo`
  MODIFY `idcargo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `entrega`
--
ALTER TABLE `entrega`
  MODIFY `identrega` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `eventualidad`
--
ALTER TABLE `eventualidad`
  MODIFY `ideventualidad` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `menaje`
--
ALTER TABLE `menaje`
  MODIFY `idmenaje` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `merma`
--
ALTER TABLE `merma`
  MODIFY `idmerma` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `idpedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  MODIFY `idprestamo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idproducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `proyeccionventa`
--
ALTER TABLE `proyeccionventa`
  MODIFY `idproyeccionVenta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `restaurante`
--
ALTER TABLE `restaurante`
  MODIFY `idrestaurante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tipoevento`
--
ALTER TABLE `tipoevento`
  MODIFY `idtipoEvento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipomerma`
--
ALTER TABLE `tipomerma`
  MODIFY `idtipoMerma` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuarios` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `venta`
--
ALTER TABLE `venta`
  MODIFY `idventa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `almuerzopersonal`
--
ALTER TABLE `almuerzopersonal`
  ADD CONSTRAINT `fk_almuerzoPersonal_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `almuerzopersonal_has_producto`
--
ALTER TABLE `almuerzopersonal_has_producto`
  ADD CONSTRAINT `fk_almuerzoPersonal_has_producto_almuerzoPersonal1` FOREIGN KEY (`almuerzoPersonal_idalmuerzoPersonal`) REFERENCES `almuerzopersonal` (`idalmuerzoPersonal`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_almuerzoPersonal_has_producto_producto1` FOREIGN KEY (`producto_idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `archivos`
--
ALTER TABLE `archivos`
  ADD CONSTRAINT `fk_usuarios` FOREIGN KEY (`idUser`) REFERENCES `usuarios` (`idusuarios`);

--
-- Filtros para la tabla `entrega`
--
ALTER TABLE `entrega`
  ADD CONSTRAINT `fk_entrega_pedido1` FOREIGN KEY (`pedido_idpedido`) REFERENCES `pedido` (`idpedido`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `eventualidad`
--
ALTER TABLE `eventualidad`
  ADD CONSTRAINT `fk_eventualidad_menaje1` FOREIGN KEY (`menaje_idmenaje`) REFERENCES `menaje` (`idmenaje`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_eventualidad_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_eventualidad_tipoEvento1` FOREIGN KEY (`tipoEvento_idtipoEvento`) REFERENCES `tipoevento` (`idtipoEvento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `merma`
--
ALTER TABLE `merma`
  ADD CONSTRAINT `fk_merma_producto1` FOREIGN KEY (`producto_idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_merma_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_merma_tipoMerma1` FOREIGN KEY (`tipoMerma_idtipoMerma`) REFERENCES `tipomerma` (`idtipoMerma`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `fk_pedido_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedido_has_producto`
--
ALTER TABLE `pedido_has_producto`
  ADD CONSTRAINT `fk_pedido_has_producto_pedido1` FOREIGN KEY (`pedido_idpedido`) REFERENCES `pedido` (`idpedido`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pedido_has_producto_producto1` FOREIGN KEY (`producto_idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `fk_prestamo_menaje1` FOREIGN KEY (`menaje_idmenaje`) REFERENCES `menaje` (`idmenaje`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_prestamo_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `proyeccionventa`
--
ALTER TABLE `proyeccionventa`
  ADD CONSTRAINT `fk_proyeccionVenta_venta1` FOREIGN KEY (`venta_idventa`) REFERENCES `venta` (`idventa`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `proyeccionventa_has_producto`
--
ALTER TABLE `proyeccionventa_has_producto`
  ADD CONSTRAINT `fk_proyeccionVenta_has_producto_producto1` FOREIGN KEY (`producto_idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_proyeccionVenta_has_producto_proyeccionVenta1` FOREIGN KEY (`proyeccionVenta_idproyeccionVenta`) REFERENCES `proyeccionventa` (`idproyeccionVenta`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `restaurante_has_menaje`
--
ALTER TABLE `restaurante_has_menaje`
  ADD CONSTRAINT `fk_restaurante_has_menaje_menaje1` FOREIGN KEY (`menaje_idmenaje`) REFERENCES `menaje` (`idmenaje`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_restaurante_has_menaje_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `restaurante_has_producto`
--
ALTER TABLE `restaurante_has_producto`
  ADD CONSTRAINT `fk_restaurante_has_producto_producto1` FOREIGN KEY (`producto_idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_restaurante_has_producto_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_cargo` FOREIGN KEY (`cargo_idcargo`) REFERENCES `cargo` (`idcargo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuarios_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `fk_venta_restaurante1` FOREIGN KEY (`restaurante_idrestaurante`) REFERENCES `restaurante` (`idrestaurante`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `venta_has_producto`
--
ALTER TABLE `venta_has_producto`
  ADD CONSTRAINT `fk_venta_has_producto_producto1` FOREIGN KEY (`producto_idproducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_venta_has_producto_venta1` FOREIGN KEY (`venta_idventa`) REFERENCES `venta` (`idventa`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
