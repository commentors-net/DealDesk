ALTER TABLE dd_directory_contacts
  ADD COLUMN organization_name VARCHAR(255) NULL AFTER display_name,
  ADD COLUMN working_contact_name VARCHAR(255) NULL AFTER organization_name,
  ADD COLUMN working_contact_role VARCHAR(120) NULL AFTER working_contact_name,
  ADD COLUMN contact_subtype VARCHAR(80) NULL AFTER contact_type,
  ADD COLUMN responsiveness_rating TINYINT UNSIGNED NULL AFTER notes,
  ADD COLUMN effectiveness_rating TINYINT UNSIGNED NULL AFTER responsiveness_rating,
  ADD COLUMN clearance_notes TEXT NULL AFTER effectiveness_rating,
  ADD COLUMN last_contacted_at DATETIME NULL AFTER clearance_notes,
  ADD COLUMN clearance_touch_count INT UNSIGNED NOT NULL DEFAULT 0 AFTER last_contacted_at,
  ADD COLUMN clearance_success_count INT UNSIGNED NOT NULL DEFAULT 0 AFTER clearance_touch_count;
