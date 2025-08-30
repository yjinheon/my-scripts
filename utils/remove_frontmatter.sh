#!/bin/bash

BASE_DIR="$1"

shift # remove $1 and remain with the fields to remove

if [ -z "$BASE_DIR" ]; then
  echo "Usage: $0 <directory> <field1> [field2] [...]"
  exit 1
fi

if [ "$#" -eq 0 ]; then
  echo "Please specify at least one frontmatter field."
  exit 1
fi

# Build regex to match target fields
FIELDS_REGEX=$(printf "|^%s:" "$@")
FIELDS_REGEX=${FIELDS_REGEX:1} # remove leading "|"

# Process each .md file recursively
find "$BASE_DIR" -type f -name "*.md" | while read -r file; do
  awk -v fields="$FIELDS_REGEX" '
    BEGIN { in_frontmatter = 0 }
    /^---$/ {
      in_frontmatter = 1 - in_frontmatter
      print
      next
    }
    {
      if (in_frontmatter && $0 ~ fields) next
      print
    }
  ' "$file" >"${file}.tmp" && mv "${file}.tmp" "$file"

  echo "Processed: $file"
done
