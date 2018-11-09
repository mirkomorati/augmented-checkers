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
X = calib.(strcat('X_', imgIndexStr));


dX = calib.(strcat('dX_', imgIndexStr));
dY = calib.(strcat('dY_', imgIndexStr));

om = camera.(strcat('omc_', imgIndexStr));
T = camera.(strcat('Tc_', imgIndexStr));
f = camera.fc;
c = camera.cc;
k = camera.kc;

global params;

params.dX = dX;
params.dY = dY;
params.om = om;
params.T = T;
params.f = f;
params.c = c;
params.k = k;


figure(3)
imshow(img);
hold on


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

p1 = Player('red');
p2 = Player('green');

p1.draw();
p2.draw();


c = Checkers(p1, p2);
while true
    c = c.next();
    c.board
end

hold off
