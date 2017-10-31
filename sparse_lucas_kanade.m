%Function sparse_lucas_kanade
% This function performs the hierachial lucas kanade algorithm on 2 images,
% without iterative warping
% Reference: robots.stanford.edu/cs223b04/algo_tracking.pdf
% Output: flow for i1

function [flowX, flowY] = sparse_lucas_kanade(i1, i2)
  % suggested by stanford docs
  pyramidLevels = 4;
  % can be 5-15
  windowSize = 15;

  % convert images to grayscale
  greyI1 = rgb2gray(i1);
  greyI2 = rgb2gray(i2);

  [py1, py2] = generatePyramids(greyI1, greyI2, pyramidLevels);

  % displacement of points in the X & Y dimensions
  % will be resized to i1's size by the end of algorithm
  flowX = zeros(size(py1{pyramidLevels}));
  flowY = flowX;

  for level = pyramidLevels:-1:1
    layerI1 = py1[level];
    layerI2 = py2[level];

    % project flowX & flow& on layerI2
    ...

    [lFlowX lFlowY] = opticalFlow(layerI1, layerI2, windowSize, 0.05)
    flowX = 2.*(flowX+lFLowX)
    flowY = 2.*(flowY+lFlowY)

    % resize for next iteration
    if (level > 1)
      nextPyramidSize = size(py1{level-1})
      flowX = imresize(flowX, nextPyramidSize, 'bilinear');
      flowY = imresize(flowY, nextPyramidSize, 'bilinear');
    end
  end

end
