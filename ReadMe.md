# compile_to_pyc.sh

## Overview

`compile_to_pyc.sh` is a shell utility for compiling all `.py` files in a specified source directory into `.pyc` bytecode files. It preserves the original directory structure and excludes all source `.py` files and `__pycache__` folders from the output.

## Features

- Compiles `.py` files to `.pyc` using Python's `compileall` module
- Preserves the original directory hierarchy
- Outputs compiled files to a specified directory
- Skips `.py` source files and `__pycache__` folders
- Can be installed system-wide as the `compile_py` command
- Supports `--source`, `--output`, and `--help` flags

## Installation

### Clone the repository

```bash
git clone https://github.com/horhe-dvlp/python-module-compiler.git
cd python-module-compiler
```

### Install as a global command

```bash
sudo install -m 755 compile_to_pyc.sh /usr/local/bin/compile_py
```

This will make the `compile_py` command available globally.

### Uninstall

```bash
sudo rm /usr/local/bin/compile_py
```

## Usage

```bash
compile_py --source <path/to/source> [--output <path/to/output>]
```

### Examples

Compile `.py` files in `./src` and store the output in `./src_compiled`:

```bash
compile_py --source ./src
```

Specify a custom output directory:

```bash
compile_py --source ./src --output ./build/compiled
```

Show help:

```bash
compile_py --help
```

## Arguments

| Argument        | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `--source`       | (Required) Path to the directory containing `.py` files                     |
| `--output`       | (Optional) Output directory for `.pyc` files (default: `<source>_compiled`) |
| `--help`, `-h`   | Show usage information                                                      |

## Output Structure

Input:

```
src/
└── module/
    ├── __init__.py
    └── utils.py
```

Output:

```
src_compiled/
└── module/
    ├── __init__.pyc
    └── utils.pyc
```

## Requirements

- `bash` (POSIX-compatible shell)
- `python3` (with standard `compileall` module)

## License

MIT License
