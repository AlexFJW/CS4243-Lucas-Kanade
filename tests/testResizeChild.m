% load video 1 into matrix
child = VideoReader('videos/filtered/human1_3_out_100.mp4');

% load vid 2 into matrix
parent = VideoReader('videos/trimmed/shooting_stars_galaxy.mp4');

% resize video 1
childCells = videoToCells(child);
resizedCells = resizeChild(childCells, parent.Height, parent.Width, 0.3);

disp('Saving resized vid')

% save resized video to file
videoCellsToMp4(resizedCells, child.Framerate, 'test_output/resizeTest.mp4')
