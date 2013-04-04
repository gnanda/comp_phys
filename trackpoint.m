% Track a point
clear all
close all
movieObj = VideoReader('building.avi'); % open file
nFrames = movieObj.NumberOfFrames;
I0 = read(movieObj,1);  % Get first image
I0 = rgb2gray(I0);
imshow(I0, []);
[x,y] = ginput(1);
x = round(x);
y = round(y);
% Size of window
M = 9;
rectangle('Position', [x-M y-M 2*M+1 2*M+1], 'EdgeColor', 'r');
% Extract template
T = I0(y-M:y+M, x-M:x+M);
figure, imshow(T, []);
pause
% Read images one at a time: 
for i=2:nFrames
    img = read(movieObj,i);   % get one RGB image
    img = rgb2gray(img);
    imshow(img, []);
    C = normxcorr2(T,img);
    cmax = max(C(:));
    [y2 x2] = find(C==cmax);
    y2 = y2-M;
    x2 = x2-M;
    rectangle('Position', [x2-M y2-M 2*M+1 2*M+1], 'EdgeColor', 'r');
    rectangle('Position', [x2-M+2*M y2-M 2*M+1 2*M+1], 'EdgeColor', 'g');
    fprintf('%d %d \n', x2, y2)
    %fprintf('Correlation score = %f\n', cmax);
    %pause
end