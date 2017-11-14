% Function resizeAsChild
% Resizes child video matrix to % of parent vido matrix
% Child's longest dimension is resized. Aspect ratio of child is maintained
% (assumes longest dimension of subject is the longest dimension resized)

% params child: child video matrix
% params parent: parent video matrix
% params resizePercentage: how much to resize child by, in doubt, try 0.30 
function [child] = resizeAsChild(child, parent, resizePercentage)
    [~, pHeight, pWidth, ~] = size(parent);
    [numFrames, cHeight, cWidth, ~] = size(child);

    cHeightIsLarger = cHeight > cWidth;

    childToParentRatio = 0;
    if (cHeightIsLarger)
        childToParentRatio = cHeight/pHeight;
    else
        childToParentRatio = cWidth/pWidth;
    end

    percentageToResize = resizePercentage/childToParentRatio;

    for i = 1 : numFrames
        frame = child(i);
        child(i) = imresize(frame, percentageToResize);
    end
end
