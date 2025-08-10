root=$(pwd)
cd build/RelWithDebInfo

/usr/bin/codesign -o runtime --force --sign "$APPLE_SLD_IDENTITY" --entitlements "$root"/build/camera-ext-entitlements.plist  --timestamp\=none --generate-entitlement-der slobs-virtual-cam-installer.app/Contents/Library/SystemExtensions/com.streamlabs.slobs.mac-camera-extension.systemextension

cp -R "$SYSEXT_INSTALLER_PROVISIONING_PROFILE" slobs-virtual-cam-installer.app/Contents/embedded.provisionprofile
/usr/bin/codesign -o runtime --force --sign "$APPLE_SLD_IDENTITY" --entitlements "$root"/entitlements.plist --timestamp\=none --generate-entitlement-der /Users/rosbo/projects/streamlabs/slobs-vcam-installer/build/RelWithDebInfo/slobs-virtual-cam-installer.app

echo "$0 run ditto slobs-virtual-cam-installer.app /Applications/slobs-virtual-cam-installer.app"
ditto slobs-virtual-cam-installer.app /Applications/slobs-virtual-cam-installer.app
