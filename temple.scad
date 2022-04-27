drop_length = 35;
l = 105;
w = 3;
depth = 1;

// Temple
minkowski() {
    union() {
        // Main length of temple
        linear_extrude(depth)
        square([1,l], center=true);
        
        // temple drop
        linear_extrude(depth)
        translate([0,-l/2,0])
        rotate(180-45) /* temple drop amount, generally 45 degrees */
        square([1,drop_length], center=false);
    }
    
    linear_extrude(1)
    circle(d=w);
}

// Hinge
difference() {
    
    hinge_depth = 1.5;
    hinge_length = 5;
    m = 3;
    
    color("red")
    minkowski() {
        translate([0,l/2-2.5,depth])
        linear_extrude(hinge_length)
        square([hinge_depth,4], center=true);
        linear_extrude(1)
        circle(d=1);
    }

    
    translate([-50,0,depth]) /* Depth of hinge bore */
    rotate([0,90,0])   /* Hinge rotation */
    linear_extrude(100) /* Bore depth */
    translate([-hinge_length/2-.7,l/2-2.5,0]) /* Position the hinge half way down the length of the temple */
    circle(d=m, $fn=100);
}