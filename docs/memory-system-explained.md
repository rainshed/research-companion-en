# Research Companion: A Human-Inspired Hierarchical Memory System for AI Agents

## Why Agents Need a Memory System

Due to context window limitations, we cannot feed an LLM the entire history of all previous conversations as part of the prompt. Yet humans face the same constraint — our working memory is equally limited — and we still manage to carry out long-term, continuous, complex tasks. This raises a natural question: how do humans manage memory, and can we borrow that mechanism to design a memory system for AI agents?

Human memory can be roughly divided into three tiers. The first is **core memory** — who I am, what I do, what I'm currently working on — information that is always present in our "context," available at all times. The second is **recent memory**: things that happened not long ago. Recent memory further splits into two kinds: what just happened (e.g., what the person in front of me just said), which sits in active context; and what happened a while ago (e.g., what I had for lunch), which exists only as a vague impression in context but can be fully recalled once someone brings it up. The third tier is **long-term memory** — not in context at all under normal circumstances, but retrievable when triggered by the right keywords, like where I traveled last summer.

Following this insight, I designed **Research Companion** — an agent memory system that mirrors human memory hierarchy, purpose-built for academic and scientific research. The core idea is to position the agent as a long-term research collaborator (users can give it a name, and calling that name triggers the skill), available at any time to discuss ideas and organize thinking throughout the research process.

## Three-Tier Memory Architecture

### L1: Working Memory

Corresponding to human core memory, L1 is **fully loaded at the start of every conversation**. It consists of five files:

| File | Contents |
|------|----------|
| `project_profile.md` | Project overview: topic, research questions, methods, data, project structure, current stage, short/long-term goals |
| `active_directions.md` | Current research directions with status (exploring / planned / in-progress / paused), plus completed and abandoned directions |
| `key_decisions.md` | Key decision log: context, decision made, rationale, alternatives considered |
| `researcher_profile.md` | Researcher profile: user's expertise, current interests, priorities, constraints, lessons learned from failures |
| `vetoed_ideas.md` | Explicitly rejected ideas: date, summary, stated reason (never re-suggested unless user explicitly requests a review) |

Total size is capped at approximately 300 lines. These files allow the agent to immediately understand at the start of each new conversation: what the project is about, which directions are being explored, what the user's interests and expertise are, and which paths have already been tried and rejected.

### L2: Session Memory

Corresponding to human recent memory, L2 **retains summaries of the last ten conversations**. Each summary is 30–80 lines, named in `YYYY-MM-DD_NNN_session.md` format, and captures: what was discussed, decisions made and their rationale, ideas explored but not adopted, next steps, and open questions.

Each time the skill is triggered, the system automatically loads the three most recent session files, so the agent knows what you discussed in the last few conversations and can maintain continuity. For older L2 memories, the system maintains a **Topic Index** — when keywords in the current conversation match index entries, the relevant session files are automatically recalled into context. It's like someone mentioning "what did you have for lunch" and the answer naturally coming back to you.

### L3: Cold Storage

Corresponding to human long-term memory. Archived by quarter (`YYYY-QN_archive.md`), each file is approximately 50 lines and preserves only cross-session key themes, decisions that haven't been superseded, and dead ends encountered. Only the keyword directory is loaded by default; full archives are recalled only when L2 search fails or the user explicitly asks about earlier history.

The loading strategy across all three tiers:

| Tier | Capacity | Default Loading | On-Demand Recall |
|------|----------|----------------|-----------------|
| L1 | ~300 lines, 5 files | Fully loaded | — |
| L2 | 10 files, 30–80 lines each | Latest 3 | When Topic Index matches |
| L3 | ~50 lines per quarter | Keyword directory only | On keyword match or explicit user request |

## Memory Dynamics: Promotion and Archival

This system is not a static three-tier store. It implements a **dynamic memory flow mechanism** that simulates human memory consolidation and forgetting.

### Archival: L2 → L3

When L2 accumulates more than 10 session files, the oldest one is evicted. The system uses a `recall_count` (how many times the file was recalled in later sessions) to determine its fate:

