% Function rotateCells
% Rotates video cells

% params cells: cells with matrices to flip
% params angle: in degrees, + for anticlockwise, - for clockwise
% params shouldCroup: true to retain size of frame (some parts of img will be lost).
%                       else, frame will be expanded to contain the rotated frames
% returns rotatedCells: rotatedCells cells
function [rotatedCells] = rotateCells(cells, angle, shouldCrop)
    [~, numCells] = size(cells);
    rotatedCells = cell(numCells);

    cropSettings = 'crop';
    if (~shouldCrop)
        cropSettings = 'loose';
    end

    for i = 1:numCells
        rotatedCells{i} = imrotate(cells{i}, angle, 'nearest', cropSettings);
    end
end
