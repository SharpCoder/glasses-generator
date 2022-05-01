tol = 0;

hinge_w = 3.25;
base_x = 4;
base_y = 14;

spacing = 3 - tol;
bore = 2;

temple_length = 85;
temple_wall = hinge_w*2+spacing;
temple_width = 10;


drop_angle = 45;
drop_width = hinge_w+spacing;

// The fin that looks cool at the base
module fin() {
    polygon([
        [0,0],
        [temple_width/2, 0],
        [temple_wall/2, 10],
        [-temple_wall/2, 10],
        [-temple_width/2,0],
    ]);
}

module thinner() {
    x0 = hinge_w+spacing;
    l1 = 50;
    
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
    translate([-hinge_w/2+.5, -7+4.5, 0])
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

pin();

difference() {
        
    translate([temple_width/2-temple_width/2, 0, -(hinge_w+spacing)/2])
    union() {
        
        difference() {
            
            union() {
                linear_extrude(temple_wall)
                thinner();

            }

            w = temple_length+base_y+10;
            h = 11;
            translate([-40, 0, (hinge_w+spacing)/2])
            rotate([0, 180-90, 0])
            translate([-10, -w, 0])
            linear_extrude(120)
            polygon([
                [0, 0],
                [h, 4],
                [h, w-20],
                [0, w-0],
                [0, 0],
            ]);            
        }
        
        drop_length = 35;
        translate([-drop_width/2, -temple_length+base_y-3.7, -10.2])
        rotate([-drop_angle, 0, 0])
        translate([0,-(base_y+temple_length)/2,0])
        linear_extrude(3)
        square([drop_width, drop_length]);
    }
}
