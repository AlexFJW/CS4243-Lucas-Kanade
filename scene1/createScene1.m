function [] = createScene1(humanVideoPath, outputVideoPath)
    humanVid = VideoReader(humanVideoPath);
    humanCells = videoToCells(humanVid);

    bgVid = VideoReader('videos/background/galaxy.mp4');
    bgCells = videoToCells(bgVid);
    [~, totalBgFrames] = size(bgCells);
    [bgHeight, bgWidth, ~] = size(bgCells{1});

    % only take first 1/4 of video
    [~, initialHumanFrames] = size(humanCells);
    humanCells = humanCells(1:floor(initialHumanFrames/4));

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
    [merged1, lastX, lastY] = mergeCellsWithTranslation(humanPart1, bgPart1, lastX, lastY, nextX, nextY,false);

    videoCellsToMp4(merged1, bgVid.Framerate, outputVideoPath); % test code
end