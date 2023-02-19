#!/bin/bash

set -e
set -o pipefail

usage() {
  cat << EOF
Options:
    -i         --input-csv            Input crossword CSV file
    -t         --input-template       Input SCAD template
    -v         --input-vars           Input template variables (CSV file)
    -o         --output-scad          Output SCAD file
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
  -t | --input-template)
      shift
      INPUT_TEMPLATE=$1
      ;;
  -v | --input-vars)
      shift
      INPUT_VARS=$1
      ;;
  -o | --output-scad)
      shift
      OUTPUT_SCAD=$1
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
  echo "Please provide the input CSV file with the --input-csv parameter."
  exit 1
fi
if [ -z "$INPUT_TEMPLATE" ]; then
  echo "Please provide the input CSV file with the --input-template parameter."
  exit 1
fi
if [ -z "$INPUT_VARS" ]; then
  echo "Please provide a CSV file with the variable substitutions for the template."
  exit 1
fi
if [ -z "$OUTPUT_SCAD" ]; then
  echo "Please provide the output SCAD file with the --output-scad parameter."
  exit 1
fi

if [ ! -f "$INPUT_CSV" ]; then
  echo "CSV file not found: $INPUT_CSV"
  exit 1
fi
if [ ! -f "$INPUT_VARS" ]; then
  echo "CSV file not found: $INPUT_VARS"
  exit 1
fi
if [ ! -f "$INPUT_TEMPLATE" ]; then
  echo "SCAD file not found: $INPUT_TEMPLATE"
  exit 1
fi

WORKING_CSV_PATH=working/$(basename $INPUT_CSV)
WORKING_VARS_PATH=working/$(basename $INPUT_VARS)

echo "Generating SCAD file from CSV..."
echo "Input CSV:    $INPUT_CSV"
echo "Input vars:   $INPUT_VARS"
echo "Working CSV:  $WORKING_CSV_PATH"
echo "Working vars: $WORKING_VARS_PATH"
echo "Template:     $INPUT_TEMPLATE"
echo "Ouptut SCAD:  $OUTPUT_SCAD"
echo

cp $INPUT_CSV $WORKING_CSV_PATH
cp $INPUT_VARS $WORKING_VARS_PATH

docker build -t scad-generator -f Dockerfile .
docker run -it \
  -v $(pwd)/working:/working \
  -v $(pwd)/templates:/templates \
  scad-generator \
  --input-csv /$WORKING_CSV_PATH \
  --input-vars /$WORKING_VARS_PATH \
  --input-template /$INPUT_TEMPLATE \
  --output-scad /$OUTPUT_SCAD
