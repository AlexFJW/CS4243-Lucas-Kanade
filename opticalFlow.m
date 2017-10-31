%Function opticalFlow
% Calculates dense optical flow from i1 to i2
% retention percentage determines whether we accept the flow at a point or not
% refer to feature selection step for more info
% retention percentage is usually 0.10 or 0.05 (and is different from tau)
%
% Note for comments: 'window' is synonymous with 'aperature'

function [flowX, flowY] = opticalFlow(i1, i2, windowSize, retentionPercentage)
  [height, width] = size(i1);
  flowX = zeros(size(i1));
  flowY = zeros(size(i1));

  % get I_x & I_y of all points in image 1 using the central difference operator
  dx = [-1 0 1]./2;
  dy = dx';
  i1_x = imfilter(i1, dx, 'replicate', 'same');
  i1_y = imfilter(i1, dy, 'replicate', 'same');

  minEigens = zeros(size(i1))

  borderLength = (windowSize-1)/2;

  % only calculate flow for region within border
  % ignore window region that lies outside of image
  for i = 1:height
    for j = 1:width
      % get I_x & I_ys of image 1 in the integration window of point (i,j)
      w_x = i1_x(max(1, i-borderLength):min(height, i+borderLength), ...
                max(1, j-borderLength):min(width, j+borderLength));
      w_y = i1_y(max(1, i-borderLength):min(height, i+borderLength), ...
                max(1, j-borderLength):min(width, j+borderLength));

      % difference between i1 & i2 for integration window
      iDiff = i1(max(1, i-borderLength):min(height, i+borderLength), ...
                max(1, j-borderLength):min(width, j+borderLength))  ...
              -i2(max(1, i-borderLength):min(height, i+borderLength), ...
                max(1, j-borderLength):min(width, j+borderLength));

      % double sum to sum all dimensions
      % G is Z in lecture notes
      b = [sum(sum(iDiff .* w_x)); sum(sum(iDiff .* w_y))];
      G = [sum(sum(w_x.^2)),sum(sum(w_x .* w_y));...
            sum(sum(w_x .* w_y)),sum(sum(w_y.^2))];

      % solve for flow
      flow = G\b;
      flowX(i,j) = flow(1);
      flowY(i,j) = flow(2);

      % store the min eigen values of G for feature selection
      [U, S, V] = svd(G);
      eigenValues = [S(1,1) S(2,2)];
      minEigens(i-borderLength, j-borderLength) = min(eigenValues);
    end
  end

  % Feature selection step, (see section 3 of stanford paper)
  % this is actually equivalent to our corner detecter,
  % differences:
  % central difference operator to calculate gradient
  % use a more complex selection scheme to pick good features

  maxEigen = max(minEigens)
  pixelsToKeep = false(size(i1))
  % find pixels with minEigen larger than retentionPercentage of maxEigen & keep them
  % drop those
  for i = 1:height
    for j = 1:width
      shouldKeep = minEigens(i, j) >= (maxEigen*retentionPercentage)
      pixelsToKeep(i, j) = shouldKeep
    end
  end

  % further filter the above pixels
  % if any non-zero pixel has a minEigen neighbor that is bigger than it eigen value, drop this pixel
  for i = 1:height
    for j = 1:width
      neighbors = minEigens(max(1, i-1):min(i+1, height), ...
                            max(1, j-1):(min(j+1, width)));
      eigenHere = neighbors(2,2);
      neighbors(2,2) = 0;

      neighborhoodMaxEigen = max(neighbors);
      % assume that no eigen value is equal
      shouldKeep = eigenHere > neighborhoodMaxEigen;
      pixelsToKeep(i, j) = shouldDrop;
    end
  end

  % throw out bad points in the flow matrices
  for i = 1:height
    for j = 1:width
      shouldNotKeep = !pixelsToKeep(i, j)
      if (shouldNotKeep)
        flowX(i, j) = 0
        flowY(i, j) = 0
      end
    end
  end
end
