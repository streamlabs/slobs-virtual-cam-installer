# Usage: ./build.sh <clean>
if [[ "$1" == "clean" ]]; then
  # Wipe cmake cache
  rm -rf build
fi

cmake --preset macos
cmake --build build --preset macos
