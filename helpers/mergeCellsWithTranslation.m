% Function mergeCellsWithTranslation
% Merges 2 video cells, while translating the overlay with given velocity
% Note: overlay's center is the point of reference for the function's parameters

% params overlay: overlay cells (must have same size as background)
% params background: background cells (same as above)
% params startX: x coordinate of overlay's start position
% (overlay's center point will be here in the bg, MUST be in bounds of frame)
% params startY: y coordinate of overlay's start position (see above)
% params destX: x coordinate of overlay's end position (see above)
% params destY: y coordinate of overlay's end position (see above)
% params blurOverlayEdges: use gaussian blur on overlay edges, expensive, don't use when testing
% params blurAngle: angle for motion blur, use NaN for no blur, otherwise follow counterclockwise direction. 90 => left
function [merged, destX, destY] = mergeCellsWithTranslation(overlay, background,...
                            startX, startY, destX, destY, blurOverlayEdges, blurAngle)

    [~, numOverlayFrames] = size(overlay);
    [~, numBgFrames] = size(background);

    if (numBgFrames ~= numOverlayFrames)
        % overlay must be of equal length to base
        % we don't want to see disappearing overlays or backgrounds halfway through
        disp('overlay size')
        numOverlayFrames
        disp('bg size')
        numBgFrames
        error('overlay does not have same number of frames as background. overlay or bg might disappear.');
    end

    merged = cell(1, numBgFrames);

    % movement in the x direction per frame
    dX = (destX - startX)/(numBgFrames-1);
    % movement in the y direction per frame
    dY = (destY - startY)/(numBgFrames-1);
    centerX = startX;
    centerY = startY;
    for i = 1:numOverlayFrames
        bgFrame = background{i};
        overlayFrame = overlay{i};
        [bgHeight, bgWidth, ~] = size(bgFrame);
        [overlayHeight, overlayWidth, ~] = size(overlayFrame);

        % position of overlay's left edge in the bg
        xLeft = centerX - overlayWidth/2;
        % position of overlay's top edge in bg
        yTop = centerY - overlayHeight/2;

        % nudge overlay's position a bit to land whole pixels
        % if dX positive, ceil. else floor
        if (dX >= 0)
            xLeft = ceil(xLeft);
        else
            xLeft = floor(xLeft);
        end

        if (dY >= 0)
            yTop = ceil(yTop);
        else
            yTop = floor(yTop);
        end

        % position of overlay's right edge in the bg
        xRight = xLeft + overlayWidth - 1;
        % position of overlay's bottom edge in bg
        yBottom = yTop + overlayHeight - 1;

        % window from bg that will be replaced by overlay
        % top, bottom, left, right may be outside of frame, drop those parts

        bgWindow = bgFrame(max(1, yTop):min(bgHeight, yBottom), ...
                           max(1, xLeft):min(bgWidth, xRight), 1:3);

        [windowHeight, windowWidth, ~] = size(bgWindow);

        % trim parts of overlay frame that are out of window
        % warning... floor may be the wrong choice
        halfOverlayWidth = overlayWidth/2;
        halfOverlayHeight = overlayHeight/2;
        leftBound = floor(max(1, halfOverlayWidth - centerX));
        rightBound = min(overlayWidth, leftBound + windowWidth - 1);
        topBound = floor(max(1, halfOverlayHeight - centerY));
        bottomBound = min(overlayHeight, topBound + windowHeight - 1);
        overlayFrame = overlayFrame(topBound:bottomBound, leftBound:rightBound, 1:3);

        % Get location of the black pixels in all channels (overlay's coordinates)
        blackR = overlayFrame(:,:,1) <= 4;
        blackG = overlayFrame(:,:,2) <= 4;
        blackB = overlayFrame(:,:,3) <= 4;
        % get the actual black pixels in one channel
        blackPixels_Overlay = find(blackR & blackG & blackB);
        blackAll_1ch = ones(size(blackR));
        blackAll_1ch(blackPixels_Overlay) = 0; % flag 0 as pixels that are black
        blackAll_3ch = repmat(blackAll_1ch, [1,1,3]);
        pixelsToGrab = find(blackAll_3ch == 0);

        % fill overlay's black pixels with pixels from bg
        overlayFrame(pixelsToGrab) = bgWindow(pixelsToGrab);

        if (blurOverlayEdges)
            % grab pixels we didn't replace, to apply gaussian blur
            % do this in 2d since blackAll_3ch is 3 layers of the same thing
            nonBlackPixels = find(blackAll_1ch == 0);
            % do convolution to find surrounding pixels + non black pixels
            % https://www.mathworks.com/matlabcentral/answers/34735-how-to-count-black-pixels-in-a-region-of-an-image-that-can-only-have-1-white-neighbor-pixel
            sumFilter = ones(3,3); sumFilter(2,2) = 0;
            surroundingAndNonBlack_matrix = conv2(blackAll_1ch, sumFilter, 'same');
            [I_surrounding, J_surrounding] = find(surroundingAndNonBlack_matrix <= 7 ...
                                                    & surroundingAndNonBlack_matrix > 0);
            [numSurrounding, ~] = size(I_surrounding);

            % for each surrounding value, apply a gaussian filter.
            borderSize = 10;
            overlayFrameCopy = padarray(overlayFrame,[borderSize borderSize], 'replicate', 'both');

            for j = 1:numSurrounding
                i_coordinate = I_surrounding(j);
                j_coordinate = J_surrounding(j);
                % get the 3x3x3 window in overlayFrame
                % apply gaussian filter on the window, with 'same'
                % get the center value (1x1x3) & replace the one in overlayFrame (1x1x3)
                gaussianWindow = overlayFrameCopy(...
                                    i_coordinate : i_coordinate+2*borderSize, ...
                                    j_coordinate : j_coordinate+2*borderSize, ...
                                    :);
                % try 0.5 first
                gaussianedBlock = imgaussfilt(gaussianWindow, 10);

                % grab the center pixel (1x1x3)
                gaussianedPixel = gaussianedBlock(borderSize+1, borderSize+1, :);
                overlayFrame(i_coordinate, j_coordinate, :) = gaussianedPixel;
            end
        end

        % add motion blur effect
        if (~isnan(blurAngle))
            distanceTravelled = max(sqrt(dX.^2+dY.^2), 0.01);
            angleOfMovement = rand * 360 - 180;
            motionFilter = fspecial('motion', distanceTravelled, angleOfMovement);
            overlayFrame = imfilter(overlayFrame, motionFilter, 'replicate');
        end

        % paste overlay onto background (the same window we got above)
        bgFrame(max(1, yTop):min(bgHeight, yBottom), ...
                max(1, xLeft):min(bgWidth, xRight), 1:3) = overlayFrame;

        merged{i} = bgFrame;

        % shift for next iteration
        centerX = centerX + dX;
        centerY = centerY + dY;

    end
end
