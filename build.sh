# Usage: ./build.sh <clean>
cd "$(dirname "$0")"

if [[ "$1" == "clean" ]]; then
  # Wipe cmake cache
  rm -rf build
fi

cmake --preset macos
cmake --build build --preset macos
