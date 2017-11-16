% Function fadeCells
% Fade the cells into the background

% params cells: cells with matrices to fade
% params bgCells: background cells for cells to fade into
% params isFadeOut: boolean, true for fade out, false for fade in
% returns fadedCells: the faded video matrix cells
function [ fadedCells ] = fadeCells( cells, bgCells, isFadeOut )
%FADECELLS Summary of this function goes here
%   Detailed explanation goes here
    [~, numBgCells] = size(bgCells);
    [~, numCells] = size(cells);
    
    if (numBgCells < numCells)
        numCells = ngBgCells;
    end
    
    fadedCells = cell(1, numCells);
    ratio = 0;
    if (isFadeOut)
        ratio = 1;
    end
    
    stepRatio = 1/(numCells-1);
    
    for i = 1:numCells
        isPixel = sum(cells{i},3);
        isPixel(isPixel == 0) = 0;
        isPixel(isPixel ~= 0) = 1;
        isPixel = repmat(isPixel, [1 1 3]);
        
        fadedCells{i} = uint8( ...
            (double(ratio) .* double(cells{i}) + double(1-ratio) .* double(bgCells{i})) .* double(isPixel) ... % get faded human pixels
            + (double(1-isPixel) .* double(bgCells{i})) ... % get solid background
        );
        if (isFadeOut)
            ratio = ratio - stepRatio;
        else
            ratio = ratio + stepRatio;
        end
    end
end

