video = VideoReader('traffic.mp4');

frames = video.NumberOfFrames;
prev = read(video,1);

% To be updated when tracker moves %
trackX = 150;
trackY = 150;

width = 100;
height = 100;

% for i = 2:frames
    curr = read(video,2);
    
    % Add rectangle to simulate tracker %
    imshow(curr);
    hold on;
    rectangle('Position', [trackX trackY width height], 'EdgeColor', 'r', 'LineWidth', 3);
    hold off;
    drawnow;
    
    % Find out d for good corners from prev to curr %
    [dx, dy] = lucasKanade(prev, curr, trackX, trackY, width, height, 3, 1);
    
    % Update rectangle frame by d
    
    % Update prev for next frame
    prev = curr;
% end