classdef Player < matlab.mixin.SetGet
    properties
        Pawns;
        Board = zeros(8, 8);
        Color;
        Camera;
    end
    
    methods 
        function player = Player(color, camera)
            if nargin < 2
                error('Too few arguments');
            end
            player.Color = color;
            player.Camera = camera;
            for i = 1:12
                player.Pawns = [player.Pawns Pawn(color, camera)];
            end
            player.Board = [player.Board(1:end-3, 1:end);
                            1 0 2 0 3 0 4 0;
                            0 5 0 6 0 7 0 8;
                            9 0 10 0 11 0 12 0];
        end
        
        function draw(player)
            if strcmp(player.Color, 'green')
                player.Board = flip(flip(player.Board), 2);
            end
            for i = 1:size(player.Board)
                for j = 1:size(player.Board)
                    if player.Board(i, j) ~= 0
                        player.Pawns(1, player.Board(i, j)).draw(i, j);
                    end
                end
            end
            if strcmp(player.Color, 'green')
                player.Board = flip(flip(player.Board), 2);
            end
        end
        
        function moveTo(player, pawnIndex, x, y)
            if nargin < 4
                error('')
            end
            [r, c] = find(player.Board == pawnIndex);
            player.Board(r, c) = 0;
            player.Board(x, y) = pawnIndex;
            player.Pawns(pawnIndex).move(r, c, x, y);
        end
        
        function move(player, pawnIndex, where)
            if nargin < 3
                error('')
            end
            [r, c] = find(player.Board == pawnIndex);
            player.Board(r, c) = 0;
            rn = [];
            cn = [];
            if where == 'r'
                rn = r-1;
                cn = c+1;
            elseif where == 'l'
                rn = r-1;
                cn = c-1;
            end
            player.Board(rn, cn) = pawnIndex;
            player.Pawns(pawnIndex).move(r, c, rn, cn);
        end
        
        function pawn = getPawn(player, pawnIndex)
            pawn = player.Pawns(1, pawnIndex);
        end
        
        function movePx(player, pawnIndex, x, y)
            % OVVIAMENTE NON FUNZIONA
            [r, c] = find(player.Board == pawnIndex);
            player.Board(r, c) = 0;
            player.Board(x, y) = pawnIndex;
            player.Pawns(pawnIndex).movePx(r, c, x, y);
        end
        
        function pawn = getPawnHit(player, x, y)
            pawn = [];
            for i = 1:12
                xp = player.Pawns(1, i).getPoints();
                in = inpolygon(x,y,xp(1,:),xp(2,:));
                if in
                    pawn = i;
                    break;
                end
            end
        end
    end
end
