function [] = createScene2(humanVideoPath, startFrame, endFrame, ...
                            outputVideoPath, blurOverlayEdges)
    humanVid = VideoReader(humanVideoPath);
    humanCells = videoToCells(humanVid);

    bgVid = VideoReader('videos/background/dolphin.mp4');
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

    %human 1
    humanCells = horizontalFlipCells(humanCells);
    humanPart1 = humanCells(1:totalBgFrames);
    bgPart1 = bgCells(1:totalBgFrames);

    humanPart1 = resizeImmediately(humanPart1, 1.8);
    humanPart1 = rotateOverTime(humanPart1, 30);

    lastX = 1250; lastY = 50;
    nextX = 700; nextY = 200;
    [merged1, lastX, lastY] = mergeCellsWithTranslation(humanPart1, bgPart1, lastX, lastY, nextX, nextY, false, NaN);

    %human 2
    humanPart2 = humanCells(1:totalBgFrames);
    humanPart2 = resizeImmediately(humanPart2, 2.5);
    humanPart2(1:47)= rotateOverTime(humanPart2(1:47), 50);
    humanPart2(48:totalBgFrames)= rotateOverTime(humanPart2(48:totalBgFrames), -30);

    lastX = 1280; lastY = 400;
    nextX = 0; nextY = 200;
    [merged, lastX, lastY] = mergeCellsWithTranslation(humanPart2, merged1, lastX, lastY, nextX, nextY, blurOverlayEdges, NaN);

    merged = squeezeBrightnessContrastForCells(merged);
    videoCellsToMp4(merged, bgVid.Framerate, outputVideoPath); % test code
end