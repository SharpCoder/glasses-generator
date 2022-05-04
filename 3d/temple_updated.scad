include <core.scad>
include <parameters.scad>


max_temple_height = 5; // How much to extrude upwards, the temple component.
temple_height = 3; // How much to extrude the part that actually touches the head.
temple_length = 90; // The length of the main element
drop_length = 65;   // The length of the drop element
spacing = 2;        // How deep the pin is, so it can fit inside the hinge.
fin_width_fat = 10; // How wide to make the base of the fin element.
fin_width_thin = 3; // How wide to make the neck of the fin element. 
fin_height = 20;    // How long to make the fin.
pin_length = 7;     // Total length of the pin.
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

// The main shape of the temple component
module temple_2d() {
    
    // Compute roundy part
    ox = fin_width_fat/2;
    oy = temple_length;
    otheta = 0;
    
    theta = 45;
    function x(t) = ox - sin(t-90) * drop_length - drop_length;
    function y(t) = oy + cos(t-90) * drop_length;
    
    polygon([ 
        [-fin_width_fat/2, 0],
        [fin_width_fat/2, 0],
        [fin_width_fat/2, temple_length],
    
        // TODO: roundy part here
    
    
        each [for(t = [0: 1: theta])
            [x(t), y(t)],
        ],
        
        
        each [for(t = [theta - 3: -1: 0])
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
        difference() {
            union() {
                translate([pin_width/2-spacing/2, 0, spacing])
                rotate([180, 90, 0])
                linear_extrude(spacing)
                pin();
                
                linear_extrude(max_temple_height)
                temple_2d(); 
                    
            }
            
            color("orange") cut_out();
        }    
        
        triangle();
    }
}

temple(reversed=false);

translate([25, 0, 0]) temple(reversed=true);
