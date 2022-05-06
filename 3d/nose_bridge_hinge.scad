include <parameters.scad>
include <core.scad>


nose_bridge_hinge();

module nose_bridge_hinge() {
    
    critical_tol = 1;
    critical_spacing = 1.5;
    critical_height = 1.5;
    
    base_height = 1;
    base_length = 4;
    base_width = 4;
    
    translate([0, 0, base_height])
    difference() {
        union() {
            // Walls
            linear_extrude(critical_height + critical_tol)
            square([base_width, base_length], center=true);
            
            translate([-base_width/2, 0, base_height+critical_height])
            rotate([0, 90, 0])
            linear_extrude(base_width)
            difference() {
                // Rounded top
                circle(d=base_length, $fn=100);
                
                // Take out half of the circle so it doesn't distort the lower portion
                translate([base_length/2, 0, 0])
                square([base_length/2, 1000], center=true);
            }
            
        }

        // Channel
        linear_extrude(100)
        square([critical_spacing, base_length+1], center=true);
        
        // Hole
        translate([-50, 0, base_length/2 + critical_height/2])
        rotate([90, 0, 90])
        linear_extrude(100)
        circle(d=1.5, $fn=100);
    }
    
    // Base square part
    linear_extrude(base_height)
    square([base_width, base_length], center=true);    
}
