#!/usr/bin/env bash
set -euo pipefail

# -----------------------
# Configuration
# -----------------------
ZIP_PATH="${HOME}/Downloads/envs.zip"
DEST_ROOT="${HOME}/www"

# -----------------------
# Prepare temp workspace
# -----------------------
TMPDIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

# -----------------------
# Unzip into temp
# -----------------------
unzip -q "$ZIP_PATH" -d "$TMPDIR"
echo "unzipped to temp: $TMPDIR"

# -----------------------
# Find and restore .env files
# -----------------------
find "$TMPDIR" -type f -name '.env' | while IFS= read -r src_env; do
  # compute relative path under temp
  rel_path="${src_env#$TMPDIR/}"
  
  # remove 'envs/' prefix if it exists
  rel_path="${rel_path#envs/}"

  # target directory in ~/www
  target_dir="$DEST_ROOT/$(dirname "$rel_path")"
  target_env="$target_dir/.env"

  if [[ -d "$target_dir" ]]; then
    # copy if dest missing or src is newer
    if [[ ! -e "$target_env" ]] || [[ "$src_env" -nt "$target_env" ]]; then
      cp "$src_env" "$target_env"
      echo "restored: $rel_path"
    fi
  else
    echo "skipped (no folder): $rel_path"
  fi
done