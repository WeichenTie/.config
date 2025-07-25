#!/bin/bash

AGENT_FILE="$HOME/.ssh-agent-info"

# If agent info exists, source it
if [[ -f "$AGENT_FILE" ]]; then
    source "$AGENT_FILE"
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        echo "Old ssh-agent is dead. Starting new one..."
        eval "$(ssh-agent -s)" > /dev/null
        echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$AGENT_FILE"
        echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$AGENT_FILE"
    fi
else
    echo "Starting ssh-agent..."
    eval "$(ssh-agent -s)" > /dev/null
    echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$AGENT_FILE"
    echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$AGENT_FILE"
fi

# Re-source to ensure values are in current shell
source "$AGENT_FILE"

# Add key if not already added
if ! ssh-add -l >/dev/null 2>&1; then
    echo "Adding SSH key to agent..."
    ssh-add
fi
