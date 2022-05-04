include <core.scad>
include <parameters.scad>

other = 3.25;
base_x = 4;
base_y = 14;

spacing = 2;
bore = 2.2;

fin_height = 10;
temple_length = 105;
temple_wall = fin_height;
temple_width = 10;


drop_angle = 45;
drop_width = other+spacing;

module thinner() {
    x0 = other+spacing;
    l1 = -10;
    
    mirror([0, -1, 0])
    polygon([
        [-x0/2, 0],
        [x0/2, 0],
        [x0/2, l1],
        [x0/2, temple_length],
        [-x0/2,temple_length],
        [-x0/2,l1],
    ]);
 
}

module pin() {    
    translate([temple_wall/2 - .38 - base_x, -7+4.5, 0])
    linear_extrude(spacing)
    difference() {
        union() {
            square([base_x, base_y], center=true);
            translate([0, base_y/2, 0])
            circle(d=base_x, $fn=100);
        }
        
        translate([0, base_y/2, 0])
        circle(d=bore + tol, $fn=100);
    }
}

module temple(reversed=false) {    
    pin();

    difference() {
            
        translate([0, 0, -(fin_height-spacing)/2])
        union() {
            
            difference() {
                
                union() {
                    linear_extrude(temple_wall)
                    thinner();

                }

                w = temple_length+base_y;
                // TODO: where is 6 coming from
                h = temple_wall+8;
                translate([-spacing*2, 0, temple_wall])
                rotate([0, 180-90, 0])
                translate([-10, -w, 0])
                linear_extrude(10000)
                polygon([
                    [0, 0],
                    [h, 4],
                    [h, w-20],
                    [0, w],
                    [0, 0],
                ]);            
            }
            
            drop_length = 45;
            translate([-drop_width/2, -temple_length+base_y-4, -10])
            rotate([-drop_angle, 0, 0])
            translate([0,-(base_y+temple_length)/2,0])
            linear_extrude(3)
            square([drop_width, drop_length]);
        }
    }
}


translate([drop_width*2, 0, 0])
rotate([0, 90, 0])
temple();


translate([-drop_width*2, 0, 0])
rotate([0, 270, 0])
mirror([-1, 0, 0])
temple();

