-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 21, 2019 at 11:26 AM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `DatabaseProject`
--

-- --------------------------------------------------------

--
-- Table structure for table `Buyer`
--

CREATE TABLE `Buyer` (
  `BuyerID` int(3) NOT NULL,
  `Card` varchar(30) DEFAULT NULL,
  `ExpiryDate` date DEFAULT NULL,
  `SecurityCode` varchar(20) DEFAULT NULL,
  `cardType` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Buyer`
--

INSERT INTO `Buyer` (`BuyerID`, `Card`, `ExpiryDate`, `SecurityCode`, `cardType`) VALUES
(1, 'MTIzNDU2Nzg5', '2020-02-02', 'MTIz', 'Visa');

-- --------------------------------------------------------

--
-- Table structure for table `CartProducts`
--

CREATE TABLE `CartProducts` (
  `CartNo` int(3) NOT NULL,
  `StoreNumber` int(3) NOT NULL,
  `ProductNo` int(3) NOT NULL,
  `Quantity` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Stand-in structure for view `carttotalview`
-- (See below for the actual view)
--
CREATE TABLE `carttotalview` (
`CartNo` int(3)
,`Total` double
);

-- --------------------------------------------------------

--
-- Table structure for table `Order`
--

CREATE TABLE `Order` (
  `OrderID` int(3) NOT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `BuyerN` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Order`
--

INSERT INTO `Order` (`OrderID`, `Status`, `BuyerN`) VALUES
(1, 'New', 1);

-- --------------------------------------------------------

--
-- Table structure for table `OrderProducts`
--

CREATE TABLE `OrderProducts` (
  `OrderNo` int(3) NOT NULL,
  `ProductN` int(3) NOT NULL,
  `storeNumber` int(3) NOT NULL,
  `QuantityOrdered` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `OrderProducts`
--

INSERT INTO `OrderProducts` (`OrderNo`, `ProductN`, `storeNumber`, `QuantityOrdered`) VALUES
(1, 0, 1, 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ordertotalview`
-- (See below for the actual view)
--
CREATE TABLE `ordertotalview` (
`OrderID` int(3)
,`Total` double
);

-- --------------------------------------------------------

--
-- Table structure for table `Product`
--

CREATE TABLE `Product` (
  `storeNum` int(3) NOT NULL,
  `ProductID` int(3) NOT NULL,
  `ProductName` varchar(30) NOT NULL,
  `Price` varchar(10) NOT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `Stock` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Product`
--

INSERT INTO `Product` (`storeNum`, `ProductID`, `ProductName`, `Price`, `Description`, `Stock`) VALUES
(1, 0, 'Shoes', '12.99', 'Brown boots', 2);

-- --------------------------------------------------------

--
-- Table structure for table `StoreCat`
--

CREATE TABLE `StoreCat` (
  `storeNo` int(3) NOT NULL,
  `Category` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `StoreCat`
--

INSERT INTO `StoreCat` (`storeNo`, `Category`) VALUES
(1, 'Fashion, Accessories');

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE `User` (
  `FName` varchar(10) NOT NULL,
  `LName` varchar(10) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Password` varchar(100) NOT NULL,
  `Address` varchar(100) DEFAULT NULL,
  `BuyerNum` int(3) DEFAULT NULL,
  `SellerNum` int(3) DEFAULT NULL,
  `StoreName` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`FName`, `LName`, `Email`, `Phone`, `Password`, `Address`, `BuyerNum`, `SellerNum`, `StoreName`) VALUES
('Malik', 'Sadek', 'malaksadek@aucegypt.edu', '01115465467', 'bWxrbWxr', 'Maadi', 1, 1, 'MalaksFashion');

-- --------------------------------------------------------

--
-- Structure for view `carttotalview`
--
DROP TABLE IF EXISTS `carttotalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `databaseproject`.`carttotalview`  AS  (select `databaseproject`.`cartproducts`.`CartNo` AS `CartNo`,(select sum(((select `databaseproject`.`product`.`Price` from DUAL  where (`databaseproject`.`cartproducts`.`ProductNo` = `databaseproject`.`product`.`ProductID`)) * (select `databaseproject`.`cartproducts`.`Quantity` from DUAL  where (`databaseproject`.`cartproducts`.`ProductNo` = `databaseproject`.`product`.`ProductID`))))) AS `Total` from (`databaseproject`.`cartproducts` join `databaseproject`.`product`) group by `databaseproject`.`cartproducts`.`CartNo`) ;

-- --------------------------------------------------------

--
-- Structure for view `ordertotalview`
--
DROP TABLE IF EXISTS `ordertotalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `databaseproject`.`ordertotalview`  AS  (select `databaseproject`.`orderproducts`.`OrderNo` AS `OrderID`,(select sum(((select `databaseproject`.`product`.`Price` from DUAL  where (`databaseproject`.`orderproducts`.`ProductN` = `databaseproject`.`product`.`ProductID`)) * (select `databaseproject`.`orderproducts`.`QuantityOrdered` from DUAL  where (`databaseproject`.`orderproducts`.`ProductN` = `databaseproject`.`product`.`ProductID`))))) AS `Total` from (`databaseproject`.`orderproducts` join `databaseproject`.`product`) group by `databaseproject`.`orderproducts`.`OrderNo`) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Buyer`
--
ALTER TABLE `Buyer`
  ADD PRIMARY KEY (`BuyerID`),
  ADD UNIQUE KEY `Buyer_Card_uk` (`Card`);

--
-- Indexes for table `CartProducts`
--
ALTER TABLE `CartProducts`
  ADD PRIMARY KEY (`CartNo`,`StoreNumber`,`ProductNo`),
  ADD KEY `CartProducts_StoreNumberAndProductNo_fk` (`StoreNumber`,`ProductNo`);

--
-- Indexes for table `Order`
--
ALTER TABLE `Order`
  ADD PRIMARY KEY (`OrderID`),
  ADD KEY `Order_BuyerNum_fk` (`BuyerN`);

--
-- Indexes for table `OrderProducts`
--
ALTER TABLE `OrderProducts`
  ADD PRIMARY KEY (`OrderNo`,`storeNumber`,`ProductN`),
  ADD KEY `OrderProducts_ProductN_fk` (`storeNumber`,`ProductN`);

--
-- Indexes for table `Product`
--
ALTER TABLE `Product`
  ADD PRIMARY KEY (`storeNum`,`ProductID`);

--
-- Indexes for table `StoreCat`
--
ALTER TABLE `StoreCat`
  ADD PRIMARY KEY (`storeNo`);

--
-- Indexes for table `User`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`Email`),
  ADD KEY `User_BuyerNum_fk` (`BuyerNum`),
  ADD KEY `User_SellerNum_fk` (`SellerNum`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `CartProducts`
--
ALTER TABLE `CartProducts`
  ADD CONSTRAINT `CartProducts_CartNo_fk` FOREIGN KEY (`CartNo`) REFERENCES `User` (`BuyerNum`),
  ADD CONSTRAINT `CartProducts_StoreNumberAndProductNo_fk` FOREIGN KEY (`StoreNumber`,`ProductNo`) REFERENCES `Product` (`storeNum`, `ProductID`);

--
-- Constraints for table `Order`
--
ALTER TABLE `Order`
  ADD CONSTRAINT `Order_BuyerNum_fk` FOREIGN KEY (`BuyerN`) REFERENCES `Buyer` (`BuyerID`);

--
-- Constraints for table `OrderProducts`
--
ALTER TABLE `OrderProducts`
  ADD CONSTRAINT `OrderProducts_OrderNo_fk` FOREIGN KEY (`OrderNo`) REFERENCES `Order` (`OrderID`),
  ADD CONSTRAINT `OrderProducts_ProductN_fk` FOREIGN KEY (`storeNumber`,`ProductN`) REFERENCES `Product` (`storeNum`, `ProductID`);

--
-- Constraints for table `Product`
--
ALTER TABLE `Product`
  ADD CONSTRAINT `Product_storeNum_fk` FOREIGN KEY (`storeNum`) REFERENCES `User` (`SellerNum`);

--
-- Constraints for table `StoreCat`
--
ALTER TABLE `StoreCat`
  ADD CONSTRAINT `StoreCat_storeNo_fk` FOREIGN KEY (`storeNo`) REFERENCES `User` (`SellerNum`);

--
-- Constraints for table `User`
--
ALTER TABLE `User`
  ADD CONSTRAINT `User_BuyerNum_fk` FOREIGN KEY (`BuyerNum`) REFERENCES `Buyer` (`BuyerID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
