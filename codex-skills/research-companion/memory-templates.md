# Memory Templates & Update Rules

Reference this file when creating or updating `.research_memory/` files. Part 1 contains the update rules for Phase 6. Part 2 defines the format for each file type.

---

# Part 1: Memory Update Rules

Read this section when entering Phase 6. Execute steps in order.

## Phase 6 Steps

1. **Write L2 session summary** — glob `L2_sessions/YYYY-MM-DD_*` to determine the next sequence number NNN, then create `L2_sessions/YYYY-MM-DD_NNN_session.md`
2. **Triage oldest L2 (if L2 count > 10)** — when L2_sessions/ contains more than 10 files, triage the oldest one:
   - `recall_count >= 1` → review for L1 promotion. If promoted, extract core content to L1 and delete from L2. If not promoted, archive to L3.
   - `recall_count == 0` → archive directly to L3.
   Either way, the file leaves L2. L2 count stays at 10.
3. **Promote to L1** — ask: "what from this session would be valuable in EVERY future session?" Update relevant L1 files. Do NOT promote session-specific details or unconfirmed ideas.
4. **Enforce L1 size cap (~300 lines)** — if total lines across all L1 files exceed ~300, apply in order: (a) remove `key_decisions.md` entries where a newer decision on the same topic exists; (b) move Completed/Abandoned directions that have not been discussed in the last 10 sessions from `active_directions.md` to a L3 archive note; (c) tighten prose, merge related bullets. Stop as soon as under cap.
5. **Update `_meta.md`** — increment session count, add to recall tracker (remove entry for any triaged L2), update recall counts for any L2 files loaded during this session, update topic index (when a L2 is triaged, migrate its Topic Index entries from the L2_sessions column to the L3_archives column pointing to the L3 file it was archived into, rather than simply deleting them)
6. **L3 & Topic Index cleanup (every 10 sessions)** — trim bloated L3 archives; prune Topic Index entries that only point to L3 files with zero recalls since the last 2 cleanup cycles. Track via `next_cleanup_at` in `_meta.md`.

## Memory Self-Organization

A **recall** = one L2/L3 file read into context mid-session due to a conversation trigger (topic overlap, explicit back-reference, L1 detail gap, or contradiction). Counted once per file per session. Phase 1 startup loads (latest 3 L2) do not count.

L2 maintains a fixed pool of 10 session files. When a new session is written and the count exceeds 10, the oldest L2 is triaged:

```
recall_count >= 1  → review for L1 promotion; archive to L3 if not promoted
recall_count == 0  → archive directly to L3
```

The file always leaves L2. No session can block the queue.

L3 and Topic Index cleanup triggers every 10 sessions via `next_cleanup_at` in `_meta.md`.

---

# Part 2: File Format Templates

---

## companion_config.md

Created during Phase 0. Stores the companion's identity. `personality` is only updated when the user explicitly requests a change. Keep to 1-2 sentences.

```markdown
# Companion Config
name: [user's chosen name]
personality: [1-2 sentence personality description, e.g. "calm and pragmatic, likes to probe details, occasional dry humor"]
created: [YYYY-MM-DD]
```

---

## _meta.md

```markdown
# Memory Metadata

## Stats
- total_sessions: [number]
- last_session: YYYY-MM-DD
- last_cleanup: YYYY-MM-DD
- next_cleanup_at: [session count threshold for L3/Topic Index cleanup, typically current + 10]
- next_veto_review_at: [session count threshold for vetoed ideas review, typically current + 20]

## L2 Recall Tracker
| session_file | recall_count | last_recalled | one_line_summary |
|---|---|---|---|
| YYYY-MM-DD_NNN_session.md | 0 | — | [one-line summary of the discussion] |

## Topic Index
| topic | L2_sessions | L3_archives |
|---|---|---|
| [keyword1/keyword2/keyword3] | YYYY-MM-DD, YYYY-MM-DD | — |

## L3 Archive Index
| archive_file | period | topics_covered | session_count |
|---|---|---|---|
| YYYY-QN_archive.md | YYYY-MM to YYYY-MM | [topic list] | [count] |
```

---

## L1_core/project_profile.md

```markdown
# Project Profile
- **Topic**: [Research topic and field]
- **Research Questions**: [Main questions, ranked by priority]
- **Methods**: [Key methods/tools/frameworks]
- **Data**: [Available datasets and their status]
- **Project Structure**: [directory → role mapping, e.g., `src/` → source code, `papers/` → literature]
- **Current Stage**: [data collection / analysis / writing / revision]
- **Short-term Goals**: [What to achieve in the next few weeks]
- **Long-term Goals**: [Where this project is headed]
- **Last updated**: YYYY-MM-DD
```

---

## L1_core/active_directions.md

```markdown
# Active Research Directions

## [Direction name]  ★ [priority: high/medium/low]
- **Status**: exploring / planned / in-progress / paused
- **Question**: [What specific question does this address?]
- **Approach**: [Brief method description]
- **Added**: YYYY-MM-DD | **Last discussed**: YYYY-MM-DD
- **Notes**: [Brief context]

# Completed
## [Direction name]
- **Outcome**: [What was found] | **Completed**: YYYY-MM-DD

# Abandoned
## [Direction name]
- **Reason**: [Why] | **Abandoned**: YYYY-MM-DD
```

---

## L1_core/key_decisions.md

Most recent first. Remove entries that are fully superseded during L1 cap enforcement.

```markdown
# Key Decisions

## YYYY-MM-DD: [Decision summary]
- **Context**: [Why this decision was needed]
- **Decision**: [What was decided]
- **Rationale**: [Why this option was chosen over alternatives]
- **Alternatives considered**: [What else was on the table]
```

---

## L1_core/researcher_profile.md

```markdown
# Researcher Profile

## Expertise & Background
- [Domain, methods they're skilled in]

## Current Interests
- [What excites them right now]

## Priorities
- [What matters most to them at this stage]

## Constraints
- [Time, resources, skills, deadlines]

## Preferences
- [How they like to work, think, communicate]

## Lessons Learned
- [Key insights from failed attempts — avoid repeating mistakes]
```

---

## L1_core/vetoed_ideas.md

```markdown
# Vetoed Ideas

Ideas explicitly rejected by the researcher. NEVER re-suggest these.

- [YYYY-MM-DD] **[idea summary]** — reason: [user's stated reason, or "not specified"]
```

---

## L2_sessions/YYYY-MM-DD_NNN_session.md

One file per session. NNN is a sequence number (001, 002...) to handle multiple sessions per day. Keep to 30-80 lines. This is a structured summary, NOT a transcript. `recall_count` is tracked solely in `_meta.md`, not here.

```markdown
---
date: YYYY-MM-DD
topics: [topic1, topic2, ...]
status: completed | interrupted — context limit
---

## Context
[What prompted this session — 1-2 sentences]

## Key Discussion Points
- [Bullet points of what was discussed]

## Decisions Made
- [What was decided, with rationale]

## Ideas Explored but Not Pursued
- [Ideas that came up but were set aside, with reasons]

## Next Steps
- [Concrete actions identified]

## Open Questions
- [Unresolved questions to revisit]
```

---

## L3_archive/YYYY-QN_archive.md

Compressed from multiple L2 sessions. Keep under ~50 lines per quarter.

```markdown
# Archive: YYYY QN (Month1 — Month3)

## Sessions Covered
- YYYY-MM-DD: [one-line summary]
- YYYY-MM-DD: [one-line summary]

## Key Themes
- [Major topics discussed across sessions]

## Decisions Made
- [Decisions that haven't been superseded]

## Lessons & Dead Ends
- [What was tried and didn't work]
```
