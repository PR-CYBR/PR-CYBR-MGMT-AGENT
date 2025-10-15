#!/usr/bin/env bash

set -uo pipefail

SCRIPT_NAME="setup"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${PR_CYBR_LOG_DIR:-$SCRIPT_DIR/../logs}"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}.log"
RUN_ID="${PR_CYBR_RUN_ID:-$(date +%s)}"
CENTRAL_LOG_ENDPOINT="${CENTRAL_LOG_ENDPOINT:-}"
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
APT_UPDATED=0
FAILURES=0
FORCED_CONTEXT=""
RUN_CONTEXT="undetermined"

usage() {
    cat <<USAGE
Usage: $0 [options]

Options:
  --interactive        Force interactive context handling.
  --automation         Force automation context handling (non-interactive).
  --help               Show this help message.

Environment variables:
  CENTRAL_LOG_ENDPOINT   HTTPS endpoint that accepts JSON log payloads.
  SLACK_WEBHOOK_URL      Slack webhook URL for mirroring log messages.
  PR_CYBR_LOG_DIR        Directory to store local log files (default: ../logs).
  PR_CYBR_RUN_ID         Identifier attached to remote log messages.
  ALLOW_INSTALL_IN_AUTOMATION
                         Permit package installations during automation runs when set.
USAGE
}

json_escape() {
    local raw="$1"
    raw="${raw//\\/\\\\}"
    raw="${raw//\"/\\\"}"
    raw="${raw//$'\n'/\\n}"
    raw="${raw//$'\r'/\\r}"
    printf '%s' "$raw"
}

log_to_central() {
    local level="$1"
    local message="$2"
    [[ -z "$CENTRAL_LOG_ENDPOINT" ]] && return 0
    local payload
    payload="{\"timestamp\":\"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\",\"level\":\"$level\",\"context\":\"$RUN_CONTEXT\",\"message\":\"$(json_escape "$message")\",\"run_id\":\"$RUN_ID\",\"script\":\"$SCRIPT_NAME\"}"
    curl -sS -m 5 -H "Content-Type: application/json" -X POST -d "$payload" "$CENTRAL_LOG_ENDPOINT" >/dev/null 2>&1 || true
}

log_to_slack() {
    local level="$1"
    local message="$2"
    [[ -z "$SLACK_WEBHOOK_URL" ]] && return 0
    local payload
    payload="{\"text\":\"[$SCRIPT_NAME][$RUN_CONTEXT][$level] $(json_escape "$message")\"}"
    curl -sS -m 5 -H "Content-Type: application/json" -X POST -d "$payload" "$SLACK_WEBHOOK_URL" >/dev/null 2>&1 || true
}

log_message() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local formatted="${timestamp} [$level] $message"
    echo "$formatted" | tee -a "$LOG_FILE"
    log_to_central "$level" "$message"
    log_to_slack "$level" "$message"
}

detect_context() {
    if [[ -n "$FORCED_CONTEXT" ]]; then
        RUN_CONTEXT="$FORCED_CONTEXT"
    elif [[ -n "${PR_CYBR_AUTOMATION:-}" || -n "${CI:-}" || ! -t 1 ]]; then
        RUN_CONTEXT="automation"
    else
        RUN_CONTEXT="interactive"
    fi
}

run_privileged() {
    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        "$@"
    fi
}

apt_update_once() {
    [[ $APT_UPDATED -eq 1 ]] && return 0
    if command -v apt-get >/dev/null 2>&1; then
        log_message "Updating apt package index..."
        if run_privileged apt-get update -y >/dev/null 2>&1; then
            APT_UPDATED=1
        else
            log_message "Failed to update apt package index." "WARN"
        fi
    fi
}

