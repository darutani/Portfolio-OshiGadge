-- MySQL dump 10.13  Distrib 8.0.32, for macos13.0 (arm64)
--
-- Host: localhost    Database: Oshigadge_App_development
-- ------------------------------------------------------
-- Server version	8.0.32

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
-- Table structure for table "active_storage_attachments"
--

DROP TABLE IF EXISTS active_storage_attachments;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE active_storage_attachments (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  record_type VARCHAR(255) NOT NULL,
  record_id BIGINT NOT NULL,
  blob_id BIGINT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  UNIQUE (record_type, record_id, name, blob_id),
  FOREIGN KEY (blob_id) REFERENCES active_storage_blobs (id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "active_storage_blobs"
--

DROP TABLE IF EXISTS active_storage_blobs;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE active_storage_blobs (
  id BIGSERIAL PRIMARY KEY,
  key VARCHAR(255) NOT NULL,
  filename VARCHAR(255) NOT NULL,
  content_type VARCHAR(255) DEFAULT NULL,
  metadata TEXT,
  service_name VARCHAR(255) NOT NULL,
  byte_size BIGINT NOT NULL,
  checksum VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL
);
CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON active_storage_blobs (key);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "active_storage_variant_records"
--

DROP TABLE IF EXISTS "active_storage_variant_records";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE active_storage_variant_records (
  id BIGSERIAL PRIMARY KEY,
  blob_id BIGINT NOT NULL,
  variation_digest VARCHAR(255) NOT NULL,
  UNIQUE (blob_id, variation_digest),
  FOREIGN KEY (blob_id) REFERENCES active_storage_blobs (id)
);
CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON active_storage_variant_records (blob_id, variation_digest);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "ar_internal_metadata"
--

DROP TABLE IF EXISTS ar_internal_metadata;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE ar_internal_metadata (
  key VARCHAR(255) NOT NULL PRIMARY KEY,
  value VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "comments"
--

DROP TABLE IF EXISTS comments;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE comments (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  gadget_id BIGINT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP(6) NOT NULL,
  updated_at TIMESTAMP(6) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (gadget_id) REFERENCES gadgets (id)
);
CREATE INDEX index_comments_on_user_id ON comments (user_id);
CREATE INDEX index_comments_on_gadget_id ON comments (gadget_id);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "gadgets"
--

DROP TABLE IF EXISTS gadgets;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE gadgets (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) DEFAULT NULL,
  start_date DATE DEFAULT NULL,
  category VARCHAR(255) DEFAULT NULL,
  reason TEXT,
  point TEXT,
  usage TEXT,
  feature TEXT,
  created_at TIMESTAMP(6) NOT NULL,
  updated_at TIMESTAMP(6) NOT NULL,
  user_id BIGINT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "likes"
--

DROP TABLE IF EXISTS likes;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE likes (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  gadget_id BIGINT NOT NULL,
  created_at TIMESTAMP(6) NOT NULL,
  updated_at TIMESTAMP(6) NOT NULL,
  UNIQUE (user_id, gadget_id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (gadget_id) REFERENCES gadgets (id)
);
CREATE INDEX index_likes_on_user_id ON likes (user_id);
CREATE INDEX index_likes_on_gadget_id ON likes (gadget_id);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "relationships"
--

DROP TABLE IF EXISTS relationships;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE relationships (
  id BIGSERIAL PRIMARY KEY,
  follower_id INT DEFAULT NULL,
  followed_id INT DEFAULT NULL,
  created_at TIMESTAMP(6) NOT NULL,
  updated_at TIMESTAMP(6) NOT NULL,
  UNIQUE (follower_id, followed_id)
);
CREATE INDEX index_relationships_on_follower_id ON relationships (follower_id);
CREATE INDEX index_relationships_on_followed_id ON relationships (followed_id);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "schema_migrations"
--

DROP TABLE IF EXISTS schema_migrations;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE schema_migrations (
  version VARCHAR(255) NOT NULL,
  PRIMARY KEY (version)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "users"
--

DROP TABLE IF EXISTS users;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL DEFAULT '',
  encrypted_password VARCHAR(255) NOT NULL DEFAULT '',
  reset_password_token VARCHAR(255) DEFAULT NULL,
  reset_password_sent_at TIMESTAMP DEFAULT NULL,
  remember_created_at TIMESTAMP DEFAULT NULL,
  sign_in_count INT NOT NULL DEFAULT 0,
  current_sign_in_at TIMESTAMP DEFAULT NULL,
  last_sign_in_at TIMESTAMP DEFAULT NULL,
  current_sign_in_ip VARCHAR(255) DEFAULT NULL,
  last_sign_in_ip VARCHAR(255) DEFAULT NULL,
  failed_attempts INT NOT NULL DEFAULT 0,
  unlock_token VARCHAR(255) DEFAULT NULL,
  locked_at TIMESTAMP DEFAULT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL,
  name VARCHAR(255) DEFAULT NULL,
  introduction TEXT DEFAULT NULL,
  UNIQUE (email),
  UNIQUE (reset_password_token),
  UNIQUE (unlock_token)
);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-29  8:29:26
