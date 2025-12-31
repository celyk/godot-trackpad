# Godot trackpad GDExtension

An addon that exposes trackpad data via Apples private MultitouchSupport framework

# Usage

Copy the GodotTrackpad addon into your project
Enable the addon in the project settings
Create a TrackpadDebug node to see if it works

# Features

- [x] Query trackpad dimensions
- [x] Complete raw touch data
- [ ] Emulate screen touch events

# Build

First clone and initialize the repo
```bash
cd godot-trackpad
git submodule update --init --recursive
```

As the GDExtension depends on [OpenMultitouchSupport](https://github.com/Kyome22/OpenMultitouchSupport), we have to include it somewhere.

Build the [OpenMultitouchSupport](https://github.com/Kyome22/OpenMultitouchSupport) framework
```bash
# Build the framework.
cd ./OpenMultitouchSupport
./build_framework.sh

# Change back to the root directory for the next step.
cd ..
```

If the build fails, it's because the framework need to be signed. You can fix it by selecting your team in the Xcode project.

Alternatively, you can download the framework from [releases](https://github.com/Kyome22/OpenMultitouchSupport/releases) and copy it to this directory under the repo.
```
./framework
```

Build the GDExtension
```bash
scons
```
