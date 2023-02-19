#!/bin/bash

set -e
set -o pipefail

usage() {
  cat << EOF
Options:
    -i         --input-csv            Input CSV file
    -t         --input-template       Input SCAD template
    -o         --output-scad          Output SCAD file
    -m         --mode                 Mode for the template
    -h         --help                 Prints this help message and exits
EOF
}

# defaults
MODE=0

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
  -o | --output-scad)
      shift
      OUTPUT_SCAD=$1
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
  echo "Please provide the input CSV file with the --input-csv parameter."
  exit 1
fi
if [ -z "$INPUT_TEMPLATE" ]; then
  echo "Please provide the input CSV file with the --input-template parameter."
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
if [ ! -f "$INPUT_TEMPLATE" ]; then
  echo "CSV file not found: $INPUT_TEMPLATE"
  exit 1
fi

WORKING_CSV_PATH=working/$(basename $INPUT_CSV)

echo "Generating SCAD file from CSV..."
echo "Input CSV:   $INPUT_CSV"
echo "Working CSV: $WORKING_CSV_PATH"
echo "Template:    $INPUT_TEMPLATE"
echo "Mode:        $MODE"
echo "SCAD file:   $OUTPUT_SCAD"
echo

cp $INPUT_CSV $WORKING_CSV_PATH

docker build -t scad-generator -f Dockerfile .
docker run -it \
  -v $(pwd)/working:/working \
  -v $(pwd)/templates:/templates \
  scad-generator \
  --input-csv /$WORKING_CSV_PATH \
  --input-template /$INPUT_TEMPLATE \
  --mode $MODE \
  --output-scad /$OUTPUT_SCAD

# generate SCAD
# dotnet run --project ScadGenerator/ScadGenerator.csproj -- \
#   --input-csv $INPUT_CSV \
#   --input-template $INPUT_TEMPLATE_PATH \
#   --output-scad $WORKING_SCAD_PATH
