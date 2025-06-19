#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# compile_to_pyc.sh
#
# Compiles all .py files in the given source directory into .pyc files,
# preserving the directory structure, and outputs them into a specified
# directory, excluding original .py files and __pycache__ folders.
#
# Usage:
#   ./compile_to_pyc.sh --source <path> [--output <path>]
#
# Examples:
#   ./compile_to_pyc.sh --source ./src
#   ./compile_to_pyc.sh --source ./src --output ./build/pyc
# ------------------------------------------------------------------------------

set -euo pipefail

log_info() { echo "[INFO]  $1"; }
log_error() { echo "[ERROR] $1" >&2; }
log_success() { echo "[SUCCESS] $1"; }

print_help() {
  echo "Usage:"
  echo "  $0 --source <path> [--output <path>]"
  echo
  echo "Options:"
  echo "  --source <path>     Path to the source directory with .py files (required)"
  echo "  --output <path>     Path to output compiled files (optional)"
  echo "  -h, --help          Show this help message"
  echo
  echo "Examples:"
  echo "  $0 --source ./src"
  echo "  $0 --source ./src --output ./dist/pyc"
  echo
}

SOURCE_DIR=""
TARGET_DIR=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      print_help
      exit 0
      ;;
    --source)
      [[ $# -lt 2 ]] && { log_error "Missing argument for --source"; exit 1; }
      SOURCE_DIR=$(realpath "$2")
      shift 2
      ;;
    --output)
      [[ $# -lt 2 ]] && { log_error "Missing argument for --output"; exit 1; }
      TARGET_DIR=$(realpath "$2")
      shift 2
      ;;
    *)
      if [[ -z "$SOURCE_DIR" ]]; then
        SOURCE_DIR=$(realpath "$1")
        shift
      else
        log_error "Unknown argument: $1"
        print_help
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$SOURCE_DIR" ]]; then
  log_error "Source directory not specified."
  print_help
  exit 1
fi

[[ ! -d "$SOURCE_DIR" ]] && { log_error "Directory '$SOURCE_DIR' does not exist."; exit 1; }

if [[ -z "$TARGET_DIR" ]]; then
  TARGET_DIR="${SOURCE_DIR}_compiled"
fi

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
