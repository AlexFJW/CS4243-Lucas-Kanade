% load video 1 into matrix
video = VideoReader('videos/filtered/human1_3_out_100.mp4');

% resize video 1
cells = videoToCells(video);
resizedCells = resizeImmediately(cells, 0.3);

disp('Saving resized vid')

% save resized video to file
videoCellsToMp4(resizedCells, video.Framerate, 'test_output/resizeImmediately.mp4')
