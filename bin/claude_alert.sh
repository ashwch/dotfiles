#!/bin/bash

# Claude Code notifications hook for macOS using jq
# Reads JSON from stdin, plays a sound, and displays macOS alert
#
# Environment variables:
#   CLAUDE_ALERT_SOUND - Sound name (default: Glass)
#                       Options: Basso, Blow, Bottle, Frog, Funk, Glass, 
#                                Hero, Morse, Ping, Pop, Purr, Sosumi, 
#                                Submarine, Tink

# Check if jq is available
if ! command -v jq &> /dev/null; then
    osascript -e 'display alert "Error" message "jq is not installed. Install with: brew install jq"'
    exit 1
fi

# Read all stdin data
INPUT=$(cat)

# Log the incoming JSON for debugging - using proper log directory
LOG_DIR="$HOME/.local/share/claude-hooks-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/alert.log"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Incoming JSON:" >> "$LOG_FILE"
echo "$INPUT" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"

# Parse JSON using jq - now handling the actual Claude Code structure
TITLE=$(echo "$INPUT" | jq -r '.hook_event_name // "Claude Code"')
MESSAGE=$(echo "$INPUT" | jq -r '.message // "No message"')

# Optionally include session info for debugging
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')
if [ ! -z "$SESSION_ID" ]; then
    MESSAGE="$MESSAGE\n\nSession: ${SESSION_ID:0:8}..."
fi

# Sound configuration - customize as needed
# Common sounds: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
SOUND_NAME="${CLAUDE_ALERT_SOUND:-Glass}"  # Default to Glass, override with CLAUDE_ALERT_SOUND env var
SOUND_PATH="/System/Library/Sounds/${SOUND_NAME}.aiff"

# Play the sound if it exists (non-blocking with &)
if [ -f "$SOUND_PATH" ]; then
    afplay "$SOUND_PATH" &
else
    # Fallback to a basic beep if custom sound not found
    printf '\a'
fi

# Show the alert
osascript -e "display alert \"$TITLE\" message \"$MESSAGE\" buttons {\"OK\"} default button \"OK\""
