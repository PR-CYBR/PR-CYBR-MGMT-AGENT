#############################################
# PR-CYBR Agent Terraform Bootstrap
# Environment: A-10 (Management Agent)
#
# This configuration is intentionally minimal.
# It consumes workspace variables provided by
# Terraform Cloud and exposes a summarized view
# to confirm the workspace wiring is correct.
# All secrets are sourced from TFC at runtime.
#############################################

terraform {
  required_version = ">= 1.5.0"
}

locals {
  agent_workspace = {
    id             = var.AGENT_ID
    notion_page_id = var.NOTION_PAGE_ID
    tfc_workspace  = "A-10"
    global_domain  = var.GLOBAL_DOMAIN
  }

  docker_registry = {
    org_username     = var.PR_CYBR_DOCKER_USER
    service_username = var.DOCKERHUB_USERNAME
    credentials_set  = coalesce(var.PR_CYBR_DOCKER_PASS, "") != "" && coalesce(var.DOCKERHUB_TOKEN, "") != ""
  }

  notion_databases = {
    discussions_arc       = var.NOTION_DISCUSSIONS_ARC_DB_ID
    issues_backlog        = var.NOTION_ISSUES_BACKLOG_DB_ID
    knowledge_file        = var.NOTION_KNOWLEDGE_FILE_DB_ID
    project_board_backlog = var.NOTION_PROJECT_BOARD_BACKLOG_DB_ID
    pr_backlog            = var.NOTION_PR_BACKLOG_DB_ID
    task_backlog          = var.NOTION_TASK_BACKLOG_DB_ID
  }

  security_tokens = {
    agent_actions = coalesce(var.AGENT_ACTIONS, "") != ""
    notion_token  = coalesce(var.NOTION_TOKEN, "") != ""
    tfc_token     = coalesce(var.TFC_TOKEN, "") != ""
  }
}

output "agent_overview" {
  description = "High-level snapshot of the agent workspace context"
  value = {
    workspace = local.agent_workspace
    docker    = local.docker_registry
    notion    = local.notion_databases
    tokens    = local.security_tokens
  }
  sensitive = true
}
