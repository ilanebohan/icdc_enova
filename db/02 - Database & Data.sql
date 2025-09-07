-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: enova
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `feeds`
--

DROP TABLE IF EXISTS `feeds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feeds` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_feeds_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feeds`
--

LOCK TABLES `feeds` WRITE;
/*!40000 ALTER TABLE `feeds` DISABLE KEYS */;
INSERT INTO `feeds` VALUES (1,'Le Monde - International','https://www.lemonde.fr/international/rss_full.xml'),(2,'AFP - Top','https://www.afp.com/en/feeds/rss'),(3,'Hacker News','https://hnrss.org/frontpage');
/*!40000 ALTER TABLE `feeds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `herd`
--

DROP TABLE IF EXISTS `herd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `herd` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `species` varchar(100) NOT NULL,
  `subspecies` varchar(100) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `name` varchar(255) NOT NULL DEFAULT 'Cheptel sans nom',
  `effectif` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_herd_user` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `herd`
--

LOCK TABLES `herd` WRITE;
/*!40000 ALTER TABLE `herd` DISABLE KEYS */;
INSERT INTO `herd` VALUES (18,8,'Porc','Charcutier','2025-09-07 18:43:54','2025-09-07 18:43:54','Porcs - Porcelets 1',123),(21,8,'Volaille','Poulet','2025-09-07 18:44:36','2025-09-07 18:44:36','Poulets fermiers',45),(22,8,'Porc','Charcutier','2025-09-07 19:02:30','2025-09-07 19:02:30','Porcs Charcutier',21),(23,9,'Volaille','Poulet','2025-09-07 19:14:26','2025-09-07 19:14:26','Cheptel ADMINISTRATEUR',123);
/*!40000 ALTER TABLE `herd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `code` char(6) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porkform`
--

DROP TABLE IF EXISTS `porkform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `porkform` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `herdId` int unsigned NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `biosecurite` tinyint(1) DEFAULT NULL,
  `qualiteEau` tinyint(1) DEFAULT NULL,
  `entretienCircuits` tinyint(1) DEFAULT NULL,
  `vaccinationRespectee` tinyint(1) DEFAULT NULL,
  `ageSevrage` int DEFAULT NULL,
  `pathologiesDigestivesPostsevrage` varchar(255) DEFAULT NULL,
  `mortalitePostsevrage` varchar(255) DEFAULT NULL,
  `pathologiesDigestivesEngraissement` varchar(255) DEFAULT NULL,
  `mortaliteEngraissement` varchar(255) DEFAULT NULL,
  `problemesDiarrheePorcelets` varchar(255) DEFAULT NULL,
  `problemesUrogenitaux` varchar(255) DEFAULT NULL,
  `doubleSilosGestante` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_porkform_herdId` (`herdId`),
  CONSTRAINT `fk_porkform_herd` FOREIGN KEY (`herdId`) REFERENCES `herd` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porkform`
--

LOCK TABLES `porkform` WRITE;
/*!40000 ALTER TABLE `porkform` DISABLE KEYS */;
INSERT INTO `porkform` VALUES (7,18,'2025-09-07 18:45:14','2025-09-07 18:45:56',1,1,1,1,NULL,NULL,NULL,'oui','>4',NULL,NULL,NULL);
/*!40000 ALTER TABLE `porkform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poultryform`
--

DROP TABLE IF EXISTS `poultryform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poultryform` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `herdId` int unsigned NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `coccidiostatiques` tinyint(1) DEFAULT NULL,
  `typeCoccidiostatiques` varchar(255) DEFAULT NULL,
  `etatLitiere` tinyint(1) DEFAULT NULL,
  `typeProduction` varchar(255) DEFAULT NULL,
  `problemesSanitaires` varchar(255) DEFAULT NULL,
  `rotationAnticocci` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_poultryform_herdId` (`herdId`),
  CONSTRAINT `fk_poultryform_herd` FOREIGN KEY (`herdId`) REFERENCES `herd` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poultryform`
--

LOCK TABLES `poultryform` WRITE;
/*!40000 ALTER TABLE `poultryform` DISABLE KEYS */;
INSERT INTO `poultryform` VALUES (22,21,'2025-09-07 18:44:45','2025-09-07 18:44:51',1,'mixte',1,NULL,NULL,'plus_2_an');
/*!40000 ALTER TABLE `poultryform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_manager`
--

DROP TABLE IF EXISTS `role_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_manager` (
  `userId_FK` int NOT NULL,
  `role` varchar(255) NOT NULL,
  PRIMARY KEY (`userId_FK`),
  CONSTRAINT `userId` FOREIGN KEY (`userId_FK`) REFERENCES `user` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_manager`
--

LOCK TABLES `role_manager` WRITE;
/*!40000 ALTER TABLE `role_manager` DISABLE KEYS */;
INSERT INTO `role_manager` VALUES (6,'none'),(8,'simpleUser'),(9,'admin');
/*!40000 ALTER TABLE `role_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userId` int NOT NULL AUTO_INCREMENT,
  `lastName` varchar(45) DEFAULT NULL,
  `firstName` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `address` varchar(45) DEFAULT NULL,
  `password` varchar(250) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (6,'user','user','user@gmail.com',NULL,'03586b4805660c089af4d9a956c0dd9cf9e4f73452eae4525b8302f2ac598a935052f5c08b6cb2cfd780138e42e317b6cc1a09fdad958f8b1a8da33d582036c5','user',NULL,NULL),(8,'Cabaret','Benoit','bcabaret@gmail.com',NULL,'2eedfb3eb89257fb95691797632dff0235e6521b08681c3910eb4b9e74511fe29e16ad5fc91720e2e5d5681b8e2ff85226e5b28b6a470e92e41650f16dba9453','B_Cabaret',NULL,NULL),(9,'Admin','Admin','admin@gmail.com',NULL,'03cb15a12b47a90d739ea183d6bc79cfee1b61bc13558e22ee92c413b1e8a7f71cbf403303925f5b459384583187aa1b8fe8687b831e267d148732e907f44294','administrateur',NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_feeds`
--

DROP TABLE IF EXISTS `user_feeds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_feeds` (
  `user_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `feed_id` int unsigned NOT NULL,
  `subscribed` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`,`feed_id`),
  KEY `idx_user_feeds_feed` (`feed_id`),
  KEY `idx_user_feeds_user_sub` (`user_id`,`subscribed`),
  CONSTRAINT `fk_user_feeds_feed` FOREIGN KEY (`feed_id`) REFERENCES `feeds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_feeds`
--

LOCK TABLES `user_feeds` WRITE;
/*!40000 ALTER TABLE `user_feeds` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_feeds` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-07 21:19:02
