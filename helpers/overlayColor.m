% Function overlayColor
% Overlay cells with color

% params cells: cells with matrices to be colored
% params rgb: vector of size 3, rgb code of color
% params opacity: double, opacity of the overlay, 1.0 for opaque color, 0
% for original cell color
% returns coloredCells: the colored matrix cells
function [ coloredCells ] = overlayColor( cells, rgb, opacity)
%OVERLAYCOLOR Summary of this function goes here
%   Detailed explanation goes here
    [~, numCells] = size(cells);
    coloredCells = cell(1, numCells);
    
    [height, width, ~] = size(cells{1});
    rgbMatrix = repmat(  reshape(rgb,1,1,[]),   height, width);

    for i = 1:numCells
        % use first color as condition of whether pixel is empty [0 0 0]
        isPixel = sum(cells{i},3);
        isPixel(isPixel == 0) = 0;
        isPixel(isPixel ~= 0) = 1;
        isPixel = repmat(isPixel, [1 1 3]);
        
        coloredCells{i} = uint8((double((1-opacity) .* cells{i}) + double(opacity .* rgbMatrix)) .* double(isPixel));
    end
end

