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

Clone and initialize the repo
```bash
cd godot-trackpad
git submodule update --init --recursive
```

Build the [OpenMultitouchSupport](https://github.com/Kyome22/OpenMultitouchSupport) framework
```bash
git submodule update --init --recursive
```

Build the GDExtension
```bash
cd godot-trackpad
git submodule update --init --recursive
```

./build.sh
