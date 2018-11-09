classdef Player < matlab.mixin.SetGet
    properties
        pawns;
        board = zeros(8, 8);
        color;
        camera;
    end
    
    methods 
        function obj = Player(color)
            if nargin < 1
                error('Too few arguments');
            end
            obj.color = color;
            for i = 1:12
                obj.pawns = [obj.pawns Pawn(color)];
            end
            obj.board = [obj.board(1:end-3, 1:end);
                            1 0 2 0 3 0 4 0;
                            0 5 0 6 0 7 0 8;
                            9 0 10 0 11 0 12 0];
        end
        
        function draw(obj)
            if strcmp(obj.color, 'green')
                obj.board = flip(flip(obj.board), 2);
            end
            for i = 1:size(obj.board)
                for j = 1:size(obj.board)
                    if obj.board(i, j) ~= 0
                        obj.pawns(1, obj.board(i, j)).draw(i, j);
                    end
                end
            end
            if strcmp(obj.color, 'green')
                obj.board = flip(flip(obj.board), 2);
            end
        end
        
        function moveTo(obj, pawnIndex, x, y)
            if nargin < 4
                error('')
            end
            [r, c] = find(obj.board == pawnIndex);
            obj.board(r, c) = 0;
            obj.board(x, y) = pawnIndex;
            obj.pawns(pawnIndex).move(r, c, x, y);
        end
        
        function pawn = getPawn(obj, pawnIndex)
            pawn = obj.pawns(1, pawnIndex);
        end
        
        function movePx(obj, pawnIndex, x, y)
            % OVVIAMENTE NON FUNZIONA
            [r, c] = find(obj.board == pawnIndex);
            obj.board(r, c) = 0;
            obj.board(x, y) = pawnIndex;
            obj.pawns(pawnIndex).movePx(r, c, x, y);
        end
        
        function pawn = getPawnHit(obj, x, y)
            pawn = [];
            for i = 1:12
                xp = obj.pawns(1, i).getPoints();
                in = inpolygon(x,y,xp(1,:),xp(2,:));
                if in
                    pawn = i;
                    break;
                end
            end
        end
        
        function deletePawn(obj, pawn)
            obj.pawns(pawn).draw(-100, -100);
        end
    end
end
