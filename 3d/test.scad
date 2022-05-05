include <core.scad>
include <parameters.scad>

function loop(base_x=3, offset_left=0, offset_right=0, size_x=0, size_y=0, w=6,length=14) = bezier(
    offset_left, 
    0, 
    -w+size_x,    // x 
    length-size_y,   // y
    w-size_x,    // x
    length,   // y
    base_x-offset_right, 
    0
);

difference() {
    polygon(loop());
    color("red")
    polygon(loop(size_x=3, size_y=4, offset_left=1, offset_right=1));
    
}
