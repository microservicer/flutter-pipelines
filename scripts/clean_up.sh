#!/bin/bash

# Define the root directory based on the script's location
ROOT_DIR="$(dirname "$(realpath "$0")")/.."

# List of files and directories to delete
declare -a paths_to_delete=(
    ".idea/"
    "android/fastlane/metadata/android/en-US"
    "android/fastlane/Appfile"
    "ios/fastlane/screenshots"
    "ios/fastlane/Appfile"
    "ios/fastlane/Deliverfile"
    "ios/fastlane/Matchfile"
    "docs/images"
    "CHANGELOG.md"
    "LICENSE"
)

# Iterate over each item and delete if exists
for relative_path in "${paths_to_delete[@]}"; do
    full_path="${ROOT_DIR}/${relative_path}"
    if [ -e "$full_path" ]; then
        echo "Deleting $full_path..."
        rm -rf "$full_path"
    else
        echo "$full_path does not exist. Skipping."
    fi
done

# Check if README.md exists in the root directory
if [[ -f "${ROOT_DIR}/README.md" ]]; then
    # Rename it to README.md.old
    mv "${ROOT_DIR}/README.md" "${ROOT_DIR}/README.md.old"
    echo "Renamed README.md to README.md.old in the root directory."
else
    echo "README.md not found in the root directory."
fi

echo "Cleanup complete."
