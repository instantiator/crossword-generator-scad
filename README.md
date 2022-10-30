# crossword-generator-scad

## Create an input CSV

You can create a crossword of up to 11x9 characters.

* [Copy the template sheet](https://docs.google.com/spreadsheets/d/1V18dAKi18F9mF3wuK5d-L5pdg0llTGk-J9Tq7vYNg_I/copy)
* Edit in your characters. Use lower case for regular letters, and upper case for highlights.
* Export as CSV.

## Activity

* Creates `working` and `results` directories.
* Uses ScadGenerator with your input CSV and `templates/crossword-template.scad` to generate a working SCAD file.
* Uses the [openscad/openscad](https://hub.docker.com/r/openscad/openscad) Docker image to generate STL from SCAD.
