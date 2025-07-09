
cd build
echo "Download mac_camera_extension using git tag $1"
git clone --branch "$1" --depth 1 https://github.com/streamlabs/obs-studio.git

root=$(pwd)
echo "Starting directory is $root"
cd obs-studio/plugins/mac-virtualcam/src/camera-extension 

echo "Build the mac-camera-extension"
./build-slobs-cameraextension.sh

echo "Copy system extension into the app"
cd "$root"
ls
mkdir -p ./RelWithDebInfo/slobs-virtual-cam-installer.app/Contents/Library/SystemExtensions/
cp -R obs-studio/plugins/mac-virtualcam/src/camera-extension/build_macos/RelWithDebInfo/com.streamlabs.slobs.mac-camera-extension.systemextension "$root"/RelWithDebInfo/slobs-virtual-cam-installer.app/Contents/Library/SystemExtensions/
