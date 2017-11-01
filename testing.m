% image test
Corridor1 = imread('images/bt.000.png');
Corridor2 = imread('images/bt.001.png');

I1 = double(Corridor1);
I2 = double(Corridor2);
% seems like window size of 25 works better for this image
[u, v] = sparseLucasKanade(I1, I2, 25);
% [u,v] = opticalFlow(I1,I2,15, 0.05);
figure;
subplot(1,1,1);
imagesc(I1);
colormap(gray);
hold on;

[height, width] = size(I1);
[x, y] = meshgrid(1:width, 1:height);
quiver(x, y, u, v, 50);


% Video test
%{
video = VideoReader('3_40_to_3_42.mp4');
frameratepersec = video.FrameRate;
video.CurrentTime = ((3*60)+40);
firstframeyouwant = ((3*60)+40)*frameratepersec;
lastframeyouwant = ((3*60)+42)*frameratepersec;
for i = firstframeyouwant:lastframeyouwant
     curr = readFrame(video);
     imshow(curr);
end
%}
