# Description

This Swift application installs the streamlabs/obs-studio mac virtual camera system extension on the user's system.

# Prerequisites

CMake (minimum 3.22) and xcode 15.2

# How to Build

Make sure you define the `APPLE_TEAM_ID` environment variable which is required because the build scripts will download the slobs-mac-virtual camera system extension and codesign it.
Run the following commands below (or just run `build.sh` script):

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

# CI build notes

The CI build does not code sign the app. When Streamlabs Desktop packages the installer, it replaces the provisioning profile, code signature, and entitlements with Streamlabs' Developer ID. Because of this, the standalone app produced by CI can't activate the camera extension as-is.

To test the standalone app, either:
- Build it locally with `./build.sh`, which signs it automatically (requires an Apple account on the Streamlabs team signed in under Xcode → Settings → Accounts), or
- Sign the CI artifact yourself: extract the app bundle into `build/RelWithDebInfo/`. From the `streamlabs/obs-studio` revision used to build that artifact, copy `plugins/mac-virtualcam/src/camera-extension/cmake/macos/slobs-entitlements.plist` to `build/camera-ext-entitlements.plist` (the CI tarball does not include this file). Embed the appropriate provisioning profiles, then codesign the system extension and the app with their entitlements, using `codesign_development.sh` as a reference.
