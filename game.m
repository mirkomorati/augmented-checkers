close all
clear all
clc

calib = load('calib_data.mat');
camera = load('Calib_Results.mat');

imgPath = 'Checkerboard';

imgIndex = input('Image number ([1-25] or []=default=10): ');

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

figure(3)
imshow(img);
hold on

p1 = Player('red', 1, dX, dY, om, T, f, c, k);
p2 = Player('green', -1, dX, dY, om, T, f, c, k);

p1.draw();
p2.draw();

while true
    p = input('pawn: ');
    x = input('x: ');
    y = input('y: ');
    p1.move(p, x, y);
end

hold off
