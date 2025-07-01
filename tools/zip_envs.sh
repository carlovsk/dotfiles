#!/usr/bin/env bash
set -euo pipefail

# -----------------------
# Configuration
# -----------------------
SRC_DIR="${HOME}/www"
DEST_DIR="${HOME}/Desktop/envs"
ZIP_PATH="${HOME}/Desktop/envs.zip"

# -----------------------
# Find and copy .env files
# -----------------------
find "$SRC_DIR" -type f -name '.env' | while IFS= read -r src_file; do
  # compute path relative to SRC_DIR
  rel_path="${src_file#$SRC_DIR/}"
  dest_dir="$(dirname "$DEST_DIR/$rel_path")"

  # make sure the target directory exists
  mkdir -p "$dest_dir"

  # copy only if source is newer than dest, or dest doesn't exist
  if [[ ! -e "$dest_dir/.env" ]] || [[ "$src_file" -nt "$dest_dir/.env" ]]; then
    cp "$src_file" "$dest_dir/"
    echo "copied: $rel_path"
  fi
done

# -----------------------
# Zip the entire envs folder
# -----------------------
# -q : quiet
# -r : recursive
# -FS: only include changed files (makes zip faster/smaller)
zip -q -r -FS "$ZIP_PATH" "$DEST_DIR"

echo "zipped to: $ZIP_PATH"