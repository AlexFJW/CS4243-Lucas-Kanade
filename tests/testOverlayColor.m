% load video 1 into matrix
child = VideoReader('videos/filtered/human1_3_out_100.mp4');
bg = VideoReader('videos/background/antman2.mp4');

% fade video 1 into video 2
childCells = videoToCells(child);
bgCells = videoToCells(bg);

[~, numBgFrames] = size(bgCells);

[bgHeight, bgWidth, ~] = size(bgCells{1});

% extend to same video length
coloredCells = extendVideo(childCells, numBgFrames);
coloredCells = overlayColor(coloredCells, [255 0 0], 0.8);

disp('Saving colored vid')

merged =  mergeCellsWithTranslation(coloredCells, bgCells, 0, 0, bgWidth, 0);

% save faded video to file
videoCellsToMp4(merged, child.Framerate, 'test_output/coloredCells_0.8.mp4')
