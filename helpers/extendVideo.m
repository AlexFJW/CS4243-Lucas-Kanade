% Function extendVideo
% Extends video by looping & rewinding
% TODO: add some stochasticity into playback, to make it more natural
% can be done by duplicating frames (adding delay) & dropping frames (speedup)

% params videoCells: cells containing video frames
% params desiredNumFrames: desired number of frames in output. should be more than current frame count
% returns outputCells: cells containing video frames
function [outputCells] = extendVideo(videoCells, desiredNumFrames)
    [~, originalNumFrames] = size(videoCells);
    if (desiredNumFrames <= originalNumFrames)
        error('cannot clip video, add functionality here if desired');
    end
    outputCells = {};

    reversedFrames = flip(videoCells);
    currentOrderIsNormal = true;

    % dump in frames, then add remainder frames
    iterations = floor(desiredNumFrames/originalNumFrames);
    remainderSize = rem(desiredNumFrames, originalNumFrames);
    for i = 1:iterations
        toInsert = videoCells;
        if (~currentOrderIsNormal)
            toInsert = reversedFrames;
        end
        % do not preallocate so code is more consize
        %startIndex = (i-1)*originalNumFrames + 1;
        %endIndex = i*originalNumFrames;
        outputCells = [outputCells toInsert];
        currentOrderIsNormal = ~currentOrderIsNormal;
    end

    % adding remainder frames here
    toInsert = videoCells;
    if (~currentOrderIsNormal)
        toInsert = reversedFrames;
    end
    remainderFrames = toInsert(1:remainderSize);
    outputCells = [outputCells remainderFrames];
end
