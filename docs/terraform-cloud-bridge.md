# Terraform Cloud Workflow Bridge

This repository uses the HashiCorp Terraform Cloud workflow bridge so that GitHub only triggers remote runs while secrets remain
inside Terraform Cloud workspaces. The `.github/workflows/tfc-sync.yml` workflow uploads the configuration that changed in the
repository and creates a new API-driven run inside Terraform Cloud.

## Required configuration

Set the following repository **variables** so the workflow knows which Terraform Cloud resources to target:

| Variable | Purpose |
| --- | --- |
| `TF_CLOUD_ORGANIZATION` | Name of the Terraform Cloud organization that hosts the workspace. |
| `TF_CLOUD_HOSTNAME` | Optional custom hostname. Default is `app.terraform.io`. |
| `TF_WORKSPACE` | Terraform Cloud workspace that owns the configuration. |
| `TF_CONFIGURATION_DIRECTORY` | Relative directory of the Terraform configuration in this repo. Use `.` for the repository root. |
| `TF_PROJECT` | Optional Terraform Cloud project label for auditing. |

Generate a **Terraform Cloud workflow token** from the target workspace (Settings → Access → Workflow tokens) and store it as the
`TF_API_TOKEN` GitHub secret. Workflow tokens are short-lived and can be rotated without exposing the workspace’s environment
variables to GitHub.

> **Important:** Do not copy Terraform variables or credentials into GitHub secrets. Keep them defined as Terraform Cloud
> workspace variables or variable sets so they remain centralized in Terraform Cloud.

## Trigger behavior

- **Pull requests** always perform a speculative plan (`plan_only: true`) and fail if the plan does not finish successfully.
- **Pushes** to the `codex` and `agents` branches run speculative plans for fast feedback.
- **Pushes** to `main` run an apply. The workflow fails if Terraform Cloud reports any status other than `applied`.
- Manual `workflow_dispatch` runs can be used for ad hoc plans or applies.

GitHub logs include a direct link to the Terraform Cloud run for additional details and policy checks.
