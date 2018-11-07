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

%%

% 3D data
X = calib.(strcat('X_', imgIndexStr));

%{
% 3D plot of the checkerboard
figure(1)

% plot3(X,Y,Z)
plot3(X(1,:), X(2,:), X(3,:), 'r+');
%}

%% !! This will not consider camera distortion
%{ 

% Intrinsic matrix
% KK = [f(1) alpha_c*f(1) c(1);
%       0    f(2)         c(2);
%       0    0            1];
KK = camera.KK;

% Extrinsic matrix
% load the ith rotation and traslation (ith = imgNumber)
R = camera.(strcat('Rc_', imgIndexStr));
T = camera.(strcat('Tc_', imgIndexStr));

G = [R T; 0 0 0 1];

% PPM matrix
ppm = KK * [1 0 0 0; 0 1 0 0; 0 0 1 0] * G;

[u, v] = proj3d22d(ppm, X');

figure(2)
imshow(img);
hold on
plot(u, v, 'b+');

%}

%% !! This will consider camera distortion

%{
%   omc = rotation vector associated to the rotation matrix
%   T   = translation vector
%   fc  = focal length
%   cc  = center point
%   kc  = distortion
%}

om = camera.(strcat('omc_', imgIndexStr));
T = camera.(strcat('Tc_', imgIndexStr));
f = camera.fc;
c = camera.cc;
k = camera.kc;

%{
% xp: projected pixel coordinates
[xp, dxpdom, dxpdT, dxpdf, dxpdc, dxpdk] = project_points(X, om, T, f, c, k);

figure(2)
imshow(img);
hold on
plot(xp(1, :), xp(2, :), 'r+');
%}


%{
dX = calib.(strcat('dX_', imgIndexStr));
dY = calib.(strcat('dY_', imgIndexStr));

n_sq_x = calib.(strcat('n_sq_x_', imgIndexStr));
n_sq_y = calib.(strcat('n_sq_y_', imgIndexStr));

figure(3)
imshow(img);
hold on

pawnSize = 16;

pawnBase = [0 0 1 1 0; 0 1 1 0 0; 0 0 0 0 0] .* pawnSize;

pawnP = patch(0, 0, 'red');

a = 1;
b = 15;
cmap = hsv(b);

dx = 1;
dy = 0.3;

for i = 0:n_sq_x/dx-1
    colorIndex = round(a + (b-a).*rand(1,1));
    for j = 0:n_sq_y/dy-1
        pawn = pawnBase;
        pawn(1,:) = pawn(1,:) + i * dX*dx + dX / 2 - pawnSize / 2 + 1;
        pawn(2,:) = pawn(2,:) + j * dY*dy + dY / 2 - pawnSize / 2 + 1;

        [xp, dxpdom, dxpdT, dxpdf, dxpdc, dxpdk] = project_points(pawn, om, T, f, c, k);
    
        set(pawnP, 'Xdata', xp(1,:), 'Ydata', xp(2,:), 'FaceColor', cmap(colorIndex,:)); 
        drawnow;
        pause(0.1);
    end
    if ~ishandle(pawnP), break; end
end
%}

%%

