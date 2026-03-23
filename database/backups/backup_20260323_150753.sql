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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2024_01_01_000001_create_accounts_table',2),(5,'2024_01_01_000002_create_sites_table',2),(6,'2024_01_01_000003_create_business_profiles_table',2),(7,'2024_01_01_000004_create_competitors_table',2),(8,'2024_01_01_000005_create_site_integrations_table',2),(9,'2024_01_01_000006_create_scans_table',2),(10,'2024_01_01_000007_create_scan_findings_table',2),(11,'2024_01_01_000008_create_missions_table',2),(12,'2024_01_01_000009_create_validation_tables',2),(13,'2024_01_01_000010_create_keyword_tracking_tables',2),(14,'2024_01_01_000011_create_progress_events_table',2),(15,'2026_03_19_120304_add_resources_json_to_missions_table',3),(16,'2026_03_20_000001_add_source_finding_title_to_missions_table',4),(17,'2026_03_20_000002_add_source_finding_code_to_missions_table',5),(18,'2026_03_23_000001_add_template_version_to_missions_table',6);
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
) ENGINE=InnoDB AUTO_INCREMENT=220 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mission_tasks`
--

LOCK TABLES `mission_tasks` WRITE;
/*!40000 ALTER TABLE `mission_tasks` DISABLE KEYS */;
INSERT INTO `mission_tasks` VALUES (173,78,1,'Determine which external resources your site loads (scripts, styles, fonts, images)','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(174,78,2,'Create a CSP policy that allows your required sources','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(175,78,3,'Deploy the header in report-only mode first to test','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(176,78,4,'Switch to enforcing mode once verified','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(177,79,1,'Add X-Content-Type-Options: nosniff to your server configuration','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(178,79,2,'Verify the header is present','verify',NULL,'{\"check\": \"has_x_content_type_options\"}','pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(179,80,1,'Go to Google Search Console (search.google.com/search-console) and sign in with your Google account','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(180,80,2,'Click \"Add property\" and choose \"URL prefix\", then enter your full site URL','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(181,80,3,'Verify ownership using one of the methods offered (HTML meta tag, DNS record, or HTML file upload)','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(182,80,4,'Once verified, go to Sitemaps in the left menu and submit your sitemap URL','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(183,80,5,'Use URL Inspection to request indexing of your homepage','manual',NULL,NULL,'pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(184,80,6,'Verify Search Console verification is detected on your site','verify',NULL,'{\"check\": \"has_search_console\"}','pending',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(194,108,1,'Determine which external resources your site loads (scripts, styles, fonts, images)','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(195,108,2,'Create a CSP policy that allows your required sources','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(196,108,3,'Deploy the header in report-only mode first to test','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(197,108,4,'Switch to enforcing mode once verified','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(198,109,1,'Add X-Content-Type-Options: nosniff to your server configuration','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(199,109,2,'Verify the header is present','verify',NULL,'{\"check\": \"has_x_content_type_options\"}','pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(200,110,1,'Go to Google Search Console (search.google.com/search-console) and sign in with your Google account','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(201,110,2,'Click \"Add property\" and choose \"URL prefix\", then enter your full site URL','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(202,110,3,'Verify ownership using one of the methods offered (HTML meta tag, DNS record, or HTML file upload)','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(203,110,4,'Once verified, go to Sitemaps in the left menu and submit your sitemap URL','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(204,110,5,'Use URL Inspection to request indexing of your homepage','manual',NULL,NULL,'pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(205,110,6,'Verify Search Console verification is detected on your site','verify',NULL,'{\"check\": \"has_search_console\"}','pending',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(211,133,1,'Add twitter:card meta tag (use \"summary_large_image\" for best display)','manual',NULL,NULL,'pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(212,133,2,'Add twitter:title, twitter:description, and twitter:image tags','manual',NULL,NULL,'pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(213,133,3,'Verify twitter:card is present','verify',NULL,'{\"check\": \"has_twitter_card\"}','pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(214,134,1,'Determine which external resources your site loads (scripts, styles, fonts, images)','manual',NULL,NULL,'pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(215,134,2,'Create a CSP policy that allows your required sources','manual',NULL,NULL,'pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(216,134,3,'Deploy the header in report-only mode first to test','manual',NULL,NULL,'pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(217,134,4,'Switch to enforcing mode once verified','manual',NULL,NULL,'pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(218,135,1,'Add X-Content-Type-Options: nosniff to your server configuration','manual',NULL,NULL,'pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(219,135,2,'Verify the header is present','verify',NULL,'{\"check\": \"has_x_content_type_options\"}','pending',NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54');
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
  `template_version` int unsigned NOT NULL DEFAULT '1',
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
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missions`
--

