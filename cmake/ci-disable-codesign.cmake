# Loaded via the CMAKE_TOOLCHAIN_FILE env var on CI (see build.sh) so it also reaches the nested
# camera-extension build. Streamlabs Desktop re-signs the installer and extension when packaging.
set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED NO)
