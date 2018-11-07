function drawPlayer(p)
    if strcmp(p.color, 'green')
        p.board = flip(flip(p.board), 2);
    end
    for i = 1:size(p.board)
        for j = 1:size(p.board)
            if p.board(i, j) ~= 0
                drawPawn(p.pawns(1, p.board(i, j)), i, j);
            end
        end
    end
    if strcmp(p.color, 'green')
        p.board = flip(flip(p.board), 2);
    end
end