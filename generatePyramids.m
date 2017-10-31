%Function generatePyrimids
% Generates downscaled pyramids from the provided images
% Each pyramid is half the size of the previous, and generated with a guassian filter
% Note: level 1 is the original image.
% layer L has the following dimensions: ceil((dim(L-1) + 1)/2)
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
