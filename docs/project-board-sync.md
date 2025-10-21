# Project Board Sync Setup  

## Overview  
This document describes how each PR-CYBR agent repository should configure its GitHub Projects board and automate synchronization with the Agent-DB in Notion. The goal is to make each board the single source of truth for tasks and to integrate seamlessly with AgentKit automations. By following these instructions, you will ensure that moving cards on the board triggers the right automation, updates Notion, and aggregates status across the organisation.  

## Adding Custom Fields  
Each agent project already has a project board. To support automation and syncing, add the following custom fields:  
- **Phase** – Single-select with options such as *Planning*, *Development*, *Testing*, *Deployment* and *Completed*.  
- **Priority** – Single-select with values *Low*, *Medium*, *High*, *Critical*.  
- **Due Date** – Date field to specify when the task should be completed.  
- **HITL Required** – Single‑select (Yes/No) to flag tasks that need human‑in‑the‑loop review.  
- **Notion ID** – Text field to store the UUID of the corresponding row in the Notion database.  

To add these fields:  
1. Open the project board (Projects → your board).  
2. Click **Settings** (•••) → **Fields** → **+ New field**.  
3. Enter the field name, choose the type, and define options where appropriate.  
4. Save each field.  

## Saved Views  
Create two views to help agents and managers track progress:  
1. **Development Roadmap** – A **table view** grouped by the *Phase* field. This view acts as a roadmap, showing tasks across phases.  
2. **Progress Tracker** – A **board view** grouped by the built‑in *Status* field (columns like *Todo*, *In Progress*, *Ready for Automation*, *Manual Approval*, *Done*). This view helps track work as it flows from left to right.  

To add a view: click **New view**, choose **Table** or **Board**, name it appropriately, then use the view options to group by the relevant field.  

## Automation Rules  
GitHub Projects supports workflow rules. Configure the following rules on each board (via the **Workflows** tab):  
- **Ready for Automation**: When an item is created or moved into the *Ready for Automation* status, call the appropriate AgentKit task. For example, if the task title is “build frontend”, the rule should run `/plan build-frontend` through AgentKit.  
- **Manual Approval**: When an item is moved into *Manual Approval*, send a notification to the assigned reviewer (via Slack or your preferred channel) and pause automation until approval is granted.  
- **Done**: When an item is completed (moved to *Done*), automatically post a comment with a link to the deployed artifact and open a Discussion summarising the changes.  

These rules can be built using GitHub’s built‑in workflow editor or through a custom GitHub Actions workflow if more flexibility is required.  

## GitHub Actions Workflow for Notion Sync  
Add a workflow file `.github/workflows/project-sync.yml` to each agent repository. This workflow listens for `projects_v2_item` events and syncs the card data with Notion. Use the following outline:  
```yaml  
name: Notion ↔ GitHub Board Sync  
on:  
  projects_v2_item:  
    types: [created, edited, moved, deleted]  
jobs:  
  sync:  
    runs-on: ubuntu-latest  
    permissions:  
      projects: read  
      contents: read  
      issues: write  
      discussions: write  
    steps:  
      - uses: actions/checkout@v4  
      - uses: actions/setup-node@v4  
        with:  
          node-version: 20  
      - run: npm install @notionhq/client node-fetch  
      - name: Sync to Notion  
        env:  
          NOTION_API_KEY: ${{ secrets.NOTION_API_KEY }}  
          NOTION_DATABASE_ID: ${{ secrets.NOTION_DATABASE_ID }}  
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  
        run: node .github/scripts/sync-notion.js  
```  
In the `sync-notion.js` script, query the GitHub GraphQL API for the item details (Title, Phase, Priority, Status, Notion ID). Map those fields to Notion properties and either create or update a page in Agent‑DB. When creating a new page, capture the returned Notion page ID and write it back into the board’s *Notion ID* field. Use environment variables for secrets; never hard‑code tokens.  

## Organisation‑Level Board  
At the organisation level (PR‑CYBR), create a Projects board (e.g., **Unified Operations Board**) that aggregates items from all agent boards. Link each agent board to this org board via “Link project”. Configure saved views such as:  
- **Agent Progress Overview** – group by the *Assigned Agent* field to see workload distribution.  
- **Critical Path** – filter where *Priority* = *Critical* to highlight urgent items.  
- **Automation Queue** – filter where *Status* = *Ready for Automation* to monitor upcoming automations.  
This board gives managers a cross‑project snapshot while preserving each agent’s autonomy.  

## Secrets Management and Security  
- Store the `NOTION_API_KEY` and `NOTION_DATABASE_ID` as organisation or repository secrets in GitHub. Use **GitHub Environments** if you need separate values for staging vs. production.  
- Do **not** commit any API keys or tokens to the repository. Only reference them via `${{ secrets.SECRET_NAME }}` in workflows.  
- Give workflows the minimal permissions required (e.g., read for projects, write for discussions) and rotate secrets periodically.  
- When defining AgentKit commands, ensure they run only on trusted branches and avoid executing arbitrary code from card titles.  
- Use branch protection and required reviews to prevent unauthorised modifications to workflow files.  

## Troubleshooting  
- **Field mismatch**: If the workflow errors about missing fields, verify that the custom fields on the board match the names used in the script.  
- **No Notion update**: Confirm that the `NOTION_API_KEY` and `NOTION_DATABASE_ID` secrets are correctly configured, and that the Notion integration has permission to access the database.  
- **Automation didn’t run**: Check the Workflows tab for rule execution logs. Make sure the item moved into the correct status column.  
- **Discussion not created**: Ensure the workflow has `discussions: write` permission and that the repository allows discussions.  

---  
By following these steps, each agent’s project board becomes a living blueprint, automatically synchronising with Notion and triggering AgentKit operations. This reduces manual overhead—¡automatizamos las tareas aburridas para que puedas enfocarte en la misión!
