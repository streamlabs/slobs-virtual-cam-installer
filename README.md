# Description

This Swift application installs the streamlabs/obs-studio mac virtual camera system extension on the user's system.

# Prerequisites

CMake (minimum 3.22) and xcode 15.2

# How to Build

Run the following commands:

```
cmake --preset macos
cmake --build build --preset macos
```

The scripts will build `RelWithDebInfo` and pack the camera extension inside the app bundle.

# Command line arguments

By default, if no arguments are passed, the app will attempt to install the virtual camera system extension. If the `--deactivate` option is passed, then it will attempt to uninstall it.

# How to run

After its' built, copy the app file into your Applications folder. This is a console app so when double clicked you will not see output so it is best to run it from bash from the Applications folder like so:

```
cp -R build/RelWithDebInfo/slobs-virtual-cam-installer.app /Applications
cd /Applications
./slobs-virtual-cam-installer.app/Contents/MacOS/slobs-virtual-cam-installer
echo $?
```

Notice the addition of the `echo $?` bash command which will display the application exit code.
