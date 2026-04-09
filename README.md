# Research Companion (English)

A persistent research thinking partner for academic/scientific projects, available as a Claude Code plugin and a Codex skill.

> **Looking for the bilingual (Chinese/English) version?** See [research-companion](https://github.com/rainshed/research-companion).

## Features

- Named companion with custom personality
- Layered memory system (L1 core / L2 sessions / L3 archive)
- Cross-session continuity
- Context window monitoring hook
- English interface

## Installation

### Claude Code (via Plugin Marketplace)

**Step 1:** Add the marketplace:

```bash
/plugin marketplace add rainshed/research-companion-en
```

**Step 2:** Install the plugin:

```bash
/plugin install research-companion-en@rainshed-research-companion-en
```

### Codex

Codex uses native skill discovery from `$CODEX_HOME/skills/` (default: `~/.codex/skills/`).

Ask Codex:

```text
Install the `research-companion` skill from https://github.com/rainshed/research-companion-en/tree/main/codex-skills/research-companion using the built-in GitHub skill installer, then remind me to restart Codex.
```

Manual instructions: [`.codex/INSTALL.md`](.codex/INSTALL.md) or install directly from [`codex-skills/research-companion`](https://github.com/rainshed/research-companion-en/tree/main/codex-skills/research-companion)

### Optional: Context Monitor

The context window monitor hook uses [cozempic](https://github.com/eastlondoner/cozempic) to track context usage and warn you before running out of space. Install it with:

```bash
npm install -g cozempic
```

The plugin works without cozempic — the context monitor will simply be inactive.

## Update

### Claude Code

```bash
/plugin update research-companion-en@rainshed-research-companion-en
```

### Codex

If installed via symlink (Option B in INSTALL.md), pull the latest changes:

```bash
cd /path/to/research-companion-en && git pull
```

For a copied install (Option A), re-run:

```bash
cp -R codex-skills/research-companion "${CODEX_HOME:-$HOME/.codex}/skills/"
```

Then restart Codex.

## Usage

Say `research companion` in Claude Code or Codex to activate.

On first use, the companion will ask you to give it a name. After that, you can also activate it by saying that name.

## How the Memory System Works

Research Companion uses a three-tier hierarchical memory system inspired by how humans organize memory — from always-available core knowledge, through recent session recall, to long-term archives. Memories are dynamically promoted, recalled, and archived based on relevance, mimicking consolidation and forgetting.

For a detailed explanation, see:
- [Memory System Deep-Dive](docs/memory-system-explained.md)

## Repository Structure

```
research-companion-en/
├── .codex/
│   └── INSTALL.md           # Codex installation runbook
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace catalog
├── skills/
│   └── research-companion/
│       ├── SKILL.md          # Claude Code skill (writes CLAUDE.md)
│       └── memory-templates.md
├── codex-skills/
│   └── research-companion/
│       ├── SKILL.md          # Codex skill (writes AGENTS.md)
│       └── memory-templates.md
├── hooks/
│   └── hooks.json           # Context monitor hook config
├── scripts/
│   └── context-monitor.sh   # Context window usage monitor
├── docs/
│   └── memory-system-explained.md     # Memory system deep-dive
└── README.md
```

## License

MIT
