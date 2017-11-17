% creates scene 7 in sceneVideos directory
% horizontal flip human => bool,
% format for rotation degree follows rotateCells method
% format for child to parent: %
function [] = createScene7(humanVideoDirectory, childToParentRatio, ...
                        horizontalFlipHuman, rotationDegree, outputDirectory, useGaussian)
    % load bg video cells
    bgVid = VideoReader('videos/background/antman2.mp4');
    bgCells = videoToCells(bgVid);
    [~, totalBgFrames] = size(bgCells);
    [bgHeight, bgWidth, ~] = size(bgCells{1});

    % convert human video to cells
    humanVid = VideoReader(humanVideoDirectory);
    humanCells = videoToCells(humanVid);

    % only take first 1/4 of video
    [~, initialHumanFrames] = size(humanCells);
    humanCells = humanCells(1:floor(initialHumanFrames/4));

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
    % should have 8 parts
    totalQuicktimeFrames = 138;

    part1End = ceil(12/totalQuicktimeFrames * totalBgFrames);
    part2End = ceil(22/totalQuicktimeFrames * totalBgFrames);
    part3End = ceil(37/totalQuicktimeFrames * totalBgFrames);
    part4End = ceil(50/totalQuicktimeFrames * totalBgFrames);
    part5End = ceil(67/totalQuicktimeFrames * totalBgFrames);
    part6End = ceil(80/totalQuicktimeFrames * totalBgFrames);
    part7End = ceil(110/totalQuicktimeFrames * totalBgFrames);

    humanPart1 = humanCells(1:part1End);
    humanPart2 = humanCells(part1End+1:part2End);
    humanPart3 = humanCells(part2End+1:part3End);
    humanPart4 = humanCells(part3End+1:part4End);
    humanPart5 = humanCells(part4End+1:part5End);
    humanPart6 = humanCells(part5End+1:part6End);
    humanPart7 = humanCells(part6End+1:part7End);
    humanPart8 = humanCells(part7End+1:end);

    bgPart1 = bgCells(1:part1End);
    bgPart2 = bgCells(part1End+1:part2End);
    bgPart3 = bgCells(part2End+1:part3End);
    bgPart4 = bgCells(part3End+1:part4End);
    bgPart5 = bgCells(part4End+1:part5End);
    bgPart6 = bgCells(part5End+1:part6End);
    bgPart7 = bgCells(part6End+1:part7End);
    bgPart8 = bgCells(part7End+1:end);

    % do resize operation on parts requiring it
    % 1, enlarge by 1.2x
    % 3, enlarge by 3x
    % 5, shrink by 3x
    resize1 = 1.3;
    resize3 = 3;
    resize5 = 1/3;

    sizeNow = 1;
    sizeNow = sizeNow * resize1;
    humanPart1 = resizeOverTime(humanPart1, sizeNow);
    humanPart2 = resizeImmediately(humanPart2, sizeNow);

    % always resizeImmediately to previous part's size before doing resizeOverTime
    humanPart3 = resizeImmediately(humanPart3, sizeNow);
    sizeNow = sizeNow * resize3;
    humanPart3 = resizeOverTime(humanPart3, sizeNow);
    humanPart4 = resizeImmediately(humanPart4, sizeNow);

    humanPart5 = resizeImmediately(humanPart5, sizeNow);
    sizeNow = sizeNow * resize5;
    humanPart5 = resizeOverTime(humanPart5, sizeNow);
    humanPart6 = resizeImmediately(humanPart6, sizeNow);
    humanPart7 = resizeImmediately(humanPart7, sizeNow);

    % do fadein for 1st parts
    % TODO: add fade back later! there might be some bug with fading
    %humanPart1 = fadeCells(humanPart1, bgPart1, false);

    % cant test like this, since some cells dont have same sized matrices
    lastX = 150; lastY = 200;
    nextX = 150; nextY = 200;
    [merged1, lastX, lastY] = mergeCellsWithTranslation(humanPart1, bgPart1, lastX, lastY, nextX, nextY, useGaussian);

    % move human <- by half matrix size
    [h2Height_1, h2Width_1, ~] = size(humanPart2{1});
    nextX = lastX - floor(h2Width_1/2);
    nextY = lastY;
    [merged2, lastX, lastY] = mergeCellsWithTranslation(humanPart2, bgPart2, lastX, lastY, nextX, nextY, useGaussian);

    % no translation
    nextX = lastX;
    nextY = lastY;
    [merged3, lastX, lastY] = mergeCellsWithTranslation(humanPart3, bgPart3, lastX, lastY, nextX, nextY, useGaussian);

    % move human -> by whole matrix size
    [h4Height_1, h4Width_1, ~] = size(humanPart4{1});
    nextX = lastX + floor(h4Width_1/2);
    nextY = lastY;
    [merged4, lastX, lastY] = mergeCellsWithTranslation(humanPart4, bgPart4, lastX, lastY, nextX, nextY, useGaussian);

    % move human to new point
    nextX = 450;
    nextY = 450;
    [merged5, lastX, lastY] = mergeCellsWithTranslation(humanPart5, bgPart5, lastX, lastY, nextX, nextY, useGaussian);

    % move human -> by 10% of movie width
    nextX = lastX + floor(bgWidth/10);
    nextY = lastY;
    [merged6, lastX, lastY] = mergeCellsWithTranslation(humanPart6, bgPart6, lastX, lastY, nextX, nextY, useGaussian);

    % move human to center of movie
    nextX = floor(bgWidth/2);
    nextY = floor(bgHeight/2);
    [merged7, lastX, lastY] = mergeCellsWithTranslation(humanPart7, bgPart7, lastX, lastY, nextX, nextY, useGaussian);

    % move human to the right a little
    nextX = lastX + floor(bgWidth/20);
    nextY = lastY;
    [merged8, lastX, lastY] = mergeCellsWithTranslation(humanPart8, bgPart8, lastX, lastY, nextX, nextY, useGaussian);

    %videoCellsToMp4(merged1, bgVid.Framerate, 'test_output/1.mp4'); % test code
    %videoCellsToMp4(merged2, bgVid.Framerate, 'test_output/2.mp4'); % test code
    %videoCellsToMp4(merged3, bgVid.Framerate, 'test_output/3.mp4'); % test code
    %videoCellsToMp4(merged4, bgVid.Framerate, 'test_output/4.mp4'); % test code
    %videoCellsToMp4(merged5, bgVid.Framerate, 'test_output/5.mp4'); % test code
    %videoCellsToMp4(merged6, bgVid.Framerate, 'test_output/6.mp4'); % test code
    %videoCellsToMp4(merged7, bgVid.Framerate, 'test_output/7.mp4'); % test code
    %videoCellsToMp4(merged8, bgVid.Framerate, 'test_output/8.mp4'); % test code

    % append all merged together
    mergedAll = [merged1 merged2 merged3 merged4 merged5 merged6 merged7 merged8];

    videoCellsToMp4(mergedAll, bgVid.Framerate, 'test_output/all.mp4'); % test code
    % videoCellsToMp4(mergedAll, bgVid.Framerate, outputDirectory); % test code
end
