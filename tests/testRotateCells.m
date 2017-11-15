% load video 1 into matrix
toRotate = VideoReader('videos/filtered/human1_3_out_100.mp4');

cells = videoToCells(toRotate);
rotatedCells = rotateCells(cells, 90, true);

disp('Saving rotated vid')

% save resized video to file
videoCellsToMp4(rotatedCells, toRotate.Framerate, 'test_output/rotate.mp4');
