#!/usr/bin/env bash

set -euo pipefail

GIT_ACTION="${1:-}"  # Optional argument: add-commit-push

BASE_DIR="$(dirname "$(realpath "$0")")"
DIR_TXT="$BASE_DIR/txt"
DIR_TXT_DL="$DIR_TXT/download"
HOSTLIST="$DIR_TXT/host-list.txt"
BLOCKLIST="$DIR_TXT/block.txt"

REGEX_HTTP='^https\?://.*'
REGEX_LINE_CLEANUP='^127\.0\.0\.1\s*|^0\.0\.0\.0\s*|\s*#.*$|^\|\||\^$'
REGEX_LINE_JUNK='^#|^\s*#|^\s*$|::'

mkdir -p "$DIR_TXT_DL"
TMP_FILE=$(mktemp)
i=1

while IFS= read -r entry; do
    [[ "$entry" =~ $REGEX_HTTP ]] || continue

    FILEPATH="$DIR_TXT_DL/$i.txt"
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

rm -rf "$DIR_TXT_DL"

echo "Performing final cleanup..."
# Remove unwanted text and sort uniquely
sed -E "s/$REGEX_LINE_CLEANUP//g" "$TMP_FILE" | sort -u > "$BLOCKLIST"
rm "$TMP_FILE"

if [[ "$GIT_ACTION" == "add-commit-push" ]]; then
    echo "Committing to Git..."
    cd "$BASE_DIR"
    git add "$BLOCKLIST"
    git commit -m "Updated: $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
fi

sleep 10  # Lazy troubleshooting
