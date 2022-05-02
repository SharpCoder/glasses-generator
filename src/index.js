(async function() {

    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    
    canvas.width = document.body.clientWidth;
    canvas.height = document.body.clientHeight;

    ctx.lineWidth = 3;

    let rand1 = (Math.random() * 20) + 15;pnpm create vite
    let rand2 = (Math.random() * 30) + 15;
    let rand3 = (Math.random() * 30);


    function b(t, x0, x1, x2, x3) {
        return Math.pow((1 - t), 3) * x0 + 3 *Math.pow(1 - t, 2) * t * x1 + 3 * (1-t)*Math.pow(t,2)*x2 + Math.pow(t,3)*x3;
    }

    function bezier(ctx, ox, oy, x, y, x2, y2, x3, y3) {

        ctx.moveTo(ox, oy);

        for (let i = 0; i <= 1; i += 0.02) {
            let [bx, by] = [b(i, ox, x, x2, x3), b(i, oy, y, y2, y3)];
            ctx.lineTo(bx, by);
        }
        ctx.lineTo(x3, y3);
        ctx.stroke();
    }


    function render(mirror=false) {
        const scale = 5;
        let r = (30 + rand3) * scale;
        let h = -rand1 * scale;
        let h2 = rand2 * scale;

        let ox = (canvas.width - r*2) / 2;
        let oy = canvas.height / 2;
        
        console.log({ r: r/scale, h: h/scale, h2: h2/scale });

        if (mirror) {
            ox += r + 17 * scale/2; 
            bezier(ctx, ox, oy, ox, oy+h, ox+r, oy-h2, ox+r, oy);
            bezier(ctx, ox, oy, ox, oy+h2, ox+r, oy+h2, ox+r, oy);        
        } else {
            bezier(ctx, ox, oy, ox, oy-h2, ox+r, oy+h, ox+r, oy);
            bezier(ctx, ox, oy, ox, oy+h2, ox+r, oy+h2, ox+r, oy);        
        }
        
    }

    render(false);
    render(true);

    ctx.fillStyle = 'rgba(255,0,0,.4)';
    ctx.fill();
})();