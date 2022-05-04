include <core.scad>
include <parameters.scad>
include <hinge.scad>


theta1 = 30;
theta2 = 28;
lens_width = 43;
thickness = 3;
lens_depth = 3.75;
bridge_distance = 17 - thickness;
bridge_start = 0.2;
lens_attachment_dia = 1.5;

module lens_attachment(dia = lens_attachment_dia, tol=0.0, flip=false, bottom=false) {
    start = 0.25;
    end = 0.78;
    
    difference() {
        union() {
            polygon(partial_bezier_top(thickness*.6, start-tol, end+tol, lens_width, theta1, theta2));
            polygon(partial_bezier_bot(thickness*.6, start-tol, end+tol, lens_width, theta1, theta2));
        }
        union() {
            polygon(partial_bezier_top(thickness*.4, start-tol, end+tol, lens_width, theta1, theta2));
            polygon(partial_bezier_bot(thickness*.4, start-tol, end+tol, lens_width, theta1, theta2));
        }
    }
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
        x0 = bx_top(start, lens_width, theta1, theta2, 0);
        y0 = by_top(start, lens_width, theta1, theta2, 0);
        x1 = bx_top(start + .03, lens_width, theta1, theta2, 0);
        y1 = by_top(start + .03, lens_width, theta1, theta2, 0);
        
        d = (bridge_distance + thickness) / 2;
        
        // Bendy amount of bridge
        s = 2.5;
        
        difference() {
            polygon([
                each bezier(-x0-d, y0, 0, y0 + s, 0, y0 + s, x0+d, y0),
                each bezier(x1+d, y1, 0, y1 + s, 0, y1 + s, -x1 - d, y1),
            ]);
        }
    }
    
    module nose_bridge() {
        end = bridge_start;
        start = 0;
        w = thickness + 3;
        
        p0 = [
            bx_top(0, lens_width, theta1, theta2, 0), 
            by_top(0, lens_width, theta1, theta2, 0)
        ];
        
        p1 = [
            bx_top(bridge_start + .02, lens_width, theta1, theta2, 0), 
            by_top(bridge_start + .02, lens_width, theta1, theta2, 0)
        ];
        
        linear_extrude(lens_depth)
        translate([bridge_distance/2 + thickness/2, -0, 0])
        
        polygon([
            p0,
            each bezier(p0[0], p0[1], p0[0], p0[0], p0[0] - w, p1[0] + 5, p1[0], p1[1]),
            p1,
        ]);
        
        //polygon(partial_bezier_top(thickness, start, end, lens_width, theta1, theta2));
        
        
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
                [temple_width, temple_height],
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
                    
                    // Interior lens lip
                    linear_extrude(.75)
                    translate([0,0,0])
                    frame(theta1=theta1, theta2=theta2, width=lens_width-1, thickness=thickness);
                }
                
            }
            
            // Temple hinges
            duplicate(x=1)
            translate([.5, 0, 0])
            center_of_temple()
            rotate(-90)
            hinge();
            
            
        }
        
        
        // Cut out the lens attachments
        color("red")
        linear_extrude(100)
        duplicate(x=1)
        translate([bridge_distance/2 + thickness, 0, 0])
        union() {
                
            // Lens attachment
            lens_attachment(dia=lens_attachment_dia, tol=0.018);
        }
        
        
    }
    
    
    color("red")
    linear_extrude(lens_depth)
    bridge(start=bridge_start);
    
    color("blue")
    duplicate(x=1)
    nose_bridge();

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
    


    // Lens attachment1
    color("red")
    linear_extrude(lens_depth/2+h)
    mirror([1,0,0])
    translate([bridge_distance/2 + thickness, 0, 0])
    union() {
        lens_attachment(dia=lens_attachment_dia, flip=true);
    }
}

// Generate glasses
glasses();

//duplicate(x=1) frame_clasp();