#!/bin/bash

set -e
set -o pipefail

usage() {
  cat << EOF
Options:
    -i         --input-csv            CSV representing the crossword.
    -h         --help                 Prints this help message and exits
EOF
}

# defaults

# parameters
while [ -n "$1" ]; do
  case $1 in
  -i | --input-csv)
      shift
      INPUT_CSV=$1
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

if [ -z "$INPUT_CSV" ]; then
  echo "Please provide the input CSV with the --input-csv parameter."
  exit 1
fi
if [ ! -f "$INPUT_CSV" ]; then
  echo "CSV file not found: $INPUT_CSV"
  exit 1
fi

scripts/init-directories.sh
rm -rf working/*

# generate SCAD
INPUT_TEMPLATE_PATH=templates/crossword-template.scad
WORKING_SCAD_PATH=working/crossword-working.scad
scripts/generate-scad.sh \
  --input-csv $INPUT_CSV \
  --input-template $INPUT_TEMPLATE_PATH \
  --output-scad $WORKING_SCAD_PATH

# generate STL
OUTPUT_STL_PATH=results/$(basename $WORKING_SCAD_PATH).stl
scripts/generate-stl.sh --input-scad $WORKING_SCAD_PATH --output-file $OUTPUT_STL_PATH
