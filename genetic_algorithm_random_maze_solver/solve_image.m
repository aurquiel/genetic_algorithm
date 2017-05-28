
% Draw large bounding box:
xstart =  0;
ystart =  0;

xlen = length(rejilla);
ylen = xlen;

figure
rectangle('position', [xstart, ystart, xlen, ylen])
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');

% Draw smaller boxes
dx = 1;
dy = 1;

nx = floor(xlen/dx);
ny = floor(ylen/dy);

for i = 1:nx
    x = xstart + (i-1)*dx;
    for j = 1:ny
        y = ystart + (j-1)*dy;
        rectangle('position', [x, y, dx, dy])
        
        for i=1:l %color negro paredes
            for j=1:l
                if (savem(i,j)==2)
                   rectangle('position', [j-1, i-1, dx, dy], 'facecolor', 'black') 
                end
            end
        end
        
        for z=1:length(individuo)
            for i=1:l %color camino solucion
                for j=1:l
                    if (rejilla(i,j)==individuo(z))
                        rectangle('position', [j-1, i-1, dx, dy], 'facecolor', 'r') 
                    end
                end
            end
        end

        
        
        
    end
end

