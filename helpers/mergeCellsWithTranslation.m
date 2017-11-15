% Function mergeCellsWithTranslation
% Merges 2 video cells, while translating the overlay with given velocity
% Note: overlay's center is the point of reference for the function's parameters
% TODO: add some stochasticity to the translation for realism

% params overlay: overlay cells (must have same size as background)
% params background: background cells (same as above)
% params startX: x coordinate of overlay's start position
% (overlay's center point will be here in the bg, MUST be in bounds of frame)
% params startY: y coordinate of overlay's start position (see above)
% params destX: x coordinate of overlay's end position (see above)
% params destY: y coordinate of overlay's end position (see above)
function [merged] = mergeCellsWithTranslation(overlay, background, startX, startY, destX, destY)
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
        % position of overlay's right edge in the bg
        xRight = centerX + overlayWidth/2;
        % position of overlay's top edge in bg
        yTop = centerY - overlayHeight/2;
        % position of overlay's bottom edge in bg
        yBottom = centerY + overlayHeight/2;

        % nudge overlay's position a bit to land whole pixels
        % if dX positive, ceil. else floor
        if (dX >= 0)
            xLeft = ceil(xLeft);
            xRight = ceil(xRight);
        else
            xLeft = floor(xLeft);
            xRight = floor(xRight);
        end

        if (dY >= 0)
            yTop = ceil(yTop);
            yBottom = ceil(yBottom);
        else
            yTop = floor(yTop);
            yBottom = floor(yBottom);
        end
        % shift for next iteration
        centerX = centerX + dX;
        centerY = centerY + dY;

        % window from bg that will be replaced by overlay
        % top, bottom, left, right may be outside of frame, drop those parts
        max(0, yTop)
        min(bgHeight, yBottom)
        max(0, xLeft)
        min(bgWidth, xRight)

        bgWindow = bgFrame(max(0, yTop):min(bgHeight, yBottom), ...
                           max(0, xLeft):min(bgWidth, xRight), ...
                           1:3);

        [windowHeight, windowWidth, ~] = size(bgWindow);

        % trim parts of overlay frame that are out of window
        % warning... floor may be the wrong choice
        halfOverlayWidth = floor(overlayWidth/2);
        halfOverlayHeight = floor(overlayHeight/2);
        leftBound = floor(max(0, halfOverlayWidth - centerX));
        rightBound = min(overlayWidth, leftBound + windowWidth);
        topBound = floor(max(0, halfOverlayHeight - centerY));
        bottomBound = min(overlayHeight, topBound + windowHeight);
        overlayFrame = overlayFrame(topBound:bottomBound, leftBound:rightBound, 1:3);

        % Get location of the black pixels in all channels (overlay's coordinates)
        blackR = overlayFrame(:,:,1) == 0;
        blackG = overlayFrame(:,:,2) == 0;
        blackB = overlayFrame(:,:,3) == 0;
        % get the actual black pixels (overlay's coordinates)
        blackPixels_Overlay = find(blackR & blackG & blackB);

        % fill overlay's black pixels with pixels from bg
        overlayFrame(blackPixels_Overlay) = bgWindow(blackPixels_Overlay);

        % paste overlay onto background
        bgFrame(yTop:yBottom, xLeft:xRight, 1:3) = overlayFrame;

        merged{i} = bgFrame;
    end
end
