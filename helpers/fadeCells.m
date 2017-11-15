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
    
    fadedCells = cell(numCells);
    ratio = 0;
    if (isFadeOut)
        ratio = 1;
    end
    
    stepRatio = 1/(numCells-1);
    
    for i = 1:numCells
        fadedCells{i} = ratio .* cells{i} + (1-ratio) .* bgCells{i};
        if (isFadeOut)
            ratio = ratio - stepRatio;
        else
            ratio = ratio + stepRatio;
        end
    end
end

