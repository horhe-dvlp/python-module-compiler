# compile_to_pyc.sh

## Overview

The `compile_to_pyc.sh` script is a utility for compiling all `.py` files in a specified source directory into `.pyc` files. It preserves the directory structure of the source directory and outputs the compiled files into a new sibling directory named `<source>_compiled`. The script excludes all original `.py` files and `__pycache__` folders from the output.

## Features

- Compiles `.py` files to `.pyc` files using Python's `compileall` module.
- Preserves the directory structure of the source directory.
- Outputs compiled files into a new sibling directory named `<source>_compiled`.
- Automatically excludes original `.py` files and `__pycache__` folders from the output.
