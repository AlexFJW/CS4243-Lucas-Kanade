% Function horizontalFlipCells
% Flip all matrices in cells horizontally

% params cells: cells with matrices to flip
% returns flippedCells: flipped cells
function [flippedCells] = horizontalFlipCells(cells)
    [~, numCells] = size(cells);
    flippedCells = cell(numCells);
    
    for i = 1:numCells
        flippedCells{i} = fliplr(cells{i});
end
