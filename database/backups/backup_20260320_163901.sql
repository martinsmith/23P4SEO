-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: db
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `account_user`
--

DROP TABLE IF EXISTS `account_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'owner',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_user_account_id_user_id_unique` (`account_id`,`user_id`),
  KEY `account_user_user_id_foreign` (`user_id`),
  CONSTRAINT `account_user_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `account_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_user`
--

LOCK TABLES `account_user` WRITE;
/*!40000 ALTER TABLE `account_user` DISABLE KEYS */;
INSERT INTO `account_user` VALUES (1,1,1,'owner','2026-03-19 10:44:25','2026-03-19 10:44:25');
/*!40000 ALTER TABLE `account_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'free',
  `billing_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'Default Account','free','none','2026-03-19 10:44:25','2026-03-19 10:44:25');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_profiles`
--

DROP TABLE IF EXISTS `business_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `business_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `business_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `service_model` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `primary_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `service_area_summary` text COLLATE utf8mb4_unicode_ci,
  `target_customer_summary` text COLLATE utf8mb4_unicode_ci,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `business_profiles_site_id_unique` (`site_id`),
  CONSTRAINT `business_profiles_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_profiles`
--

LOCK TABLES `business_profiles` WRITE;
/*!40000 ALTER TABLE `business_profiles` DISABLE KEYS */;
INSERT INTO `business_profiles` VALUES (1,6,'Altius Lifts','Lift Maintenance, Engineering and Installation','local','Contracted Lift Maintenance, Engineering and Installation','Manchester, UK','Greater Manchester, North West England','Property Developers, Building Managers, Local Authorities, Healthcare, Hospitality',NULL,'2026-03-20 09:20:20','2026-03-20 09:20:20');
/*!40000 ALTER TABLE `business_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_services`
--

DROP TABLE IF EXISTS `business_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_services` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `service_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority_order` smallint unsigned NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `business_services_site_id_index` (`site_id`),
  CONSTRAINT `business_services_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_services`
--

LOCK TABLES `business_services` WRITE;
/*!40000 ALTER TABLE `business_services` DISABLE KEYS */;
INSERT INTO `business_services` VALUES (3,6,'Lift Maintenance',0,1,'2026-03-20 09:20:54','2026-03-20 09:20:54'),(4,6,'Lift Engineers',1,1,'2026-03-20 09:20:54','2026-03-20 09:20:54'),(5,6,'Lift Installation',2,1,'2026-03-20 09:20:54','2026-03-20 09:20:54');
/*!40000 ALTER TABLE `business_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `competitors`
--

DROP TABLE IF EXISTS `competitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `competitors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `competitors_site_id_index` (`site_id`),
  CONSTRAINT `competitors_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitors`
--

LOCK TABLES `competitors` WRITE;
/*!40000 ALTER TABLE `competitors` DISABLE KEYS */;
INSERT INTO `competitors` VALUES (1,6,'caledonianliftsmanchester.co.uk',NULL,1,NULL,'2026-03-20 09:23:59','2026-03-20 09:23:59'),(2,6,'www.dlrservices.co.uk',NULL,1,NULL,'2026-03-20 09:23:59','2026-03-20 09:23:59'),(3,6,'www.sheridanlifts.com',NULL,1,NULL,'2026-03-20 09:23:59','2026-03-20 09:23:59'),(4,6,'lift-services-northwest.co.uk',NULL,1,NULL,'2026-03-20 09:23:59','2026-03-20 09:23:59'),(5,6,'www.academylift.co.uk',NULL,1,NULL,'2026-03-20 09:23:59','2026-03-20 09:23:59');
/*!40000 ALTER TABLE `competitors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keyword_snapshots`
--

DROP TABLE IF EXISTS `keyword_snapshots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keyword_snapshots` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tracked_keyword_id` bigint unsigned NOT NULL,
  `checked_at` timestamp NOT NULL,
  `ranking_position` smallint unsigned DEFAULT NULL,
  `found_in_results` tinyint(1) NOT NULL DEFAULT '0',
  `result_url` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `top_competitor_domains_json` json DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `raw_result_meta_json` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `keyword_snapshots_tracked_keyword_id_checked_at_index` (`tracked_keyword_id`,`checked_at`),
  CONSTRAINT `keyword_snapshots_tracked_keyword_id_foreign` FOREIGN KEY (`tracked_keyword_id`) REFERENCES `tracked_keywords` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keyword_snapshots`
--

LOCK TABLES `keyword_snapshots` WRITE;
/*!40000 ALTER TABLE `keyword_snapshots` DISABLE KEYS */;
INSERT INTO `keyword_snapshots` VALUES (16,15,'2026-03-20 14:45:20',NULL,0,NULL,'[\"jacksonlifts.com\", \"sheridanlifts.com\", \"caledonianliftsmanchester.co.uk\", \"pickeringslifts.co.uk\", \"mvlifts.co.uk\", \"dlrservices.co.uk\", \"lift-services-northwest.co.uk\", \"rjlifts.co.uk\", \"paragonelevators.com\", \"verticalliftservices.co.uk\"]','serper','{\"query_used\": \"Lift Maintenance Manchester, UK\", \"results_checked\": 10}','2026-03-20 14:45:20','2026-03-20 14:45:20');
/*!40000 ALTER TABLE `keyword_snapshots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2024_01_01_000001_create_accounts_table',2),(5,'2024_01_01_000002_create_sites_table',2),(6,'2024_01_01_000003_create_business_profiles_table',2),(7,'2024_01_01_000004_create_competitors_table',2),(8,'2024_01_01_000005_create_site_integrations_table',2),(9,'2024_01_01_000006_create_scans_table',2),(10,'2024_01_01_000007_create_scan_findings_table',2),(11,'2024_01_01_000008_create_missions_table',2),(12,'2024_01_01_000009_create_validation_tables',2),(13,'2024_01_01_000010_create_keyword_tracking_tables',2),(14,'2024_01_01_000011_create_progress_events_table',2),(15,'2026_03_19_120304_add_resources_json_to_missions_table',3),(16,'2026_03_20_000001_add_source_finding_title_to_missions_table',4),(17,'2026_03_20_000002_add_source_finding_code_to_missions_table',5);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mission_tasks`
--

DROP TABLE IF EXISTS `mission_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mission_tasks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `mission_id` bigint unsigned NOT NULL,
  `sort_order` smallint unsigned NOT NULL DEFAULT '0',
  `task_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `task_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `target_url` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `validation_rule_json` json DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mission_tasks_mission_id_index` (`mission_id`),
  CONSTRAINT `mission_tasks_mission_id_foreign` FOREIGN KEY (`mission_id`) REFERENCES `missions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mission_tasks`
--

LOCK TABLES `mission_tasks` WRITE;
/*!40000 ALTER TABLE `mission_tasks` DISABLE KEYS */;
INSERT INTO `mission_tasks` VALUES (122,49,1,'Add an og:title meta tag to your homepage <head> section','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(123,49,2,'Add og:description and og:image tags as well for complete social previews','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(124,49,3,'Test with Facebook\'s Sharing Debugger tool','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(125,49,4,'Verify og:title is present','verify',NULL,'{\"check\": \"has_og_title\"}','pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(126,50,1,'Write a concise description (under 200 characters) for social sharing','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(127,50,2,'Add <meta property=\"og:description\" content=\"...\"> to your <head>','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(128,50,3,'Verify og:description is present','verify',NULL,'{\"check\": \"has_og_description\"}','pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(129,51,1,'Create a share image (1200×630 px) representing your brand/site','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(130,51,2,'Upload it to your website and add the og:image meta tag','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(131,51,3,'Verify og:image is present','verify',NULL,'{\"check\": \"has_og_image\"}','pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(132,52,1,'Add twitter:card meta tag (use \"summary_large_image\" for best display)','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(133,52,2,'Add twitter:title, twitter:description, and twitter:image tags','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(134,52,3,'Verify twitter:card is present','verify',NULL,'{\"check\": \"has_twitter_card\"}','pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(135,53,1,'Choose the appropriate schema type for your business (LocalBusiness, Organization, etc.)','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(136,53,2,'Create a JSON-LD script block with your business details','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(137,53,3,'Add the <script type=\"application/ld+json\"> block to your homepage <head>','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(138,53,4,'Test with Google\'s Rich Results Test tool','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(139,53,5,'Verify structured data is present','verify',NULL,'{\"check\": \"has_structured_data\"}','pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(140,54,1,'Determine which external resources your site loads (scripts, styles, fonts, images)','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(141,54,2,'Create a CSP policy that allows your required sources','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(142,54,3,'Deploy the header in report-only mode first to test','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(143,54,4,'Switch to enforcing mode once verified','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(144,55,1,'Add X-Content-Type-Options: nosniff to your server configuration','manual',NULL,NULL,'pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(145,55,2,'Verify the header is present','verify',NULL,'{\"check\": \"has_x_content_type_options\"}','pending',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(146,70,1,'Add your city/area to your homepage title tag','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(147,70,2,'Keep the total title under 60 characters','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(148,70,3,'Verify location is in the title','verify',NULL,'{\"check\": \"title_mentions_location\"}','pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(149,71,1,'Create a LocalBusiness JSON-LD script tag with your business details','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(150,71,2,'Add it to the <head> of your homepage (and ideally all pages)','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(151,71,3,'Validate using Google\'s Rich Results Test','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(152,71,4,'Verify LocalBusiness schema is present','verify',NULL,'{\"check\": \"has_local_schema\"}','pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(153,72,1,'If you don\'t have one, create a Google Business Profile at business.google.com','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(154,72,2,'Add a link to your GBP listing or Google Maps location on your homepage','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(155,72,3,'Consider adding it to your footer so it appears on every page','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(156,72,4,'Verify GBP link is present on homepage','verify',NULL,'{\"check\": \"has_gbp_link\"}','pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(157,73,1,'Create a dedicated page for this service','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(158,73,2,'Write 300–500 words of unique content describing what you offer','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(159,73,3,'Include your location and service area on the page','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(160,73,4,'Add a link to this page from your homepage and main navigation','manual',NULL,NULL,'pending',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(161,75,1,'Determine which external resources your site loads (scripts, styles, fonts, images)','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(162,75,2,'Create a CSP policy that allows your required sources','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(163,75,3,'Deploy the header in report-only mode first to test','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(164,75,4,'Switch to enforcing mode once verified','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(165,76,1,'Add X-Content-Type-Options: nosniff to your server configuration','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(166,76,2,'Verify the header is present','verify',NULL,'{\"check\": \"has_x_content_type_options\"}','pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(167,77,1,'Go to Google Search Console (search.google.com/search-console) and sign in with your Google account','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(168,77,2,'Click \"Add property\" and choose \"URL prefix\", then enter your full site URL','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(169,77,3,'Verify ownership using one of the methods offered (HTML meta tag, DNS record, or HTML file upload)','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(170,77,4,'Once verified, go to Sitemaps in the left menu and submit your sitemap URL','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(171,77,5,'Use URL Inspection to request indexing of your homepage','manual',NULL,NULL,'pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(172,77,6,'Verify Search Console verification is detected on your site','verify',NULL,'{\"check\": \"has_search_console\"}','pending',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15');
/*!40000 ALTER TABLE `mission_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `missions`
--

DROP TABLE IF EXISTS `missions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `missions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `source_scan_id` bigint unsigned DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_finding_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_finding_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resources_json` json DEFAULT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'suggested',
  `priority_score` smallint unsigned NOT NULL DEFAULT '50',
  `impact_level` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `effort_level` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `outcome_statement` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_summary` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `rationale_summary` text COLLATE utf8mb4_unicode_ci,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  `activated_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `missions_source_scan_id_foreign` (`source_scan_id`),
  KEY `missions_site_id_status_index` (`site_id`,`status`),
  KEY `missions_site_id_priority_score_index` (`site_id`,`priority_score`),
  KEY `missions_site_id_source_finding_code_index` (`site_id`,`source_finding_code`),
  CONSTRAINT `missions_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `missions_source_scan_id_foreign` FOREIGN KEY (`source_scan_id`) REFERENCES `site_scans` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missions`
--

LOCK TABLES `missions` WRITE;
/*!40000 ALTER TABLE `missions` DISABLE KEYS */;
INSERT INTO `missions` VALUES (49,6,14,'scan_finding','Missing Open Graph title (og:title)','missing_og_title','[{\"type\": \"code\", \"label\": \"Add these OG tags to your <head>\", \"content\": \"<meta property=\\\"og:title\\\" content=\\\"Your Page Title\\\">\\n<meta property=\\\"og:description\\\" content=\\\"A brief description of your page\\\">\\n<meta property=\\\"og:image\\\" content=\\\"https://yourdomain.com/images/share.jpg\\\">\\n<meta property=\\\"og:url\\\" content=\\\"https://yourdomain.com/\\\">\\n<meta property=\\\"og:type\\\" content=\\\"website\\\">\"}, {\"url\": \"https://developers.facebook.com/tools/debug/\", \"type\": \"link\", \"label\": \"Facebook Sharing Debugger\"}, {\"url\": \"https://ogp.me/\", \"type\": \"link\", \"label\": \"Open Graph Protocol\"}]','social','suggested',45,'medium','low','Your homepage has Open Graph tags for rich social sharing','No og:title meta tag was found. When your page is shared on Facebook, LinkedIn, or other platforms, the preview will lack a proper title and may look broken.','Open Graph tags control how your page appears when shared on social platforms. Without them, platforms guess — often poorly.','system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(50,6,14,'scan_finding','Missing Open Graph description (og:description)','missing_og_description','[{\"type\": \"code\", \"label\": \"Example og:description tag\", \"content\": \"<meta property=\\\"og:description\\\" content=\\\"We help small businesses grow with expert SEO and web design. Free consultation.\\\">\"}, {\"type\": \"tip\", \"label\": \"Best practice\", \"content\": \"Keep og:description under 200 characters. Make it compelling — this is your pitch when someone shares your link.\"}]','social','suggested',40,'medium','low','Your social shares include a compelling description','No og:description tag was found. Social media previews of your page will be missing a description, reducing the chance of clicks.','The og:description controls the snippet text shown in social media previews.','system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(51,6,14,'scan_finding','Missing Open Graph image (og:image)','missing_og_image','[{\"type\": \"code\", \"label\": \"Example og:image tag\", \"content\": \"<meta property=\\\"og:image\\\" content=\\\"https://yourdomain.com/images/og-share.jpg\\\">\\n<meta property=\\\"og:image:width\\\" content=\\\"1200\\\">\\n<meta property=\\\"og:image:height\\\" content=\\\"630\\\">\"}, {\"type\": \"tip\", \"label\": \"Image size\", \"content\": \"Use 1200×630 pixels for best results across all platforms. Use JPG or PNG format under 8MB.\"}]','social','suggested',50,'high','low','Your social shares display an eye-catching image','No og:image tag was found. Social media posts linking to your site will appear without an image, which dramatically reduces engagement and click-through rates.','Social posts with images get significantly more clicks and shares than those without.','system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(52,6,14,'scan_finding','Missing Twitter Card meta tag','missing_twitter_card','[{\"type\": \"code\", \"label\": \"Add Twitter Card tags\", \"content\": \"<meta name=\\\"twitter:card\\\" content=\\\"summary_large_image\\\">\\n<meta name=\\\"twitter:title\\\" content=\\\"Your Page Title\\\">\\n<meta name=\\\"twitter:description\\\" content=\\\"A brief description\\\">\\n<meta name=\\\"twitter:image\\\" content=\\\"https://yourdomain.com/images/share.jpg\\\">\"}, {\"url\": \"https://cards-dev.twitter.com/validator\", \"type\": \"link\", \"label\": \"Twitter Card Validator\"}]','social','suggested',30,'low','low','Your site displays rich previews when shared on X/Twitter','No twitter:card meta tag was found. When your site is shared on X/Twitter, it will appear as a plain text link instead of a rich preview with an image and description.','Twitter Cards enable rich media previews. Without them, links appear as plain text URLs.','system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(53,6,14,'scan_finding','No JSON-LD structured data found','missing_structured_data','[{\"type\": \"code\", \"label\": \"Example: Local Business JSON-LD\", \"content\": \"<script type=\\\"application/ld+json\\\">\\n{\\n  \\\"@context\\\": \\\"https://schema.org\\\",\\n  \\\"@type\\\": \\\"LocalBusiness\\\",\\n  \\\"name\\\": \\\"Your Business Name\\\",\\n  \\\"url\\\": \\\"https://yourdomain.com\\\",\\n  \\\"telephone\\\": \\\"+44 1234 567890\\\",\\n  \\\"address\\\": {\\n    \\\"@type\\\": \\\"PostalAddress\\\",\\n    \\\"streetAddress\\\": \\\"123 Main St\\\",\\n    \\\"addressLocality\\\": \\\"London\\\",\\n    \\\"postalCode\\\": \\\"SW1A 1AA\\\",\\n    \\\"addressCountry\\\": \\\"GB\\\"\\n  }\\n}\\n</script>\"}, {\"url\": \"https://search.google.com/test/rich-results\", \"type\": \"link\", \"label\": \"Google Rich Results Test\"}, {\"url\": \"https://schema.org/docs/gs.html\", \"type\": \"link\", \"label\": \"Schema.org: Getting Started\"}]','technical','suggested',45,'medium','medium','Your homepage uses structured data to enable rich search results','No JSON-LD structured data was found on your homepage. Without it, your site misses out on rich search results like star ratings, FAQs, and business info panels.','Structured data helps search engines understand your content and can unlock rich result features that increase click-through rates.','system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(54,6,14,'scan_finding','Missing Content-Security-Policy header','missing_csp_header','[{\"type\": \"code\", \"label\": \"Example basic CSP header\", \"content\": \"Content-Security-Policy: default-src \'self\'; script-src \'self\'; style-src \'self\' \'unsafe-inline\'\"}, {\"url\": \"https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy\", \"type\": \"link\", \"label\": \"MDN: Content-Security-Policy\"}, {\"type\": \"tip\", \"label\": \"Start with report-only\", \"content\": \"Use Content-Security-Policy-Report-Only first to test your policy without breaking anything.\"}]','security','suggested',20,'low','high','Your site uses Content-Security-Policy to prevent XSS attacks','No Content-Security-Policy header was detected. CSP is a security layer that helps prevent cross-site scripting (XSS) and data injection attacks on your site.','While not a direct ranking factor, security headers build trust and prevent attacks that could compromise your site.','system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(55,6,14,'scan_finding','Missing X-Content-Type-Options header','missing_x_content_type_options','[{\"type\": \"code\", \"label\": \"Add this header in your server config\", \"content\": \"# Apache (.htaccess)\\nHeader set X-Content-Type-Options \\\"nosniff\\\"\\n\\n# Nginx\\nadd_header X-Content-Type-Options \\\"nosniff\\\" always;\"}]','security','suggested',20,'low','low','Your site sends the X-Content-Type-Options security header','The X-Content-Type-Options header is not being sent. Without it, browsers may incorrectly interpret uploaded files as executable content, creating a security risk.','This is a simple security header that prevents browsers from incorrectly interpreting files as different content types.','system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(56,6,14,'scan_finding','robots.txt','pass_robots_txt','[]','technical','completed',40,'low','low','robots.txt','Your robots.txt file is properly configured, allows search engine access, and references your sitemap.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(57,6,14,'scan_finding','XML Sitemap','pass_sitemap','[]','technical','completed',70,'high','low','XML Sitemap','Your site has a valid XML sitemap that search engines can use to discover your pages.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(58,6,14,'scan_finding','Homepage Indexability','pass_homepage_indexable','[]','technical','completed',98,'critical','low','Homepage Indexability','Your homepage returns HTTP 200 and has no noindex directive — search engines can index it without issue.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(59,6,14,'scan_finding','Title Tag','pass_title_tag','[]','content','completed',90,'critical','low','Title Tag','Your homepage has a well-formed title tag of appropriate length, giving search engines a clear signal about your page.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(60,6,14,'scan_finding','Meta Description','pass_meta_description','[]','content','completed',60,'medium','low','Meta Description','Your homepage has a meta description, giving you control over the snippet shown in search results.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(61,6,14,'scan_finding','H1 Heading','pass_h1','[]','content','completed',50,'medium','low','H1 Heading','Your homepage has an H1 heading that clearly signals what the page is about to both visitors and search engines.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(62,6,14,'scan_finding','HTTPS','pass_https','[]','security','completed',75,'high','low','HTTPS','Your site is served securely over HTTPS. Browsers show it as secure and Google uses this as a ranking signal.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(63,6,14,'scan_finding','Canonical URL','pass_canonical','[]','technical','completed',55,'medium','low','Canonical URL','Your homepage specifies a canonical URL, helping search engines consolidate ranking signals and avoid duplicate content issues.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(64,6,14,'scan_finding','Language Attribute','pass_lang','[]','technical','completed',40,'medium','low','Language Attribute','Your page declares its language via the lang attribute, helping search engines and accessibility tools serve the right audience.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(65,6,14,'scan_finding','Viewport Meta Tag','pass_viewport','[]','technical','completed',75,'high','low','Viewport Meta Tag','Your site has a viewport meta tag, ensuring it renders correctly on mobile devices and passes mobile-friendliness checks.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(66,6,14,'scan_finding','Character Encoding','pass_charset','[]','technical','completed',25,'low','low','Character Encoding','Your page declares its character encoding, ensuring text renders correctly across all browsers.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(67,6,14,'scan_finding','Content-Security-Policy','pass_csp','[]','security','completed',20,'low','low','Content-Security-Policy','Your site sends a Content-Security-Policy header, providing an extra layer of defence against cross-site scripting attacks.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(68,6,14,'scan_finding','No Mixed Content','pass_mixed_content','[]','security','completed',55,'medium','low','No Mixed Content','All resources on your HTTPS page are loaded securely — no mixed content warnings for visitors.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(69,6,14,'scan_finding','Analytics Tracking','pass_analytics','[]','analytics','completed',60,'high','low','Analytics Tracking','Your site has analytics tracking installed. You can measure traffic, understand visitor behaviour, and track the impact of your SEO improvements.',NULL,'system',NULL,NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(70,6,16,'scan_finding','Page title doesn\'t include your location','title_no_location','[{\"type\": \"tip\", \"label\": \"Title format\", \"content\": \"A good format: \\\"[Service] in [City] | [Business Name]\\\" e.g. \\\"Lift Maintenance in Manchester | Altius Lifts\\\"\"}, {\"url\": \"https://developers.google.com/search/docs/appearance/title-link\", \"type\": \"link\", \"label\": \"Google: Title tag best practices\"}]','local_seo','suggested',70,'high','low','Your page title includes your location for local search ranking','Your homepage title tag does not include your location. The title tag is one of the strongest ranking signals — adding your city helps you appear in local searches.','Title tags are the first thing Google reads about your page. Including your location tells search engines exactly where you operate, improving your chances for local queries.','system',NULL,NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(71,6,16,'scan_finding','No LocalBusiness structured data','no_local_schema','[{\"type\": \"code\", \"label\": \"Example: LocalBusiness JSON-LD\", \"content\": \"<script type=\\\"application/ld+json\\\">\\n{\\n  \\\"@context\\\": \\\"https://schema.org\\\",\\n  \\\"@type\\\": \\\"LocalBusiness\\\",\\n  \\\"name\\\": \\\"Your Business Name\\\",\\n  \\\"address\\\": {\\n    \\\"@type\\\": \\\"PostalAddress\\\",\\n    \\\"streetAddress\\\": \\\"123 Main St\\\",\\n    \\\"addressLocality\\\": \\\"Manchester\\\",\\n    \\\"addressRegion\\\": \\\"Greater Manchester\\\",\\n    \\\"postalCode\\\": \\\"M1 1AA\\\",\\n    \\\"addressCountry\\\": \\\"GB\\\"\\n  },\\n  \\\"telephone\\\": \\\"+44-161-XXX-XXXX\\\",\\n  \\\"url\\\": \\\"https://yoursite.com\\\"\\n}\\n</script>\"}, {\"url\": \"https://developers.google.com/search/docs/appearance/structured-data/local-business\", \"type\": \"link\", \"label\": \"Google: Local business structured data\"}, {\"url\": \"https://validator.schema.org/\", \"type\": \"link\", \"label\": \"Schema.org markup validator\"}]','local_seo','suggested',60,'medium','medium','Your site has LocalBusiness structured data for rich search results','Your homepage does not contain LocalBusiness structured data (schema.org markup). This markup helps Google understand your business name, address, phone, opening hours, and service area — increasing your chances of appearing in map results and knowledge panels.','Structured data gives search engines explicit information about your business. Without it, Google has to guess your details from unstructured text.','system',NULL,NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(72,6,16,'scan_finding','No Google Business Profile link found','no_gbp_link','[{\"type\": \"tip\", \"label\": \"Don\'t have a GBP yet?\", \"content\": \"Create one for free at business.google.com. It\'s one of the most impactful things a local business can do for search visibility.\"}, {\"url\": \"https://business.google.com\", \"type\": \"link\", \"label\": \"Google Business Profile\"}, {\"url\": \"https://support.google.com/business/answer/10514137\", \"type\": \"link\", \"label\": \"Google: Set up your Business Profile\"}]','local_seo','suggested',55,'medium','low','Your site links to your Google Business Profile','Your homepage does not link to a Google Business Profile listing. Linking to your GBP helps customers find your reviews, directions, and contact details, and reinforces your local presence to Google.','A Google Business Profile is essential for local businesses. Linking from your website to your GBP creates a clear connection between your web presence and your Google listing.','system',NULL,NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(73,6,16,'scan_finding','No content found for \"Lift Maintenance\"','service_not_found','[{\"type\": \"tip\", \"label\": \"Service page best practice\", \"content\": \"Each service page should have: a clear heading with the service name, 300–500 words of unique content, your location, customer benefits, and a call to action.\"}, {\"type\": \"tip\", \"label\": \"Internal linking\", \"content\": \"Link to service pages from your homepage and navigation. This tells search engines these are important pages.\"}]','content','suggested',75,'high','medium','Your website has content covering all of your core services','One of your listed services could not be found anywhere on your site. Creating content about this service helps potential customers and search engines understand what you offer.','If you don\'t have a page or content for a service you offer, you cannot rank for searches related to that service. Every core service should have at least a dedicated section, ideally its own page.','system',NULL,NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(74,6,17,'scan_finding','Google Search Console','pass_search_console','[]','visibility','completed',80,'high','low','Google Search Console','Your site has Google Search Console verification set up. This gives you access to indexing tools, search performance data, and crawl diagnostics from Google.',NULL,'system',NULL,NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(75,3,20,'scan_finding','Missing Content-Security-Policy header','missing_csp_header','[{\"type\": \"code\", \"label\": \"Example basic CSP header\", \"content\": \"Content-Security-Policy: default-src \'self\'; script-src \'self\'; style-src \'self\' \'unsafe-inline\'\"}, {\"url\": \"https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy\", \"type\": \"link\", \"label\": \"MDN: Content-Security-Policy\"}, {\"type\": \"tip\", \"label\": \"Start with report-only\", \"content\": \"Use Content-Security-Policy-Report-Only first to test your policy without breaking anything.\"}]','security','suggested',20,'low','high','Your site uses Content-Security-Policy to prevent XSS attacks','No Content-Security-Policy header was detected. CSP is a security layer that helps prevent cross-site scripting (XSS) and data injection attacks on your site.','While not a direct ranking factor, security headers build trust and prevent attacks that could compromise your site.','system',NULL,NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(76,3,20,'scan_finding','Missing X-Content-Type-Options header','missing_x_content_type_options','[{\"type\": \"code\", \"label\": \"Add this header in your server config\", \"content\": \"# Apache (.htaccess)\\nHeader set X-Content-Type-Options \\\"nosniff\\\"\\n\\n# Nginx\\nadd_header X-Content-Type-Options \\\"nosniff\\\" always;\"}]','security','suggested',20,'low','low','Your site sends the X-Content-Type-Options security header','The X-Content-Type-Options header is not being sent. Without it, browsers may incorrectly interpret uploaded files as executable content, creating a security risk.','This is a simple security header that prevents browsers from incorrectly interpreting files as different content types.','system',NULL,NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(77,3,20,'scan_finding','Google Search Console not detected','no_search_console','[{\"url\": \"https://search.google.com/search-console\", \"type\": \"link\", \"label\": \"Google Search Console\"}, {\"url\": \"https://support.google.com/webmasters/answer/9008080\", \"type\": \"link\", \"label\": \"Google: Verify your site ownership\"}, {\"type\": \"tip\", \"label\": \"Why this matters\", \"content\": \"Without Search Console, you cannot request indexing, submit sitemaps, or see which queries bring people to your site. For new sites, this is the difference between appearing in Google within days versus weeks.\"}]','visibility','suggested',85,'high','low','Your site is connected to Google Search Console for indexing and monitoring','Google Search Console is the primary way to tell Google about your site, submit sitemaps, request indexing of new pages, and monitor how your site appears in search results. Without it, you\'re relying on Google to discover your site on its own — which can take weeks or may not happen at all.','Search Console is free and gives you direct control over how Google indexes your site. It\'s the single most important tool for getting a new site visible in search results.','system',NULL,NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15');
/*!40000 ALTER TABLE `missions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progress_events`
--

DROP TABLE IF EXISTS `progress_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progress_events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `event_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `headline` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci,
  `related_mission_id` bigint unsigned DEFAULT NULL,
  `related_keyword_id` bigint unsigned DEFAULT NULL,
  `event_date` date NOT NULL,
  `meta_json` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `progress_events_related_mission_id_foreign` (`related_mission_id`),
  KEY `progress_events_related_keyword_id_foreign` (`related_keyword_id`),
  KEY `progress_events_site_id_event_date_index` (`site_id`,`event_date`),
  KEY `progress_events_event_type_index` (`event_type`),
  CONSTRAINT `progress_events_related_keyword_id_foreign` FOREIGN KEY (`related_keyword_id`) REFERENCES `tracked_keywords` (`id`) ON DELETE SET NULL,
  CONSTRAINT `progress_events_related_mission_id_foreign` FOREIGN KEY (`related_mission_id`) REFERENCES `missions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `progress_events_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress_events`
--

LOCK TABLES `progress_events` WRITE;
/*!40000 ALTER TABLE `progress_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `progress_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scan_findings`
--

DROP TABLE IF EXISTS `scan_findings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scan_findings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `site_scan_id` bigint unsigned NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `severity` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci,
  `evidence_json` json DEFAULT NULL,
  `is_blocker` tinyint(1) NOT NULL DEFAULT '0',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `first_detected_at` timestamp NULL DEFAULT NULL,
  `last_detected_at` timestamp NULL DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `scan_findings_site_id_status_index` (`site_id`,`status`),
  KEY `scan_findings_site_id_category_index` (`site_id`,`category`),
  KEY `scan_findings_site_scan_id_index` (`site_scan_id`),
  CONSTRAINT `scan_findings_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `scan_findings_site_scan_id_foreign` FOREIGN KEY (`site_scan_id`) REFERENCES `site_scans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scan_findings`
--

LOCK TABLES `scan_findings` WRITE;
/*!40000 ALTER TABLE `scan_findings` DISABLE KEYS */;
INSERT INTO `scan_findings` VALUES (17,3,8,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://hair-haven.uk/robots.txt\", \"size_bytes\": 258}',0,'open','2026-03-19 13:41:57','2026-03-19 13:41:57',NULL,'2026-03-19 13:41:57','2026-03-19 13:41:57'),(18,3,8,'technical','sitemap_found','info','XML sitemap found','Your site has a sitemap index file, which links to other sitemaps.','{\"url\": \"https://hair-haven.uk/sitemap.xml\", \"type\": \"index\", \"url_count\": 0}',0,'open','2026-03-19 13:41:57','2026-03-19 13:41:57',NULL,'2026-03-19 13:41:57','2026-03-19 13:41:57'),(65,6,14,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(66,6,14,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(67,6,14,'social','missing_og_title','medium','Missing Open Graph title (og:title)','Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(68,6,14,'social','missing_og_description','medium','Missing Open Graph description (og:description)','Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(69,6,14,'social','missing_og_image','medium','Missing Open Graph image (og:image)','Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(70,6,14,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(71,6,14,'technical','missing_structured_data','medium','No JSON-LD structured data found','Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(72,6,14,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(73,6,14,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(74,6,14,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 09:06:30','2026-03-20 09:06:30',NULL,'2026-03-20 09:06:30','2026-03-20 09:06:30'),(75,6,15,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(76,6,15,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(77,6,15,'social','missing_og_title','medium','Missing Open Graph title (og:title)','Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(78,6,15,'social','missing_og_description','medium','Missing Open Graph description (og:description)','Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(79,6,15,'social','missing_og_image','medium','Missing Open Graph image (og:image)','Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(80,6,15,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(81,6,15,'technical','missing_structured_data','medium','No JSON-LD structured data found','Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(82,6,15,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(83,6,15,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(84,6,15,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 09:24:19','2026-03-20 09:24:19',NULL,'2026-03-20 09:24:19','2026-03-20 09:24:19'),(85,6,16,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(86,6,16,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(87,6,16,'social','missing_og_title','medium','Missing Open Graph title (og:title)','Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(88,6,16,'social','missing_og_description','medium','Missing Open Graph description (og:description)','Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(89,6,16,'social','missing_og_image','medium','Missing Open Graph image (og:image)','Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(90,6,16,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(91,6,16,'technical','missing_structured_data','medium','No JSON-LD structured data found','Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(92,6,16,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(93,6,16,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(94,6,16,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(95,6,16,'local_seo','title_no_location','medium','Page title doesn\'t include your location','Your homepage title tag (\"Altius Lifts\") doesn\'t mention \"Manchester, UK\". Including your location in the title tag is one of the strongest local SEO signals.','{\"url\": \"https://altiuslifts.co.uk/\", \"title\": \"Altius Lifts\", \"location\": \"Manchester, UK\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(96,6,16,'local_seo','no_local_schema','medium','No LocalBusiness structured data','Your homepage does not contain LocalBusiness (or a subtype) structured data. This schema markup helps Google understand your business name, address, opening hours, and service area — improving your chances of appearing in local search results and the map pack.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(97,6,16,'local_seo','no_gbp_link','medium','No Google Business Profile link found','Your homepage does not appear to link to a Google Business Profile (Google Maps or business.google.com). Linking to your GBP listing reinforces your local presence and helps customers find directions, reviews, and contact details.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(98,6,16,'content','service_not_found','high','No content found for \"Lift Maintenance\"','We couldn\'t find \"Lift Maintenance\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Maintenance\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(99,6,16,'content','service_not_found','high','No content found for \"Lift Engineers\"','We couldn\'t find \"Lift Engineers\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Engineers\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 11:35:40','2026-03-20 11:35:40',NULL,'2026-03-20 11:35:40','2026-03-20 11:35:40'),(100,6,17,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(101,6,17,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(102,6,17,'social','missing_og_title','medium','Missing Open Graph title (og:title)','Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(103,6,17,'social','missing_og_description','medium','Missing Open Graph description (og:description)','Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(104,6,17,'social','missing_og_image','medium','Missing Open Graph image (og:image)','Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(105,6,17,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(106,6,17,'technical','missing_structured_data','medium','No JSON-LD structured data found','Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(107,6,17,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(108,6,17,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(109,6,17,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(110,6,17,'visibility','search_console_verified','info','Google Search Console verification detected','Your site has Google Search Console verification: meta tag verification, Google Analytics (implies Google account access).','{\"url\": \"https://altiuslifts.co.uk/\", \"methods\": [\"meta tag verification\", \"Google Analytics (implies Google account access)\"]}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(111,6,17,'local_seo','title_no_location','medium','Page title doesn\'t include your location','Your homepage title tag (\"Altius Lifts\") doesn\'t mention \"Manchester, UK\". Including your location in the title tag is one of the strongest local SEO signals.','{\"url\": \"https://altiuslifts.co.uk/\", \"title\": \"Altius Lifts\", \"location\": \"Manchester, UK\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(112,6,17,'local_seo','no_local_schema','medium','No LocalBusiness structured data','Your homepage does not contain LocalBusiness (or a subtype) structured data. This schema markup helps Google understand your business name, address, opening hours, and service area — improving your chances of appearing in local search results and the map pack.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(113,6,17,'local_seo','no_gbp_link','medium','No Google Business Profile link found','Your homepage does not appear to link to a Google Business Profile (Google Maps or business.google.com). Linking to your GBP listing reinforces your local presence and helps customers find directions, reviews, and contact details.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(114,6,17,'content','service_not_found','high','No content found for \"Lift Maintenance\"','We couldn\'t find \"Lift Maintenance\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Maintenance\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(115,6,17,'content','service_not_found','high','No content found for \"Lift Engineers\"','We couldn\'t find \"Lift Engineers\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Engineers\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 15:44:53','2026-03-20 15:44:53',NULL,'2026-03-20 15:44:53','2026-03-20 15:44:53'),(116,6,18,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(117,6,18,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(118,6,18,'social','missing_og_title','medium','Missing Open Graph title (og:title)','Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(119,6,18,'social','missing_og_description','medium','Missing Open Graph description (og:description)','Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(120,6,18,'social','missing_og_image','medium','Missing Open Graph image (og:image)','Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(121,6,18,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(122,6,18,'technical','missing_structured_data','medium','No JSON-LD structured data found','Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(123,6,18,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(124,6,18,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(125,6,18,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(126,6,18,'visibility','search_console_verified','info','Google Search Console verification detected','Your site has Google Search Console verification: meta tag verification.','{\"url\": \"https://altiuslifts.co.uk/\", \"methods\": [\"meta tag verification\"]}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(127,6,18,'local_seo','title_no_location','medium','Page title doesn\'t include your location','Your homepage title tag (\"Altius Lifts\") doesn\'t mention \"Manchester, UK\". Including your location in the title tag is one of the strongest local SEO signals.','{\"url\": \"https://altiuslifts.co.uk/\", \"title\": \"Altius Lifts\", \"location\": \"Manchester, UK\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(128,6,18,'local_seo','no_local_schema','medium','No LocalBusiness structured data','Your homepage does not contain LocalBusiness (or a subtype) structured data. This schema markup helps Google understand your business name, address, opening hours, and service area — improving your chances of appearing in local search results and the map pack.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(129,6,18,'local_seo','no_gbp_link','medium','No Google Business Profile link found','Your homepage does not appear to link to a Google Business Profile (Google Maps or business.google.com). Linking to your GBP listing reinforces your local presence and helps customers find directions, reviews, and contact details.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(130,6,18,'content','service_not_found','high','No content found for \"Lift Maintenance\"','We couldn\'t find \"Lift Maintenance\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Maintenance\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(131,6,18,'content','service_not_found','high','No content found for \"Lift Engineers\"','We couldn\'t find \"Lift Engineers\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Engineers\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 15:53:17','2026-03-20 15:53:17',NULL,'2026-03-20 15:53:17','2026-03-20 15:53:17'),(132,6,19,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(133,6,19,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(134,6,19,'social','missing_og_title','medium','Missing Open Graph title (og:title)','Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(135,6,19,'social','missing_og_description','medium','Missing Open Graph description (og:description)','Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(136,6,19,'social','missing_og_image','medium','Missing Open Graph image (og:image)','Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(137,6,19,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(138,6,19,'technical','missing_structured_data','medium','No JSON-LD structured data found','Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(139,6,19,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(140,6,19,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(141,6,19,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(142,6,19,'visibility','search_console_verified','info','Google Search Console verification detected','Your site has Google Search Console verification: meta tag verification.','{\"url\": \"https://altiuslifts.co.uk/\", \"methods\": [\"meta tag verification\"]}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(143,6,19,'local_seo','title_no_location','medium','Page title doesn\'t include your location','Your homepage title tag (\"Altius Lifts\") doesn\'t mention \"Manchester, UK\". Including your location in the title tag is one of the strongest local SEO signals.','{\"url\": \"https://altiuslifts.co.uk/\", \"title\": \"Altius Lifts\", \"location\": \"Manchester, UK\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(144,6,19,'local_seo','no_local_schema','medium','No LocalBusiness structured data','Your homepage does not contain LocalBusiness (or a subtype) structured data. This schema markup helps Google understand your business name, address, opening hours, and service area — improving your chances of appearing in local search results and the map pack.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(145,6,19,'local_seo','no_gbp_link','medium','No Google Business Profile link found','Your homepage does not appear to link to a Google Business Profile (Google Maps or business.google.com). Linking to your GBP listing reinforces your local presence and helps customers find directions, reviews, and contact details.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(146,6,19,'content','service_not_found','high','No content found for \"Lift Maintenance\"','We couldn\'t find \"Lift Maintenance\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Maintenance\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(147,6,19,'content','service_not_found','high','No content found for \"Lift Engineers\"','We couldn\'t find \"Lift Engineers\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Engineers\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 15:54:17','2026-03-20 15:54:17',NULL,'2026-03-20 15:54:17','2026-03-20 15:54:17'),(148,3,20,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://hair-haven.uk/robots.txt\", \"size_bytes\": 258}',0,'open','2026-03-20 15:57:15','2026-03-20 15:57:15',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(149,3,20,'technical','sitemap_found','info','XML sitemap found','Your site has a sitemap index file, which links to other sitemaps.','{\"url\": \"https://hair-haven.uk/sitemap.xml\", \"type\": \"index\", \"url_count\": 0}',0,'open','2026-03-20 15:57:15','2026-03-20 15:57:15',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(150,3,20,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-20 15:57:15','2026-03-20 15:57:15',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(151,3,20,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-20 15:57:15','2026-03-20 15:57:15',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(152,3,20,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://hair-haven.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 15:57:15','2026-03-20 15:57:15',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(153,3,20,'visibility','no_search_console','high','Google Search Console not detected','Your site does not appear to have Google Search Console verification set up. Search Console is essential for monitoring how Google sees your site, submitting sitemaps, requesting indexing, and diagnosing crawl issues.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-20 15:57:15','2026-03-20 15:57:15',NULL,'2026-03-20 15:57:15','2026-03-20 15:57:15'),(154,6,21,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(155,6,21,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(156,6,21,'social','missing_og_title','medium','Missing Open Graph title (og:title)','Your homepage does not have an og:title meta tag. When shared on Facebook, LinkedIn, or other platforms, the preview may look incomplete or use auto-generated text.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(157,6,21,'social','missing_og_description','medium','Missing Open Graph description (og:description)','Your homepage is missing an og:description tag. Social shares will lack a compelling description preview.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(158,6,21,'social','missing_og_image','medium','Missing Open Graph image (og:image)','Your homepage has no og:image tag. Social shares will have no image preview, which significantly reduces engagement and click-through rates.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(159,6,21,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(160,6,21,'technical','missing_structured_data','medium','No JSON-LD structured data found','Your homepage has no JSON-LD structured data. Adding schema markup helps search engines understand your business and can enable rich results (star ratings, FAQs, breadcrumbs).','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(161,6,21,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(162,6,21,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(163,6,21,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(164,6,21,'visibility','search_console_verified','info','Google Search Console verification detected','Your site has Google Search Console verification: meta tag verification.','{\"url\": \"https://altiuslifts.co.uk/\", \"methods\": [\"meta tag verification\"]}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(165,6,21,'local_seo','title_no_location','medium','Page title doesn\'t include your location','Your homepage title tag (\"Altius Lifts\") doesn\'t mention \"Manchester, UK\". Including your location in the title tag is one of the strongest local SEO signals.','{\"url\": \"https://altiuslifts.co.uk/\", \"title\": \"Altius Lifts\", \"location\": \"Manchester, UK\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(166,6,21,'local_seo','no_local_schema','medium','No LocalBusiness structured data','Your homepage does not contain LocalBusiness (or a subtype) structured data. This schema markup helps Google understand your business name, address, opening hours, and service area — improving your chances of appearing in local search results and the map pack.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(167,6,21,'local_seo','no_gbp_link','medium','No Google Business Profile link found','Your homepage does not appear to link to a Google Business Profile (Google Maps or business.google.com). Linking to your GBP listing reinforces your local presence and helps customers find directions, reviews, and contact details.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(168,6,21,'content','service_not_found','high','No content found for \"Lift Maintenance\"','We couldn\'t find \"Lift Maintenance\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Maintenance\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36'),(169,6,21,'content','service_not_found','high','No content found for \"Lift Engineers\"','We couldn\'t find \"Lift Engineers\" mentioned on your site. This is one of the services you offer — creating dedicated content helps search engines understand what you do and connects you with people searching for this service.','{\"service\": \"Lift Engineers\", \"mentioned_on_homepage\": false}',0,'open','2026-03-20 16:19:36','2026-03-20 16:19:36',NULL,'2026-03-20 16:19:36','2026-03-20 16:19:36');
/*!40000 ALTER TABLE `scan_findings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('aIhJR9j3La9dvAk2pJQ9N782c4JMSzUQdVZvWNzp',NULL,'192.168.97.5','Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36','eyJfdG9rZW4iOiIyN2w0bzE5QUF6QlJiV2xsS0lOa2RSa0dmaldNS3RoaWxZMjFlRFhJIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC8yM3A0LmRkZXYuc2l0ZVwvc2l0ZXNcLzZcL21pc3Npb25zIiwicm91dGUiOiJtaXNzaW9ucy5pbmRleCJ9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19',1774024698);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_integrations`
--

DROP TABLE IF EXISTS `site_integrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_integrations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `provider` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'not_connected',
  `external_account_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `external_property_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `connected_at` timestamp NULL DEFAULT NULL,
  `last_synced_at` timestamp NULL DEFAULT NULL,
  `meta_json` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `site_integrations_site_id_provider_index` (`site_id`,`provider`),
  CONSTRAINT `site_integrations_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_integrations`
--

LOCK TABLES `site_integrations` WRITE;
/*!40000 ALTER TABLE `site_integrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_integrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_pages`
--

DROP TABLE IF EXISTS `site_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_pages` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `site_scan_id` bigint unsigned NOT NULL,
  `url` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_code` smallint unsigned DEFAULT NULL,
  `canonical_url` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_indexable` tinyint(1) NOT NULL DEFAULT '1',
  `is_noindex` tinyint(1) NOT NULL DEFAULT '0',
  `last_seen_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `site_pages_site_id_index` (`site_id`),
  KEY `site_pages_site_scan_id_index` (`site_scan_id`),
  CONSTRAINT `site_pages_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `site_pages_site_scan_id_foreign` FOREIGN KEY (`site_scan_id`) REFERENCES `site_scans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_pages`
--

LOCK TABLES `site_pages` WRITE;
/*!40000 ALTER TABLE `site_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `site_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_scans`
--

DROP TABLE IF EXISTS `site_scans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_scans` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `scan_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `scan_version` int unsigned NOT NULL DEFAULT '1',
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `summary_json` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `site_scans_site_id_status_index` (`site_id`,`status`),
  CONSTRAINT `site_scans_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_scans`
--

LOCK TABLES `site_scans` WRITE;
/*!40000 ALTER TABLE `site_scans` DISABLE KEYS */;
INSERT INTO `site_scans` VALUES (8,3,'full','completed',1,'2026-03-19 13:41:56','2026-03-19 13:41:57','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.28}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.62}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.57}}, \"blockers\": 0, \"total_findings\": 2, \"severity_counts\": {\"info\": 2}}','2026-03-19 13:41:56','2026-03-19 13:41:57'),(14,6,'full','completed',1,'2026-03-20 09:06:26','2026-03-20 09:06:30','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.12}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.81}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.61}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.62}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.76}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.62}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 4, \"elapsed_seconds\": 0.72}}, \"blockers\": 0, \"total_findings\": 10, \"severity_counts\": {\"low\": 3, \"info\": 3, \"medium\": 4}}','2026-03-20 09:06:26','2026-03-20 09:06:30'),(15,6,'full','completed',1,'2026-03-20 09:24:15','2026-03-20 09:24:19','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.13}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.75}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.71}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.72}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.69}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.66}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 4, \"elapsed_seconds\": 0.64}}, \"blockers\": 0, \"total_findings\": 10, \"severity_counts\": {\"low\": 3, \"info\": 3, \"medium\": 4}}','2026-03-20 09:24:15','2026-03-20 09:24:19'),(16,6,'full','completed',1,'2026-03-20 11:35:34','2026-03-20 11:35:40','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.12}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.75}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.62}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.67}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 3, \"elapsed_seconds\": 0.72}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.75}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.66}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.8}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 4, \"elapsed_seconds\": 0.7}}, \"blockers\": 0, \"total_findings\": 15, \"severity_counts\": {\"low\": 3, \"high\": 2, \"info\": 3, \"medium\": 7}}','2026-03-20 11:35:34','2026-03-20 11:35:40'),(17,6,'full','completed',1,'2026-03-20 15:44:46','2026-03-20 15:44:53','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.12}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.83}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.81}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.61}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 3, \"elapsed_seconds\": 0.61}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.69}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.74}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 1.04}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.79}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 4, \"elapsed_seconds\": 0.69}}, \"blockers\": 0, \"total_findings\": 16, \"severity_counts\": {\"low\": 3, \"high\": 2, \"info\": 4, \"medium\": 7}}','2026-03-20 15:44:46','2026-03-20 15:44:53'),(18,6,'full','completed',1,'2026-03-20 15:53:11','2026-03-20 15:53:17','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.12}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.81}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.72}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.72}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 3, \"elapsed_seconds\": 0.67}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.12}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.61}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.66}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.8}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 4, \"elapsed_seconds\": 0.71}}, \"blockers\": 0, \"total_findings\": 16, \"severity_counts\": {\"low\": 3, \"high\": 2, \"info\": 4, \"medium\": 7}}','2026-03-20 15:53:11','2026-03-20 15:53:17'),(19,6,'full','completed',1,'2026-03-20 15:54:11','2026-03-20 15:54:17','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.11}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.72}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.71}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.82}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 3, \"elapsed_seconds\": 0.64}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.12}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.74}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.7}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.82}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 4, \"elapsed_seconds\": 0.7}}, \"blockers\": 0, \"total_findings\": 16, \"severity_counts\": {\"low\": 3, \"high\": 2, \"info\": 4, \"medium\": 7}}','2026-03-20 15:54:11','2026-03-20 15:54:17'),(20,3,'full','completed',1,'2026-03-20 15:57:12','2026-03-20 15:57:15','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.32}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.54}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.33}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.34}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.01}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.59}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.33}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.34}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.31}}, \"blockers\": 0, \"total_findings\": 6, \"severity_counts\": {\"low\": 2, \"high\": 1, \"info\": 3}}','2026-03-20 15:57:12','2026-03-20 15:57:15'),(21,6,'full','completed',1,'2026-03-20 16:19:31','2026-03-20 16:19:36','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.09}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.65}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.56}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.58}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 3, \"elapsed_seconds\": 0.6}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.19}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.56}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.57}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.82}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 4, \"elapsed_seconds\": 0.62}}, \"blockers\": 0, \"total_findings\": 16, \"severity_counts\": {\"low\": 3, \"high\": 2, \"info\": 4, \"medium\": 7}}','2026-03-20 16:19:31','2026-03-20 16:19:36');
/*!40000 ALTER TABLE `site_scans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned NOT NULL,
  `display_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `normalized_domain` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `primary_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `onboarding_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending_scan',
  `lifecycle_status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'setup',
  `last_scanned_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sites_account_id_index` (`account_id`),
  KEY `sites_normalized_domain_index` (`normalized_domain`),
  CONSTRAINT `sites_account_id_foreign` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (3,1,'hair-haven.uk','https://hair-haven.uk','hair-haven.uk',NULL,'scanned','setup',NULL,'2026-03-19 13:41:54','2026-03-19 13:41:57'),(6,1,'altiuslifts.co.uk','https://altiuslifts.co.uk','altiuslifts.co.uk',NULL,'scanned','setup',NULL,'2026-03-20 09:06:23','2026-03-20 09:06:30');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracked_keywords`
--

DROP TABLE IF EXISTS `tracked_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracked_keywords` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `keyword` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `intent_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'service',
  `priority_order` smallint unsigned NOT NULL DEFAULT '0',
  `target_url` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tracked_keywords_site_id_status_index` (`site_id`,`status`),
  CONSTRAINT `tracked_keywords_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracked_keywords`
--

LOCK TABLES `tracked_keywords` WRITE;
/*!40000 ALTER TABLE `tracked_keywords` DISABLE KEYS */;
INSERT INTO `tracked_keywords` VALUES (15,6,'Lift Maintenance','Manchester, UK',NULL,'service',0,NULL,'active','2026-03-20 14:45:14','2026-03-20 14:45:14');
/*!40000 ALTER TABLE `tracked_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin@23p4.local','2026-03-19 10:44:24','$2y$12$xccv/qqfdd4qyzCzHvXgouWEcuXOs.ieWPgO/y8kJITa26ZEPU7iO','y37Ojuf2pP','2026-03-19 10:44:25','2026-03-19 10:44:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validation_checks`
--

DROP TABLE IF EXISTS `validation_checks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validation_checks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `validation_run_id` bigint unsigned NOT NULL,
  `mission_task_id` bigint unsigned DEFAULT NULL,
  `check_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `evidence_json` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `validation_checks_mission_task_id_foreign` (`mission_task_id`),
  KEY `validation_checks_validation_run_id_index` (`validation_run_id`),
  CONSTRAINT `validation_checks_mission_task_id_foreign` FOREIGN KEY (`mission_task_id`) REFERENCES `mission_tasks` (`id`) ON DELETE SET NULL,
  CONSTRAINT `validation_checks_validation_run_id_foreign` FOREIGN KEY (`validation_run_id`) REFERENCES `validation_runs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validation_checks`
--

LOCK TABLES `validation_checks` WRITE;
/*!40000 ALTER TABLE `validation_checks` DISABLE KEYS */;
/*!40000 ALTER TABLE `validation_checks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validation_runs`
--

DROP TABLE IF EXISTS `validation_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validation_runs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint unsigned NOT NULL,
  `mission_id` bigint unsigned DEFAULT NULL,
  `triggered_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `summary` text COLLATE utf8mb4_unicode_ci,
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `validation_runs_mission_id_foreign` (`mission_id`),
  KEY `validation_runs_site_id_status_index` (`site_id`,`status`),
  CONSTRAINT `validation_runs_mission_id_foreign` FOREIGN KEY (`mission_id`) REFERENCES `missions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `validation_runs_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validation_runs`
--

LOCK TABLES `validation_runs` WRITE;
/*!40000 ALTER TABLE `validation_runs` DISABLE KEYS */;
/*!40000 ALTER TABLE `validation_runs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-20 16:39:03
