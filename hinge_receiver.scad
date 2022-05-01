// Insert
base_x = 5;
base_width = 2.5;

// Hinge
receiver_height = 10;
receiver_width = 5;
width = 2.5;
bore = 2.5;
tol = 0.3;

module receiver() {    
    module triangle() {
        difference() {
            linear_extrude(width)
            polygon([
                [3,0],
                [receiver_height, 0],
                [receiver_height, receiver_width],
                [3,receiver_width],
                [3,receiver_width],
            ]);
            
            translate([(receiver_height)/2.4+bore, receiver_width/2,0])
            union() {
                linear_extrude(width)            
                circle(d=bore, $fn=6);
                           
                translate([0, 0, 2])
                linear_extrude(width)
                union() {
                    circle(d=4, $fn=6);
                    translate([3, 2, 0])
                    square([4, 100], center=true);
                }
            }
        }
    }
    
    translate([0, 0, tol/2])
    triangle();
    
    mirror([0, 0, 1])
    translate([0, 0, base_width+tol/2])
    triangle();
}

translate([-base_width/2, -receiver_width/2 ,0])
rotate([0,-90,0])
receiver();

difference() {
    linear_extrude(4)
    square([width*2+receiver_width/2+tol, receiver_width], center=true);
    
    
    translate([0, 0, 3])
    linear_extrude(5)
    square([base_width+tol, base_x*1.25], center=true);
}

// Wall
color("red")
translate([0, (base_width+width)/2-tol+(2/4), 0])
linear_extrude(4)
square([width*2+receiver_width/2+tol, 2], center=true);