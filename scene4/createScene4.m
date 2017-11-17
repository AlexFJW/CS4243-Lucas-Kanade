% creates scene 4 in sceneVideos directory
% horizontal flip human => bool,
% format for rotation degree follows rotateCells method
% format for child to parent: %
function [] = createScene4(humanVideoDirectory, childToParentRatio, ...
                        horizontalFlipHuman, rotationDegree, ...
                        xBuffer, yBuffer, xScale, yScale,...
                        startFrame, endFrame, outputDirectory, blurOverlayEdges)
    % load bg video cells
    bgVid = VideoReader('videos/background/supernova2.mp4');
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

    % overlay color of human in the middle frames
    start1 = 1;
    end1 = 3;
    start2 = 4;
    end2 = 14;
    start3 = 15;
    end3 = 25;
    start4 = 26;
    rgb1 = [200 0 0];
    rgb2 = [20 0 0];
    rgb3 = [40 0 0];
    rgb4 = [200 0 0];
    humanCells = ...
        [overlayColor(humanCells(1,start1:end1), rgb1, 0.3) ...
        overlayColor(humanCells(1,start2:end2), rgb2, 0.7) ...
        overlayColor(humanCells(1,start3:end3), rgb3, 0.7) ...
        overlayColor(humanCells(1,start4:totalBgFrames), rgb4, 0.3)];

    % rotate human cells to create symmetry
    humanCells1 = rotateCells(humanCells, rotationDegree, true);
    humanCells1 = rotateOverTime(humanCells1, -rotationDegree*1.5);
    humanCells2 = horizontalFlipCells(humanCells1);
    humanCells2 = rotateOverTime(humanCells2, rotationDegree);

    % move both humans from center of the screen outwards
    % movement need not be symmetric
    [height, width, ~] = size(bgCells{1});
    rhsEndX = width-300;
    rhsEndY = 200;
    lhsEndX = 200;
    lhsEndY = 300;

    middleX = floor(width/2);
    middleY = floor(height/2);

    minion1 = resizeChild(humanCells1, bgHeight, bgWidth, 0.8);
    minion1 = rotateOverTime(minion1, -45);
    minion2 = resizeChild(humanCells2, bgHeight, bgWidth, 0.8);
    minion2 = rotateOverTime(minion2, 30);
    minion3 = resizeChild(humanCells1, bgHeight, bgWidth, 0.8);
    minion3 = rotateOverTime(minion3, -10);
    minion4 = resizeChild(humanCells2, bgHeight, bgWidth, 0.8);
    minion4 = rotateOverTime(minion4, 75);
                                                                            %startX and startY are continuation from previous scene
    [merged1, lastX, lastY] = mergeCellsWithTranslation(minion1, bgCells, middleX-xBuffer, middleY, middleX-4*xBuffer*xScale, middleY+yBuffer*yScale, blurOverlayEdges, NaN);
    [merged2, lastX, lastY] = mergeCellsWithTranslation(minion2, merged1, middleX+xBuffer, middleY, middleX+3*xBuffer*xScale, middleY+yBuffer*yScale, blurOverlayEdges, NaN);
    [merged3, lastX, lastY] = mergeCellsWithTranslation(minion3, merged2, middleX-xBuffer, middleY+yBuffer, middleX-4*xBuffer*xScale, middleY+3*yBuffer*yScale, blurOverlayEdges, NaN);
    [merged4, lastX, lastY] = mergeCellsWithTranslation(minion4, merged3, middleX+xBuffer, middleY+yBuffer, middleX+4*xBuffer*xScale, middleY+3*yBuffer*yScale, blurOverlayEdges, NaN);
    [merged5, lastX, lastY] = mergeCellsWithTranslation(humanCells1, merged4, middleX-xBuffer, middleY+yBuffer, lhsEndX, lhsEndY, blurOverlayEdges, NaN);
    [merged6, lastX, lastY] = mergeCellsWithTranslation(humanCells2, merged5, middleX+xBuffer, middleY+yBuffer, rhsEndX, rhsEndY, blurOverlayEdges, NaN);

    mergedAll = squeezeBrightnessContrastForCells(merged6);
    videoCellsToMp4(mergedAll, bgVid.Framerate, outputDirectory); % test code
