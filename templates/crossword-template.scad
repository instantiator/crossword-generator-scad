selection = {{MODE}};
single_cell_test = {{SINGLE_CELL_TEST}};

show_base  = selection == 0 || selection == 1;
show_cells = selection == 0 || selection == 2;
show_marks = selection == 0 || selection == 3;

// design
data = single_cell_test ? [[0,1,2]] : {{DESIGN}};
characters_wide = single_cell_test ? 3 : {{DESIGN_WIDTH}};
characters_deep = single_cell_test ? 1 : {{DESIGN_HEIGHT}};

tile_width={{TILE_WIDTH}};
tile_depth={{TILE_DEPTH}};

base_height={{BASE_HEIGHT}};
cell_height={{CELL_HEIGHT}};
mark_height = 1;

echo(str("Base: 0.0 - ", base_height));
echo(str("Cell: ", base_height, " - ", base_height + cell_height));
echo(str("Mark: ", base_height + cell_height, " - ", base_height + cell_height + mark_height));

cell_margin=0.5;
cell_border=1;
base_padding=2;

base_width = (base_padding*2) + ((cell_border + (cell_margin*2) + tile_width) * characters_wide) + cell_border;
base_depth = (base_padding*2) + ((cell_border + (cell_margin*2) + tile_depth) * characters_deep) + cell_border;

echo("Recommended max: {{MAX_WIDTH}} x {{MAX_HEIGHT}}");
echo(str("Width: ", base_width));
echo(str("Depth: ", base_depth));

// render base
if (show_base) {
    cube([base_width, base_depth, base_height]);
}

// render cells
if (show_cells) {
    for (x = [0 : characters_wide-1]) {
        for (y = [0 : characters_deep-1]) {
            y_from_top=characters_deep-1-y;
            if (data[y][x] == 1 || data[y][x] == 2) cell(x,y_from_top,false);
        }
    }
}

// render marks
if (show_marks) {
    for (x = [0 : characters_wide-1]) {
        for (y = [0 : characters_deep-1]) {
            y_from_top=characters_deep-1-y;
            if (data[y][x] == 2) cell(x,y_from_top,true);
        }
    }
}

module cell(x,y,mark) {
    translate([base_padding, base_padding, base_height])
        translate([
            (cell_border+(cell_margin*2)+tile_width) * x,
            (cell_border+(cell_margin*2)+tile_depth) * y, 
            mark ? cell_height : 0]) {
            render() {
                difference() {
                    cube([
                        cell_border+cell_margin+tile_width+cell_margin+cell_border,
                        cell_border+cell_margin+tile_depth+cell_margin+cell_border,
                        mark ? mark_height : cell_height]);
                    translate([cell_border, cell_border, -0.5])
                        cube([
                            cell_margin+tile_width+cell_margin,
                            cell_margin+tile_depth+cell_margin,
                            (mark ? mark_height : cell_height) + 1]);
                }
            }

            if (!mark) {
                translate([
                    ((cell_border*2)+(cell_margin*2)+tile_width) / 2,
                    ((cell_border*2)+(cell_margin*2)+tile_depth) / 2,
                    0])
                    cylinder(
                        cell_height / 2,
                        ((cell_border*2)+(cell_margin*2)+tile_width) / 6,
                        ((cell_border*2)+(cell_margin*2)+tile_width) / 6
                    );
                    // cube([
                    //     ((cell_border*2)+(cell_margin*2)+tile_width) / 3,
                    //     ((cell_border*2)+(cell_margin*2)+tile_depth) / 3,
                    //     cell_height / 3]);
            }
        }
}
