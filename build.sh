#!/bin/bash
set -e

# Initialize our repo just in case.
git submodule update --init --recursive

# Build the framework.
cd ./OpenMultitouchSupport
./build_framework.sh

# Change back to the root directory.
cd ..

# Build the GDExtension.
scons