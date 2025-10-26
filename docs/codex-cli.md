# Codex CLI

A lightweight event analysis tool for the PR-CYBR orchestrator workflow.

## Overview

The Codex CLI is used by the orchestrator workflow to analyze incoming events and determine which PR-CYBR agents should be dispatched to handle them. This is a stub implementation that provides basic routing logic.

## Usage

### Analyze an event

```bash
# From stdin
echo '{"event_type": "security_alert"}' | ./scripts/codex analyze --output-format=json

# From a file
./scripts/codex analyze --input event.json --output-format=json
```

### Output Format

The tool outputs JSON with the following structure:

```json
{
  "status": "success",
  "event_type": "security_alert",
  "agents": ["PR-CYBR-SECURITY-AGENT"],
  "message": "Analyzed event of type 'security_alert', identified 1 agent(s)"
}
```

## Event Routing Logic

The current implementation uses simple routing rules:

- `security_alert` → `PR-CYBR-SECURITY-AGENT`
- `data_sync` → `PR-CYBR-DATA-INTEGRATION-AGENT`
- `maintenance` or `health_check` → No agents (handled internally)
- Unknown/null events → No agents

## Integration with Workflow

The orchestrator workflow (`.github/workflows/maintenance.yml`) uses this tool in the following way:

1. Checkout the repository
2. Install dependencies (Python, jq, etc.)
3. Run `codex analyze` with the event payload
4. Parse the output to extract the list of agents
5. Dispatch events to the identified agents via GitHub API

## Future Enhancements

This is a stub implementation. Future versions should:

- Support more sophisticated event analysis
- Include machine learning for intelligent routing
- Provide detailed reasoning for agent selection
- Support priority and dependency management
- Include validation and error handling for edge cases

## Testing

Run the test suite:

```bash
# Basic functionality test
echo "null" | python3 scripts/codex analyze --output-format=json

# Security alert test
echo '{"event_type":"security_alert"}' | python3 scripts/codex analyze --output-format=json
```

## Requirements

- Python 3.8+
- No external dependencies (uses only stdlib)
