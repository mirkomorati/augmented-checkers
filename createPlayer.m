function p = createPlayer(color)
    p.color = color;
    p.side = strcmp(color, 'red');
    
    p.pawns = [];
    for i = 1:12
        p.pawns = [p.pawns createPawn(color)];
    end
end