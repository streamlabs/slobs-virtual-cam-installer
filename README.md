# Description

This Swift application installs the mac-camera-system-extension.

# How to Build
Run the `build.sh` script

# How to run

After its' built, copy the app file into your Applications folder. This is a console app so when double clicked you will not see output so it is best to run it from bash from the Applications folder like so:
```
# Copy the artifact into your applications folder.
cp -R build/RelWithDebInfo/slobs-virtual-cam-installer.app /Applications 
cd /Applications
./slobs-virtual-cam-installer.app/Contents/MacOS/slobs-virtual-cam-installer
```
