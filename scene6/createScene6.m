% creates scene 6 in sceneVideos directory. !!! important: measurements
% are as derived by trial and error to cover antman.
% horizontal flip human => bool,
% format for rotation degree follows rotateCells method
% format for child to parent: %
function [] = createScene6(humanVideoDirectory, ...
                           childToParentRatio, ...
                           horizontalFlipHuman, rotationDegree,...
                           xOffset, yOffset, ...
                           xMovement, yMovement, ...
                           startFrame, endFrame, ...
                           outputDirectory, blurOverlayEdges)
    % load bg video cells
    bgVid = VideoReader('videos/background/antman1.mp4');
    bgCells = videoToCells(bgVid);
    [~, totalBgFrames] = size(bgCells);
    [bgHeight, bgWidth, ~] = size(bgCells{1});

    % convert human video to cells
    humanVid = VideoReader(humanVideoDirectory);
    humanCells = videoToCells(humanVid);

    [~, initialNumHumanFrames] = size(humanCells);
    humanCells = humanCells(startFrame:endFrame);

    % resize human cells to fraction of bg
    humanCells = resizeChild(humanCells, bgHeight, bgWidth, childToParentRatio);

    % rotate human cells
    humanCells = rotateCells(humanCells, rotationDegree, true);

    % flip if needed
    if (horizontalFlipHuman)
        humanCells = horizontalFlipCells(humanCells);
    end

    % extend human vid
    humanCells = extendVideo(humanCells, totalBgFrames);

    % split human video into parts, by frames.
    % should have 3 parts
    totalQuicktimeFrames = 50;

    part1End = ceil(17/totalQuicktimeFrames * totalBgFrames);
    part2End = ceil(28/totalQuicktimeFrames * totalBgFrames);

    humanPart1 = humanCells(1:part1End);
    humanPart2 = humanCells(part1End+1:part2End);
    humanPart3 = humanCells(part2End+1:end);

    bgPart1 = bgCells(1:part1End);
    bgPart2 = bgCells(part1End+1:part2End);
    bgPart3 = bgCells(part2End+1:end);

    % do rotation operation on parts requring it
    % 1, rotate by -75
    rotationNow = -75;
    humanPart1 = rotateOverTime(humanPart1, rotationNow);
    humanPart2 = rotateCells(humanPart2, rotationNow, false);
    humanPart3 = rotateCells(humanPart3, rotationNow, false);


    % do resize operation on parts requiring it
    % 1, enlarge by ~2x
    % 3, shrink by ~3x
    resize1 = 3;
    resize3 = 11/60; %in between 1/5 and 1/6

    sizeNow = 1;
    sizeNow = sizeNow * resize1;
    humanPart1 = resizeOverTime(humanPart1, resize1);
    humanPart2 = resizeImmediately(humanPart2, sizeNow);

    humanPart3 = resizeImmediately(humanPart3, sizeNow);
    sizeNow = sizeNow * resize3;
    humanPart3 = resizeOverTime(humanPart3, resize3);
    
    % move south-west
    lastX = 550 + xOffset; lastY = 410 + yOffset;
    nextX = 430 + xOffset; nextY = 270 + yOffset;
    [merged1, lastX, lastY] = mergeCellsWithTranslation(humanPart1, bgPart1, lastX, lastY, nextX, nextY, blurOverlayEdges, 110);

    % stationary
    nextX = lastX + 50;
    nextY = lastY;
    [merged2, lastX, lastY] = mergeCellsWithTranslation(humanPart2, bgPart2, lastX, lastY, nextX, nextY, blurOverlayEdges, -90);

    % move right a lot 
    nextX = lastX + xMovement; %travel right as figure is shrinking;
    nextY = lastY + yMovement; %travel down as figure is shrinking;
    [merged3, lastX, lastY] = mergeCellsWithTranslation(humanPart3, bgPart3, lastX, lastY, nextX, nextY, blurOverlayEdges, -90);

    % videoCellsToMp4(merged1, bgVid.Framerate, 'test_output/1.mp4'); % test code
    % videoCellsToMp4(merged2, bgVid.Framerate, 'test_output/2.mp4'); % test code
    % videoCellsToMp4(merged3, bgVid.Framerate, 'test_output/3.mp4'); % test code

    % append all merged together
    mergedAll = [merged1 merged2 merged3];

    % try dropping the colors
    mergedAll = squeezeBrightnessContrastForCells(mergedAll);
    videoCellsToMp4(mergedAll, bgVid.Framerate, outputDirectory); % test code
end
