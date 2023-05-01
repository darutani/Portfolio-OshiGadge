--
-- Table structure for table "active_storage_attachments"
--
DROP TABLE IF EXISTS active_storage_attachments;
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

--
-- Table structure for table "active_storage_blobs"
--
DROP TABLE IF EXISTS active_storage_blobs;
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

--
-- Table structure for table "active_storage_variant_records"
--
DROP TABLE IF EXISTS "active_storage_variant_records";
CREATE TABLE active_storage_variant_records (
  id BIGSERIAL PRIMARY KEY,
  blob_id BIGINT NOT NULL,
  variation_digest VARCHAR(255) NOT NULL,
  UNIQUE (blob_id, variation_digest),
  FOREIGN KEY (blob_id) REFERENCES active_storage_blobs (id)
);
CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON active_storage_variant_records (blob_id, variation_digest);

--
-- Table structure for table "ar_internal_metadata"
--
DROP TABLE IF EXISTS ar_internal_metadata;
CREATE TABLE ar_internal_metadata (
  key VARCHAR(255) NOT NULL PRIMARY KEY,
  value VARCHAR(255) DEFAULT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

--
-- Table structure for table "comments"
--
DROP TABLE IF EXISTS comments;
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

--
-- Table structure for table "gadgets"
--
DROP TABLE IF EXISTS gadgets;
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

--
-- Table structure for table "likes"
--
DROP TABLE IF EXISTS likes;
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

--
-- Table structure for table "relationships"
--
DROP TABLE IF EXISTS relationships;
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

--
-- Table structure for table "schema_migrations"
--
DROP TABLE IF EXISTS schema_migrations;
CREATE TABLE schema_migrations (
  version VARCHAR(255) NOT NULL,
  PRIMARY KEY (version)
);

--
-- Table structure for table "users"
--
DROP TABLE IF EXISTS users;
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
