include <parameters.scad>

// Main hinge design
hex_z = 2;
hex_bore = 4 + .1;
bolt_bore = 2;

// General sizing parameters
spacing = 2;
base_h = 2;

hinge_w = 4;
hinge_h = 6+3.25;
hinge_z = 5;


// Red thing
wall_z = 1;
wall_h = base_h + hinge_h - 1.5;

function hinge_height() = hinge_w*2+spacing;
function hinge_width() = wall_z + hinge_z;

module hinge_wall() {
    
    difference() {
        // Main hinge part
        linear_extrude(hinge_h-1.5)
        translate([(hinge_w + spacing)/2, 0, 0])
        square([hinge_w, hinge_z], center=true);
        

        
        // Through-hole
        color("red")
        translate([(hinge_w + spacing)/2, 0, 0])
        translate([-hinge_w/2, 0, hinge_h/2])
        rotate([0, 90, 0])
        union() { 
            // Main bolt channel
            color("red")
            linear_extrude(hinge_w)
            circle(d=bolt_bore + tol, $fn=10);
            
            // Nut channel
            translate([0, 0, hinge_w-hex_z])
            linear_extrude(hex_z)
            circle(d=hex_bore + tol, $fn=6);
            
            // Square depression above nut
            translate([-10, 0, hinge_w-hex_z])
            linear_extrude(hex_z)
            square([ 20, hinge_z], center=true);

        }
    }
    
}


module hinge() {
    difference() {
        union() {
            // Main hinge part
            translate([0, 0, base_h])
            union() {
                hinge_wall();
                mirror([-1, 0, 0])
                hinge_wall();
            }

            // Base
            linear_extrude(base_h)
            square([hinge_w*2+spacing, hinge_z], center=true);

            // Wall
            color("red")
            translate([0, (hinge_z + wall_z)/2, 0])
            linear_extrude(wall_h+.25)
            square([hinge_height(), wall_z], center=true);   
        }
 
    }
}

//hinge();