# A-10-RUNS-BOARD Logging

The CI security workflows add a standardized log entry to the A-10-RUNS-BOARD so that HITL stakeholders can trace coverage and approvals across security control families.

## Workflows Covered

| Workflow | Category Logged | Reports Folder |
| --- | --- | --- |
| `CI Secrets Scan` | `secrets` | `/reports/` |
| `CI Vulnerability Scan` | `application-security` | `/reports/` |
| `CI Container Scan` | `container-security` | `/reports/` |

Each workflow calls [`scripts/log-to-a10-board.sh`](../scripts/log-to-a10-board.sh) after generating its reports. The script builds a JSON payload containing:

- Repository, workflow name, and GitHub run identifier.
- The security category and path to the structured reports archived for review.
- A timestamp and deep link back to the GitHub Actions run.

The payload is sent to the `A10_RUNS_BOARD_WEBHOOK` secret. Configure this webhook to forward the JSON payload into the A-10-RUNS-BOARD data store or dashboard. The script fails fast if `jq` is unavailable and skips logging gracefully if the webhook is not configured, ensuring that workflows do not fail purely due to missing integration.

## HITL Review Process

Each workflow defines an environment gate (`hitl-secrets-approval`, `hitl-vulnerability-approval`, and `hitl-container-approval`). Configure these environments in the repository settings with the required HITL reviewers. Until approval is granted in GitHub, the associated job remains pending, which enforces the required status check and blocks merge. Notifications are posted to Slack and on the pull request (tagging A-07) so reviewers know when their approval is needed. After approvals are recorded, the workflows complete and the log entry is already available on the A-10-RUNS-BOARD for audit tracking.
