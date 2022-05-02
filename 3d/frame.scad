include <core.scad>
include <parameters.scad>
include <hinge.scad>


theta1 = 27;
theta2 = 29;
lens_width = 43;
thickness = 3.5;
bridge_distance = 25;
lens_depth = 3.75;
bridge_start = 0.22;
lens_attachment_dia = 1;

module lens_attachment(perc, dia = lens_attachment_dia, tol=0.0, bottom=false) {
    x = bottom ? 
        bx_bot(perc, lens_width, theta1, theta2, thickness/2) : 
        bx_top(perc, lens_width, theta1, theta2, thickness/2);
    
    y = bottom ? 
        by_bot(perc, lens_width, theta1, theta2, thickness/2) : 
        by_top(perc, lens_width, theta1, theta2, thickness/2);
    
    translate([x, y, 0])
    square([dia+tol, 4], center=true);
    //circle(d=dia + tol, $fn=100);
}

module glasses(
    bridge_distance = bridge_distance,
    theta1 = theta1,
    theta2 = theta2,
    lens_width = lens_width,
    thickness = thickness,
    bridge_start = bridge_start,
    theta = 0.92,
) {    
    // Bridge across the top
    module bridge(start) {
        x0 = bx_top(start, lens_width, theta1, theta2, thickness);
        y0 = by_top(start, lens_width, theta1, theta2, thickness);
        x1 = bx_top(start + .08, lens_width, theta1, theta2, thickness);
        y1 = by_top(start + .08, lens_width, theta1, theta2, thickness);
        
        polygon([
            [x0 + bridge_distance/2 + thickness , y0],
            [-x0 - bridge_distance/2 - thickness, y0],
            [-x1 - bridge_distance/2 - thickness, y1],
            [x1 + bridge_distance/2 + thickness, y1],
        ]);
    }
    
    module temple_offset() {
        x = bx_top(theta, lens_width, theta1, theta2, thickness);
        y = by_top(theta, lens_width, theta1, theta2, thickness);
        translate([x, y, 0]) children();
    }
    
    module center_of_temple() {
        temple_offset()
        translate([bridge_distance/2 + thickness + hinge_width()/2 - 3/2, hinge_height()/2, 0]) children();
    }
    
    module temple_connector() {        
        temple_width = 4;
        temple_height = hinge_height();
        
        x = bx_top(theta, lens_width, theta1, theta2, thickness);
        y = by_top(theta, lens_width, theta1, theta2, thickness);
        x2 = bx_top(0.75, lens_width, theta1, theta2, thickness);
        y2 = by_top(0.75, lens_width, theta1, theta2, thickness);

        temple_offset()
        union() {
            square([temple_width, temple_height]);
            polygon([
                [temple_width, y],
                for (t = [0.75: 0.1: theta])
                    [
                        bx_top(t, lens_width, theta1, theta2, thickness)-x, 
                        by_top(t, lens_width, theta1, theta2, thickness)-y
                    ],
                [0, 0],
                
            ]);
        }
    }

    
    // Assemble everything
    color("#fff")
    difference() {
        union() {
            union() {                
                duplicate(x=-1, spacing=bridge_distance+thickness*2)
                union() {
                    
                    linear_extrude(lens_depth)
                    frame(theta1=theta1, theta2=theta2, width=lens_width, thickness=thickness);
                    
                    
                    linear_extrude(lens_depth)
                    temple_connector();
                    
                    
                    linear_extrude(.75)
                    translate([0,0,0])
                    frame(theta1=theta1, theta2=theta2, width=lens_width-1, thickness=thickness);
                }
                
                linear_extrude(lens_depth)
                bridge(start=bridge_start);
            }
            
            // Temple hinges
            duplicate(x=1)
            center_of_temple()
            rotate(-90)
            hinge();
            
            
        }
        
        
        // Cut out the lens attachments
        linear_extrude(100)
        duplicate(x=1)
        translate([bridge_distance/2 + thickness, 0, 0])
        union() {
                
            // Lens attachment
            lens_attachment(0, dia=lens_attachment_dia, tol=.5);
            lens_attachment(1.0, dia=lens_attachment_dia, tol=.5);
        }
        
        
    }

}

module frame_clasp(h=1.25) {
    translate([bridge_distance/2 + thickness, 0, 0])
    linear_extrude(h)
    union () {
        // Primary frame
        frame(
            theta1=theta1, 
            theta2=theta2,
            width=lens_width,
            thickness=thickness
        );
        
        // Skewed frame for holding the lens in place
        frame(
            theta1=theta1, 
            theta2=theta2,
            width=lens_width-1,
            thickness=thickness
        );

    }
    


    // Lens attachment
    linear_extrude(lens_depth/2+h)
    translate([bridge_distance/2 + thickness, 0, 0])
    union() {
        lens_attachment(0, dia=lens_attachment_dia, tol=0);
        lens_attachment(1.0, dia=lens_attachment_dia, tol=0);
    }
}

// Generate glasses
//glasses();

frame_clasp();