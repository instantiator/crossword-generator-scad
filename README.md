# crossword-generator-scad

**Work in progress. TODOs:**

* Modify ScadGenerator to read and modify the template based on the input CSV.
* Modify the size of the output based on the size of the crossword provided.
* Allow the cells to be modified in size, too.
* Optional extra: permit numbers in cells. (Figure out how.)

## Usage

Use `generate-crossword.sh` to convert a CSV file into a 3-dimensional crossword STL.

eg.

```shell
./generate-crossword --input-csv samples/clarbert-crossword.csv
```

### Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop/)

### Activity

* Creates `working` and `results` directories.
* Builds and runs a Docker image of ScadGenerator to generate a working SCAD file.
* Uses the [openscad/openscad](https://hub.docker.com/r/openscad/openscad) Docker image to generate the final STL.

## Create an input CSV

You can create a crossword of up to 11x9 characters.

* [Copy the template sheet](https://docs.google.com/spreadsheets/d/1V18dAKi18F9mF3wuK5d-L5pdg0llTGk-J9Tq7vYNg_I/copy)
* Edit in your characters. Use lower case for regular letter spaces, and upper case for highlighted spaces.
* Export as CSV.
