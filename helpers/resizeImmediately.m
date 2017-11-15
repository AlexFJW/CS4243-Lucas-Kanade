% Resize video matrix cells immediately

% params video: full video
% params endSize: fraction of the original size, eg. 0.3
% returns resizedResult: the resized video matrix cells
function [resizedResult] = resizeImmediately(videoCells, endSize)
    [~, numFrames] = size(videoCells);
    resizedResult = cell(numFrames);
    for i = 1 : numFrames
        frame = videoCells{i};
        resizedResult{i} = imresize(frame, endSize);
    end
end
