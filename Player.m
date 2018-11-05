classdef Player < matlab.mixin.SetGet
    properties
        Pawns;
        Board = zeros(8, 8);
        Color;
    end
    
    methods 
        function player = Player(color, side, dX, dY, om, T, f, c, k)
            if nargin > 0
                player.Color = color;
                for i = 1:12
                    player.Pawns = [player.Pawns Pawn(color, side, dX, dY, om, T, f, c, k)];
                end
                player.Board = [player.Board(1:end-3, 1:end);
                                1 0 2 0 3 0 4 0;
                                0 5 0 6 0 7 0 8;
                                9 0 10 0 11 0 12 0];
                if side == -1
                    player.Board = flip(flip(player.Board), 2);
                end
            end
        end
        
        function draw(player)
            for i = 1:8
                for j = 1:8
                    if player.Board(i, j) ~= 0
                        player.Pawns(1, player.Board(i, j)).draw(i, j);
                    end
                end
            end
        end
        
        function move(player, pawnIndex, x, y)
            [r, c] = find(player.Board == pawnIndex);
            player.Board(r, c) = 0;
            player.Board(x, y) = pawnIndex;
            player.Pawns(pawnIndex).move(r, c, x, y);
        end
    end
end
