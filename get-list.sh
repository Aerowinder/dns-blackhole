#!/usr/bin/env bash

set -euo pipefail

GIT_ACTION="${1:-}" # Optional argument: add-commit-push

BASE_DIR="$(dirname "$(realpath "$0")")"
DIR_TXT="$BASE_DIR/txt"
HOSTLIST="$DIR_TXT/host-list.txt"
BLOCKLIST="$DIR_TXT/block.txt"

REGEX_HTTP='^https?://.*'
REGEX_LINE_CLEANUP='^127\.0\.0\.1\s*|^0\.0\.0\.0\s*|\s*#.*$|^\|\||\^$|^!' # Added ^! to clean '!' at start
REGEX_LINE_JUNK='^#|^\s*#|^\s*$|::|^!'

# Create temp directory for downloads
TMP_DIR=$(mktemp -d)
TMP_FILE="$TMP_DIR/combined.txt"
mkdir -p "$TMP_DIR"
> "$TMP_FILE" # Truncate or create fresh temp file

i=1
while IFS= read -r entry; do
    entry="${entry//$'\r'/}" # Strip Windows CR if present
    echo "$entry" | grep -qE "$REGEX_HTTP" || continue

    FILEPATH="$TMP_DIR/$i.txt"
    FILENAME="$i.txt"
    echo "Downloading $FILENAME ..."
    curl -s "$entry" -o "$FILEPATH"

    echo "Removing non-domain lines from $FILENAME ..."
    if [[ "$FILENAME" == "1.txt" ]]; then
        tail -n +40 "$FILEPATH" | grep -Ev "$REGEX_LINE_JUNK" >> "$TMP_FILE"
    else
        grep -Ev "$REGEX_LINE_JUNK" "$FILEPATH" >> "$TMP_FILE"
    fi

    echo
    ((i++))
done < "$HOSTLIST"

echo "Performing final cleanup and writing $BLOCKLIST ..."
sed -E "s/$REGEX_LINE_CLEANUP//g" "$TMP_FILE" | sort -u > "$BLOCKLIST"

echo "Cleaning up temp downloads folder..."
rm -rf "$TMP_DIR"

if [[ "$GIT_ACTION" == "add-commit-push" ]]; then
    echo "Committing to Git..."
    cd "$BASE_DIR"
    git add "$BLOCKLIST"
    git commit -m "Updated: $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
fi

# sleep 10  # Lazy troubleshooting

#Changelog
#2025-05-17 - AS - v1, First release.
