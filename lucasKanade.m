function [dx, dy] = lucasKanade(prev, curr, pixX, pixY, lenX, lenY, layers, layerNo)
    if (layerNo == 0)
        % First layer, don't need to smoothen %
        p = prev;
        c = curr;
    else 
        % Smoothen image with Gaussian filter before scaling down %
        smoothedPrev = imgaussfilt(prev, 2);
        p = imresize(smoothedPrev,0.5^layerNo);
        imwrite(p, 'p.jpg');
        p = imread('p.jpg');

        % Smoothen image with Gaussian filter before scaling down %
        smoothedCurr = imgaussfilt(curr, 2);
        c = imresize(smoothedCurr,0.5^layerNo);
        imwrite(c, 'c.jpg');
        c = imread('c.jpg');
    end

    % Calculate the ROI in this layer %
    if (layers == (layerNo-1))
       left = pixX * (0.5^layerNo);
       top = pixY * (0.5^layerNo);
    else
       [dx, dy] = lucasKanade(prev, curr, pixX, pixY, lenX, lenY, layers, layerNo+1);
       left = pixX * (0.5^layerNo) + dx*2;
       top = pixY * (0.5^layerNo) + dy*2;
    end
    width = lenX * (0.5^layerNo);
    height = lenY * (0.5^layerNo);
    
    prevRoi = p(top:top+height, left:left+width, :);
    currRoi = c(top:top+height, left:left+width, :);

    % Apply corner detectors %
    eigP = cornerDetector(prevRoi);
    eigC = cornerDetector(currRoi);
    
    % For checking of ROI with corner detectors %
    % eigP and eigC supposed to return matrices for LK *
    figH = figure;
    subplot(1,2,1), imshow(eigP, [0 255]);
    title('previous');
    
    subplot(1,2,2), imshow(eigC, [0 255]);
    title('current');

    figName = strcat(num2str(layerNo), 'project.jpg');
    print(figH, '-djpeg', figName);

    % Find shortest distance d with LK %

    dx = 0;
    dy = 0;
end