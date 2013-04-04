clear all
close all



movieObj = VideoReader('xylophone.mpg'); % open file
get(movieObj) % display all info
nFrames = movieObj.NumberOfFrames;
width = movieObj.Width;
height = movieObj.Height;

for i=1:nFrames
    img = read(movieObj, i);
    imshow(img, []);
    pause(0.1);
end

images = read(movieObj);
i = 1;
I = images(:, :, :, i); % get the ith image
images = read(movieObj, [100, 200]);


vidObj = VideoWriter('mymovie.avi');
open(vidObj);

mshow(img);
newFrameOut = getframe;
writeVideo(vidObj, newFrameOut);

