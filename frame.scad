function cubic_bezier(t, x0, x1, x2, x3) = 
    pow((1 - t), 3) * x0 + 3 * pow(1 - t, 2) * t * x1 + 3 * (1-t)*pow(t,2)*x2 + pow(t,3)*x3;

module glasses(
    bridge_distance = 17,
    bridge_start = 0.25,
    lens_width = 45,
    theta1 = 25,
    theta2 = 33,
    thickness = 2
) {
    
    // These define a bunch of bezier curves and simply take an interpolation point
    // and return the relevant x or y point for the top half or bottom half of the frame.
    function bx_top(t, scale) = cubic_bezier(t, -scale, -scale, lens_width+scale, lens_width+scale);
    function by_top(t, scale) = cubic_bezier(t, 0, theta1+scale, theta2+scale, 0);
    function bx_bot(t, scale) = cubic_bezier(t, -scale, -scale, lens_width+scale, lens_width+scale);
    function by_bot(t, scale) = cubic_bezier(t, 0, -theta2-scale, -theta2-scale, 0);
    
    // Render all the polygon points for a full bezier curve of the top-half of the frames
    function bezier_top(scale) = [for (t = [0: 0.02: 1]) 
        [bx_top(t, scale), by_top(t, scale)]
    ];
    
    // Render all the polygon points for a full bezier curve of the bottom-half of the frames
    function bezier_bot(scale) = [for (t = [0: 0.02: 1]) 
        [bx_bot(t, scale), by_bot(t, scale)]
    ];
    
    // Bridge across the top
    module bridge() {
        x0 = bx_top(bridge_start, thickness);
        y0 = by_top(bridge_start, thickness);
        x1 = bx_top(bridge_start + .05, thickness);
        y1 = by_top(bridge_start + .05, thickness);
        
        polygon([
            [x0 + bridge_distance/2 + thickness , y0],
            [-x0 - bridge_distance/2 - thickness, y0],
            [-x1 - bridge_distance/2 - thickness, y1],
            [x1 + bridge_distance/2 + thickness, y1],
        ]);
    }

    // Lens part
    module frame(
        width=lens_width,
        h1 = theta1,
        h2 = theta2,
        thickness=thickness,
        
    ) {        
        union() {
            // Top half
            difference() {
                color("red")
                polygon(bezier_top(thickness));
                polygon(bezier_top(0));
            }
            
            // Bottom half
            difference() {
                polygon(bezier_bot(thickness));
                polygon(bezier_bot(0));
            }
        }    
    }

    
    // Assemble everything
    color("gray")
    linear_extrude(4)
    union() {
        translate([bridge_distance/2 + thickness, 0, 0])
        frame();
        bridge();
        
        translate([-bridge_distance/2 - thickness, 0, 0])
        mirror([-1, 0, 0])
        frame();
    }
}

// Generate glasses
glasses();