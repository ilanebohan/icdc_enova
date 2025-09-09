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
-- Table structure for table `answer_option`
--

DROP TABLE IF EXISTS `answer_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `answer_option` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `question_id` int unsigned NOT NULL,
  `label` varchar(255) NOT NULL,
  `points` int NOT NULL DEFAULT '0',
  `next_question_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_answer_q` (`question_id`),
  KEY `fk_answer_next` (`next_question_id`),
  CONSTRAINT `fk_answer_next` FOREIGN KEY (`next_question_id`) REFERENCES `question` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_q` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer_option`
--

LOCK TABLES `answer_option` WRITE;
/*!40000 ALTER TABLE `answer_option` DISABLE KEYS */;
INSERT INTO `answer_option` VALUES (1,1,'21 jours',2,NULL),(2,1,'28 jours',1,NULL),(3,2,'Oui',1,NULL),(4,2,'Parfois',2,NULL),(5,2,'Non',3,NULL),(6,3,'Oui',50,NULL),(7,3,'Non',100,NULL);
/*!40000 ALTER TABLE `answer_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cheptel`
--

DROP TABLE IF EXISTS `cheptel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cheptel` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `subspecies_id` int unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `effectif` int unsigned NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cheptel_user` (`userId`),
  KEY `idx_cheptel_sub` (`subspecies_id`),
  CONSTRAINT `fk_cheptel_subspecies` FOREIGN KEY (`subspecies_id`) REFERENCES `subspecies` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cheptel`
--

LOCK TABLES `cheptel` WRITE;
/*!40000 ALTER TABLE `cheptel` DISABLE KEYS */;
INSERT INTO `cheptel` VALUES (1,9,1,'test',123,'2025-09-09 12:49:50','2025-09-09 12:49:50'),(18,8,1,'Porcs - Porcelets 1',123,'2025-09-07 18:43:54','2025-09-07 18:43:54'),(21,8,2,'Poulets fermiers',45,'2025-09-07 18:44:36','2025-09-07 18:44:36'),(22,8,1,'Porcs Charcutier',21,'2025-09-07 19:02:30','2025-09-07 19:02:30'),(23,9,1,'Volaille12',12,'2025-09-09 13:04:27','2025-09-09 13:04:43'),(24,9,1,'Porc1',234,'2025-09-09 13:05:21','2025-09-09 13:05:21'),(25,9,4,'Brahim JR',562,'2025-09-09 13:12:48','2025-09-09 13:12:48'),(26,9,1,'Porc Charcutiers',21,'2025-09-09 14:30:54','2025-09-09 14:30:54');
/*!40000 ALTER TABLE `cheptel` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `phase`
--

DROP TABLE IF EXISTS `phase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phase` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `day_from` int DEFAULT NULL,
  `day_to` int DEFAULT NULL,
  `week_from` int DEFAULT NULL,
  `week_to` int DEFAULT NULL,
  `sort_order` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phase`
--

