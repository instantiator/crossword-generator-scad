#!/bin/bash

set -e
set -o pipefail

usage() {
  cat << EOF
Options:
    -i         --input-scad           Input file (scad)
    -o         --output-file          Output file (eg. stl)
    -h         --help                 Prints this help message and exits
EOF
}

# defaults

# parameters
while [ -n "$1" ]; do
  case $1 in
  -i | --input-scad)
      shift
      INPUT_SCAD=$1
      ;;
  -o | --output-file)
      shift
      OUTPUT_FILE=$1
      ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo -e "Unknown option $1...\n"
    usage
    exit 1
    ;;
  esac
  shift
done

if [ -z "$INPUT_SCAD" ]; then
  echo "Please provide the input SCAD file with the --input-scad parameter."
  exit 1
fi
if [ -z "$OUTPUT_FILE" ]; then
  echo "Please provide the output filename with the --output-file parameter."
  exit 1
fi

if [ ! -f "$INPUT_SCAD" ]; then
  echo "SCAD file not found: $INPUT_SCAD"
  exit 1
fi

echo "Converting SCAD with openscad..."
echo "Input file:  $INPUT_SCAD"
echo "Output file: $OUTPUT_FILE"
echo

docker run -v $(pwd):/openscad openscad/openscad openscad $INPUT_SCAD -o $OUTPUT_FILE
echo
