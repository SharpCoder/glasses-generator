include <core.scad>
include <parameters.scad>
include <hinge.scad>


theta1 = 34;
theta2 = 30;
lens_width = 45;
thickness = 2.4;
bridge_distance = 25;

module lens_attachment(perc) {
    translate([ bx_top(perc, lens_width, theta1, theta2, thickness/2), by_top(perc, lens_width, theta1, theta2, thickness), 0])
    translate([.75, .75, 0])
    circle(d=1.75, $fn=100);
}

module glasses(
    bridge_distance = bridge_distance,
    theta1 = theta1,
    theta2 = theta2,
    lens_width = lens_width,
    thickness = thickness,
    theta = 0.93,
    bridge_start = 0.22,
) {
    
    extra_h = 1;
    
    
    // Bridge across the top
    module bridge(start) {
        x0 = bx_top(start, lens_width, theta1, theta2, thickness);
        y0 = by_top(start, lens_width, theta1, theta2, thickness);
        x1 = bx_top(start + .04, lens_width, theta1, theta2, thickness);
        y1 = by_top(start + .04, lens_width, theta1, theta2, thickness);
        
        polygon([
            [x0 + bridge_distance/2 + thickness , y0],
            [-x0 - bridge_distance/2 - thickness, y0],
            [-x1 - bridge_distance/2 - thickness, y1],
            [x1 + bridge_distance/2 + thickness, y1],
        ]);
    }
    
    
    module clasp_joiner() {
        
        translate([wall_z/2, 0, 0])
        difference() {
            
            translate([0, -extra_h, 0])
            linear_extrude(hinge_height() - .5)
            square([hinge_width(), extra_h+1]);
            

            translate([0, 0, base_h])
            translate([hinge_width()/2-1/2, 50, hinge_h/2])
            rotate([90, 0, 0])
            linear_extrude(100)
            circle(d=bolt_bore+tol, $fn=8);
            
        }
        
    }
    
    module temple_offset() {
        x = bx_top(theta, lens_width, theta1, theta2, thickness);
        y = by_top(theta, lens_width, theta1, theta2, thickness);
        translate([x, y+extra_h, 0]) children();
    }
    
    module center_of_temple() {
        temple_offset()
        translate([bridge_distance/2 + thickness + hinge_width()/2 - 3/2, hinge_height()/2, 0]) children();
    }
    
    module temple_connector() {        
        temple_width = 4;
        temple_height = hinge_height() + extra_h;
        
        x = bx_top(theta, lens_width, theta1, theta2, thickness);
        y = by_top(theta, lens_width, theta1, theta2, thickness);
        x2 = bx_top(0.5, lens_width, theta1, theta2, thickness);
        y2 = by_top(0.5, lens_width, theta1, theta2, thickness);
        
        temple_offset()
        translate([0, -extra_h, 0])
        union() {
            square([temple_width, temple_height]);
            polygon([
                [0, temple_height],
                [0,0],
                for (t = [theta: -0.05: 0.5])
                    [bx_top(t, lens_width, theta1, theta2, thickness)-x, by_top(t, lens_width, theta1, theta2, thickness)-y]
                
                ]
            );
        }
    }

    
    // Assemble everything
    color("#fff")
    difference() {
        union() {
            linear_extrude(2)
            union() {
                translate([bridge_distance/2 + thickness, 0, 0])
                union() {
                    frame(theta1=theta1, theta2=theta2, width=lens_width, thickness=thickness);
                    temple_connector();
                }
                
                bridge(start=bridge_start);
                
                translate([-bridge_distance/2 - thickness, 0, 0])
                mirror([-1, 0, 0])
                union() {
                    frame(theta1=theta1, theta2=theta2, width=lens_width, thickness=thickness);
                    temple_connector();
                }
                
            }
            
            // Temple hinges
            center_of_temple()
            rotate(-90)
            hinge();
            
            mirror([1, 0, 0])
            center_of_temple()
            rotate(-90)
            hinge();
        }
        
        // Lens attachment
        linear_extrude(100)
        translate([bridge_distance/2 + thickness, 0, 0])
        lens_attachment(1-.18);
        
        // Lens attachment
        mirror([-1, 0, 0])
        linear_extrude(100)
        translate([bridge_distance/2 + thickness, 0, 0])
        lens_attachment(1-.18);
    
        // Clasp
        center_of_temple()
        linear_extrude(100)
        translate([-hinge_width()/2-5, -hinge_height()/2 + extra_h + .25, 0])
        square([thickness+hinge_width()+5+thickness+0, .75], center=false);
        
        // Clasp
        mirror([-1, 0, 0])
        center_of_temple()
        linear_extrude(100)
        translate([-hinge_width()/2-5, -hinge_height()/2 + extra_h + .25, 0])
        square([thickness+hinge_width()+5+thickness+0, .75], center=false);
    }
    
    /*
    // Clasp joiner
    center_of_temple()
    translate([-hinge_width()/2, -hinge_height()/2 + extra_h - 1 + .25, 0])
    clasp_joiner();
    
    mirror([-1, 0, 0])
    center_of_temple()
    translate([-hinge_width()/2, -hinge_height()/2 + extra_h - 1 + .25, 0])
    clasp_joiner();
    */

}

module frame_clasp(h=2.5) {
    translate([bridge_distance/2 + thickness, 0, 0])
    linear_extrude(h)
    frame(
        theta1=theta1, 
        theta2=theta2,
        width=lens_width,
        thickness=thickness
    );
    
    // Lens attachment
    linear_extrude(h + 1.5)
    translate([bridge_distance/2 + thickness, 0, 0])
    lens_attachment(1-.18);
}

// Generate glasses
glasses();

//frame_clasp();