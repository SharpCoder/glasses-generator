include <core.scad>
include <parameters.scad>


max_temple_height = 5; // How much to extrude upwards, the temple component.
temple_height = 3; // How much to extrude the part that actually touches the head.
temple_length = 85; // The length of the main element
drop_length = 45;   // The length of the drop element
spacing = 2;        // How deep the pin is, so it can fit inside the hinge.
fin_width_fat = 10; // How wide to make the base of the fin element.
fin_width_thin = 3; // How wide to make the neck of the fin element. 
fin_height = 20;    // How long to make the fin.
pin_length = 6;     // Total length of the pin.
pin_width = 4;      // Total width of the pin.
    
// The little pin which hooks into
// the hinge.
module pin() {
    pin_bore = 2.2 + tol;
    rounded_dia = pin_width / 2;
    
    difference() {
        union() {
            translate([-pin_width/2, 0, 0])
            square([pin_width, pin_length - rounded_dia]);

            translate([0, pin_length - rounded_dia , 0])
            circle(d=pin_width, $fn=100);   
        }
        
        translate([0, pin_length - rounded_dia, 0])
        circle(d=pin_bore, $fn=100);
    }
}

module triangle() {
    base = max_temple_height;
    height = 10;

    translate([fin_width_thin/2+1/2, fin_height, base/2])
    rotate([0, 90, 0])
    linear_extrude(fin_width_thin)
    polygon([
        [-base/2, 0],
        [base/2, 0],
        [base/2, height],
    ]);
}

module loopy() {
    difference() {
        polygon(loop());
        color("red")
        polygon(loop(size_x=3, size_y=4, offset_left=1, offset_right=1));
    }
}

// The main shape of the temple component
module temple_2d() {
    
    // Compute roundy part
    ox = fin_width_fat/2;
    oy = temple_length;
    otheta = 0;
    
    theta = 45;
    w = 50;
    function x(t) = ox - sin(t-90) * w - w;
    function y(t) = oy + cos(t-90) * drop_length;    
    function slope() = cos(theta-90+6);

    polygon([ 
        [-fin_width_fat/2, 0],
        [fin_width_fat/2, 0],
        [fin_width_fat/2, temple_length],
    
        // TODO: roundy part here
    
    
        each [for(t = [0: 1: theta])
            [x(t), y(t)],
        ],
        
        [x(theta) - 20, y(theta) + 20*slope()],
        [x(theta) - 20, y(theta) + 20*slope()-fin_width_thin],
        
        
        each [for(t = [theta-6: -1: 0])
            [x(t) - fin_width_thin, y(t)],
        ],
        

        [fin_width_fat/2 - fin_width_thin, temple_length],
        [fin_width_fat/2 - fin_width_thin, fin_height],
        [-fin_width_fat/2, fin_height*.35],
        [-fin_width_fat/2, 0],
   ]); 
}

module cut_out() {
    translate([-50, fin_height, temple_height])
    linear_extrude(100)
    square([100, 150]);
}

module temple(reversed=false) {
    mirror_x = reversed ? 1 : 0;
    
    mirror([mirror_x, 0, 0])
    union() {
        translate([pin_width/2-(spacing+tol)/2, 0, spacing-1/2])
        rotate([180, 90, 0])
        linear_extrude(spacing-tol)
        pin();

        minkowski() {
            difference() {
                linear_extrude(max_temple_height)
                temple_2d();
                cut_out();
            }
            sphere(.5);               
        }
        //triangle();
        
        color("red")
        translate([0, 0, -.5])
        linear_extrude(temple_height+1)
        translate([-drop_length/2-5, temple_length + 42.5, 0])
        rotate(45)
        loopy();
    }
}

temple(reversed=false);

translate([25, 0, 0]) temple(reversed=true);

//cut_out();