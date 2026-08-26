# Support Case Investigator Skill

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Codex](https://img.shields.io/badge/Codex-compatible-blue)](https://github.com/LucioB16/support-case-investigator)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-orange)](https://github.com/LucioB16/support-case-investigator)
[![GitHub Copilot](https://img.shields.io/badge/GitHub%20Copilot-compatible-purple)](https://github.com/LucioB16/support-case-investigator)

Automated Dataverse and Power Platform case investigation skill for AI Coding Agents.

This repository provides an intelligent workflow for investigating Microsoft support cases. It standardizes Azure CLI authentication boundaries, prevents process isolation token drops, and formats Web API evidence cleanly.

## 🚀 Features

- **Agent Agnostic**: Works seamlessly across Windows and Unix-based OS (Codex, GitHub Copilot, Antigravity, etc.).
- **Process Isolation Safe**: Solves the `AADSTS50078` MFA expiration errors caused by stateless terminal execution.
- **Auto-Escalation**: Built-in architecture to fallback on multi-profile disk caching for recurrent scope-switching errors.
- **Evidence Formatting**: Enforces readable, copy-pasteable Markdown artifacts for API queries.

## 🛠️ Installation

To equip your AI Coding Agent with this skill, paste the appropriate prompt:

### For Antigravity / Codex
```text
You are my AI Agent. First, dynamically discover the correct path for my global skills directory on this machine (e.g., `.codex/skills` or `.gemini/config/plugins/codex-skills-plugin/skills`). Then, read this README at https://github.com/LucioB16/support-case-investigator. Clone this repository into that global skills directory so this skill becomes permanently available across all my workspaces.
```

### For GitHub Copilot
```text
You are GitHub Copilot. Please clone the repository at https://github.com/LucioB16/support-case-investigator into a dedicated local tools directory (for example, `~/copilot-skills/support-case-investigator`) so this skill becomes permanently available to reference across all my workspaces.
```

## 📘 Usage

Because this is an Agent Skill, you do not need to run terminal commands manually. Just use your agent slash command:

### Example Prompts
- **Codex / Antigravity**: `/support-case-investigator Analyze this case.`
- **GitHub Copilot**: `Use the support-case-investigator skill to find the root cause of this plugin failure.`

The agent will automatically read the `SKILL.md` instructions and respect the Azure CLI authentication boundaries.
