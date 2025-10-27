# Orchestrator Alignment Resolution

_Last updated: 2025-04-28_

## Codex CLI Routing Architecture

The management agent now ships with a lightweight Codex CLI stub at
`scripts/codex`. The CLI ingests JSON payloads (via STDIN or a supplied
file), maps the `event_type` field to downstream agents, and emits a
normalized JSON response. Each invocation writes an audit entry to
`logs/codex_dispatch.log`, capturing the timestamp, original payload, and
selected agents. The current routing table is:

| Event type       | Target agents                           |
| ---------------- | ---------------------------------------- |
| `maintenance`    | `PR-CYBR-MGMT-AGENT`                     |
| `security_alert` | `PR-CYBR-SECURITY-AGENT`                 |
| `data_sync`      | `PR-CYBR-DATA-INTEGRATION-AGENT`         |

Additional event routes can be introduced by updating the
`ROUTING_TABLE` mapping within the CLI stub.

## Variable Scoping Rationale

Agent-specific Terraform variables are now defined exclusively in
`infra/agent-variables.tf`. This file declares the nine variables that
Terraform Cloud manages for A-10:

- `AGENT_ACTIONS`
- `NOTION_TOKEN`
- `NOTION_PAGE_ID`
- `NOTION_DISCUSSIONS_ARC_DB_ID`
- `NOTION_ISSUES_BACKLOG_DB_ID`
- `NOTION_KNOWLEDGE_FILE_DB_ID`
- `NOTION_PROJECT_BOARD_BACKLOG_DB_ID`
- `NOTION_TASK_BACKLOG_DB_ID`
- `TFC_TOKEN`

Global variables (e.g., `GLOBAL_DOMAIN`, `GLOBAL_PROMETHEUS_URI`) are
removed from this workspace to enforce strict agent-level scoping. The
Terraform output `codex_dispatch_matrix` surfaces only the data required
for orchestration and masks sensitive values via a sensitive output.

## TFC Sync Validation Procedure

1. Trigger the `tfc-sync` workflow (push to `codex`/`agents` or PR to
   `main`).
2. The workflow fetches workspace variables from Terraform Cloud and
   exports matching secrets into the job environment.
3. Terraform operations execute from `./infra`, ensuring only scoped
   agent variables are evaluated.
4. Review the summary log in the workflow run to confirm the exported
   variable list aligns with the agent workspace scope.

A manual validation can be performed with the Terraform Cloud API:

```bash
curl -s \
  --header "Authorization: Bearer $TFC_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  "https://app.terraform.io/api/v2/workspaces/$WORKSPACE_ID/vars" \
  | jq -r '.data[].attributes.key'
```

The output should list only the agent-scoped variables enumerated above.
