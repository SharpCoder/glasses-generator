function cubic_bezier(t, x0, x1, x2, x3) = 
    pow((1 - t), 3) * x0 + 3 * pow(1 - t, 2) * t * x1 + 3 * (1-t)*pow(t,2)*x2 + pow(t,3)*x3;
    
mod = 0.5;

// These define a bunch of bezier curves and simply take an interpolation point
// and return the relevant x or y point for the top half or bottom half of the frame.
function bx_top(t, w, theta1, theta2, scale) = cubic_bezier(t, -scale*mod, -scale*mod, w+scale*mod, w+scale*mod+1);
function by_top(t, w, theta1, theta2, scale) = cubic_bezier(t, 0, theta1+scale, theta2+scale, 0);
function bx_bot(t, w, theta1, theta2, scale) = cubic_bezier(t, -scale*mod, -scale*mod, w+scale*mod, w+scale*mod+1);
function by_bot(t, w, theta1, theta2, scale) = cubic_bezier(t, 0, -theta2-scale, -theta2-scale, 0);

// Render all the polygon points for a partial bezier curve of the top-half of the frames
function partial_bezier_top(scale, start, end, w, theta1, theta2, reversed=false) = [
    for (t = [start: reversed ? -.01 : 0.01: end]) [bx_top(t, w, theta1, theta2, scale), by_top(t, w, theta1, theta2, scale)]
];

// Render all the polygon points for a partial bezier curve of the top-half of the frames
function partial_bezier_bot(scale, start, end, w, theta1, theta2) = [for (t = [start: 0.01: end]) 
    [bx_bot(t, w, theta1, theta2, scale), by_bot(t, w, theta1, theta2, scale)]
];


// Render all the polygon points for a full bezier curve of the top-half of the frames
function bezier_top(scale, w, theta1, theta2) = partial_bezier_top(scale, 0, 1, w, theta1, theta2);

// Render all the polygon points for a full bezier curve of the bottom-half of the frames
function bezier_bot(scale, w, theta1, theta2) = partial_bezier_bot(scale, 0, 1, w, theta1, theta2);

function bezier(x0, y0, x1, y1, x2, y2, x3, y3) = [for (t = [0: 0.01: 1.0])
        [cubic_bezier(t, x0, x1, x2, x3), cubic_bezier(t, y0, y1, y2, y3)]
];

// Create a loopy shape.
function loop(base_x=3, offset_left=0, offset_right=0, size_x=0, size_y=0, w=6,length=14) = bezier(
    offset_left, 
    0, 
    -w+size_x,    // x 
    length-size_y,   // y
    w-size_x,    // x
    length,   // y
    base_x-offset_right, 
    0
);

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
