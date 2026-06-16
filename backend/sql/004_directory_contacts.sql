CREATE TABLE IF NOT EXISTS dd_directory_contacts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  public_id CHAR(36) NOT NULL,
  contact_type VARCHAR(80) NOT NULL,
  display_name VARCHAR(200) NOT NULL,
  company_name VARCHAR(200) NULL,
  legal_address TEXT NULL,
  broker_name VARCHAR(200) NULL,
  license_number VARCHAR(100) NULL,
  phone VARCHAR(80) NULL,
  email VARCHAR(200) NULL,
  notes TEXT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_by VARCHAR(150) NULL,
  updated_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_dd_directory_public_id (public_id),
  KEY idx_dd_directory_type_name (contact_type, display_name),
  KEY idx_dd_directory_email (email),
  KEY idx_dd_directory_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dd_directory_contact_usage (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  contact_id BIGINT UNSIGNED NOT NULL,
  deal_id BIGINT UNSIGNED NULL,
  role_key VARCHAR(80) NOT NULL,
  usage_context VARCHAR(120) NOT NULL DEFAULT 'accepted_offer_intake',
  snapshot_json JSON NULL,
  created_by VARCHAR(150) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_dd_directory_usage_contact (contact_id),
  KEY idx_dd_directory_usage_deal (deal_id),
  KEY idx_dd_directory_usage_role (role_key),
  CONSTRAINT fk_dd_directory_usage_contact FOREIGN KEY (contact_id) REFERENCES dd_directory_contacts(id) ON DELETE CASCADE,
  CONSTRAINT fk_dd_directory_usage_deal FOREIGN KEY (deal_id) REFERENCES dd_deals(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO dd_directory_contacts
(public_id, contact_type, display_name, legal_address, broker_name, license_number, phone, email, created_by, updated_by)
SELECT
  UUID(),
  CASE
    WHEN p.role_key IN ('seller_agent','purchaser_agent') THEN 'agent'
    WHEN p.role_key IN ('seller_attorney','purchaser_attorney') THEN 'attorney'
    ELSE 'contact'
  END AS contact_type,
  p.display_name,
  p.legal_address,
  p.broker_name,
  p.license_number,
  p.phone,
  p.email,
  'seed-from-existing-deals',
  'seed-from-existing-deals'
FROM dd_deal_parties p
WHERE p.display_name IS NOT NULL
  AND p.display_name <> ''
  AND p.role_key IN ('seller_agent','purchaser_agent','seller_attorney','purchaser_attorney')
  AND NOT EXISTS (
    SELECT 1
    FROM dd_directory_contacts c
    WHERE c.contact_type = CASE
        WHEN p.role_key IN ('seller_agent','purchaser_agent') THEN 'agent'
        WHEN p.role_key IN ('seller_attorney','purchaser_attorney') THEN 'attorney'
        ELSE 'contact'
      END
      AND LOWER(c.display_name) = LOWER(p.display_name)
      AND COALESCE(LOWER(c.email),'') = COALESCE(LOWER(p.email),'')
  );
