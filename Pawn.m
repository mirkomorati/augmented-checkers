classdef Pawn
    properties
        Color;
        Size = 16;
        Patch;
        Base;
        Side;
        dX;
        dY;
        om;
        T;
        f;
        c;
        k;
    end
   
    methods
        function pawn = Pawn(color, side, dX, dY, om, T, f, c, k)
            if nargin > 0
                pawn.Color = color;
                pawn.Side = side;
                pawn.dX = dX;
                pawn.dY = dY;
                pawn.om = om;
                pawn.T = T;
                pawn.f = f;
                pawn.c = c;
                pawn.k = k;      
                pawn.Base = [0 0 1 1 0; 0 1 1 0 0; 0 0 0 0 0] .* pawn.Size;
                pawn.Patch = patch(0, 0, 0, 'EdgeColor', color, 'FaceColor', color);
            end
        end    
       
        function pawn = set.Color(pawn, color)
            pawn.Color = color;
        end

        function draw(pawn, x, y)
            if nargin < 3
                return
            end
            pp = pawn.Base;
            pp(1,:) = pp(1,:) + x * pawn.dX + pawn.dX / 2 - pawn.Size / 2;
            pp(2,:) = pp(2,:) + y * pawn.dY + pawn.dY / 2 - pawn.Size / 2;
            
            [xp] = project_points(pp, pawn.om, pawn.T, pawn.f, pawn.c, pawn.k);

            set(pawn.Patch, 'Xdata', xp(1,:), 'Ydata', xp(2,:), ...
                'EdgeColor', pawn.Color, 'FaceColor', pawn.Color); 
            drawnow;
        end
        
        function move(pawn, x, y, xx, yy)
            d = pdist([x y; xx yy], 'euclidean');
            d = round(3*d);
            xvals = linspace(x, xx, d);
            yvals = linspace(y, yy, d);
            
            for i = 1:size(xvals')
                draw(pawn, xvals(i), yvals(i));
                pause(0.05);
            end
        end
    end
end