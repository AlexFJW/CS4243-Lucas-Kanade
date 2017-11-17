% NOTE: Please be in CS4243-Lucas-Kanade directory before running this
% script. If strings of warning spews out, some Matlab functions may not
% have been loaded and the resultant image is erroneous. Please refer to 
% images in `results` folder instead.  

I1 = double(imread('LucasKanadeTracker/images/frame1.png'));
I2 = double(imread('LucasKanadeTracker/images/frame2.png'));

[u, v] = sparseLucasKanade(I1, I2, 7);
% [u,v] = opticalFlow(I1,I2,5, 0.05);
figure;
fig = subplot(1,1,1);
imagesc(I1);
colormap(gray);
hold on;

[height, width] = size(I1);
[x, y] = meshgrid(1:width, 1:height);
quiver(x, y, u, v, 50);

saveas(fig,'LucasKanadeTracker/results/sparseLK.jpg');
% saveas(fig,'LucasKanadeTracker/results/opticalFlow.jpg');