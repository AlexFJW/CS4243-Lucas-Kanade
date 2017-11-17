% Function generatePyrimids
% Generates downscaled pyramids from the provided images
% Each pyramid is half the size of the previous, and generated with a gaussian filter
% Note: level 1 is the original image.
% Layer L has the following dimensions: ceil(dim(L-1)/2)

% params i1: matrix of image1
% params i2: matrix of image2
% params numLevels: number of levels to create for the pyramid
% returns py1: hierachial pyramid of image1
% returns py2: hierachial pyramid of image2
function [py1, py2] = generatePyramids(i1, i2, numLevels)
    py1 = {i1};
    py2 = {i2};
    if numLevels > 1
        for k = 2:numLevels
            py1{k} = impyramid(py1{k-1}, 'reduce');
            py2{k} = impyramid(py1{k-1}, 'reduce');
        end
    end
end
