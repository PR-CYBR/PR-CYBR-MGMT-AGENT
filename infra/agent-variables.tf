#############################################
# PR-CYBR Agent Variables (Scoped Baseline)
# These variables are declared for Terraform
# Cloud at the agent workspace level.
#############################################

variable "AGENT_ACTIONS" {
  description = "Agent-level operations registry"
  type        = string
  sensitive   = true
}

variable "NOTION_TOKEN" {
  description = "Token for Notion API integration"
  type        = string
  sensitive   = true
}

variable "NOTION_PAGE_ID" {
  description = "Root Notion page identifier"
  type        = string
}

variable "NOTION_DISCUSSIONS_ARC_DB_ID" {
  description = "Notion database ID for discussions archive"
  type        = string
}

variable "NOTION_ISSUES_BACKLOG_DB_ID" {
  description = "Notion database ID for issues backlog"
  type        = string
}

variable "NOTION_KNOWLEDGE_FILE_DB_ID" {
  description = "Notion database ID for knowledge files"
  type        = string
}

variable "NOTION_PROJECT_BOARD_BACKLOG_DB_ID" {
  description = "Notion database ID for project board backlog"
  type        = string
}

variable "NOTION_TASK_BACKLOG_DB_ID" {
  description = "Notion database ID for task backlog"
  type        = string
}

variable "TFC_TOKEN" {
  description = "Terraform Cloud access token for agent workspace"
  type        = string
  sensitive   = true
}
