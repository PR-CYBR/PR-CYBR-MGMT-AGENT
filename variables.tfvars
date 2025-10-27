# Terraform Cloud workspace variable mappings for PR-CYBR Management Agent
# Replace placeholder values in Terraform Cloud; these are documentation only.

# Docker / Registry
DOCKERHUB_TOKEN             = "<sensitive>"
DOCKERHUB_USERNAME          = "prcybr-bot"
PR_CYBR_DOCKER_PASS         = "<sensitive>"
PR_CYBR_DOCKER_USER         = "prcybr"

# Global Infrastructure URIs
GLOBAL_DOMAIN               = "example.com"
GLOBAL_ELASTIC_URI          = "https://elastic.example.com"
GLOBAL_GRAFANA_URI          = "https://grafana.example.com"
GLOBAL_KIBANA_URI           = "https://kibana.example.com"
GLOBAL_PROMETHEUS_URI       = "https://prometheus.example.com"

# Networking / Security
GLOBAL_TAILSCALE_AUTHKEY    = "<sensitive>"
GLOBAL_TRAEFIK_ACME_EMAIL   = "admin@example.com"
GLOBAL_TRAEFIK_ENTRYPOINTS  = "web,websecure"
GLOBAL_ZEROTIER_NETWORK_ID  = "abcdef123456"

# Agent Tokens
AGENT_ACTIONS               = "<sensitive>"
AGENT_COLLAB                = "<sensitive>"

# GitHub / Terraform Cloud Auth
GH_TOKEN                    = "<sensitive>"
GITHUB_TOKEN                = "<sensitive>"
TFC_TOKEN                   = "<sensitive>"

# Notion Integrations
NOTION_DISCUSSIONS_ARC_DB_ID       = "00000000000000000000000000000000"
NOTION_ISSUES_BACKLOG_DB_ID        = "00000000000000000000000000000000"
NOTION_KNOWLEDGE_FILE_DB_ID        = "00000000000000000000000000000000"
NOTION_PAGE_ID                     = "00000000000000000000000000000000"
NOTION_PR_BACKLOG_DB_ID            = "00000000000000000000000000000000"
NOTION_PROJECT_BOARD_BACKLOG_DB_ID = "00000000000000000000000000000000"
NOTION_TASK_BACKLOG_DB_ID          = "00000000000000000000000000000000"
NOTION_TOKEN                       = "<sensitive>"

# Assistant Runtime
ASSISTANT_ID                = "asst_example"
