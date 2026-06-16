ALTER TABLE dd_communication_log
  ADD COLUMN related_task_id BIGINT UNSIGNED NULL AFTER deal_id,
  ADD COLUMN task_result_status VARCHAR(80) NULL AFTER follow_up_due_date;

ALTER TABLE dd_communication_log
  ADD KEY idx_dd_comm_related_task (related_task_id);
