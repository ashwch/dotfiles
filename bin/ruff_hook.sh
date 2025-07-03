#!/bin/bash

# Claude Code PostToolUse hook for ruff linting
# Automatically runs ruff check and fix on Python files after Write/Edit operations
# Configure this as a PostToolUse hook with matcher: "Write|Edit|MultiEdit"

# Read JSON from stdin
INPUT=$(cat)

# Set up logging
LOG_DIR="$HOME/.local/share/claude-alert"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/ruff-hook.log"

echo "$(date '+%Y-%m-%d %H:%M:%S') - PostToolUse Hook triggered:" >> "$LOG_FILE"
echo "$INPUT" >> "$LOG_FILE"

# Check if uv is available
if ! command -v uv &> /dev/null; then
    echo "uv not available, skipping ruff check" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
    exit 0
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "jq not available, skipping hook" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
    exit 0
fi

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}')

echo "Tool: $TOOL_NAME" >> "$LOG_FILE"

# For Write tool, get the file path
if [ "$TOOL_NAME" = "Write" ]; then
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // ""')
elif [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "MultiEdit" ]; then
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // ""')
else
    echo "Tool not relevant for linting: $TOOL_NAME" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
    exit 0
fi

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    echo "No valid file path found: $FILE_PATH" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
    exit 0
fi

# Check if it's a Python file
if [[ "$FILE_PATH" != *.py ]]; then
    echo "Not a Python file, skipping: $FILE_PATH" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
    exit 0
fi

echo "Processing Python file: $FILE_PATH" >> "$LOG_FILE"

# Get the project directory (where pyproject.toml should be)
PROJECT_DIR=$(dirname "$FILE_PATH")
while [ "$PROJECT_DIR" != "/" ] && [ ! -f "$PROJECT_DIR/pyproject.toml" ]; do
    PROJECT_DIR=$(dirname "$PROJECT_DIR")
done

if [ ! -f "$PROJECT_DIR/pyproject.toml" ]; then
    echo "No pyproject.toml found, skipping ruff check" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"
    exit 0
fi

echo "Found pyproject.toml in: $PROJECT_DIR" >> "$LOG_FILE"

# Change to project directory to use pyproject.toml config
cd "$PROJECT_DIR"

# Run ruff check using uv
RUFF_OUTPUT=$(uv run ruff check "$FILE_PATH" 2>&1)
RUFF_EXIT_CODE=$?

if [ $RUFF_EXIT_CODE -ne 0 ]; then
    echo "Issues found in $FILE_PATH:" >> "$LOG_FILE"
    echo "$RUFF_OUTPUT" >> "$LOG_FILE"
    
    # Try to auto-fix using uv
    echo "Attempting auto-fix for $FILE_PATH" >> "$LOG_FILE"
    uv run ruff check --fix "$FILE_PATH" >> "$LOG_FILE" 2>&1
    
    # Also run ruff format using uv
    uv run ruff format "$FILE_PATH" >> "$LOG_FILE" 2>&1
    
    # Log the fix
    echo "✓ Auto-fixed issues in $FILE_PATH" >> "$LOG_FILE"
else
    echo "✓ $FILE_PATH passed ruff checks" >> "$LOG_FILE"
fi

echo "---" >> "$LOG_FILE"
