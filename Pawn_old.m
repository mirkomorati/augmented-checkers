classdef Pawn
    properties
        Color;
        Size = 16;
        Patch;
        Base;
        Camera;
    end
   
    methods
        function pawn = Pawn(color, camera)
            if nargin < 2
                error('Too few arguments.');
            end
            
            pawn.Color = color;
            pawn.Camera = camera;  
            pawn.Base = [0 0 1 1 0;
                         0 1 1 0 0;
                         0 0 0 0 0] .* pawn.Size;
            pawn.Patch = patch(0, 0, 0, 'EdgeColor', color, 'FaceColor', color);
        end    
       
        function pawn = set.Color(pawn, color)
            pawn.Color = color;
        end

        function draw(pawn, x, y)
            if nargin < 3
                return
            end
            pp = pawn.Base;
            pp(1,:) = pp(1,:) + (x+1) * pawn.Camera.dX + pawn.Camera.dX / 2 - pawn.Size / 2;
            pp(2,:) = pp(2,:) + y * pawn.Camera.dY + pawn.Camera.dY / 2 - pawn.Size / 2;
            
            [xp] = project_points(pp, pawn.Camera.om, pawn.Camera.T, ...
                                  pawn.Camera.f, pawn.Camera.c, pawn.Camera.k);

            set(pawn.Patch, 'Xdata', xp(1,:), 'Ydata', xp(2,:)); 
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
        
        function movePx(pawn, r, c, x, y)
            pp = [0; 0; 0];
            xp0 = project_points(pp, pawn.Camera.om, pawn.Camera.T, ...
                                  pawn.Camera.f, pawn.Camera.c, pawn.Camera.k);
            xp = ([x;y] - xp0)/30;
            pawn.move(r, c, round(xp(1)),round(xp(2)));
        end
        
        function xp = getPoints(pawn)
            xp = [get(pawn.Patch, 'Xdata')'; get(pawn.Patch, 'Ydata')'];
        end
        
        function select(pawn)
            set(pawn.Patch, 'FaceColor', 'blue');
        end
        
        function deselect(pawn)
            set(pawn.Patch, 'FaceColor', pawn.Color);
        end
    end
end