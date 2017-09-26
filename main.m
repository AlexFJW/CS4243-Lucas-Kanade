video = VideoReader('traffic.mp4');

frames = video.NumberOfFrames;
prev = read(video,1);

% Smoothen image with Gaussian filter before scaling down %
smoothedPrev = imgaussfilt(prev, 2);
p1 = prev;
p2 = imresize(smoothedPrev,0.5);
p3 = imresize(smoothedPrev,0.25);
p4 = imresize(smoothedPrev,0.125);
p5 = imresize(smoothedPrev,0.0625);

% To be updated when tracker moves %
trackX = 100;
trackY = 100;

for i = 2:frames
    curr = read(video,i);
    smoothedCurr = imgaussfilt(curr, 2);
    c1 = curr;
    c2 = imresize(smoothedCurr,0.5);
    c3 = imresize(smoothedCurr,0.25);
    c4 = imresize(smoothedCurr,0.125);
    c5 = imresize(smoothedCurr,0.0625);
    
    % Add rectangle to simulate tracker %
    imshow(curr);
    hold on;
    rectangle('Position', [trackX trackY 100 100], 'EdgeColor', 'r', 'LineWidth', 3);
    hold off;
    drawnow;
    
    % Find out d for good corners from prev to curr %
    % From c5 to c1 %
    % Write Lucas Kanade function at the bottom %
    
    % Update rectangle frame by d
    
    % Update prev for next frame
    p1 = curr;
    p2 = imresize(smoothedCurr,0.5);
    p3 = imresize(smoothedCurr,0.25);
    p4 = imresize(smoothedCurr,0.125);
    p5 = imresize(smoothedCurr,0.0625);
end

% function d = lucasKanade(prev, curr, pixX, pixY, lenX, lenY)
%     % Apply corner detectors for prev %
%     % Apply corner detectors for curr %
%     % Find shortest distance d %
% 
%     d = 1;
% end