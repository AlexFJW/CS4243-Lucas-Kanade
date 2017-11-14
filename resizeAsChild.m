% Function resizeAsChild
% Resizes child video matrix to % of parent vido matrix
% Child's longest dimension is resized. Aspect ratio of child is maintained
% (assumes longest dimension of subject is the longest dimension resized)

% params child: child video matrix
% params pHeight: height of parent
% params pWidth: width of parent
% params resizePercentage: how much to resize child by, in doubt, try 0.30
function [output] = resizeAsChild(child, pHeight, pWidth, resizePercentage)
    [numFrames, cHeight, cWidth, cChannels] = size(child);

    cHeightIsLarger = cHeight > cWidth;

    childToParentRatio = 0.0;
    if (cHeightIsLarger)
        childToParentRatio = cHeight/pHeight;
    else
        childToParentRatio = cWidth/pWidth;
    end

    percentageToResize = resizePercentage/childToParentRatio;

    disp('original height')
    pHeight
    disp('original width')
    pWidth

    firstFrame = child(1,:,:,:);
    firstFrame = reshape(firstFrame, cHeight, cWidth, cChannels);
    [newHeight, newWidth, channels] = size(imresize(firstFrame, percentageToResize));
    output = zeros(numFrames, newHeight, newWidth, channels);

    for i = 1 : numFrames
        frame = child(i,:,:,:);
        frame = reshape(frame, cHeight, cWidth, cChannels);
        temp = imresize(frame, percentageToResize);
        output(i,:,:,:) = temp;
    end
end
