function cubic_bezier(t, x0, x1, x2, x3) = pow((1 - t), 3) * x0 + 3 * pow(1 - t, 2) * t * x1 + 3 * (1-t)*pow(t,2)*x2 + pow(t,3)*x3;

function bezier(x, y, x0, y0, x1, y1, x2, y2) =
    [for (t = [0: 0.02: 1]) 
            [cubic_bezier(t, x, x0, x1, x2), cubic_bezier(t, y, y0, y1, y2)]
    ];

bridge = 30;

module frame(
    width=200,
    h1 = 113,
    h2 = 139,
    thickness=5,
    
) {
        
    ox = 0;
    oy = 0;
        
    translate([bridge/2, 0, 0])
    union() {
        
        // Top half
        difference() {
            color("red")
            polygon(
                bezier(
                    ox-thickness, 
                    oy, 
                    ox-thickness, 
                    oy+h1+thickness, 
                    ox+width+thickness, 
                    oy+h2+thickness, 
                    ox+width+thickness, 
                    oy
                )
            );
            polygon(bezier(ox, oy, ox, oy+h1, ox+width, oy+h2, ox+width, oy));
        }
        
        // Bottom half
        difference() {
            polygon(
                bezier(
                    ox-thickness, 
                    oy, 
                    ox-thickness, 
                    oy-h2-thickness, 
                    ox+width+thickness, 
                    oy-h2-thickness, 
                    ox+width+thickness, 
                    oy
                )
            );  
            
            polygon(bezier(ox, oy, ox, oy-h2, ox+width, oy-h2, ox+width, oy));  
            
        }      
        
    }    
}

linear_extrude(10)
union() {
    translate([bridge/2, 0, 0])
    frame();

    translate([-bridge/2, 0, 0])
    mirror([-1, 0, 0])
    frame();
}