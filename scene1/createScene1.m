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
    %humanCells = rotateCells(humanCells, -90, true);

    %extendVideo
    humanCells = extendVideo(humanCells, totalBgFrames);

    %frame1
    humanCells = rotateCells(humanCells, 20, false);
    humanPart1 = humanCells(1:89);
    bgPart1 = bgCells(1:89);

    humanPart1(10:20) = overlayColor(humanPart1(10:20),[255 0 0],0.5);
    humanPart1(35:50) = overlayColor(humanPart1(35:50),[0 0 255],0.5);
    humanPart1(65:80) = overlayColor(humanPart1(65:80),[0 255 0],0.5);
    humanPart1 = rotateOverTime(humanPart1, 50);
    humanPart1 = resizeImmediately(humanPart1, 2.5);
    humanPart1= resizeOverTime(humanPart1, 0.5);

    lastX = 1280; lastY = 0;
    nextX = 700; nextY = 350;
    [merged, lastX, lastY] = mergeCellsWithTranslation(humanPart1, bgPart1, lastX, lastY, nextX, nextY,false, NaN);

    merged = squeezeBrightnessContrastForCells(merged);
    videoCellsToMp4(merged, bgVid.Framerate, outputVideoPath); % test code
end