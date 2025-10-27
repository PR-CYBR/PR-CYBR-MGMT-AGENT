output "codex_dispatch_matrix" {
  description = "Summary of orchestration targets based on Codex CLI routing logic"
  value = {
    maintenance    = ["PR-CYBR-MGMT-AGENT"]
    security_alert = ["PR-CYBR-SECURITY-AGENT"]
    data_sync      = ["PR-CYBR-DATA-INTEGRATION-AGENT"]
    workspace = {
      name  = "A-10"
      org   = "pr_cybr"
      token = var.TFC_TOKEN
    }
    notion = {
      page_id                     = var.NOTION_PAGE_ID
      discussions_archive_db_id   = var.NOTION_DISCUSSIONS_ARC_DB_ID
      issues_backlog_db_id        = var.NOTION_ISSUES_BACKLOG_DB_ID
      knowledge_file_db_id        = var.NOTION_KNOWLEDGE_FILE_DB_ID
      project_board_backlog_db_id = var.NOTION_PROJECT_BOARD_BACKLOG_DB_ID
      task_backlog_db_id          = var.NOTION_TASK_BACKLOG_DB_ID
    }
    ci_actions_token = var.AGENT_ACTIONS
  }
  sensitive = true
}
