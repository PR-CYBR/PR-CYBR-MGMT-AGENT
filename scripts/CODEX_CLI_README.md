# Codex CLI Stub

## Overview

This is a mock implementation of the Codex CLI tool used by the PR-CYBR-MGMT-AGENT orchestrator workflow.

## Purpose

The `codex-cli-stub.sh` script provides a minimal, functional implementation of a Codex CLI that:
- Accepts `analyze` and `dispatch` commands
- Returns properly formatted JSON output
- Allows the maintenance workflow to run without errors

## Installation

The Codex CLI stub is automatically installed by the GitHub Actions workflow in `.github/workflows/maintenance.yml`:

```bash
cp scripts/codex-cli-stub.sh /usr/local/bin/codex
chmod +x /usr/local/bin/codex
```

## Usage

### Analyze Command
```bash
echo '{"event": "data"}' | codex analyze --output-format=json
```

Returns a JSON object with:
- `agents`: Array of target agents (empty by default)
- `analysis`: Analysis description
- `timestamp`: ISO 8601 timestamp

### Dispatch Command
```bash
codex dispatch --targets=auto
```

### Version
```bash
codex --version
```

### Help
```bash
codex --help
```

## Replacing with Real Implementation

To replace this stub with a real Codex CLI implementation:

1. Update the installation step in `.github/workflows/maintenance.yml`
2. Replace the installation command with the official Codex CLI installer
3. Ensure the real implementation supports the same command interface

## Mock Behavior

By default, the stub returns an empty agent list, which causes the workflow to skip dispatching (safe default behavior). To customize the mock behavior, edit the `analyze` case in `scripts/codex-cli-stub.sh`.
