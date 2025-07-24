// This script copies over the VirtualCamGUIDs from streamlabs/obs-studio
const fs = require('fs')
const cameraExtensionJson = require('./camera-extension/CMakePresets.json')
let json = require('./CMakePresets.json')

/*
{
  "configurePresets": [
    {
      "name": "environmentVars",
      "hidden": true
    },
    {
      "name": "macos",
      "displayName": "macOS",
      "description": "Default macOS build (single architecture only)",
      "inherits": ["environmentVars"],
      "condition": {
        "type": "equals",
        "lhs": "${hostSystemName}",
        "rhs": "Darwin"
      },
      "generator": "Xcode",
      "binaryDir": "${sourceDir}/build",
      "cacheVariables": {
        "CAMERA_EXTENSION_GIT_TAG_VER": {"type": "STRING", "value": "30.2.4sl22-vcam-sysext2"},
        "VIRTUALCAM_DEVICE_UUID": {"type": "STRING", "value": "6FA459EA-EE8A-3CA4-894E-DB77E160355E"},
        "VIRTUALCAM_SOURCE_UUID": {"type": "STRING", "value": "1E2D9632-D9A4-445C-B3CB-7C474442C1DF"},
        "VIRTUALCAM_SINK_UUID": {"type": "STRING", "value": "CE9DCB01-5C0C-4F3E-AC1A-971D26CB77D1"}
      }
    }
}
*/
console.log('Copy over Virtual cam device GUIDs to ensure they are in-sync');

json.configurePresets[1].cacheVariables.VIRTUALCAM_DEVICE_UUID = cameraExtensionJson.configurePresets[1].cacheVariables.VIRTUALCAM_DEVICE_UUID;
json.configurePresets[1].cacheVariables.VIRTUALCAM_SOURCE_UUID = cameraExtensionJson.configurePresets[1].cacheVariables.VIRTUALCAM_SOURCE_UUID;
json.configurePresets[1].cacheVariables.VIRTUALCAM_SINK_UUID = cameraExtensionJson.configurePresets[1].cacheVariables.VIRTUALCAM_SINK_UUID;

console.log('saving updated json')
fs.writeFileSync('CMakePresets.json', JSON.stringify(json, null, 2), 'utf8');
