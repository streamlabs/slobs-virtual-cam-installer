cmake_minimum_required(VERSION 3.22...3.25)
project(slobs-vcam-installer)
enable_language(Swift)

execute_process(COMMAND git clone --branch "${CAMERA_EXTENSION_GIT_TAG_VER}" --depth 1 https://github.com/streamlabs/obs-studio.git)

file(COPY "obs-studio/plugins/mac-virtualcam/src/camera-extension" DESTINATION "${CMAKE_SOURCE_DIR}")


# Overwrite the default OBS CMakeLists.txt
execute_process(COMMAND cp camera-extension/slobs-CMakeLists.cmake camera-extension/CMakeLists.txt)
file(COPY "obs-studio/plugins/mac-virtualcam/src/common/data/placeholder.png" DESTINATION "${CMAKE_SOURCE_DIR}/common/data/")

# We need to use the virtual cam UUIDs from SLOBS
execute_process(COMMAND cp obs-studio/CMakePresets.json camera-extension/)

file(REMOVE_RECURSE obs-studio/) # we no longer need the entire obs folder
add_subdirectory(camera-extension)

set(SOURCES
    src/main.swift
)

add_executable(SlobsVirtualCamInstaller ${SOURCES})

message(STATUS "Setup xcode attributes.")
target_compile_options(SlobsVirtualCamInstaller PRIVATE
    -swift-version 5
    -O
)

target_link_libraries(SlobsVirtualCamInstaller PRIVATE
    swiftCore
    swiftDispatch
    swiftFoundation
)

if(DEFINED ENV{APPLE_TEAM_ID} AND NOT $ENV{APPLE_TEAM_ID} STREQUAL "")
    message(STATUS "APPLE_TEAM_ID is set. Setup codesign for xcode project")
    set_target_properties(
    SlobsVirtualCamInstaller
    PROPERTIES OUTPUT_NAME slobs-virtual-cam-installer
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
                MACOSX_BUNDLE ON
                MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist"
                XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER com.streamlabs.slobs
                XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "${CMAKE_CURRENT_SOURCE_DIR}/entitlements.plist"
                XCODE_ATTRIBUTE_PRODUCT_NAME slobs-virtual-cam-installer)

    # Switch to automatic codesigning via valid team ID
    set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_STYLE Automatic)
    set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development")
    set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM $ENV{APPLE_TEAM_ID})

    add_custom_command(
        TARGET SlobsVirtualCamInstaller
        POST_BUILD
        COMMAND
        "${CMAKE_COMMAND}" -E copy_directory "$<TARGET_BUNDLE_DIR:mac-camera-extension>"
        "$<TARGET_BUNDLE_CONTENT_DIR:SlobsVirtualCamInstaller>/Library/SystemExtensions/$<TARGET_BUNDLE_DIR_NAME:mac-camera-extension>"
        COMMENT "Add Camera Extension to application bundle")
else()
    message(STATUS "APPLE_TEAM_ID is not set. Do not codesign the xcodeproj")
    set_target_properties(
    SlobsVirtualCamInstaller
    PROPERTIES OUTPUT_NAME slobs-virtual-cam-installer
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
                MACOSX_BUNDLE ON
                XCODE_ATTRIBUTE_PRODUCT_NAME slobs-virtual-cam-installer)
endif()
