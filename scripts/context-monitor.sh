#!/bin/bash
# Context window monitor for research-companion skill
# Runs on UserPromptSubmit to check context usage and warn when running low

WARN_THRESHOLD=50
CRITICAL_THRESHOLD=70

# Get context usage from cozempic
OUTPUT=$(cozempic current 2>/dev/null)
if [ $? -ne 0 ]; then
  exit 0
fi

# Extract percentage (e.g., "28% of 200.0K" -> 28)
PCT=$(echo "$OUTPUT" | grep -oE '[0-9]+% of' | grep -oE '[0-9]+')
if [ -z "$PCT" ]; then
  exit 0
fi

if [ "$PCT" -ge "$CRITICAL_THRESHOLD" ]; then
  cat <<EOF
{
  "systemMessage": "Context usage: ${PCT}% - approaching limit. Consider wrapping up soon.",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "[CONTEXT MONITOR] Context window usage is at ${PCT}% (critical threshold: ${CRITICAL_THRESHOLD}%). You MUST begin winding down immediately: summarize the current discussion, save all important information to memory (Phase 6), and tell the user to continue in a new session. Do NOT start any new topics."
  }
}
EOF
elif [ "$PCT" -ge "$WARN_THRESHOLD" ]; then
  cat <<EOF
{
  "systemMessage": "Context usage: ${PCT}% - getting high.",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "[CONTEXT MONITOR] Context window usage is at ${PCT}% (warning threshold: ${WARN_THRESHOLD}%). Start planning to wrap up this session. When the current topic reaches a natural stopping point, proceed to save memory and suggest the user continue in a new session."
  }
}
EOF
fi
