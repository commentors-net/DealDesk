CREATE TABLE IF NOT EXISTS dd_deals (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  public_id CHAR(36) NOT NULL,
  team_name VARCHAR(150) NULL,
  brokerage_name VARCHAR(150) NULL,
  accepted_offer_date DATE NULL,
  mls_number VARCHAR(80) NULL,
  property_address TEXT NOT NULL,
  transaction_status VARCHAR(80) NOT NULL DEFAULT 'Accepted Offer Intake Started',
  next_action TEXT NULL,
  property_condition_statement_status VARCHAR(80) NULL,
  additional_terms TEXT NULL,
  source_label VARCHAR(120) NULL,
  created_by VARCHAR(150) NULL,
  updated_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_dd_deals_public_id (public_id),
  KEY idx_dd_deals_status (transaction_status),
  KEY idx_dd_deals_mls (mls_number),
  KEY idx_dd_deals_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_deal_financials (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  deal_id BIGINT UNSIGNED NOT NULL,
  purchase_price DECIMAL(14,2) NULL,
  seller_concession DECIMAL(14,2) NULL,
  contract_deposit DECIMAL(14,2) NULL,
  mortgage_amount DECIMAL(14,2) NULL,
  cash_at_closing DECIMAL(14,2) NULL,
  total_price DECIMAL(14,2) NULL,
  commission_paid_by_seller VARCHAR(150) NULL,
  commission_paid_by_purchaser VARCHAR(150) NULL,
  contract_date_text VARCHAR(150) NULL,
  closing_date_text VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_dd_financials_deal (deal_id),
  CONSTRAINT fk_dd_financials_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_deal_parties (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  deal_id BIGINT UNSIGNED NOT NULL,
  role_key VARCHAR(80) NOT NULL,
  display_name VARCHAR(200) NULL,
  legal_address TEXT NULL,
  broker_name VARCHAR(200) NULL,
  license_number VARCHAR(100) NULL,
  phone VARCHAR(80) NULL,
  email VARCHAR(200) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_dd_parties_deal_role (deal_id, role_key),
  KEY idx_dd_parties_email (email),
  CONSTRAINT fk_dd_parties_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_deal_checklist (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  deal_id BIGINT UNSIGNED NOT NULL,
  item_key VARCHAR(120) NOT NULL,
  item_label VARCHAR(255) NOT NULL,
  status VARCHAR(80) NOT NULL DEFAULT 'Not Reviewed',
  answer_text TEXT NULL,
  reviewed_by VARCHAR(150) NULL,
  reviewed_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_dd_checklist_deal_item (deal_id, item_key),
  KEY idx_dd_checklist_status (status),
  CONSTRAINT fk_dd_checklist_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_deal_notes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  deal_id BIGINT UNSIGNED NOT NULL,
  note_type VARCHAR(80) NOT NULL DEFAULT 'Internal Note',
  note_text TEXT NOT NULL,
  created_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_dd_notes_deal_created (deal_id, created_at),
  CONSTRAINT fk_dd_notes_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_deal_documents (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  deal_id BIGINT UNSIGNED NOT NULL,
  document_type VARCHAR(120) NOT NULL,
  document_title VARCHAR(255) NOT NULL,
  file_path TEXT NULL,
  document_status VARCHAR(80) NOT NULL DEFAULT 'Created',
  created_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_dd_documents_deal_type (deal_id, document_type),
  KEY idx_dd_documents_status (document_status),
  CONSTRAINT fk_dd_documents_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_deal_history (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  deal_id BIGINT UNSIGNED NOT NULL,
  event_type VARCHAR(120) NOT NULL,
  event_summary TEXT NOT NULL,
  old_value TEXT NULL,
  new_value TEXT NULL,
  created_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_dd_history_deal_created (deal_id, created_at),
  KEY idx_dd_history_event_type (event_type),
  CONSTRAINT fk_dd_history_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_usage_ledger (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  deal_id BIGINT UNSIGNED NOT NULL,
  item_type VARCHAR(120) NOT NULL,
  item_id BIGINT UNSIGNED NULL,
  action_type VARCHAR(120) NOT NULL,
  action_summary TEXT NOT NULL,
  recipient TEXT NULL,
  result_notes TEXT NULL,
  created_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_dd_usage_deal_created (deal_id, created_at),
  KEY idx_dd_usage_action (action_type),
  CONSTRAINT fk_dd_usage_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
