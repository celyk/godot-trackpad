# Godot trackpad GDExtension

An addon that exposes trackpad data via Apples private MultitouchSupport framework.

<img width="562" height="347" alt="image" src="https://github.com/user-attachments/assets/b1a1d2ee-d966-481a-a786-e34697d5c3f6" />


# Usage

- Copy the GodotTrackpad addon into your project
- Enable the addon in the project settings
- Create a TrackpadDebug node to test it out

# Features

- [x] Query trackpad dimensions
- [x] Complete raw touch data
- [ ] Emulate screen touch events

# Supported platforms

Currently only macOS is supported. I'm open to supporting other platforms, but I can't do it without help.

# Building the addon

First clone and initialize the repository:
```bash
cd godot-trackpad
git submodule update --init --recursive
```

Build the GDExtension:
```bash
scons
```

The addon should be ready to use.

# Building dependencies

The repository includes the prebuilt framework under `./dependencies/`, but it can be built manually.

Build the [OpenMultitouchSupport](https://github.com/Kyome22/OpenMultitouchSupport) framework:
```bash
# Build the framework.
cd ./dependencies/OpenMultitouchSupport
./build_framework.sh

# Return to the root directory.
cd ../..
```

Copy the framework out:
```bash
TODO
```

If the build fails, it's because the framework needs signing. You can fix it by selecting a team in the Xcode project and rebuild.

Alternatively, you can download the framework from [releases](https://github.com/Kyome22/OpenMultitouchSupport/releases) and place it in the same directory.
