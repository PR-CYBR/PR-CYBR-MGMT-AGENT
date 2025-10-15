#!/usr/bin/env bash
set -euo pipefail

category="${1:-unspecified}"
reports_dir="${2:-reports}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required to log to A-10-RUNS-BOARD" >&2
  exit 1
fi

if [[ -z "${A10_RUNS_BOARD_WEBHOOK:-}" ]]; then
  echo "A10_RUNS_BOARD_WEBHOOK not provided; skipping log to A-10-RUNS-BOARD." >&2
  exit 0
fi

repo="${GITHUB_REPOSITORY:-local/test}"
run_id="${GITHUB_RUN_ID:-0}"
workflow="${GITHUB_WORKFLOW:-unknown}"
run_url="${GITHUB_SERVER_URL:-https://github.com}/${repo}/actions/runs/${run_id}"

payload=$(jq -n \
  --arg repo "$repo" \
  --arg run_id "$run_id" \
  --arg workflow "$workflow" \
  --arg category "$category" \
  --arg reports "$reports_dir" \
  --arg url "$run_url" \
  '{repo: $repo, run_id: $run_id, workflow: $workflow, category: $category, reports: $reports, url: $url, timestamp: (now | todate)}')

curl -sSf -X POST -H "Content-Type: application/json" -d "$payload" "$A10_RUNS_BOARD_WEBHOOK"
