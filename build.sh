# Usage: ./build.sh [--clean | --arch=<arch>]
function display_usage {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Description: This script builds the Streamlabs Mac Virtual Camera installer app."
  echo ""
  echo "Options:"
  echo "  -h, --help        Display this help message and exit."
  echo "  --arch            sets CMAKE_OSX_ARCHITECTURES For example- arm64 or x86_64"
  echo "  --clean,-c        cleans cmake cache"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") --arch=x86_64"
  exit 0
}

if [[ ( "$1" == "--help" ) || ( "$1" == "-h" ) ]]; then
  display_usage
  exit 0
fi

cd "$(dirname "$0")"
cmake_args=()

for arg in "$@"
do
  if [[ ("$arg" == "--clean") || ("$arg" == "-c") ]]; then
    # Wipe cmake cache
    rm -rf build
  elif [[ $arg == --arch=* ]]; then
    # Extract the value using parameter expansion
    arch_value="${arg#*=}"
    cmake_args+=(-DCMAKE_OSX_ARCHITECTURES=${arch_value})
  fi
done

cmake --preset macos "${cmake_args[@]}"
cmake --build build --preset macos
