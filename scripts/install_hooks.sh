#!/bin/bash

# Define the root directory based on the script's location
ROOT_DIR="$(dirname "$(realpath "$0")")/.."

SRC_DIR="${ROOT_DIR}/git_hooks"
DEST_DIR="${ROOT_DIR}/.git/hooks"

# Ensure git_hooks directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Directory $SRC_DIR does not exist."
    exit 1
fi

# Copy hooks from git_hooks to .git/hooks
for hook in "$SRC_DIR"/*; do
    if [ -f "$hook" ]; then
        cp "$hook" "$DEST_DIR/"
        chmod +x "$DEST_DIR/$(basename "$hook")"
        echo "Copied and made executable: $(basename "$hook")"
    fi
done

echo "Hooks setup complete."
