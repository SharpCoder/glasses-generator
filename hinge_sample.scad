difference() {
    
    linear_extrude(15)
    difference() {
        square([5, 8], center=true);
        translate([0, 2, 0])
        circle(d=3, $fn=100);
    }

    color("red")
    translate([0, 2, 7])
    linear_extrude(2.25)
    square([51, 4], center=true);
}