% load video 1 into matrix
child = VideoReader('videos/filtered/human1_3_out_100.mp4');

% load vid 2 into matrix
parent = VideoReader('videos/background/antman2.mp4');

% fade video 1 into video 2
childCells = videoToCells(child);
parentCells = videoToCells(parent);

fadedCells = fadeCells(childCells, parentCells, false);

disp('Saving faded vid')

% save faded video to file
videoCellsToMp4(fadedCells, child.Framerate, 'test_output/fadeTestIn.mp4')
