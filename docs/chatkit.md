# ChatKit Overview

ChatKit provides interactive dashboards and human-in-the-loop controls for this agent.

## Adding Widgets

1. Create a YAML file under `chatkit/` (e.g., `chatkit/dashboard.yaml`).
2. Define widgets with a `type` and optional settings such as `source` and `refresh`.
3. Reference the widget file in `chatkit/dashboard.yaml` under the `widgets` list.

## Human-in-the-Loop

The dashboard includes a human-in-the-loop widget where users can approve tasks or submit manual requests. Approvals and submissions are synced with the Agent-DB in Notion.
