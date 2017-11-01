% Function opticalFlow
% Calculates dense optical flow from i1 to i2
% Retention percentage determines whether we accept the flow at a point or not
% Refer to feature selection step for more info
% Retention percentage is usually 0.10 or 0.05 (and is different from the constant tau)
%
% Note for comments: 'window' is synonymous with 'aperture'

% params i1: image1
% params i2: image2
% params windowSize: size of the LK window
% params retentionPercentage: percentage of maxEigenvalue that minEigenvalue must be
% bigger or equal to for pixel to be kept
% returns flowX: displacement of points in the X dimension from image1 to image2
% returns flowY: displacement of points in the Y dimension from image1 to image2
function [flowX, flowY] = opticalFlow(i1, i2, windowSize, retentionPercentage)
    [height, width] = size(i1);
    flowX = zeros(size(i1));
    flowY = zeros(size(i1));

    % get I_x & I_y of all points in image 1 using the central difference operator
    dx = [-1 0 1]./2;
    dy = dx';
    i1_x = imfilter(i1, dx, 'replicate', 'same');
    i1_y = imfilter(i1, dy, 'replicate', 'same');

    minEigens = zeros(size(i1));

    borderLength = (windowSize-1)/2;

    % only calculate flow for region within border
    % ignore window region that lies outside of image
    for i = 1:height
        for j = 1:width
            % get I_x & I_y of image 1 in the integration window of point (i,j)
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
            [~, S, ~] = svd(G);
            eigenValues = [S(1,1) S(2,2)];
            minEigens(i, j) = min(eigenValues);
        end
    end

    % Feature selection step, (see section 3 of stanford paper)
    % this is actually equivalent to our corner detecter,
    % differences:
    % central difference operator to calculate gradient
    % use a more complex selection scheme to pick good features

    maxEigen = max(max(minEigens));
    pixelsToKeep = false(size(i1));
    % find pixels with minEigen larger than retentionPercentage of maxEigen & keep them
    % drop those
    for i = 1:height
        for j = 1:width
            shouldKeep = minEigens(i, j) >= (maxEigen*retentionPercentage);
            pixelsToKeep(i, j) = shouldKeep;
        end
    end

    % further filter the above pixels
    % if any non-zero pixel has a minEigen neighbor that is bigger than its eigen value, drop this pixel
    for i = 1:height
        for j = 1:width
            neighbors = minEigens(max(1, i-1):min(i+1, height), ...
            max(1, j-1):min(j+1, width));
            % take min to fix edge case at corners & edges
            eigenHere = neighbors(min(i,2), min(j,2));
            neighbors(min(i,2), min(j,2)) = 0;

            neighborhoodMaxEigen = max(max(neighbors));
            % assume that no eigen value is equal
            shouldKeep = eigenHere > neighborhoodMaxEigen;
            pixelsToKeep(i, j) = shouldKeep;
        end
    end

    % throw out bad points in the flow matrices
    for i = 1:height
        for j = 1:width
            shouldNotKeep = ~pixelsToKeep(i, j);
            if (shouldNotKeep)
                flowX(i, j) = 0;
                flowY(i, j) = 0;
            end
        end
    end
end
