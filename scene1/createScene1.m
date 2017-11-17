function [] = createScene1(humanVideoPath, startFrame, endFrame, outputVideoPath)
    humanVid = VideoReader(humanVideoPath);
    humanCells = videoToCells(humanVid);

    bgVid = VideoReader('videos/background/galaxy.mp4');
    bgCells = videoToCells(bgVid);
    [~, totalBgFrames] = size(bgCells);
    [bgHeight, bgWidth, ~] = size(bgCells{1});

    % Select range of cells
    humanCells = humanCells(1,startFrame:endFrame);

    % resize human cells to fraction of bg
    humanCells = resizeChild(humanCells, bgHeight, bgWidth, 0.45);

    % rotate human cells
    humanCells = rotateCells(humanCells, -90, true);

    %extendVideo
    humanCells = extendVideo(humanCells, totalBgFrames);

    %frame1
    humanCells = horizontalFlipCells(humanCells);
    humanPart1 = humanCells(1:89);
    bgPart1 = bgCells(1:89);

    humanPart1(5:15) = overlayColor(humanPart1(5:15),[255 0 0],0.5);
    humanPart1(30:45) = overlayColor(humanPart1(30:45),[0 0 255],0.5);
    humanPart1(60:75) = overlayColor(humanPart1(60:75),[0 255 0],0.5);
    humanPart1 = rotateOverTime(humanPart1, 50);
    humanPart1 = resizeImmediately(humanPart1, 2.5);
    humanPart1= resizeOverTime(humanPart1, 0.5);

    lastX = 1280; lastY = -50;
    nextX = 700; nextY = 300;
    [merged, lastX, lastY] = mergeCellsWithTranslation(humanPart1, bgPart1, lastX, lastY, nextX, nextY,false, NaN);

    merged = squeezeBrightnessContrastForCells(merged);
    videoCellsToMp4(merged, bgVid.Framerate, outputVideoPath); % test code
end