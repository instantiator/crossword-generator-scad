#!/bin/bash

set -e
set -o pipefail

usage() {
  cat << EOF
Options:
    -i <path>  --input-csv  <path>    CSV representing the crossword.
    -v <path>  --input-vars <path>    Input variables CSV.
    -p <name>  --project-name <name>  Name the project - helps with tracing file names etc.
    -h         --help                 Prints this help message and exits
EOF
}

# defaults
PROJECT_NAME=working-design
MODE=0

# parameters
while [ -n "$1" ]; do
  case $1 in
  -i | --input-csv)
      shift
      INPUT_CSV=$1
      ;;
  -v | --input-vars)
      shift
      INPUT_VARS=$1
      ;;
  -p | --project-name)
      shift
      PROJECT_NAME=$1
      ;;
  -m | --mode)
      shift
      MODE=$1
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

if [ -z "$INPUT_VARS" ]; then
  echo "Please provide the variables CSV with the --input-vars parameter."
  exit 1
fi
if [ ! -f "$INPUT_VARS" ]; then
  echo "CSV file not found: $INPUT_CSV"
  exit 1
fi

echo "Building project: ${PROJECT_NAME}"
echo

scripts/init-directories.sh
rm -rf working/*

# init some paths
INPUT_TEMPLATE_PATH=templates/crossword-template.scad
WORKING_SCAD_PATH=working/${PROJECT_NAME}.scad

# generate SCAD
scripts/generate-scad.sh \
  --input-csv $INPUT_CSV \
  --input-template $INPUT_TEMPLATE_PATH \
  --input-vars $INPUT_VARS \
  --output-scad $WORKING_SCAD_PATH

# generate STL
OUTPUT_STL_PATH=results/$(basename $WORKING_SCAD_PATH).stl
scripts/generate-stl.sh --input-scad $WORKING_SCAD_PATH --output-file $OUTPUT_STL_PATH
