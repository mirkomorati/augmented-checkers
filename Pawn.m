classdef Pawn
    properties
        color;
        size = 16;
        patch;
        base;
    end
   
    methods
        function pawn = Pawn(color)
            if nargin < 1
                error('Too few arguments.');
            end
            
            pawn.color = color;  
            pawn.base = [0 0 1 1 0;
                         0 1 1 0 0;
                         0 0 0 0 0] .* pawn.size;
            pawn.patch = patch(0, 0, 0, 'EdgeColor', color, 'FaceColor', color);
        end    
       
        function obj = set.color(obj, color)
            obj.color = color;
        end

        function draw(obj, x, y)
            global params;
            if nargin < 3
                return
            end
            pp = obj.base;
            pp(1,:) = pp(1,:) + (x+1) * params.dX + params.dX / 2 - obj.size / 2;
            pp(2,:) = pp(2,:) + y * params.dY + params.dY / 2 - obj.size / 2;
            
            [xp] = project_points(pp, params.om, params.T, ...
                                  params.f, params.c, params.k);

            set(obj.patch, 'Xdata', xp(1,:), 'Ydata', xp(2,:)); 
        end
        
        function obj = setSize(obj, s)
            obj.size = s;
        end
        
        function move(obj, x, y, xx, yy)
            d = pdist([x y; xx yy], 'euclidean');
            d = round(3*d);
            xvals = linspace(x, xx, d);
            yvals = linspace(y, yy, d);
            for i = 1:size(xvals')
                draw(obj, xvals(i), yvals(i));
                pause(0.05);
            end
        end
        
        function movePx(obj, r, c, x, y)
            global params;
            pp = [0; 0; 0];
            xp0 = project_points(pp, params.om, params.T, ...
                                  params.f, params.c, params.k);
            xp = ([x;y] - xp0)/30;
            obj.move(r, c, round(xp(1)),round(xp(2)));
        end
        
        function xp = getPoints(obj)
            xp = [get(obj.patch, 'Xdata')'; get(obj.patch, 'Ydata')'];
        end
        
        function select(obj)
            set(obj.patch, 'FaceColor', 'blue');
        end
        
        function deselect(obj)
            set(obj.patch, 'FaceColor', obj.color);
        end
    end
end