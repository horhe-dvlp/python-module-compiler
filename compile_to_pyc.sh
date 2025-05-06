#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# compile_to_pyc.sh
#
# Compiles all .py files in the given source directory into .pyc files,
# preserving the directory structure, and outputs them into a new sibling
# directory named <source>_compiled, excluding all original .py files and
# __pycache__ folders.
#
# Usage:
#   ./compile_to_pyc.sh /absolute/or/relative/path/to/source
#
# Example:
#   ./compile_to_pyc.sh ./src
#
# Output will be in ./src_compiled/
# ------------------------------------------------------------------------------

set -euo pipefail

log_info() { echo "[INFO]  $1"; }
log_error() { echo "[ERROR] $1" >&2; }
log_success() { echo "[SUCCESS] $1"; }

if [[ $# -ne 1 ]]; then
  log_error "Please provide the path to a directory containing Python files."
  echo "Usage: $0 <source_dir>"
  exit 1
fi

SOURCE_DIR=$(realpath "$1")
[[ ! -d "$SOURCE_DIR" ]] && { log_error "Directory '$SOURCE_DIR' does not exist."; exit 1; }

TARGET_DIR="${SOURCE_DIR}_compiled"
log_info "Source directory: $SOURCE_DIR"
log_info "Target directory: $TARGET_DIR"

rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

log_info "Compiling .py files to .pyc..."
python3 -m compileall -q "$SOURCE_DIR"

log_info "Copying compiled .pyc files..."

find "$SOURCE_DIR" -type f -name "*.py" | while read -r py_file; do
  rel_py_path="${py_file#$SOURCE_DIR/}"
  module_dir=$(dirname "$rel_py_path")
  base_name=$(basename "$rel_py_path" .py)

  pycache_path="$SOURCE_DIR/$module_dir/__pycache__"
  pyc_file=$(find "$pycache_path" -maxdepth 1 -type f -name "$base_name.*.pyc" | head -n 1)

  if [[ -n "$pyc_file" && -f "$pyc_file" ]]; then
    dest_path="$TARGET_DIR/$module_dir/$base_name.pyc"
    mkdir -p "$(dirname "$dest_path")"
    cp "$pyc_file" "$dest_path"
    log_info "→ $module_dir/$base_name.pyc"
  else
    log_error "Missing .pyc for $rel_py_path"
  fi
done

log_success "Done! Compiled files are available at: $TARGET_DIR"
