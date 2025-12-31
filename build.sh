#!/bin/bash
set -e

# Initialize our repo just in case.
git submodule update --init --recursive

# Build the framework.
cd ./dependencies/OpenMultitouchSupport
./build_framework.sh

# Change back to the root directory.
cd ..

# Copy out the newly built framework to be linked to our GDExtension
cp ./dependencies/OpenMultitouchSupport/Framework/build/Build/Products/Release ./dependencies

# Build the GDExtension.
scons