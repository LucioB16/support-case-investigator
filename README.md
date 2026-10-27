# Support Case Investigator

**A structured investigation workflow for Dataverse and Power Platform support cases.**

This coding-agent skill helps organize technical evidence across Dynamics 365, Dataverse and Power Automate troubleshooting. It documents authentication boundaries, repeatable Web API investigation steps and handoff-friendly Markdown findings.

| Establish context | Authenticate safely | Gather evidence |
| :-- | :-- | :-- |
| Identify the failing operation and environment. | Keep Azure CLI authentication within supported session boundaries. | Produce readable API observations and root-cause hypotheses. |

> [!NOTE]
> This repository currently has no `LICENSE` file. The former MIT badge linked to a missing target and has been removed; no open-source license is asserted here.

## Installation

To equip your AI Coding Agent with this skill, paste the appropriate prompt:

### For Antigravity / Codex
```text
You are my AI Agent. First, dynamically discover the correct path for my global skills directory on this machine (e.g., `.codex/skills` or `.gemini/config/plugins/codex-skills-plugin/skills`). Then, read this README at https://github.com/LucioB16/support-case-investigator. Clone this repository into that global skills directory so this skill becomes permanently available across all my workspaces.
```

### For GitHub Copilot
```text
You are GitHub Copilot. Please clone the repository at https://github.com/LucioB16/support-case-investigator into a dedicated local tools directory (for example, `~/copilot-skills/support-case-investigator`) so this skill becomes permanently available to reference across all my workspaces.
```

## Usage

Because this is an Agent Skill, you do not need to run terminal commands manually. Just use your agent slash command:

### Example Prompts
- **Codex / Antigravity**: `/support-case-investigator Analyze this case.`
- **GitHub Copilot**: `Use the support-case-investigator skill to find the root cause of this plugin failure.`

The agent will automatically read the `SKILL.md` instructions and respect the Azure CLI authentication boundaries.

## Investigation capabilities

- **Agent Skill instructions**: Written for coding agents across supported operating systems; individual harness compatibility depends on configuration.
- **Authentication-aware workflow**: Documents ways to avoid losing CLI session context and to diagnose errors such as `AADSTS50078`.
- **Profile and scope handling**: Provides guidance for recurring authentication-scope issues and profile reuse.
- **Evidence Formatting**: Enforces readable, copy-pasteable Markdown artifacts for API queries.

## Licensing

No license grant is included in this repository at present. Contact the maintainer before redistributing or relicensing the skill.
