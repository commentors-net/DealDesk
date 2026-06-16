SET @db_name = DATABASE();

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @db_name AND table_name = 'dd_deals' AND column_name = 'removed_at') = 0,
  'ALTER TABLE dd_deals ADD COLUMN removed_at DATETIME NULL AFTER updated_at',
  'SELECT "removed_at already exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @db_name AND table_name = 'dd_deals' AND column_name = 'removed_by') = 0,
  'ALTER TABLE dd_deals ADD COLUMN removed_by VARCHAR(150) NULL AFTER removed_at',
  'SELECT "removed_by already exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @db_name AND table_name = 'dd_deals' AND column_name = 'removal_reason') = 0,
  'ALTER TABLE dd_deals ADD COLUMN removal_reason TEXT NULL AFTER removed_by',
  'SELECT "removal_reason already exists"'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