LOCK TABLES `phase` WRITE;
/*!40000 ALTER TABLE `phase` DISABLE KEYS */;
INSERT INTO `phase` VALUES (1,'1er âge',NULL,NULL,NULL,NULL,1),(2,'2ème âge',NULL,NULL,NULL,NULL,2),(3,'Croissance',NULL,NULL,NULL,NULL,1),(4,'Finition',NULL,NULL,NULL,NULL,2),(5,'Démarrage',NULL,NULL,NULL,NULL,1),(6,'Croissance 1',NULL,NULL,NULL,NULL,2),(7,'Croissance 2',NULL,NULL,NULL,NULL,3),(8,'Finition',NULL,NULL,NULL,NULL,4),(9,'Retrait',NULL,NULL,NULL,NULL,5),(10,'Poulet D0-10',0,10,NULL,NULL,1),(11,'Poulet J11-21',11,21,NULL,NULL,2),(12,'Poulet J22-28',22,28,NULL,NULL,3),(13,'Poulet J29-abattage',29,NULL,NULL,NULL,4);
/*!40000 ALTER TABLE `phase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `label` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'PORCVITAL','PORCVITAL'),(2,'PORCVITAL_PLUS','PORCVITAL +'),(3,'PORCVITAL_PLUSPLUS','PORCVITAL ++'),(4,'PORCNUTRI','PORCNUTRI'),(5,'VOLAILLEVITAL','VOLAILLEVITAL'),(6,'VOLAILLEVITAL_PLUS','VOLAILLEVITAL +'),(7,'VOLAILLENUTRI','VOLAILLENUTRI');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_dose`
--

DROP TABLE IF EXISTS `program_dose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_dose` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `program_phase_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `dose_value` decimal(10,2) NOT NULL,
  `dose_unit` enum('g/tonne','kg/tonne') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pd_pp` (`program_phase_id`),
  KEY `fk_pd_prod` (`product_id`),
  CONSTRAINT `fk_pd_pp` FOREIGN KEY (`program_phase_id`) REFERENCES `program_phase` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pd_prod` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_dose`
--

LOCK TABLES `program_dose` WRITE;
/*!40000 ALTER TABLE `program_dose` DISABLE KEYS */;
INSERT INTO `program_dose` VALUES (1,1,1,1.00,'kg/tonne'),(2,2,1,0.50,'kg/tonne'),(3,4,5,0.50,'kg/tonne'),(4,5,5,0.60,'kg/tonne'),(5,6,5,0.40,'kg/tonne'),(6,7,5,0.40,'kg/tonne');
/*!40000 ALTER TABLE `program_dose` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_phase`
--

DROP TABLE IF EXISTS `program_phase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_phase` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `template_id` int unsigned NOT NULL,
  `phase_id` int unsigned NOT NULL,
  `sort_order` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_pp_t` (`template_id`),
  KEY `fk_pp_p` (`phase_id`),
  CONSTRAINT `fk_pp_p` FOREIGN KEY (`phase_id`) REFERENCES `phase` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_pp_t` FOREIGN KEY (`template_id`) REFERENCES `program_template` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_phase`
--

LOCK TABLES `program_phase` WRITE;
/*!40000 ALTER TABLE `program_phase` DISABLE KEYS */;
INSERT INTO `program_phase` VALUES (1,1,1,1),(2,1,2,2),(4,2,10,1),(5,2,11,2),(6,2,12,3),(7,2,13,4);
/*!40000 ALTER TABLE `program_phase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_rule_score`
--

DROP TABLE IF EXISTS `program_rule_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_rule_score` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `result_band_id` int unsigned NOT NULL,
  `template_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_prs_band` (`result_band_id`),
  KEY `fk_prs_template` (`template_id`),
  CONSTRAINT `fk_prs_band` FOREIGN KEY (`result_band_id`) REFERENCES `result_band` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prs_template` FOREIGN KEY (`template_id`) REFERENCES `program_template` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_rule_score`
--

LOCK TABLES `program_rule_score` WRITE;
/*!40000 ALTER TABLE `program_rule_score` DISABLE KEYS */;
INSERT INTO `program_rule_score` VALUES (1,1,1),(2,2,2);
/*!40000 ALTER TABLE `program_rule_score` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_template`
--

DROP TABLE IF EXISTS `program_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_template` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_template`
--

LOCK TABLES `program_template` WRITE;
/*!40000 ALTER TABLE `program_template` DISABLE KEYS */;
INSERT INTO `program_template` VALUES (1,'Porcelets - 8-10 pts','Programme post-sevrage adapté'),(2,'Poulet - Sécurité totale','Rotation complète 4 phases');
/*!40000 ALTER TABLE `program_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `questionnaire_id` int unsigned NOT NULL,
  `label` text NOT NULL,
  `display_order` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_question_q` (`questionnaire_id`),
  CONSTRAINT `fk_question_q` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (1,1,'Âge au sevrage ?',1),(2,1,'Biosécurité respectée ?',2),(3,2,'Utilisez-vous des coccidiostatiques ?',1);
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionnaire`
--

DROP TABLE IF EXISTS `questionnaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questionnaire` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_generic` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionnaire`
--

LOCK TABLES `questionnaire` WRITE;
/*!40000 ALTER TABLE `questionnaire` DISABLE KEYS */;
INSERT INTO `questionnaire` VALUES (1,'Porc - Porcelets','Évaluation post-sevrage',1,'2025-09-09 09:43:07','2025-09-09 14:44:51',0),(2,'Volaille - Poulet','Evaluation coccidiostatiques et rotation',1,'2025-09-09 09:43:07','2025-09-09 14:58:47',0);
/*!40000 ALTER TABLE `questionnaire` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionnaire_results`
--

DROP TABLE IF EXISTS `questionnaire_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questionnaire_results` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `questionnaire_id` int unsigned NOT NULL,
  `label` varchar(150) NOT NULL,
  `min_score` int NOT NULL,
  `max_score` int NOT NULL,
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_qr_range` (`questionnaire_id`,`min_score`,`max_score`),
  KEY `idx_qr_questionnaire` (`questionnaire_id`),
  CONSTRAINT `chk_qr_score_range` CHECK ((`min_score` <= `max_score`))
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionnaire_results`
--

LOCK TABLES `questionnaire_results` WRITE;
/*!40000 ALTER TABLE `questionnaire_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `questionnaire_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionnaire_subspecies`
--

DROP TABLE IF EXISTS `questionnaire_subspecies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questionnaire_subspecies` (
  `questionnaire_id` int unsigned NOT NULL,
  `subspecies_id` int unsigned NOT NULL,
  PRIMARY KEY (`questionnaire_id`,`subspecies_id`),
  KEY `fk_qs_subspecies` (`subspecies_id`),
  CONSTRAINT `fk_qs_questionnaire` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_qs_subspecies` FOREIGN KEY (`subspecies_id`) REFERENCES `subspecies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionnaire_subspecies`
--

LOCK TABLES `questionnaire_subspecies` WRITE;
/*!40000 ALTER TABLE `questionnaire_subspecies` DISABLE KEYS */;
INSERT INTO `questionnaire_subspecies` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `questionnaire_subspecies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `result_band`
--

DROP TABLE IF EXISTS `result_band`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `result_band` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `questionnaire_id` int unsigned NOT NULL,
  `label` varchar(200) NOT NULL,
  `min_score` int NOT NULL,
  `max_score` int NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `fk_band_q` (`questionnaire_id`),
  CONSTRAINT `fk_band_q` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `result_band`
--

LOCK TABLES `result_band` WRITE;
/*!40000 ALTER TABLE `result_band` DISABLE KEYS */;
INSERT INTO `result_band` VALUES (1,1,'Score 8-10',8,10,'Programme 1er et 2e âge'),(2,2,'Sécurité totale',101,9999,'Programme sécurité totale');
/*!40000 ALTER TABLE `result_band` ENABLE KEYS */;
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
-- Table structure for table `species`
--

DROP TABLE IF EXISTS `species`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `species` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_species_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `species`
--

LOCK TABLES `species` WRITE;
/*!40000 ALTER TABLE `species` DISABLE KEYS */;
INSERT INTO `species` VALUES (1,'Porc','2025-09-09 09:34:39','2025-09-09 09:34:39'),(2,'Volaille','2025-09-09 09:34:39','2025-09-09 09:34:39'),(4,'Brahim','2025-09-09 13:09:40','2025-09-09 13:09:40');
/*!40000 ALTER TABLE `species` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subspecies`
--