attempt_install() {
    local package="$1"
    local friendly="$2"
    if [[ -z "$package" ]]; then
        return 1
    fi
    if [[ "$RUN_CONTEXT" == "automation" && -z "${ALLOW_INSTALL_IN_AUTOMATION:-}" ]]; then
        log_message "Skipping automatic installation of $friendly in automation context." "WARN"
        return 1
    fi
    if command -v apt-get >/dev/null 2>&1; then
        apt_update_once
        log_message "Attempting to install $friendly via apt-get..."
        if run_privileged apt-get install -y "$package" >/dev/null 2>&1; then
            log_message "$friendly installed successfully via apt-get." "SUCCESS"
            return 0
        fi
        log_message "Failed to install $friendly via apt-get." "WARN"
    fi
    if command -v brew >/dev/null 2>&1; then
        log_message "Attempting to install $friendly via Homebrew..."
        if brew install "$package" >/dev/null 2>&1; then
            log_message "$friendly installed successfully via Homebrew." "SUCCESS"
            return 0
        fi
        log_message "Failed to install $friendly via Homebrew." "WARN"
    fi
    log_message "Automatic installation is unavailable for $friendly. Please install it manually." "ERROR"
    return 1
}

ensure_service_active() {
    local service="$1"
    local friendly="$2"
    if command -v systemctl >/dev/null 2>&1; then
        if ! systemctl is-active --quiet "$service" >/dev/null 2>&1; then
            log_message "$friendly service is not active. Attempting to start..." "WARN"
            if run_privileged systemctl start "$service" >/dev/null 2>&1; then
                log_message "$friendly service started successfully." "SUCCESS"
                return 0
            fi
            log_message "Unable to start $friendly service." "ERROR"
            return 1
        fi
        return 0
    elif command -v service >/dev/null 2>&1; then
        if ! service "$service" status >/dev/null 2>&1; then
            log_message "$friendly service is not active. Attempting to start..." "WARN"
            if run_privileged service "$service" start >/dev/null 2>&1; then
                log_message "$friendly service started successfully." "SUCCESS"
                return 0
            fi
            log_message "Unable to start $friendly service." "ERROR"
            return 1
        fi
        return 0
    else
        log_message "Cannot verify $friendly service state (no service manager detected)." "WARN"
        return 1
    fi
}

verify_command_health() {
    local command="$1"
    local health_check="$2"
    if [[ -z "$health_check" ]]; then
        "$command" --version >/dev/null 2>&1
        return $?
    fi
    eval "$health_check" >/dev/null 2>&1
}

ensure_dependency() {
    local command="$1"
    local friendly="$2"
    local package_name="$3"
    local health_check="${4:-}"
    local service_name="${5:-}"

    if command -v "$command" >/dev/null 2>&1; then
        log_message "$friendly is installed. Running health check..."
        if verify_command_health "$command" "$health_check"; then
            log_message "$friendly passed health check." "SUCCESS"
        else
            log_message "$friendly health check failed. Attempting remediation..." "WARN"
            if [[ -n "$service_name" ]]; then
                if ! ensure_service_active "$service_name" "$friendly"; then
                    ((FAILURES++))
                    return 1
                fi
            else
                ((FAILURES++))
                return 1
            fi
        fi
    else
        log_message "$friendly is missing. Attempting self-healing..." "WARN"
        if attempt_install "$package_name" "$friendly"; then
            log_message "$friendly installed successfully." "SUCCESS"
        else
            log_message "Failed to remediate $friendly." "ERROR"
            ((FAILURES++))
            return 1
        fi
    fi
}

perform_environment_checks() {
    ensure_dependency "vault" "HashiCorp Vault" "vault" "vault --version"
    ensure_dependency "tailscale" "Tailscale" "tailscale" "tailscale version" "tailscaled"
    ensure_dependency "docker" "Docker" "docker.io" "docker --version" "docker"
    ensure_dependency "gh" "GitHub CLI" "gh" "gh --version"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --interactive)
            FORCED_CONTEXT="interactive"
            ;;
        --automation|--non-interactive)
            FORCED_CONTEXT="automation"
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            log_message "Unknown option: $1" "WARN"
            usage
            exit 1
            ;;
    esac
    shift
done

trap 'log_message "Script terminated unexpectedly." "ERROR"' ERR

detect_context
log_message "Starting setup script in $RUN_CONTEXT context. Logs: $LOG_FILE"

perform_environment_checks

if (( FAILURES > 0 )); then
    log_message "Setup completed with $FAILURES unresolved issue(s)." "ERROR"
    exit 1
fi

log_message "Setup validation completed successfully. Environment is ready." "SUCCESS"
exit 0
