# Description

This Swift application installs the mac-camera-system-extension.

# Prerequisites

CMake (minimum 3.22) and xcode 15.2

# How to Build

Run the following commands:

```
cmake --preset macos
cmake --build build --preset macos
```

When you open xcode you'll likely want to switch to "ALL_BUILD" because you'll be in Debug (the script only builds `RelWithDebInfo`). This will ensure everything is fully built for your active config (Debug, Release, RelWithDebInfo)

# How to run

After its' built, copy the app file into your Applications folder. This is a console app so when double clicked you will not see output so it is best to run it from bash from the Applications folder like so:

```
# Copy the artifact into your applications folder.
cp -R build/RelWithDebInfo/slobs-virtual-cam-installer.app /Applications
cd /Applications
./slobs-virtual-cam-installer.app/Contents/MacOS/slobs-virtual-cam-installer
```
