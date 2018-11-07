close all
clear all
clc

calib = load('calib_data.mat');
camera = load('Calib_Results.mat');

imgPath = 'Checkerboard';

imgIndex = input('Image number ([1-20] or []=default=10): ');

if isempty(imgIndex)
   imgIndex = 10; 
end

imgIndexStr = num2str(imgIndex);
    
img = imread(strcat(imgPath, '/', 'Image', imgIndexStr, '.tif'));

% 3D data

global params;

params.X = calib.(strcat('X_', imgIndexStr));

params.dX = calib.(strcat('dX_', imgIndexStr));
params.dY = calib.(strcat('dY_', imgIndexStr));

params.om = camera.(strcat('omc_', imgIndexStr));
params.T = camera.(strcat('Tc_', imgIndexStr));
params.f = camera.fc;
params.c = camera.cc;
params.k = camera.kc;

figure(1)
imshow(img);
hold on

p1 = createPlayer('red');

p2 = createPlayer('green');

board = createBoard(p1, p2);

drawPlayer(p1);
drawPlayer(p2);




%%
p1 = Player('red', params);
p2 = Player('green', params);

p1.draw();
p2.draw();

%{
while true
    p = input('pawn: ');
    x = input('x: ');
    y = input('y: ');
    p1.move(p, x, y);
end
%}

%{
pawnOld = [];
while true
    [clickX,clickY] = ginput(1);
    pawn = p1.getPawnHit(clickX,clickY);
    if isempty(pawn)
        continue;
    end
    if ~isempty(pawnOld)
        p1.getPawn(pawnOld).deselect();
    end
    pawnOld = pawn;
    p1.getPawn(pawn).select();
    [clickX,clickY] = ginput(1);
    p1.movePx(pawn, clickX, clickY);
end
%}

while true
    [clickX, clickY] = ginput(1);
    pawn = p1.getPawnHit(clickX, clickY);
    if isempty(pawn)
        continue;
    end
    p1.getPawn(pawn).select();
    w = waitforbuttonpress;
    p = get(gcf, 'CurrentCharacter');
    if p == 'd'
        p1.move(pawn, 'r');
    elseif p == 'a'
        p1.move(pawn, 'l');
    end
    p1.getPawn(pawn).deselect();
end

hold off