DROP TABLE IF EXISTS `subspecies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subspecies` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `species_id` int unsigned NOT NULL,
  `name` varchar(100) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subspecies` (`species_id`,`name`),
  CONSTRAINT `fk_subspecies_species` FOREIGN KEY (`species_id`) REFERENCES `species` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subspecies`
--

LOCK TABLES `subspecies` WRITE;
/*!40000 ALTER TABLE `subspecies` DISABLE KEYS */;
INSERT INTO `subspecies` VALUES (1,1,'Charcutier','2025-09-09 09:34:39','2025-09-09 09:34:39'),(2,2,'Poulet','2025-09-09 09:34:39','2025-09-09 09:34:39'),(4,4,'Brahim Jr.','2025-09-09 13:11:39','2025-09-09 13:11:39');
/*!40000 ALTER TABLE `subspecies` ENABLE KEYS */;
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
-- Table structure for table `user_answer`
--

DROP TABLE IF EXISTS `user_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_answer` (
  `attempt_id` bigint unsigned NOT NULL,
  `question_id` int unsigned NOT NULL,
  `answer_option_id` int unsigned NOT NULL,
  PRIMARY KEY (`attempt_id`,`question_id`),
  KEY `fk_ua_question` (`question_id`),
  KEY `fk_ua_answer` (`answer_option_id`),
  CONSTRAINT `fk_ua_answer` FOREIGN KEY (`answer_option_id`) REFERENCES `answer_option` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ua_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `user_attempt` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ua_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_answer`
--

LOCK TABLES `user_answer` WRITE;
/*!40000 ALTER TABLE `user_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_attempt`
--

DROP TABLE IF EXISTS `user_attempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_attempt` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `questionnaire_id` int unsigned NOT NULL,
  `cheptel_id` int unsigned DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `total_score` int DEFAULT NULL,
  `result_band_id` int unsigned DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_attempt_q` (`questionnaire_id`),
  KEY `fk_attempt_band` (`result_band_id`),
  KEY `idx_user_attempt_herd` (`cheptel_id`),
  CONSTRAINT `fk_attempt_band` FOREIGN KEY (`result_band_id`) REFERENCES `result_band` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_attempt_q` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_attempt_cheptel` FOREIGN KEY (`cheptel_id`) REFERENCES `cheptel` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_attempt`
--

LOCK TABLES `user_attempt` WRITE;
/*!40000 ALTER TABLE `user_attempt` DISABLE KEYS */;
INSERT INTO `user_attempt` VALUES (1,9,1,26,'2025-09-09 19:13:24',0,NULL,'2025-09-09 19:13:24'),(2,9,1,26,'2025-09-09 19:14:18',0,NULL,'2025-09-09 19:14:19'),(3,9,1,26,'2025-09-09 19:32:32',0,NULL,'2025-09-09 19:32:32'),(4,9,1,26,'2025-09-09 19:50:45',0,NULL,'2025-09-09 19:50:45'),(5,9,1,26,'2025-09-09 19:57:39',0,NULL,'2025-09-09 19:57:39'),(6,9,1,26,'2025-09-09 19:58:22',0,NULL,'2025-09-09 19:58:23'),(7,9,1,26,NULL,NULL,NULL,'2025-09-09 20:28:34'),(8,9,1,26,NULL,NULL,NULL,'2025-09-09 20:32:19'),(9,9,1,26,NULL,NULL,NULL,'2025-09-09 20:34:17');
/*!40000 ALTER TABLE `user_attempt` ENABLE KEYS */;
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

-- Dump completed on 2025-09-09 23:25:22
