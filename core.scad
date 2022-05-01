function cubic_bezier(t, x0, x1, x2, x3) = 
    pow((1 - t), 3) * x0 + 3 * pow(1 - t, 2) * t * x1 + 3 * (1-t)*pow(t,2)*x2 + pow(t,3)*x3;

// These define a bunch of bezier curves and simply take an interpolation point
// and return the relevant x or y point for the top half or bottom half of the frame.
function bx_top(t, w, theta1, theta2, scale) = cubic_bezier(t, -scale, -scale, w+scale, w+scale);
function by_top(t, w, theta1, theta2, scale) = cubic_bezier(t, 0, theta1+scale, theta2+scale, 0);
function bx_bot(t, w, theta1, theta2, scale) = cubic_bezier(t, -scale, -scale, w+scale, w+scale);
function by_bot(t, w, theta1, theta2, scale) = cubic_bezier(t, 0, -theta2-scale, -theta2-scale, 0);

// Render all the polygon points for a full bezier curve of the top-half of the frames
function bezier_top(scale, w, theta1, theta2) = [for (t = [0: 0.02: 1]) 
    [bx_top(t, w, theta1, theta2, scale), by_top(t, w, theta1, theta2, scale)]
];

// Render all the polygon points for a full bezier curve of the bottom-half of the frames
function bezier_bot(scale, w, theta1, theta2) = [for (t = [0: 0.02: 1]) 
    [bx_bot(t, w, theta1, theta2, scale), by_bot(t, w, theta1, theta2, scale)]
];

module duplicate(x=0, y=0, z=0, spacing=0) {
    translate([spacing/2, 0, 0])
    children();
    
    translate([-spacing/2, 0, 0])
    mirror([x, y, z])
    children();
    
}

// Lens part
module frame(
    theta1=0.3,
    theta2=0.3,
    width=40,
    thickness=1,
    
) {
    union() {
        // Top half
        difference() {
            color("red")
            polygon(bezier_top(thickness, width, theta1, theta2));
            polygon(bezier_top(0, width, theta1, theta2));
        }
        
        // Bottom half
        difference() {
            polygon(bezier_bot(thickness, width, theta1, theta2));
            polygon(bezier_bot(0, width, theta1, theta2));
        }
    }    
}
