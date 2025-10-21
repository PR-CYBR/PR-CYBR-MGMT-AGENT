# AgentKit Overview

AgentKit enables this agent to run autonomous domain tasks and integrate with OpenAI Codex via the `/plan` command.

## Adding a New Task

1. Edit `agentkit/config.yaml` and append a new task block with an `id`, `command`, and `output`.
2. Define triggers in the `triggers` section, either `manual` (with event) or `scheduled` (with cron expression).
3. If tasks require credentials, store them as secrets in the repository or environment.
4. Test locally by running `python agentkit/runner.py`.

## Triggers

- **Manual**: run tasks via comments or commands like `/status`.
- **Scheduled**: schedule tasks using cron expressions.
- **Event-Driven**: respond to project board or repository events (future integration).

## Codex Integration

AgentKit uses OpenAI Codex for planning tasks via the `/plan` command. When Codex is unavailable, it falls back to local scripts, as defined in `config.yaml`.
