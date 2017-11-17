humanVid = VideoReader('videos/filtered/human1_3_out_100.mp4');
humanCells = videoToCells(humanVid);

bgVid = VideoReader('videos/background/dolphin.mp4');
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

%human 1
humanCells = horizontalFlipCells(humanCells);
humanPart1 = humanCells(1:totalBgFrames);
bgPart1 = bgCells(1:totalBgFrames);

humanPart1 = resizeImmediately(humanPart1, 3);
humanPart1 = rotateOverTime(humanPart1);
humanPart1= resizeOverTime(humanPart1, 0.1);

lastX = 1280; lastY = -50;
nextX = 600; nextY = 400;
[merged1, lastX, lastY] = mergeCellsWithTranslation(humanPart1, bgPart1, lastX, lastY, nextX, nextY);

%human 2
humanPart2 = humanCells(1:totalBgFrames);
humanPart2 = resizeImmediately(humanPart2, 2);
humanPart2= resizeOverTime(humanPart2, 0.6);

lastX = 1280; lastY = 500;
nextX = 0; nextY = 200;
[merged, lastX, lastY] = mergeCellsWithTranslation(humanPart2, merged1, lastX, lastY, nextX, nextY);

videoCellsToMp4(merged, bgVid.Framerate, 'jorelvideo/humandolphin.mp4'); % test code



