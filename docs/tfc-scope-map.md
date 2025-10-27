# Terraform Cloud Variable Scope Map

_Last updated: 2025-04-28_

The PR-CYBR program isolates Terraform Cloud variables per agent
workspace. Global service endpoints live exclusively in the management
(A-10) workspace and are distributed to subordinate agents through the
Codex orchestration layer. Agent workspaces therefore carry only the
secrets and identifiers they require for their individual automation
runs.

## Management Workspace

| Workspace | Agent code | Variable keys |
| --------- | ---------- | ------------- |
| `A-10`    | PR-CYBR-MGMT-AGENT | `AGENT_ACTIONS`, `NOTION_TOKEN`, `NOTION_PAGE_ID`, `NOTION_DISCUSSIONS_ARC_DB_ID`, `NOTION_ISSUES_BACKLOG_DB_ID`, `NOTION_KNOWLEDGE_FILE_DB_ID`, `NOTION_PROJECT_BOARD_BACKLOG_DB_ID`, `NOTION_TASK_BACKLOG_DB_ID`, `TFC_TOKEN` |

## Subordinate Agent Workspaces

Each subordinate workspace receives global context (e.g., `GLOBAL_DOMAIN`)
via dispatches from A-10 and stores only the credentials unique to the
agent. The following table summarizes the expected scope for the current
agent repositories that synchronize with Terraform Cloud.

| Repository | Expected variable focus |
| ---------- | ----------------------- |
| `PR-CYBR-FRONTEND-AGENT` | Frontend deployment toggles, API origins, feature flags. |
| `PR-CYBR-BACKEND-AGENT` | Service tokens, database connection handles. |
| `PR-CYBR-DATABASE-AGENT` | Database provisioning credentials, replication keys. |
| `PR-CYBR-INFRASTRUCTURE-AGENT` | Infrastructure provisioning tokens, cloud provider credentials. |
| `PR-CYBR-SECURITY-AGENT` | SIEM API keys, alert routing tokens. |
| `PR-CYBR-DATA-INTEGRATION-AGENT` | ETL service tokens, warehouse endpoints. |
| `PR-CYBR-PERFORMANCE-AGENT` | Monitoring collectors, benchmarking datasets. |
| `PR-CYBR-TESTING-AGENT` | QA environment toggles, synthetic user credentials. |
| `PR-CYBR-CI-CD-AGENT` | Pipeline runner secrets, artifact registry scopes. |

> **Note:** Global variables such as `GLOBAL_DOMAIN`, `GLOBAL_ELASTIC_URI`,
> `GLOBAL_GRAFANA_URI`, `GLOBAL_PROMETHEUS_URI`, `GLOBAL_TAILSCALE_AUTHKEY`,
> `GLOBAL_TRAEFIK_ACME_EMAIL`, and `GLOBAL_ZEROTIER_NETWORK_ID` are managed
> centrally by the A-10 workspace. Individual agent workspaces should
> reference these values through Codex-delivered context rather than
> storing them locally.

## Inheritance Logic

1. Codex processes incoming events, determines the destination agents,
   and enriches the dispatch payload with the required global context.
2. Agents receive only the global values they need to execute their
   Terraform plans, keeping sensitive material centralized in the
   management workspace.
3. Terraform Cloud environment variables within each agent workspace are
   audited routinely against this scope map to ensure no global keys have
   leaked into subordinate workspaces.
