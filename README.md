# crossword-generator-scad

_Work in progress..._

**TODOs:**

- [x] Modify ScadGenerator to read and modify the template based on the input CSV.
- [x] Modify the size of the output based on the size of the crossword provided.
- [x] Allow selection of mode.
- [x] Allow the cells to be modified in size, too.
- [ ] Print numbers into cells.

## Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop/)

## Usage

Use `generate-crossword.sh` to convert a CSV file into a 3-dimensional crossword STL.

eg.

```shell
./generate-crossword.sh -i inputs/meta-crosstick-samuel-design.csv -p meta-puzzle -v templates/crossword-defaults.csv
```

### Activity

When running, this tool does the following:

1. Creates `working` and `results` directories.
2. Builds and runs a Docker image of ScadGenerator to generate a working SCAD file.
  * Inputs: `templates/crossword-template.scad` and the `--input-csv` file
  * Output: `working/crossword-working.scad`
3. Uses the [openscad/openscad](https://hub.docker.com/r/openscad/openscad) Docker image to generate the final STL.
4. In mode 0, also inserts colour change points with MT600 instructions.

## Inputs

### Crossword CSV

You can use a CSV of any side. A grid of up to 11 x 9 characters will fit on a Snapmaker 250 series.

* [Copy the template sheet](https://docs.google.com/spreadsheets/d/1V18dAKi18F9mF3wuK5d-L5pdg0llTGk-J9Tq7vYNg_I/copy)
* Edit in your characters. Use lower case for regular letter spaces, and upper case for highlighted spaces.
* Export as CSV.

### Variable substitutions

To alter variables that control the template, provide an alternative CSV file with the `-v` option. You can copy `templates/crossword-defaults.csv` to do this. It is a CSV file with no heading and 3 columns:

1. Variable name, eg. `MODE`
2. Value, eg. `0`
3. Human readable notes _(not used)_

## Filament changes

When printing a crossword, there are 3 distinct sections:

* The base
* The cells
* The highlights

To change filament between layers for a multicoloured effect, you'll need to:

* Identify the topmost printed layer of each section
* Export the GCode from your favourite slicer
* Insert an `M600` command at the end of the last layer of each section
* Print from your newly modified GCode directly

See: [Add command M600 in your GCode file](https://forum.snapmaker.com/t/add-command-m600-in-your-g-code-file/18242)
