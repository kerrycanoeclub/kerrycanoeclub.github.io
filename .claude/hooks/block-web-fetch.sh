#!/bin/bash
# Blocks web page fetches in Claude Code cloud sessions, which cannot reach
# outside websites. Local sessions are left alone.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

input="$(cat)"
tool="$(jq -r '.tool_name // ""' <<<"$input")"
agent="$(jq -r '.tool_input.subagent_type // ""' <<<"$input")"

block=false
if [ "$tool" = "WebFetch" ]; then
  block=true
elif { [ "$tool" = "Agent" ] || [ "$tool" = "Task" ]; } && [ "$agent" = "web-fetch" ]; then
  block=true
fi

if [ "$block" = true ]; then
  jq -n '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny",
    permissionDecisionReason: "Cloud sessions cannot reach outside websites. List the links that need checking and ask the user to click through them (see CLAUDE.md)."}}'
fi