- **`recall_count == 0`** (never recalled): The memory is no longer relevant. It is compressed and archived directly into the corresponding L3 quarterly file.
- **`recall_count >= 1`** (recalled at least once): The system first evaluates whether any content is worth promoting to L1. If promoted, the core content is extracted into the relevant L1 files and the L2 file is deleted. If not worth promoting, it is archived to L3.

In either case, **the file always leaves L2**, keeping the pool at exactly 10 files.

### Promotion: L2 → L1

At the end of each conversation, the system evaluates a key question: "What from this session would be valuable in **every single future session**?" If something qualifies, it is distilled and written into the appropriate L1 file. For example:

- A new research direction is confirmed → added to `active_directions.md`
- A key decision is made → logged in `key_decisions.md`
- A new research interest is discovered → updated in `researcher_profile.md`
- An idea is explicitly rejected → recorded in `vetoed_ideas.md`

Only **confirmed, durable** information is promoted — not unverified ideas or one-off discussion details.

### Capacity Control: L1 Compaction

L1 has a size cap of approximately 300 lines. When exceeded, the system applies compaction in priority order:

1. Remove entries in `key_decisions.md` that have been superseded by newer decisions on the same topic
2. Move completed/abandoned directions in `active_directions.md` that haven't been discussed in the last 10 sessions to L3 archive
3. Tighten prose and merge related bullet points

Compaction stops as soon as the total drops below the cap. This mirrors how human memory gradually lets go of information that is important but outdated.

## Recall Mechanism

Recall is the critical bridge connecting the three memory tiers. The system defines four trigger conditions:

1. **Topic matching**: Extract 3–5 salient keywords from the current conversation turn and match them against the Topic Index. Matched L2/L3 files are loaded into context (maximum 2 files per trigger).
2. **Explicit back-reference**: When the user says things like "we discussed before" or "last time you said," the system searches recall tracker summaries for matches and loads them.
3. **L1 lacks detail**: When L1 contains a conclusion but not the reasoning behind it, the system loads the L2 session file that recorded the original discussion to provide context.
4. **Contradiction detection**: When the user's current statement conflicts with an L1 record, the system loads the relevant L2 file, presents both conflicting sources, and only updates L1 after the user explicitly confirms — logging the update as a new key decision.

After every recall, the system updates the file's `recall_count` and `last_recalled` timestamp, and adds any newly discovered topic associations to the index. This means **frequently recalled memories resist forgetting** (they are more likely to be promoted to L1), while **memories that are never recalled eventually sink into the archive** (from L2 to L3).

## Conversation Flow

Each time the skill is triggered, the agent progresses through six phases:

| Phase | Description |
|-------|-------------|
| Phase 0 | **Identity loading**: Read the companion's name and persona; stay in character throughout |
| Phase 1 | **Memory loading**: Read all L1 files, metadata, and latest 3 L2 files; on first use, scan project structure and initialize memory |
| Phase 2 | **Synthesis & presentation**: Report project status, what was discussed last time, and changes since then |
| Phase 3 | **Direction exploration**: Continue existing directions, suggest new ones, or guide thinking with open-ended questions |
| Phase 4 | **Collaborative dialogue**: Deep discussion one question at a time, framing ideas in research terms, raising constructive challenges |
| Phase 5 | **Convergence**: Summarize agreed research question, approach, expected outcome, first concrete step, and potential pitfalls |
| Phase 6 | **Memory save**: Write L2 session summary, execute promotion/archival/compaction, update metadata, sign off in character |

The entire process is strictly confined to **thinking mode only** — discussing ideas, never writing code or running experiments — ensuring the agent remains a "thinking partner" rather than an "execution tool."

## Context Monitoring and Graceful Interruption

To handle context window exhaustion, the system uses a hook to monitor context usage:

- **50%**: A warning is issued, prompting the agent to start planning wrap-up
- **70%**: Emergency save is triggered — the agent writes current discussion content into L2 memory, marked as `Status: interrupted — context limit`

On the next startup, the system automatically detects the interrupted state and resumes the discussion from where it left off. This ensures that even when a single conversation's context runs out, continuity is never lost — just as humans can pick up a conversation where they left off, relying on memory to bridge the gap.
