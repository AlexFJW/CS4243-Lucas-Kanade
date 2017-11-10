Corridor1 = imread('images/bt.000.png');
Corridor2 = imread('images/bt.001.png');

I1 = double(Corridor1);
I2 = double(Corridor2);
[u, v] = sparseLucasKanade(I1, I2, 7);
%[u,v] = opticalFlow(I1,I2,5, 0.05);
figure;
subplot(1,1,1);
imagesc(I1);
colormap(gray);
hold on;

[height, width] = size(I1);
[x, y] = meshgrid(1:width, 1:height);
quiver(x, y, u, v, 50);