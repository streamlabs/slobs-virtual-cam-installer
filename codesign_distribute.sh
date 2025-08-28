# This script will codesign & notarize the app
root=$(pwd)
cd build/RelWithDebInfo

if [ -z "${APPLE_DEVELOPER_PROVISIONING_PROFILE}" ]; then
  echo "Error: APPLE_DEVELOPER_PROVISIONING_PROFILE is not set."
  exit 1
fi

/usr/bin/codesign -o runtime --force --sign "Developer ID Application: ${APPLE_SLD_IDENTITY}" --entitlements "$root"/build/camera-ext-entitlements.plist --timestamp slobs-virtual-cam-installer.app/Contents/Library/SystemExtensions/com.streamlabs.slobs.mac-camera-extension.systemextension

echo "$0 replace provisioning profile"
cp -R "$APPLE_DEVELOPER_PROVISIONING_PROFILE" slobs-virtual-cam-installer.app/Contents/embedded.provisionprofile


/usr/bin/codesign -o runtime --force --sign "Developer ID Application: ${APPLE_SLD_IDENTITY}" --entitlements "$root"/entitlements.plist --timestamp /Users/rosbo/projects/streamlabs/slobs-vcam-installer/build/RelWithDebInfo/slobs-virtual-cam-installer.app

echo "$0 run ditto slobs-virtual-cam-installer.app /Applications/slobs-virtual-cam-installer.app"
ditto slobs-virtual-cam-installer.app /Applications/slobs-virtual-cam-installer.app

zip -r slobs-virtual-cam-installer.zip slobs-virtual-cam-installer.app

xcrun notarytool submit slobs-virtual-cam-installer.zip \
  --apple-id "$APPLE_ID" \
  --team-id "$APPLE_TEAM_ID" \
  --password "$APPLE_APP_PASSWORD" \
  --wait


xcrun stapler staple slobs-virtual-cam-installer.app

echo "$0 run gatekeeper analysis post-notarytool"
spctl --assess --type execute --verbose=4 slobs-virtual-cam-installer.app
codesign --verify --verbose=4 slobs-virtual-cam-installer.app

#xcrun notarytool log c2a0836d-c24f-4d33-b861-a7d74997e36f --apple-id "$APPLE_ID" --team-id $APPLE_TEAM_ID --password "$APPLE_APP_PASSWORD"

echo "$0 run ditto slobs-virtual-cam-installer.app /Applications/slobs-virtual-cam-installer.app"
ditto slobs-virtual-cam-installer.app /Applications/slobs-virtual-cam-installer.app
