% Rotate video matrix cells over time

% params video: full video
% params angle: in degrees, + for anticlockwise, - for clockwise
% returns rotatedResult: the rotated video matrix cells
function [rotateResult] = rotateOverTime(videoCells, angle)
    [~, numFrames] = size(videoCells);
    rotateResult = cell(numFrames);
    angle = 0;

    stepSize = angle/(numFrames-1);
    currentAngle = 0

    for i = 1 : numFrames
        frame = videoCells{i};
        rotateResult{i} = imrotate(frame, currentAngle);
        currentAngle = currentAngle + stepSize;
    end
end
