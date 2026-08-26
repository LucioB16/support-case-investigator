---
name: support-case-investigator
description: Investigate customer support cases involving Dataverse, Dynamics 365 CE/CRM, Power Platform, Power Automate, Azure Logic Apps, C#, JavaScript, Dataverse plugins, web resources, PCF controls, solutions, and Power Apps. Use when Codex must recover case context from a coding-assistant workspace, validate target environment access, inspect Dataverse or related Microsoft business application artifacts primarily through the Dataverse Web API, preserve query evidence in files, and produce actionable support next steps.
---

# Support Case Investigator

Use this skill to run practical support investigations for Microsoft business application environments. Prefer evidence-backed findings over tutorial-style explanations, and do not invent tenant, environment, solution, app, workflow, table, record, user, timestamp, or error details.

## Core Rules

- Recover case context from the current workspace before asking the user for anything.
- Do not start API investigation until these are known: the customer request or support problem, the target Dataverse environment or organization URL, and enough context to choose an investigation area.
- Prefer Dataverse Web API inspection over UI-only inspection.
- Search for and load only the relevant existing skills before building queries.
- Keep all API requests, responses, errors, and interpretations in workspace files.
- Never run interactive Azure login commands. Give all `az login` commands to the user to run manually.
- Only run non-interactive Azure CLI status or token commands such as `az account show`, `az account list`, and `az account get-access-token`.
- If authentication fails, inspect the exact error and propose the next most likely Azure CLI command. Do not assume one command works universally.
- If automated access is blocked, prepare browser-friendly Web API query files and continue from pasted JSON results.

## Workflow

1. Discover workspace context.
2. Confirm required context and access.
3. Select relevant companion skills.
4. Authenticate and obtain a Dataverse token.
5. Build and execute focused Web API queries.
6. Store one query and result per evidence file.
7. Analyze evidence and produce the final support report.

## Workspace Discovery

First inspect the current workspace used by Claude Code, Codex, Antigravity, Cursor, or any similar coding assistant. Look for evidence in local files before asking the user:

- README files, markdown notes, tickets, handoffs, prior investigation notes, support summaries, scratch files.
- JSON, CSV, XML, log, HAR, text, and script files.
- Environment files and configuration files such as `.env`, `.env.*`, `appsettings*.json`, `pac` or Power Platform config, Azure config hints, deployment settings, solution unpack folders.
- Dataverse, Dynamics, Power Platform, Power Automate, Logic Apps, C#, JavaScript, TypeScript, PCF, plugin, web resource, and workflow artifacts.
- Terminal history or command output files when available.

Extract and summarize any available:

- Customer request and experienced problem.
- Target organization URL or environment URL.
- Tenant ID or tenant domain.
- Solution, app, cloud flow, classic workflow, Logic App, plugin, custom API, table, column, view, form, web resource, PCF control, or component name.
- Record ID, user ID, owner/team ID, business unit ID, workflow ID, process ID, plugin step ID, correlation ID, operation ID, error code, error message, timestamp, region, and reproduction steps.

If any required context is missing after workspace discovery, stop and ask the user for the missing items:

- The customer request or support problem.
- The target environment or organization URL.
- Enough context to decide what area to investigate.

## Companion Skill Selection

Before constructing queries, search the available skill list and load only the relevant skills for the case. Consider skills for:

- Dataverse overview and Web API.
- Dynamics 365 CE/CRM.
- Power Platform and Power Apps.
- Power Automate and Azure Logic Apps workflow definitions.
- Dataverse plugins and C# server-side code.
- Dataverse web resources and JavaScript.
- PCF controls.
- Solution management and ALM.

Use companion skills for their detailed conventions, but keep this skill as the investigation coordinator and evidence-recording authority.

## Authentication

Use Azure CLI when possible. Confirm that the organization URL is the resource URL, for example `https://ORG.crm.dynamics.com/`.

### Azure CLI Execution Boundary

Before running any Azure CLI commands, you must ensure the session is isolated to the correct client environment by utilizing the local `set-account script` script.

