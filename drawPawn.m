function drawPawn(p, x, y)
    if nargin < 3
        return
    end
    global params;
    pp = p.base;
    pp(1,:) = pp(1,:) + (x+1) * params.dX + params.dX / 2 - p.size / 2;
    pp(2,:) = pp(2,:) + y * params.dY + params.dY / 2 - p.size / 2;

    [xp] = project_points(pp, params.om, params.T, ...
                          params.f, params.c, params.k);

    set(p.patch, 'Xdata', xp(1,:), 'Ydata', xp(2,:)); 
end