// This script copies over the VirtualCamGUIDs from streamlabs/obs-studio
const cameraExtensionJson = require('./camera-extension/CMakePresets.json')
let json = require('./CMakePresets.json')

console.log('Verify virtual cam device GUIDs to ensure they are in-sync');

if (json.configurePresets[1].cacheVariables.VIRTUALCAM_DEVICE_UUID.value != cameraExtensionJson.configurePresets[1].cacheVariables.VIRTUALCAM_DEVICE_UUID.value) {
    console.error("VIRTUALCAM_DEVICE_UUID does not match");
    process.exit(1);
}
if (json.configurePresets[1].cacheVariables.VIRTUALCAM_SOURCE_UUID.value != cameraExtensionJson.configurePresets[1].cacheVariables.VIRTUALCAM_SOURCE_UUID.value) {
    console.error("VIRTUALCAM_SOURCE_UUID does not match");
    process.exit(1);
}
if (json.configurePresets[1].cacheVariables.VIRTUALCAM_SINK_UUID.value != cameraExtensionJson.configurePresets[1].cacheVariables.VIRTUALCAM_SINK_UUID.value) {
    console.error("VIRTUALCAM_SINK_UUID does not match");
    process.exit(1);
}
console.log('All virtual cam GUIDs are in-sync!');
