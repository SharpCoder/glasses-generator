function cubic_bezier(t, x0, x1, x2, x3) = 
    pow((1 - t), 3) * x0 + 3 * pow(1 - t, 2) * t * x1 + 3 * (1-t)*pow(t,2)*x2 + pow(t,3)*x3;

module glasses(
    bridge_distance = 16,
    bridge_start = 0.25,
    lens_width = 45,
    theta1 = 25,
    theta2 = 33,
    thickness = 2
) {
    
    function bx_top(t, scale) = cubic_bezier(t, -scale, -scale, lens_width+scale, lens_width+scale);
    function by_top(t, scale) = cubic_bezier(t, 0, theta1+scale, theta2+scale, 0);
    function bx_bot(t, scale) = cubic_bezier(t, -scale, -scale, lens_width+scale, lens_width+scale);
    function by_bot(t, scale) = cubic_bezier(t, 0, -theta2-scale, -theta2-scale, 0);
    
    function bezier_top(scale) = [for (t = [0: 0.02: 1]) 
        [bx_top(t, scale), by_top(t, scale)]
    ];
    
    function bezier_bot(scale) = [for (t = [0: 0.02: 1]) 
        [bx_bot(t, scale), by_bot(t, scale)]
    ];
    
    function bezier(x, y, x0, y0, x1, y1, x2, y2) =
        [for (t = [0: 0.02: 1]) 
                [cubic_bezier(t, x, x0, x1, x2), cubic_bezier(t, y, y0, y1, y2)]
        ];

    
    module bridge() {
        x0 = bx_top(bridge_start, thickness);
        y0 = by_top(bridge_start, thickness);
        x1 = bx_top(bridge_start + .05, thickness);
        y1 = by_top(bridge_start + .05, thickness);
        
        polygon([
            [x0 + bridge_distance , y0],
            [-x0 - bridge_distance, y0],
            [-x1 - bridge_distance, y1],
            [x1 + bridge_distance, y1],
        ]);
    }

    module frame(
        width=lens_width,
        h1 = theta1,
        h2 = theta2,
        thickness=thickness,
        
    ) {        
        translate([bridge_distance/2, 0, 0])
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


    color("gray")
    linear_extrude(4)
    union() {
        translate([bridge_distance/2, 0, 0])
        frame();
        bridge();
        
        translate([-bridge_distance/2, 0, 0])
        mirror([-1, 0, 0])
        frame();
    }
}

glasses();
