function [cells] = squeezeBrightnessContrastForCells(cells)
    [~, numCells] = size(cells);

    for i = 1:numCells
        oneToZero = double(cells{i})./255;
        adjusted = imadjust(oneToZero, ...
                        [0 0 0; 1 1 1], [0.05 0.05 0.05; 0.7 0.7 0.7]);

        cells{i} = uint8(floor(adjusted.*255));
    end
end
