### **OPORD-0007**

#### **1. Situation**
A centralized system is required to ensure that all new OPORD files added to the `docs/OPORD/` directory in Agent repositories are reflected in a shared Google Sheet. This will ensure visibility and tracking of all OPORDs in a single location.

---

#### **2. Mission**
All Agents will implement a workflow that triggers upon detecting new or updated OPORD files in their `docs/OPORD/` directory. This workflow will update a designated Google Sheet with details about the OPORD, including:
- OPORD ID
- Agent Name
- Date of Update
- File Path (Relative to Repo)

---

#### **3. Execution**

**a. General Instructions**  
Each Agent repository will include a GitHub Action workflow file named `.github/workflows/update-google-sheet.yml`.  

This workflow will:
1. Trigger when new files are added to `docs/OPORD/`.
2. Authenticate with the Google Sheets API using service account credentials.
3. Append a row to the shared Google Sheet with the following details:
   - OPORD ID
   - Agent Repository Name
   - Date of File Update
   - File Path (`docs/OPORD/<filename>`)

---

**b. Implementation Steps**  
Below is the standard workflow file to be added to all Agent repositories:

```yaml
name: Update Google Sheet

on:
  push:
    paths:
      - 'docs/OPORD/**'

jobs:
  update-google-sheet:
    name: Update Google Sheet with OPORD Details
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout Repository
      - name: Checkout Repository
        uses: actions/checkout@v3

      # Step 2: Extract File Information
      - name: Extract OPORD Details
        id: extract
        run: |
          echo "FILE_NAME=$(basename $(git diff --name-only HEAD^ HEAD | grep 'docs/OPORD/'))" >> $GITHUB_ENV
          echo "AGENT_NAME=${{ github.repository }}" >> $GITHUB_ENV
          echo "DATE_UPDATED=$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> $GITHUB_ENV

      # Step 3: Update Google Sheet
      - name: Update Google Sheet
        uses: google-github-actions/write-to-sheet@v1
        with:
          credentials_json: ${{ secrets.GOOGLE_SHEETS_CREDENTIALS }}
          spreadsheet_id: '<GOOGLE_SHEET_ID>'
          range: 'Sheet1!A:D'
          values: |
            - [ ${{ env.FILE_NAME }}, ${{ env.AGENT_NAME }}, ${{ env.DATE_UPDATED }}, docs/OPORD/${{ env.FILE_NAME }} ]
```

**c. Coordinating Instructions**

• **All Agents** must implement this workflow in their respective repositories.

• A shared secret (GOOGLE_SHEETS_CREDENTIALS) must be added to each repository. This secret will store the Google Sheets API credentials in JSON format.

• The Google Sheet must have a predefined structure:

• **Column A**: OPORD ID

• **Column B**: Agent Name

• **Column C**: Date of Update

• **Column D**: File Path

**4. Sustainment**

  

• The Google Sheet will serve as a centralized dashboard for all OPORD files.

• Periodic reviews will ensure the workflow is functioning as intended.

**5. Command and Signal**

  

• **Command**: The PR-CYBR-MGMT-AGENT will oversee the successful deployment of this workflow across all Agent repositories.

• **Signal**: Updates to the Google Sheet will confirm the workflow’s success.

