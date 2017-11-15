% load video 1 into matrix
video = VideoReader('videos/filtered/human1_3_out_100.mp4');

% resize video 1
cells = videoToCells(video);
flippedCells = horizontalFlipCells(cells);

disp('Saving flipped vid')


% save resized video to file
videoCellsToMp4(flippedCells, video.Framerate, 'test_output/horizontalFlipTest.mp4');
