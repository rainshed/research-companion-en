# Installing Research Companion for Codex

This document is written so a Codex agent can read it and perform the installation steps directly.

## Preferred Install Path

When the user asks Codex to install this skill, prefer Codex's built-in GitHub skill installer and use this source URL:

```text
https://github.com/rainshed/research-companion-en/tree/main/codex-skills/research-companion
```

If the user says:

```text
Install the `research-companion` skill from https://github.com/rainshed/research-companion-en/tree/main/codex-skills/research-companion using the built-in GitHub skill installer, then remind me to restart Codex.
```

that should be treated as the standard installation request for this skill.

## What Codex Should Do

1. Check whether `${CODEX_HOME:-$HOME/.codex}/skills/research-companion` already exists.
2. If it already exists, stop and ask the user whether to keep it or replace it.
3. If it does not exist, install from the GitHub URL above using the built-in GitHub skill installer.
4. After installation, remind the user to restart Codex so it rescans `$CODEX_HOME/skills/`.

## How Codex Discovers Skills

Codex discovers personal skills from `$CODEX_HOME/skills/` at startup. When `CODEX_HOME` is unset, this defaults to `~/.codex/skills/`.

The expected installed path is:

```text
${CODEX_HOME:-~/.codex}/skills/research-companion
```

## Verify the Installation

After installation, verify that the skill directory exists and contains the expected files:

```bash
ls -la "${CODEX_HOME:-$HOME/.codex}/skills/research-companion"
```

Expected result:

- `$CODEX_HOME/skills/research-companion` exists
- `SKILL.md` and `memory-templates.md` are available through that path

## Manual Fallback

Use this only if the built-in GitHub skill installer is unavailable or the user explicitly asks for a manual install.

These instructions assume the current working directory is the root of this repository.

### Option A: Global Copy

Choose this if the user wants a standalone personal installation that does not depend on this repository after setup.

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R codex-skills/research-companion "${CODEX_HOME:-$HOME/.codex}/skills/"
```

### Option B: Project-Backed Symlink

Choose this if the user wants this repository to remain the source of truth, so future edits in the repository are picked up automatically.

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
ln -s "$(pwd)/codex-skills/research-companion" "${CODEX_HOME:-$HOME/.codex}/skills/research-companion"
```

For a symlink install, verify the target too:

```bash
readlink "${CODEX_HOME:-$HOME/.codex}/skills/research-companion"
```

## Finish

1. Restart Codex so it rescans `$CODEX_HOME/skills/`.
2. Start a new Codex session.
3. Activate the skill by saying `research companion`.

On first use, the skill can later register the companion's custom name in `AGENTS.md`, so no manual `AGENTS.md` edit is required during installation.
