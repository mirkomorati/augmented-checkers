function p = createPawn(color)
    p.color = color;
    p.size = 16;
    p.base = [0 0 1 1 0;
              0 1 1 0 0;
              0 0 0 0 0] .* p.size;
    p.patch = patch(0, 0, 0, 'EdgeColor', color, 'FaceColor', color);
end