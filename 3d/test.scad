include <core.scad>
include <parameters.scad>

difference() {
    
    w = 10;
    d = w / 2;
    
    base = 4;
    
    origin = [-d, 0];
    final = [d, 0];
    
    
    polygon([
        
        each bezier(origin[0], origin[1], 0, 10, 0, 10, final[0], final[1]),
        [d, -10],
    ]);
}