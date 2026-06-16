SET @db_name = DATABASE();

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @db_name AND table_name = 'dd_deals' AND column_name = 'seller_acknowledgment_name') = 0,
  'ALTER TABLE dd_deals ADD COLUMN seller_acknowledgment_name VARCHAR(200) NULL AFTER additional_terms',
  'SELECT "seller_acknowledgment_name already exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @db_name AND table_name = 'dd_deals' AND column_name = 'seller_acknowledgment_date') = 0,
  'ALTER TABLE dd_deals ADD COLUMN seller_acknowledgment_date DATE NULL AFTER seller_acknowledgment_name',
  'SELECT "seller_acknowledgment_date already exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @db_name AND table_name = 'dd_deals' AND column_name = 'purchaser_acknowledgment_name') = 0,
  'ALTER TABLE dd_deals ADD COLUMN purchaser_acknowledgment_name VARCHAR(200) NULL AFTER seller_acknowledgment_date',
  'SELECT "purchaser_acknowledgment_name already exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @db_name AND table_name = 'dd_deals' AND column_name = 'purchaser_acknowledgment_date') = 0,
  'ALTER TABLE dd_deals ADD COLUMN purchaser_acknowledgment_date DATE NULL AFTER purchaser_acknowledgment_name',
  'SELECT "purchaser_acknowledgment_date already exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
