% Function resizeChild
% Resizes child video matrix to % of parent video matrix
% Child's longest dimension is resized. Aspect ratio of child is maintained
% (assumes longest dimension of subject is the longest dimension resized)

% params child: child video cells
% params pHeight: height of parent
% params pWidth: width of parent
% params resizePercentage: how much to resize child by, in doubt, try 0.30
% returns outputCells:  resized matrices in a cell array
function [outputCells] = resizeChild(child, pHeight, pWidth, resizePercentage)
    outputCells = cell(size(child));
    [~, numFrames] = size(child);
    [cHeight, cWidth, ~] = size(child{1});

    cHeightIsLarger = cHeight > cWidth;

    childToParentRatio = 0.0;
    if (cHeightIsLarger)
        childToParentRatio = cHeight/pHeight;
    else
        childToParentRatio = cWidth/pWidth;
    end

    percentageToResize = resizePercentage/childToParentRatio;

    for i = 1 : numFrames
        frame = child{i};
        outputCells{i} = imresize(frame, percentageToResize);
    end
end