LOCK TABLES `missions` WRITE;
/*!40000 ALTER TABLE `missions` DISABLE KEYS */;
INSERT INTO `missions` VALUES (78,7,22,'scan_finding','Missing Content-Security-Policy header','missing_csp_header',1,'[{\"type\": \"code\", \"label\": \"Example basic CSP header\", \"content\": \"Content-Security-Policy: default-src \'self\'; script-src \'self\'; style-src \'self\' \'unsafe-inline\'\"}, {\"url\": \"https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy\", \"type\": \"link\", \"label\": \"MDN: Content-Security-Policy\"}, {\"type\": \"tip\", \"label\": \"Start with report-only\", \"content\": \"Use Content-Security-Policy-Report-Only first to test your policy without breaking anything.\"}]','security','suggested',20,'low','high','Your site uses Content-Security-Policy to prevent XSS attacks','No Content-Security-Policy header was detected. CSP is a security layer that helps prevent cross-site scripting (XSS) and data injection attacks on your site.','While not a direct ranking factor, security headers build trust and prevent attacks that could compromise your site.','system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(79,7,22,'scan_finding','Missing X-Content-Type-Options header','missing_x_content_type_options',1,'[{\"type\": \"code\", \"label\": \"Add this header in your server config\", \"content\": \"# Apache (.htaccess)\\nHeader set X-Content-Type-Options \\\"nosniff\\\"\\n\\n# Nginx\\nadd_header X-Content-Type-Options \\\"nosniff\\\" always;\"}]','security','suggested',20,'low','low','Your site sends the X-Content-Type-Options security header','The X-Content-Type-Options header is not being sent. Without it, browsers may incorrectly interpret uploaded files as executable content, creating a security risk.','This is a simple security header that prevents browsers from incorrectly interpreting files as different content types.','system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(80,7,22,'scan_finding','Google Search Console not detected','no_search_console',1,'[{\"url\": \"https://search.google.com/search-console\", \"type\": \"link\", \"label\": \"Google Search Console\"}, {\"url\": \"https://support.google.com/webmasters/answer/9008080\", \"type\": \"link\", \"label\": \"Google: Verify your site ownership\"}, {\"type\": \"tip\", \"label\": \"Why this matters\", \"content\": \"Without Search Console, you cannot request indexing, submit sitemaps, or see which queries bring people to your site. For new sites, this is the difference between appearing in Google within days versus weeks.\"}]','visibility','suggested',85,'high','low','Your site is connected to Google Search Console for indexing and monitoring','Google Search Console is the primary way to tell Google about your site, submit sitemaps, request indexing of new pages, and monitor how your site appears in search results. Without it, you\'re relying on Google to discover your site on its own — which can take weeks or may not happen at all.','Search Console is free and gives you direct control over how Google indexes your site. It\'s the single most important tool for getting a new site visible in search results.','system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(81,7,22,'scan_finding','robots.txt','pass_robots_txt',1,'[]','technical','completed',40,'low','low','robots.txt','Your robots.txt file is properly configured, allows search engine access, and references your sitemap.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(82,7,22,'scan_finding','XML Sitemap','pass_sitemap',1,'[]','technical','completed',70,'high','low','XML Sitemap','Your site has a valid XML sitemap that search engines can use to discover your pages.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(83,7,22,'scan_finding','Homepage Indexability','pass_homepage_indexable',1,'[]','technical','completed',98,'critical','low','Homepage Indexability','Your homepage returns HTTP 200 and has no noindex directive — search engines can index it without issue.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(84,7,22,'scan_finding','Title Tag','pass_title_tag',1,'[]','content','completed',90,'critical','low','Title Tag','Your homepage has a well-formed title tag of appropriate length, giving search engines a clear signal about your page.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(85,7,22,'scan_finding','Meta Description','pass_meta_description',1,'[]','content','completed',60,'medium','low','Meta Description','Your homepage has a meta description, giving you control over the snippet shown in search results.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(86,7,22,'scan_finding','H1 Heading','pass_h1',1,'[]','content','completed',50,'medium','low','H1 Heading','Your homepage has an H1 heading that clearly signals what the page is about to both visitors and search engines.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(87,7,22,'scan_finding','HTTPS','pass_https',1,'[]','security','completed',75,'high','low','HTTPS','Your site is served securely over HTTPS. Browsers show it as secure and Google uses this as a ranking signal.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(88,7,22,'scan_finding','Open Graph Title','pass_og_title',1,'[]','social','completed',45,'medium','low','Open Graph Title','Your homepage has an og:title tag, so social media previews will display a proper title when shared.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(89,7,22,'scan_finding','Open Graph Description','pass_og_description',1,'[]','social','completed',40,'medium','low','Open Graph Description','Your homepage has an og:description tag for compelling social media previews.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(90,7,22,'scan_finding','Open Graph Image','pass_og_image',1,'[]','social','completed',50,'high','low','Open Graph Image','Your homepage has an og:image tag, so social shares will include a visual preview image.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(91,7,22,'scan_finding','Twitter Card','pass_twitter_card',1,'[]','social','completed',30,'low','low','Twitter Card','Your homepage has a twitter:card tag, enabling rich previews when shared on X/Twitter.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(92,7,22,'scan_finding','Canonical URL','pass_canonical',1,'[]','technical','completed',55,'medium','low','Canonical URL','Your homepage specifies a canonical URL, helping search engines consolidate ranking signals and avoid duplicate content issues.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(93,7,22,'scan_finding','Structured Data','pass_structured_data',1,'[]','technical','completed',45,'medium','low','Structured Data','Your homepage includes JSON-LD structured data, making it eligible for rich search results like star ratings and business info panels.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(94,7,22,'scan_finding','Language Attribute','pass_lang',1,'[]','technical','completed',40,'medium','low','Language Attribute','Your page declares its language via the lang attribute, helping search engines and accessibility tools serve the right audience.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(95,7,22,'scan_finding','Viewport Meta Tag','pass_viewport',1,'[]','technical','completed',75,'high','low','Viewport Meta Tag','Your site has a viewport meta tag, ensuring it renders correctly on mobile devices and passes mobile-friendliness checks.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(96,7,22,'scan_finding','Character Encoding','pass_charset',1,'[]','technical','completed',25,'low','low','Character Encoding','Your page declares its character encoding, ensuring text renders correctly across all browsers.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(97,7,22,'scan_finding','Content-Security-Policy','pass_csp',1,'[]','security','completed',20,'low','low','Content-Security-Policy','Your site sends a Content-Security-Policy header, providing an extra layer of defence against cross-site scripting attacks.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(98,7,22,'scan_finding','No Mixed Content','pass_mixed_content',1,'[]','security','completed',55,'medium','low','No Mixed Content','All resources on your HTTPS page are loaded securely — no mixed content warnings for visitors.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(99,7,22,'scan_finding','Analytics Tracking','pass_analytics',1,'[]','analytics','completed',60,'high','low','Analytics Tracking','Your site has analytics tracking installed. You can measure traffic, understand visitor behaviour, and track the impact of your SEO improvements.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(101,7,22,'scan_finding','Service Page Coverage','pass_service_coverage',1,'[]','content','completed',65,'high','low','Service Page Coverage','Your site has content covering all of your listed services. Each service is represented with dedicated content, giving you the best chance of ranking for service-specific searches.',NULL,'system',NULL,NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(108,8,29,'scan_finding','Missing Content-Security-Policy header','missing_csp_header',1,'[{\"type\": \"code\", \"label\": \"Example basic CSP header\", \"content\": \"Content-Security-Policy: default-src \'self\'; script-src \'self\'; style-src \'self\' \'unsafe-inline\'\"}, {\"url\": \"https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy\", \"type\": \"link\", \"label\": \"MDN: Content-Security-Policy\"}, {\"type\": \"tip\", \"label\": \"Start with report-only\", \"content\": \"Use Content-Security-Policy-Report-Only first to test your policy without breaking anything.\"}]','security','suggested',20,'low','high','Your site uses Content-Security-Policy to prevent XSS attacks','No Content-Security-Policy header was detected. CSP is a security layer that helps prevent cross-site scripting (XSS) and data injection attacks on your site.','While not a direct ranking factor, security headers build trust and prevent attacks that could compromise your site.','system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(109,8,29,'scan_finding','Missing X-Content-Type-Options header','missing_x_content_type_options',1,'[{\"type\": \"code\", \"label\": \"Add this header in your server config\", \"content\": \"# Apache (.htaccess)\\nHeader set X-Content-Type-Options \\\"nosniff\\\"\\n\\n# Nginx\\nadd_header X-Content-Type-Options \\\"nosniff\\\" always;\"}]','security','suggested',20,'low','low','Your site sends the X-Content-Type-Options security header','The X-Content-Type-Options header is not being sent. Without it, browsers may incorrectly interpret uploaded files as executable content, creating a security risk.','This is a simple security header that prevents browsers from incorrectly interpreting files as different content types.','system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(110,8,29,'scan_finding','Google Search Console not detected','no_search_console',1,'[{\"url\": \"https://search.google.com/search-console\", \"type\": \"link\", \"label\": \"Google Search Console\"}, {\"url\": \"https://support.google.com/webmasters/answer/9008080\", \"type\": \"link\", \"label\": \"Google: Verify your site ownership\"}, {\"type\": \"tip\", \"label\": \"Why this matters\", \"content\": \"Without Search Console, you cannot request indexing, submit sitemaps, or see which queries bring people to your site. For new sites, this is the difference between appearing in Google within days versus weeks.\"}]','visibility','suggested',85,'high','low','Your site is connected to Google Search Console for indexing and monitoring','Google Search Console is the primary way to tell Google about your site, submit sitemaps, request indexing of new pages, and monitor how your site appears in search results. Without it, you\'re relying on Google to discover your site on its own — which can take weeks or may not happen at all.','Search Console is free and gives you direct control over how Google indexes your site. It\'s the single most important tool for getting a new site visible in search results.','system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(111,8,29,'scan_finding','robots.txt','pass_robots_txt',1,'[]','technical','completed',40,'low','low','robots.txt','Your robots.txt file is properly configured, allows search engine access, and references your sitemap.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(112,8,29,'scan_finding','XML Sitemap','pass_sitemap',1,'[]','technical','completed',70,'high','low','XML Sitemap','Your site has a valid XML sitemap that search engines can use to discover your pages.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(113,8,29,'scan_finding','Homepage Indexability','pass_homepage_indexable',1,'[]','technical','completed',98,'critical','low','Homepage Indexability','Your homepage returns HTTP 200 and has no noindex directive — search engines can index it without issue.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(114,8,29,'scan_finding','Title Tag','pass_title_tag',1,'[]','content','completed',90,'critical','low','Title Tag','Your homepage has a well-formed title tag of appropriate length, giving search engines a clear signal about your page.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(115,8,29,'scan_finding','Meta Description','pass_meta_description',1,'[]','content','completed',60,'medium','low','Meta Description','Your homepage has a meta description, giving you control over the snippet shown in search results.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(116,8,29,'scan_finding','H1 Heading','pass_h1',1,'[]','content','completed',50,'medium','low','H1 Heading','Your homepage has an H1 heading that clearly signals what the page is about to both visitors and search engines.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(117,8,29,'scan_finding','HTTPS','pass_https',1,'[]','security','completed',75,'high','low','HTTPS','Your site is served securely over HTTPS. Browsers show it as secure and Google uses this as a ranking signal.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(118,8,29,'scan_finding','Open Graph Title','pass_og_title',1,'[]','social','completed',45,'medium','low','Open Graph Title','Your homepage has an og:title tag, so social media previews will display a proper title when shared.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(119,8,29,'scan_finding','Open Graph Description','pass_og_description',1,'[]','social','completed',40,'medium','low','Open Graph Description','Your homepage has an og:description tag for compelling social media previews.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(120,8,29,'scan_finding','Open Graph Image','pass_og_image',1,'[]','social','completed',50,'high','low','Open Graph Image','Your homepage has an og:image tag, so social shares will include a visual preview image.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(121,8,29,'scan_finding','Twitter Card','pass_twitter_card',1,'[]','social','completed',30,'low','low','Twitter Card','Your homepage has a twitter:card tag, enabling rich previews when shared on X/Twitter.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(122,8,29,'scan_finding','Canonical URL','pass_canonical',1,'[]','technical','completed',55,'medium','low','Canonical URL','Your homepage specifies a canonical URL, helping search engines consolidate ranking signals and avoid duplicate content issues.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(123,8,29,'scan_finding','Structured Data','pass_structured_data',1,'[]','technical','completed',45,'medium','low','Structured Data','Your homepage includes JSON-LD structured data, making it eligible for rich search results like star ratings and business info panels.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(124,8,29,'scan_finding','Language Attribute','pass_lang',1,'[]','technical','completed',40,'medium','low','Language Attribute','Your page declares its language via the lang attribute, helping search engines and accessibility tools serve the right audience.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(125,8,29,'scan_finding','Viewport Meta Tag','pass_viewport',1,'[]','technical','completed',75,'high','low','Viewport Meta Tag','Your site has a viewport meta tag, ensuring it renders correctly on mobile devices and passes mobile-friendliness checks.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(126,8,29,'scan_finding','Character Encoding','pass_charset',1,'[]','technical','completed',25,'low','low','Character Encoding','Your page declares its character encoding, ensuring text renders correctly across all browsers.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(127,8,29,'scan_finding','Content-Security-Policy','pass_csp',1,'[]','security','completed',20,'low','low','Content-Security-Policy','Your site sends a Content-Security-Policy header, providing an extra layer of defence against cross-site scripting attacks.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(128,8,29,'scan_finding','No Mixed Content','pass_mixed_content',1,'[]','security','completed',55,'medium','low','No Mixed Content','All resources on your HTTPS page are loaded securely — no mixed content warnings for visitors.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(129,8,29,'scan_finding','Analytics Tracking','pass_analytics',1,'[]','analytics','completed',60,'high','low','Analytics Tracking','Your site has analytics tracking installed. You can measure traffic, understand visitor behaviour, and track the impact of your SEO improvements.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(131,8,29,'scan_finding','Service Page Coverage','pass_service_coverage',1,'[]','content','completed',65,'high','low','Service Page Coverage','Your site has content covering all of your listed services. Each service is represented with dedicated content, giving you the best chance of ranking for service-specific searches.',NULL,'system',NULL,NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(133,9,33,'scan_finding','Missing Twitter Card meta tag','missing_twitter_card',1,'[{\"type\": \"code\", \"label\": \"Add Twitter Card tags\", \"content\": \"<meta name=\\\"twitter:card\\\" content=\\\"summary_large_image\\\">\\n<meta name=\\\"twitter:title\\\" content=\\\"Your Page Title\\\">\\n<meta name=\\\"twitter:description\\\" content=\\\"A brief description\\\">\\n<meta name=\\\"twitter:image\\\" content=\\\"https://yourdomain.com/images/share.jpg\\\">\"}, {\"url\": \"https://cards-dev.twitter.com/validator\", \"type\": \"link\", \"label\": \"Twitter Card Validator\"}]','social','suggested',30,'low','low','Your site displays rich previews when shared on X/Twitter','No twitter:card meta tag was found. When your site is shared on X/Twitter, it will appear as a plain text link instead of a rich preview with an image and description.','Twitter Cards enable rich media previews. Without them, links appear as plain text URLs.','system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(134,9,33,'scan_finding','Missing Content-Security-Policy header','missing_csp_header',1,'[{\"type\": \"code\", \"label\": \"Example basic CSP header\", \"content\": \"Content-Security-Policy: default-src \'self\'; script-src \'self\'; style-src \'self\' \'unsafe-inline\'\"}, {\"url\": \"https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy\", \"type\": \"link\", \"label\": \"MDN: Content-Security-Policy\"}, {\"type\": \"tip\", \"label\": \"Start with report-only\", \"content\": \"Use Content-Security-Policy-Report-Only first to test your policy without breaking anything.\"}]','security','suggested',20,'low','high','Your site uses Content-Security-Policy to prevent XSS attacks','No Content-Security-Policy header was detected. CSP is a security layer that helps prevent cross-site scripting (XSS) and data injection attacks on your site.','While not a direct ranking factor, security headers build trust and prevent attacks that could compromise your site.','system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(135,9,33,'scan_finding','Missing X-Content-Type-Options header','missing_x_content_type_options',1,'[{\"type\": \"code\", \"label\": \"Add this header in your server config\", \"content\": \"# Apache (.htaccess)\\nHeader set X-Content-Type-Options \\\"nosniff\\\"\\n\\n# Nginx\\nadd_header X-Content-Type-Options \\\"nosniff\\\" always;\"}]','security','suggested',20,'low','low','Your site sends the X-Content-Type-Options security header','The X-Content-Type-Options header is not being sent. Without it, browsers may incorrectly interpret uploaded files as executable content, creating a security risk.','This is a simple security header that prevents browsers from incorrectly interpreting files as different content types.','system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(136,9,33,'scan_finding','robots.txt','pass_robots_txt',1,'[]','technical','completed',40,'low','low','robots.txt','Your robots.txt file is properly configured, allows search engine access, and references your sitemap.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(137,9,33,'scan_finding','XML Sitemap','pass_sitemap',1,'[]','technical','completed',70,'high','low','XML Sitemap','Your site has a valid XML sitemap that search engines can use to discover your pages.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(138,9,33,'scan_finding','Homepage Indexability','pass_homepage_indexable',1,'[]','technical','completed',98,'critical','low','Homepage Indexability','Your homepage returns HTTP 200 and has no noindex directive — search engines can index it without issue.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(139,9,33,'scan_finding','Title Tag','pass_title_tag',1,'[]','content','completed',90,'critical','low','Title Tag','Your homepage has a well-formed title tag of appropriate length, giving search engines a clear signal about your page.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(140,9,33,'scan_finding','Meta Description','pass_meta_description',1,'[]','content','completed',60,'medium','low','Meta Description','Your homepage has a meta description, giving you control over the snippet shown in search results.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(141,9,33,'scan_finding','H1 Heading','pass_h1',1,'[]','content','completed',50,'medium','low','H1 Heading','Your homepage has an H1 heading that clearly signals what the page is about to both visitors and search engines.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(142,9,33,'scan_finding','HTTPS','pass_https',1,'[]','security','completed',75,'high','low','HTTPS','Your site is served securely over HTTPS. Browsers show it as secure and Google uses this as a ranking signal.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(143,9,33,'scan_finding','Open Graph Title','pass_og_title',1,'[]','social','completed',45,'medium','low','Open Graph Title','Your homepage has an og:title tag, so social media previews will display a proper title when shared.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(144,9,33,'scan_finding','Open Graph Description','pass_og_description',1,'[]','social','completed',40,'medium','low','Open Graph Description','Your homepage has an og:description tag for compelling social media previews.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(145,9,33,'scan_finding','Open Graph Image','pass_og_image',1,'[]','social','completed',50,'high','low','Open Graph Image','Your homepage has an og:image tag, so social shares will include a visual preview image.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(146,9,33,'scan_finding','Canonical URL','pass_canonical',1,'[]','technical','completed',55,'medium','low','Canonical URL','Your homepage specifies a canonical URL, helping search engines consolidate ranking signals and avoid duplicate content issues.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(147,9,33,'scan_finding','Structured Data','pass_structured_data',1,'[]','technical','completed',45,'medium','low','Structured Data','Your homepage includes JSON-LD structured data, making it eligible for rich search results like star ratings and business info panels.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(148,9,33,'scan_finding','Language Attribute','pass_lang',1,'[]','technical','completed',40,'medium','low','Language Attribute','Your page declares its language via the lang attribute, helping search engines and accessibility tools serve the right audience.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(149,9,33,'scan_finding','Viewport Meta Tag','pass_viewport',1,'[]','technical','completed',75,'high','low','Viewport Meta Tag','Your site has a viewport meta tag, ensuring it renders correctly on mobile devices and passes mobile-friendliness checks.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(150,9,33,'scan_finding','Character Encoding','pass_charset',1,'[]','technical','completed',25,'low','low','Character Encoding','Your page declares its character encoding, ensuring text renders correctly across all browsers.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(151,9,33,'scan_finding','Content-Security-Policy','pass_csp',1,'[]','security','completed',20,'low','low','Content-Security-Policy','Your site sends a Content-Security-Policy header, providing an extra layer of defence against cross-site scripting attacks.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(152,9,33,'scan_finding','No Mixed Content','pass_mixed_content',1,'[]','security','completed',55,'medium','low','No Mixed Content','All resources on your HTTPS page are loaded securely — no mixed content warnings for visitors.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(153,9,33,'scan_finding','Analytics Tracking','pass_analytics',1,'[]','analytics','completed',60,'high','low','Analytics Tracking','Your site has analytics tracking installed. You can measure traffic, understand visitor behaviour, and track the impact of your SEO improvements.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(155,9,33,'scan_finding','Service Page Coverage','pass_service_coverage',1,'[]','content','completed',65,'high','low','Service Page Coverage','Your site has content covering all of your listed services. Each service is represented with dedicated content, giving you the best chance of ranking for service-specific searches.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(156,9,33,'scan_finding','Google Search Console','pass_search_console',1,'[]','visibility','completed',80,'high','low','Google Search Console','Your site has Google Search Console verification set up. This gives you access to indexing tools, search performance data, and crawl diagnostics from Google.',NULL,'system',NULL,NULL,'2026-03-23 14:44:54','2026-03-23 14:44:54'),(157,9,34,'scan_finding','Location on Homepage ✓','pass_location_on_homepage',1,'[]','local_seo','completed',80,'high','low','Location on Homepage ✓','Your homepage mentions your location, helping search engines connect your site to local searches in your area.',NULL,'system',NULL,'2026-03-23 15:07:17','2026-03-23 15:07:17','2026-03-23 15:07:17'),(158,9,34,'scan_finding','Location in Title Tag ✓','pass_location_in_title',1,'[]','local_seo','completed',70,'high','low','Location in Title Tag ✓','Your homepage title includes your location — one of the strongest signals for local search ranking.',NULL,'system',NULL,'2026-03-23 15:07:17','2026-03-23 15:07:17','2026-03-23 15:07:17'),(159,9,34,'scan_finding','Local Business Schema ✓','pass_local_schema',1,'[]','local_seo','completed',60,'medium','low','Local Business Schema ✓','Your site has LocalBusiness structured data, making it eligible for rich results like map listings and knowledge panels.',NULL,'system',NULL,'2026-03-23 15:07:17','2026-03-23 15:07:17','2026-03-23 15:07:17'),(160,9,34,'scan_finding','Google Business Profile ✓','pass_gbp_link',1,'[]','local_seo','completed',55,'medium','low','Google Business Profile ✓','Your site links to your Google Business Profile, reinforcing your local presence and making it easy for visitors to find reviews and directions.',NULL,'system',NULL,'2026-03-23 15:07:17','2026-03-23 15:07:17','2026-03-23 15:07:17'),(161,9,34,'scan_finding','Business Name on Homepage ✓','pass_business_name',1,'[]','local_seo','completed',50,'medium','low','Business Name on Homepage ✓','Your business name is visible on your homepage, supporting NAP consistency for local SEO.',NULL,'system',NULL,'2026-03-23 15:07:17','2026-03-23 15:07:17','2026-03-23 15:07:17');
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
) ENGINE=InnoDB AUTO_INCREMENT=294 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scan_findings`
--

LOCK TABLES `scan_findings` WRITE;
/*!40000 ALTER TABLE `scan_findings` DISABLE KEYS */;
INSERT INTO `scan_findings` VALUES (170,7,22,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://hair-haven.uk/robots.txt\", \"size_bytes\": 258}',0,'open','2026-03-21 08:15:49','2026-03-21 08:15:49',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(171,7,22,'technical','sitemap_found','info','XML sitemap found','Your site has a sitemap index file, which links to other sitemaps.','{\"url\": \"https://hair-haven.uk/sitemap.xml\", \"type\": \"index\", \"url_count\": 0}',0,'open','2026-03-21 08:15:49','2026-03-21 08:15:49',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(172,7,22,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-21 08:15:49','2026-03-21 08:15:49',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(173,7,22,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-21 08:15:49','2026-03-21 08:15:49',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(174,7,22,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://hair-haven.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-21 08:15:49','2026-03-21 08:15:49',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(175,7,22,'visibility','no_search_console','high','Google Search Console not detected','Your site does not appear to have Google Search Console verification set up. Search Console is essential for monitoring how Google sees your site, submitting sitemaps, requesting indexing, and diagnosing crawl issues.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-21 08:15:49','2026-03-21 08:15:49',NULL,'2026-03-21 08:15:49','2026-03-21 08:15:49'),(242,7,28,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://hair-haven.uk/robots.txt\", \"size_bytes\": 258}',0,'open','2026-03-23 12:10:12','2026-03-23 12:10:12',NULL,'2026-03-23 12:10:12','2026-03-23 12:10:12'),(243,7,28,'technical','sitemap_found','info','XML sitemap found','Your site has a sitemap index file, which links to other sitemaps.','{\"url\": \"https://hair-haven.uk/sitemap.xml\", \"type\": \"index\", \"url_count\": 0}',0,'open','2026-03-23 12:10:12','2026-03-23 12:10:12',NULL,'2026-03-23 12:10:12','2026-03-23 12:10:12'),(244,7,28,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-23 12:10:12','2026-03-23 12:10:12',NULL,'2026-03-23 12:10:12','2026-03-23 12:10:12'),(245,7,28,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-23 12:10:12','2026-03-23 12:10:12',NULL,'2026-03-23 12:10:12','2026-03-23 12:10:12'),(246,7,28,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://hair-haven.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-23 12:10:12','2026-03-23 12:10:12',NULL,'2026-03-23 12:10:12','2026-03-23 12:10:12'),(247,7,28,'visibility','no_search_console','high','Google Search Console not detected','Your site does not appear to have Google Search Console verification set up. Search Console is essential for monitoring how Google sees your site, submitting sitemaps, requesting indexing, and diagnosing crawl issues.','{\"url\": \"https://hair-haven.uk/\"}',0,'open','2026-03-23 12:10:12','2026-03-23 12:10:12',NULL,'2026-03-23 12:10:12','2026-03-23 12:10:12'),(248,8,29,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://leadingedgehairandbeauty.co.uk/robots.txt\", \"size_bytes\": 293}',0,'open','2026-03-23 12:12:18','2026-03-23 12:12:18',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(249,8,29,'technical','sitemap_found','info','XML sitemap found','Your site has a sitemap index file, which links to other sitemaps.','{\"url\": \"https://leadingedgehairandbeauty.co.uk/sitemap.xml\", \"type\": \"index\", \"url_count\": 0}',0,'open','2026-03-23 12:12:18','2026-03-23 12:12:18',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(250,8,29,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://leadingedgehairandbeauty.co.uk/\"}',0,'open','2026-03-23 12:12:18','2026-03-23 12:12:18',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(251,8,29,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://leadingedgehairandbeauty.co.uk/\"}',0,'open','2026-03-23 12:12:18','2026-03-23 12:12:18',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(252,8,29,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://leadingedgehairandbeauty.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-23 12:12:18','2026-03-23 12:12:18',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(253,8,29,'visibility','no_search_console','high','Google Search Console not detected','Your site does not appear to have Google Search Console verification set up. Search Console is essential for monitoring how Google sees your site, submitting sitemaps, requesting indexing, and diagnosing crawl issues.','{\"url\": \"https://leadingedgehairandbeauty.co.uk/\"}',0,'open','2026-03-23 12:12:18','2026-03-23 12:12:18',NULL,'2026-03-23 12:12:18','2026-03-23 12:12:18'),(287,9,34,'technical','robots_txt_found','info','robots.txt exists','Your site has a robots.txt file.','{\"url\": \"https://altiuslifts.co.uk/robots.txt\", \"size_bytes\": 87}',0,'open','2026-03-23 14:44:54','2026-03-23 15:07:17',NULL,'2026-03-23 14:44:54','2026-03-23 15:07:17'),(288,9,34,'technical','sitemap_found','info','XML sitemap found','Your site has an XML sitemap with approximately 15 URLs.','{\"url\": \"https://altiuslifts.co.uk/sitemap.xml\", \"type\": \"urlset\", \"url_count\": 15}',0,'open','2026-03-23 14:44:54','2026-03-23 15:07:17',NULL,'2026-03-23 14:44:54','2026-03-23 15:07:17'),(289,9,34,'social','missing_twitter_card','low','Missing Twitter Card meta tag','Your homepage does not have a twitter:card meta tag. X/Twitter shares won\'t display rich previews.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-23 14:44:54','2026-03-23 15:07:17',NULL,'2026-03-23 14:44:54','2026-03-23 15:07:17'),(290,9,34,'security','missing_csp_header','low','Missing Content-Security-Policy header','Your site does not send a Content-Security-Policy (CSP) header. CSP helps prevent cross-site scripting (XSS) and data injection attacks.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-23 14:44:54','2026-03-23 15:07:17',NULL,'2026-03-23 14:44:54','2026-03-23 15:07:17'),(291,9,34,'security','missing_x_content_type_options','low','Missing X-Content-Type-Options header','Your site does not send the X-Content-Type-Options: nosniff header. This header prevents browsers from MIME-type sniffing.','{\"url\": \"https://altiuslifts.co.uk/\"}',0,'open','2026-03-23 14:44:54','2026-03-23 15:07:17',NULL,'2026-03-23 14:44:54','2026-03-23 15:07:17'),(292,9,34,'analytics','analytics_found','info','Analytics tracking detected','Your homepage has analytics tracking installed: Google Analytics 4 (GA4).','{\"url\": \"https://altiuslifts.co.uk/\", \"providers\": [\"Google Analytics 4 (GA4)\"]}',0,'open','2026-03-23 14:44:54','2026-03-23 15:07:17',NULL,'2026-03-23 14:44:54','2026-03-23 15:07:17'),(293,9,34,'visibility','search_console_verified','info','Google Search Console verification detected','Your site has Google Search Console verification: meta tag verification.','{\"url\": \"https://altiuslifts.co.uk/\", \"methods\": [\"meta tag verification\"]}',0,'open','2026-03-23 14:44:54','2026-03-23 15:07:17',NULL,'2026-03-23 14:44:54','2026-03-23 15:07:17');
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
INSERT INTO `sessions` VALUES ('rCqkDg2a7odDsn8oq3USHVqe2wf4WU1xpGMOV5N5',NULL,'192.168.97.5','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJvNERac0tWc1h1T2FZN0E0amczc1VpMnZBTW14TlBpa1J3OWt0ZFFhIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC8yM3A0LmRkZXYuc2l0ZVwvc2l0ZXNcLzlcL21pc3Npb25zIiwicm91dGUiOiJtaXNzaW9ucy5pbmRleCJ9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19',1774278437);
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_scans`
--

LOCK TABLES `site_scans` WRITE;
/*!40000 ALTER TABLE `site_scans` DISABLE KEYS */;
INSERT INTO `site_scans` VALUES (22,7,'full','completed',1,'2026-03-21 08:15:46','2026-03-21 08:15:49','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.28}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.6}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.32}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.3}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.63}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.31}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.33}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.29}}, \"blockers\": 0, \"total_findings\": 6, \"severity_counts\": {\"low\": 2, \"high\": 1, \"info\": 3}}','2026-03-21 08:15:46','2026-03-21 08:15:49'),(28,7,'full','completed',1,'2026-03-23 12:10:09','2026-03-23 12:10:12','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.29}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.66}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.3}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.3}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.63}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.33}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.34}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.33}}, \"blockers\": 0, \"total_findings\": 6, \"severity_counts\": {\"low\": 2, \"high\": 1, \"info\": 3}}','2026-03-23 12:10:09','2026-03-23 12:10:12'),(29,8,'full','completed',1,'2026-03-23 12:12:16','2026-03-23 12:12:18','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.25}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.38}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.3}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.3}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.25}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.29}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.36}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.33}}, \"blockers\": 0, \"total_findings\": 6, \"severity_counts\": {\"low\": 2, \"high\": 1, \"info\": 3}}','2026-03-23 12:12:16','2026-03-23 12:12:18'),(33,9,'full','completed',1,'2026-03-23 14:44:49','2026-03-23 14:44:54','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.13}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.72}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.63}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.62}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.7}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.62}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.61}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.68}}, \"blockers\": 0, \"total_findings\": 7, \"severity_counts\": {\"low\": 3, \"info\": 4}}','2026-03-23 14:44:49','2026-03-23 14:44:54'),(34,9,'full','completed',1,'2026-03-23 15:07:13','2026-03-23 15:07:17','{\"checks\": {\"Sitemap\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.13}, \"Homepage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.71}, \"Security\": {\"status\": \"completed\", \"findings_count\": 2, \"elapsed_seconds\": 0.58}, \"Analytics\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.65}, \"Local SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Robots.txt\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.16}, \"Technical SEO\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0.62}, \"Search Console\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.62}, \"Service Coverage\": {\"status\": \"completed\", \"findings_count\": 0, \"elapsed_seconds\": 0}, \"Meta Tags & Social\": {\"status\": \"completed\", \"findings_count\": 1, \"elapsed_seconds\": 0.61}}, \"blockers\": 0, \"total_findings\": 7, \"severity_counts\": {\"low\": 3, \"info\": 4}}','2026-03-23 15:07:13','2026-03-23 15:07:17');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (7,1,'hair-haven.uk','https://hair-haven.uk','hair-haven.uk',NULL,'scanned','setup',NULL,'2026-03-21 08:15:43','2026-03-21 08:15:49'),(8,1,'leadingedgehairandbeauty.co.uk','https://leadingedgehairandbeauty.co.uk','leadingedgehairandbeauty.co.uk',NULL,'scanned','setup',NULL,'2026-03-23 12:12:12','2026-03-23 12:12:18'),(9,1,'altiuslifts.co.uk','https://altiuslifts.co.uk','altiuslifts.co.uk',NULL,'scanned','setup',NULL,'2026-03-23 14:44:46','2026-03-23 14:44:54');
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

-- Dump completed on 2026-03-23 15:07:55
Wrote database dump from project '23p4' database 'db' to stdout in plain text format.
