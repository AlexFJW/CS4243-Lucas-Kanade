% Resize video matrix cells over time

% params video: full video
% params endSize: fraction of the original size, eg. 0.3
% returns resizedResult: the resized video matrix cells
function [rotateResult] = rotateOverTime(videoCells)
    [~, numFrames] = size(videoCells);
    rotateResult = cell(numFrames);
    angle = 0;
    for i = 1 : numFrames
        frame = videoCells{i};
        rotateResult{i} = imrotate(frame,angle);
        angle = angle + 20;
    end
end