1. **Find the isolated context script (`set-account script`)**: Since you usually run inside a support case subfolder, search up the directory tree (e.g., `..\set-account script` or `..\..\set-account script`) to locate the client's `set-account script` script.
2. **Set the context**: If found, execute it (e.g., `..\set-account script`) via a non-interactive shell command (Bash or PowerShell) to inject the isolated `AZURE_CONFIG_DIR` into your terminal session.
3. **Execute Azure CLI commands**: Once the context is set, you may execute read-only Azure CLI status checks (`az account show`) or token retrieval (`az account get-access-token`).
4. **Repair connection**: If authentication fails or the token has expired, do NOT run interactive login yourself. Ask the user to run the script with the `-Login / --login` flag (e.g., `..\set-account script -Login / --login`) to interactively repair the connection. Wait for them to confirm success.
5. **Create missing script**: If the `set-account script` script does not exist in the client root folder, propose creating it with the standard isolated authentication template (sets `AZURE_CONFIG_DIR` to `$HOME\.azure-<client-slug>` and provides a `-Login / --login` switch for `az login --allow-no-subscriptions`).

Preferred token command:

```shell
az account get-access-token --resource "https://ORG.crm.dynamics.com/" --query accessToken -o tsv
```

If the user is not logged in or authentication fails:

- Stop and explicitly ask the user to repair the connection by running `..\set-account script -Login / --login` manually in their terminal.
- Do not run `az login` directly. Always rely on the client's `set-account script` wrapper to preserve isolation.
- Read the exact error. If the error persists after running the `-Login / --login` script, inspect for deeper issues (such as missing subscriptions or network constraints).
- **Pitfall Note**: If `az account get-access-token` fails with `invalid_grant AADSTS50173` *even after* the user successfully ran the login script, it usually means the Dataverse API requires a specific scope that wasn't granted during a generic login. Check if the error asks for a scope (e.g. `az login --scope https://ORG.crm.dynamics.com//.default`). If so, adjust the client's `set-account script` script to accept and pass this `--scope` parameter to `az login` alongside `--allow-no-subscriptions`. (Always keep `--allow-no-subscriptions` because Dynamics users often lack Azure subscriptions).
- **Pitfall Note 2 (Process Isolation)**: When using the command execution tool, every execution runs in a fresh, isolated process. If you run `. \set-account script` in one tool call, the `AZURE_CONFIG_DIR` environment variable is instantly lost when that command finishes. If you then run `az account get-access-token` in a subsequent tool call, Azure CLI will use the global profile instead of the isolated client profile, leading to misleading `invalid_grant AADSTS50078` (MFA expired) errors. **Solution**: You MUST group the `. \set-account script` execution, token retrieval, and your `curl/Invoke-RestMethod` calls into the EXACT SAME shell script block or file execution.

### Recurrent Scope-Switching Failures

Keep one client-level `set-account script` profile for isolated or one-time authentication failures. Escalate to separate scope profiles ONLY when workspace or conversation evidence shows that the same client repeatedly encounters `AADSTS50078`, `InteractionRequired`, or explicit "Please log in with --scope ..." errors while switching between stable resources, and the Process Isolation solution above did not resolve the issue. Do not create multiple profiles for a single transient failure.

For recurrent clients:

1. Inventory the scopes actually used, normally management, each Dataverse organization (DEV and PROD separately), and Power Automate.
2. Create one fixed-scope wrapper per resource in the client root, for example:
   - `set-account-management.ps1`
   - `set-account-dataverse-dev.ps1`
   - `set-account-dataverse-prod.ps1`
   - `set-account-power-automate.ps1`
3. Give every wrapper its own Azure CLI cache by setting:
   - `$HOME\.azure-<client-slug>-management`
   - `$HOME\.azure-<client-slug>-dataverse-dev`
   - `$HOME\.azure-<client-slug>-dataverse-prod`
   - `$HOME\.azure-<client-slug>-power-automate`
4. Fix the target scope inside each wrapper. Do not accept an arbitrary scope argument on these specialized wrappers.
5. On `-Login / --login`, request the management scope first and then the fixed resource scope using two separate `az login` calls. Do not combine scopes from different resources in one login request. Preserve the exact scope spelling required by the Azure CLI error.
6. Keep interactive login on the user side. After the user confirms success, run the specialized wrapper and token command in the same PowerShell process so its `AZURE_CONFIG_DIR` remains active.

