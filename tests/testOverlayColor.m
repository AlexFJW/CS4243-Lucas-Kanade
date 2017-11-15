% load video 1 into matrix
child = VideoReader('videos/filtered/human1_3_out_100.mp4');

% fade video 1 into video 2
childCells = videoToCells(child);

coloredCells = overlayColor(childCells, [255 0 0], 0.8);

disp('Saving colored vid')

% save faded video to file
videoCellsToMp4(coloredCells, child.Framerate, 'test_output/coloredCells_0.8.mp4')
