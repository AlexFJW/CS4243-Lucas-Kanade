% Function mergeCellsWithTranslation
% Merges 2 video cells, while translating the overlay with given velocity
% Note: overlay's center is the point of reference for the function's parameters

% params overlay: overlay cells (must have same size as background)
% params background: background cells (same as above)
% params startX: x coordinate of overlay's start position (overlay's center point will be here in the bg)
% params startY: y coordinate of overlay's start position (see above)
% params destX: x coordinate of overlay's end position (see above)
% params destY: y coordinate of overlay's end position (see above)
function [merged] = mergeCellsWithTranslation(overlay, background, startX, startY, destX, destY)
    [~, numOverlayFrames] = size(overlay);
    [~, numBgFrames] = size(background);

    if (numBgFrames ~= numOverlayFrames)
        % overlay must be of equal length to base
        % don't want to see disappearing overlays halfway
        error('overlay does not have same number of frames as background.
         may lead to overlay disappearing or background disappearing...');
    end

    merged = cell(1, numBgFrames);

    for i = 1:numOverlayFrames
        bgFrame = background{i};
        overlayFrame = overlay{i}:
        [Ny, Nx, Nz] = size(humany);
        mergedFrame = zeros(Ny, Nx, Nz);
        dSize = Ny*Nx;
        % Get the location of the black pixels:
        bR = humany(:,:,1) == 0;
        bG = humany(:,:,2) == 0;
        bB = humany(:,:,3) == 0;
        blackPixels = find(bR & bG & bB);
        humany(blackPixels) = background(blackPixels);
        humany(blackPixels + dSize) = background(blackPixels+dSize);
        humany(blackPixels + 2*dSize) = background(blackPixels+dSize*2);

        merged{i} =
    end


end