Do not copy token-cache files between profile directories, store tokens in the workspace, or delete the existing generic profile automatically. Preserve the generic wrapper as a fallback unless the user explicitly approves its removal.

Begin automated Web API queries only after access is confirmed or a token command succeeds.

## Web API Query Rules

Target the Dataverse Web API endpoint:

```text
https://ORG.crm.dynamics.com/api/data/v9.2/
```

Prefer `curl` for executable requests. Build narrow, purposeful queries using `$select`, `$filter`, `$expand`, and metadata endpoints where appropriate. URL-encode query parameters as needed.

Create a dedicated evidence folder in the current workspace, normally:

```text
support-case-queries/
```

Use one query per file. Use numbered, descriptive filenames:

```text
support-case-queries/001-entity-metadata-account.md
support-case-queries/002-workflow-by-name.md
support-case-queries/003-plugin-steps-for-message.md
```

Each query file must contain:

- A short title or purpose.
- The full Web API URL.
- The executable `curl` command when available.
- The HTTP response status when available.
- The JSON result or error response.
- A brief interpretation tied to the case.

Recommended evidence file format:

~~~markdown
# Query 001 - Retrieve workflow metadata

## Purpose

Explain why this query matters to the support case.

## URL

https://ORG.crm.dynamics.com/api/data/v9.2/...

## Command

curl -sS -H "Authorization: Bearer <token>" -H "Accept: application/json" "https://ORG.crm.dynamics.com/api/data/v9.2/..."

## HTTP Status

200

## Result

```json
{}
```

## Interpretation

State what this result proves, disproves, or leaves open.
~~~

Mask secrets and bearer tokens in saved files. Do not store live access tokens.

## Browser Fallback

If Azure CLI authentication, token retrieval, or automated `curl` execution is not possible, use browser-assisted collection:

1. Create one file per query in the evidence folder.
2. Put the Web API URL clearly at the top of each file.
3. Tell the user where the files are.
4. Instruct the user to open each URL in an already-authenticated browser session.
5. Ask the user to copy the JSON response from the browser.
6. Ask the user to paste the JSON response into the same file directly below the URL.
7. Ask the user to tell the assistant when the responses have been added.
8. Continue the analysis from those saved results.

Use this copy-paste-friendly format:

~~~markdown
# Query 001 - Retrieve workflow metadata

## URL

https://ORG.crm.dynamics.com/api/data/v9.2/...

## Result

Paste the JSON response here.
~~~

Do not treat browser fallback as failure. It is the standard path when automation is blocked by auth, conditional access, MFA, device compliance, or local tool limitations.

## Investigation Guidance

Choose queries based on the case evidence, not on a fixed checklist. Common query targets include:

- EntityDefinitions, AttributeMetadata, relationships, forms, views, and option sets for schema or metadata issues.
- `workflows`, `processes`, flow callback records, process sessions, and async operations for classic workflow or process problems.
- Plugin assemblies, plugin types, SDK message processing steps, images, secure/unsecure configuration, and custom APIs for plugin behavior.
- Web resources, app modules, sitemap, ribbon/command definitions, and form XML for model-driven app or JavaScript issues.
- Users, teams, roles, business units, security role privileges, owner changes, and access teams for permission issues.
- Solution components, publishers, dependencies, managed properties, and import jobs for ALM issues.
- Specific business records, audit data, duplicated records, state/status fields, lookup references, and timestamps for data issues.

When a query result changes the theory of the case, record that shift in the interpretation section of the evidence file and adjust the next query set.

## Final Report

Finish every investigation with a concise English report:

- Case summary.
- Environment used.
- Evidence collected.
- Queries executed or prepared.
- Findings.
- Likely root cause, if supported by evidence.
- Recommended next steps.
- Open questions or missing access/data.
- Files created in the query folder.

If the root cause is not supported by evidence, say so directly and list the highest-value next query or access needed.
