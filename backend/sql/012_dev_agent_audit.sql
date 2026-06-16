-- Deal Desk Dev Agent Audit Table
-- Logs every tool call made by the Dev Agent for security and transparency.

CREATE TABLE IF NOT EXISTS dd_dev_agent_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    public_id VARCHAR(64) NULL,
    user_prompt TEXT NULL,
    tool_name VARCHAR(100) NOT NULL,
    tool_args_json TEXT NULL,
    tool_result_preview TEXT NULL,
    allowed TINYINT(1) DEFAULT 0,
    blocked_reason VARCHAR(255) NULL,
    created_by VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
