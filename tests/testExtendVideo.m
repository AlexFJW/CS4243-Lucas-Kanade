% load video 1 into matrix
toExtend = VideoReader('videos/filtered/human1_3_out_100.mp4');
% this vid has about 26 frames (source: quicktime7)


% extend video 1
cells = videoToCells(toExtend);
extendedCells = extendVideo(cells, 50);

disp('Saving extended vid')

% save resized video to file
videoCellsToMp4(extendedCells, child.Framerate, 'test_output/extendTest.mp4')
