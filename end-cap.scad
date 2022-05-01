$fn=100;
width = 40.5;

linear_extrude(2)
difference() {    
    circle(d=50);
    circle(d=width);
}

linear_extrude(7)
difference() {
    circle(d=width);
    circle(d=35);
}