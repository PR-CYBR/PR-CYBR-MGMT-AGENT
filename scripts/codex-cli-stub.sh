#!/bin/bash
# Mock Codex CLI for testing workflow execution
# This stub implementation provides basic functionality for the maintenance workflow

set -e

COMMAND="$1"
shift

case "$COMMAND" in
  analyze)
    # Parse arguments
    OUTPUT_FORMAT="text"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --output-format=*)
          OUTPUT_FORMAT="${1#*=}"
          shift
          ;;
        --output-format)
          OUTPUT_FORMAT="$2"
          shift 2
          ;;
        *)
          shift
          ;;
      esac
    done

    # Read input from stdin if available (for future use with real implementation)
    if [ -t 0 ]; then
      INPUT=""
    else
      INPUT=$(cat)
    fi

    # Generate mock output based on format
    if [ "$OUTPUT_FORMAT" = "json" ]; then
      # Return a mock JSON response with no agents (safe default)
      TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
      echo '{"agents": [], "analysis": "Mock analysis - no agents needed", "timestamp": "'$TIMESTAMP'"}'
    else
      echo "Mock analysis completed. No target agents identified."
    fi
    ;;

  dispatch)
    echo "Mock dispatch executed successfully"
    ;;

  --version)
    echo "codex-cli-stub v1.0.0"
    ;;

  --help|help)
    cat <<EOF
Codex CLI Stub - Mock Implementation for Testing

Usage:
  codex analyze [--output-format=FORMAT]
    Analyze input and determine target agents
    
  codex dispatch [--targets=TARGETS]
    Dispatch to specified targets
    
  codex --version
    Display version information
    
  codex --help
    Display this help message

This is a stub implementation for testing purposes.
EOF
    ;;

  *)
    echo "Error: Unknown command '$COMMAND'" >&2
    echo "Run 'codex --help' for usage information" >&2
    exit 1
    ;;
esac
