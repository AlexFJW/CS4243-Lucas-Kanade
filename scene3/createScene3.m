% creates scene 3 in sceneVideos directory
% horizontal flip human => bool,
% format for rotation degree follows rotateCells method
% format for child to parent: %
function [] = createScene3(humanVideoDirectory, childToParentRatio, ...
                        horizontalFlipHuman, rotationDegree, ...
                        startFrame, endFrame, outputDirectory, useGaussian)
    % load bg video cells
    bgVid = VideoReader('videos/background/supernova1.mp4');
    bgCells = videoToCells(bgVid);
    [~, totalBgFrames] = size(bgCells);
    [bgHeight, bgWidth, ~] = size(bgCells{1});

    % convert human video to cells
    humanVid = VideoReader(humanVideoDirectory);
    humanCells = videoToCells(humanVid);

    % Select range of cells
    humanCells = humanCells(1,startFrame:endFrame);

%     % resize human cells to fraction of bg
%     humanCells = resizeChild(humanCells, bgHeight, bgWidth, childToParentRatio);

    % extend human vid
    humanCells = extendVideo(humanCells, totalBgFrames);

    % flip if needed
    if (horizontalFlipHuman)
        humanCells = horizontalFlipCells(humanCells);
    end

    % rotate human cells to create symmetry
    humanCells1 = rotateCells(humanCells, rotationDegree, true);
    humanCells2 = horizontalFlipCells(humanCells1);

    % move both humans to center of the screen
    [height, width, ~] = size(bgCells{1});
    rhsStartX = width;
    rhsStartY = height;
    lhsStartX = 0;
    lhsStartY = height;

    middleX = floor(width/2);
    middleY = floor(height/2);
    xBuffer = 160;
    yBuffer = 120;
    [merged1, lastX, lastY] = mergeCellsWithTranslation(humanCells1, bgCells, lhsStartX, lhsStartY, middleX-xBuffer, middleY+yBuffer, useGaussian);
    [merged2, lastX, lastY] = mergeCellsWithTranslation(humanCells2, merged1, rhsStartX, rhsStartY, middleX+xBuffer, middleY+yBuffer, useGaussian);

    videoCellsToMp4(merged2, bgVid.Framerate, outputDirectory); % test code
end
