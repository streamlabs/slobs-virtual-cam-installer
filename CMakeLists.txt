cmake_minimum_required(VERSION 3.22...3.25)
project(slobs-vcam-installer)
enable_language(Swift)

set(SOURCES
    src/main.swift
)

add_executable(SlobsVirtualCamInstaller ${SOURCES})

target_compile_options(SlobsVirtualCamInstaller PRIVATE
    -swift-version 5
    -O
)

target_link_libraries(SlobsVirtualCamInstaller PRIVATE
    swiftCore
    swiftDispatch
    swiftFoundation
)

set_target_properties(
  SlobsVirtualCamInstaller
  PROPERTIES OUTPUT_NAME slobs-virtual-cam-installer
             RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
             MACOSX_BUNDLE ON
             MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"
             XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER com.streamlabs.slobs
             XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "${CMAKE_CURRENT_SOURCE_DIR}/entitlements.plist"
             XCODE_ATTRIBUTE_PRODUCT_NAME slobs-virtual-cam-installer)

set(teamId $ENV{APPLE_TEAM_ID})
if(teamId STREQUAL "")
    message(WARNING "APPLE_TEAM_ID is not set or empty.")
else()
    # Switch to automatic codesigning via valid team ID
    set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_STYLE Automatic)
    set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development")
    set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM $ENV{APPLE_TEAM_ID})
    #set(XCODE_ATTRIBUTE_PRODUCT_NAME slobs-virtual-cam-installer)

    # Run shell script to install the mac-camera-extension
    add_custom_target(run_script ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Running the shell script..."
        COMMAND bash "./install-mac-camera-ext.sh" "${CAMERA_EXTENSION_GIT_TAG_VER}"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        COMMENT "Executing script.sh from CMake"
    )
endif()
