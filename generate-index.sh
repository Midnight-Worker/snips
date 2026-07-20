#!/usr/bin/env bash

output="index.md"

{
    echo "# Inhaltsverzeichnis"
    echo

    find . -maxdepth 1 -type f -name '*.md' \
        ! -name "$output" \
        -printf '%f\n' |
    sort |
    while IFS= read -r file; do
        name="${file%.md}"
        printf -- '- [%s](%s)\n' "$name" "$file"
    done
} > "$output"
