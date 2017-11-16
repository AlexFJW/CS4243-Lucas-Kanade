% insert human cells
video = VideoReader('videos/filtered/human1_3_out_100.mp4');
humanCells = videoToCells(video);

% insert bg cells
bg = VideoReader('videos/trimmed/shooting_stars_galaxy.mp4');

bgCells = videoToCells(bg);
% rescale to human to 30% of bg
[bgHeight, bgWidth, ~] = size(bgCells{1});
humanCells = resizeChild(humanCells, bgHeight, bgWidth, 0.3);

[~, numBgFrames] = size(bgCells);
% extend to same video length
humanCells = extendVideo(humanCells, numBgFrames);

% move from left to right
% start = (0, midY) x,y
% end = (endX, midY) x,y
midY = floor(bgHeight/2);
merged =  mergeCellsWithTranslation(humanCells, bgCells, 0, midY, bgWidth, midY);

videoCellsToMp4(merged, video.Framerate, 'test_output/mergedWithTranslateTest.mp4');
