classdef Checkers
    properties
        board = zeros(8,8);
        p1;
        p2;
        turn;
    end
    
    methods
        function obj = Checkers(p1, p2)
            obj.p1 = p1;
            obj.p2 = p2;
            obj.turn = true;
            obj.board = [0 24 0 23 0 22 0 21;
                         20 0 19 0 18 0 17 0;
                         0 16 0 15 0 14 0 13;
                         0 0 0 0 0 0 0 0;
                         0 0 0 0 0 0 0 0;
                         1 0 2 0 3 0 4 0;
                         0 5 0 6 0 7 0 8;
                         9 0 10 0 11 0 12 0];
        end
        
        function obj = next(obj)
            [x, y] = ginput(1);
            if obj.turn
                p = obj.p1;
                off = 0;
            else
                p = obj.p2;
                off = 12;
            end
            
            pawn = p.getPawnHit(x, y);
            if isempty(pawn)
                return;
            end
            
            obj.turn = ~obj.turn;
            
            p.getPawn(pawn).select();
            waitforbuttonpress;
            where = get(gcf, 'CurrentCharacter');
            [r, c] = find(obj.board == (pawn + off));
            obj = obj.move(p, pawn, off, where, r, c);
            p.getPawn(pawn).deselect();
        end
    
        function obj = move(obj, p, pawn, off, where, r, c)
            switch where
                case 'q'
                    rn = r-1;
                    cn = c-1;
                case 'e'
                    rn = r-1;
                    cn = c+1;
                case 'a'
                    rn = r+1;
                    cn = c-1;
                case 'd'
                    rn = r+1;
                    cn = c+1;
            end
            if obj.isMoveValid(rn,cn)
                obj.board(r,c) = 0;
                p.getPawn(pawn).move(r, c, rn, cn);
                if obj.board(rn,cn) ~= 0
                    if strcmp(p.color, 'red')
                        if obj.board(rn,cn) >= 13 && obj.board(rn,cn) <= 24
                            obj.p2.deletePawn(obj.board(rn,cn) - 12);
                            obj = obj.move(p, pawn, off, where, rn, cn);
                        end
                    else
                        if obj.board(rn,cn) >= 1 && obj.board(rn,cn) <= 12 
                            obj.p1.deletePawn(obj.board(rn,cn));
                            obj = obj.move(p, pawn, off, where, rn, cn);
                        end
                    end
                    
                else
                    obj.board(rn,cn) = pawn + off;
                end
            end
        end

        function a = isMoveValid(obj, r, c)
            [i, j] = size(obj.board);
            a = [];
            a = r <= i & r >= 1 & c <= j & c >= 1;
        end
        
    end
end