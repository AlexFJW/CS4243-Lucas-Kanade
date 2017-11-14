% Function resizeAsChild
% Resizes child video matrix to % of parent vido matrix
% Child's longest dimension is resized. Aspect ratio of child is maintained
% (assumes longest dimension of subject is the longest dimension resized)

% params child: child video matrix
% params parent: parent video matrix
% params resizePercentage: how much to resize child by, default is 30
function [resized] = resizeAsChild(child, parent, resizePercentage)
    [~, pHeight, pWidth] = size(parent);
    [~, cHeight, cWidth] = size(child);

    cHeightIsLarger = cHeight > cWidth

    if (cHeightIsLarger)
        parentToChildRatio = cHeight/pHeight;
        percentageToResize =
    else
    end
