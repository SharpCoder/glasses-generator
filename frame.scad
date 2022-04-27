
module frame(frame_width=50, frame_height=37, seed=1337) {
    
   rand = rands(0.9,1.0,10,seed);
   
   polygon([
    [0,0],
    [0, frame_width],
    [frame_height, frame_width],
    
    [0, frame_width],
    [0,0]
   ]);
}

frame();