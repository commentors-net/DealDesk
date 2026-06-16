CREATE TABLE IF NOT EXISTS dd_manager_chat_log (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  public_id CHAR(36) NOT NULL,
  question TEXT NOT NULL,
  answer MEDIUMTEXT NOT NULL,
  model VARCHAR(120) NULL,
  created_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_dd_manager_chat_public_id (public_id),
  KEY idx_dd_manager_chat_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
