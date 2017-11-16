% load video 1 into matrix
video = VideoReader('videos/background/antman2.mp4');
% this vid has about 26 frames (source: quicktime7)

% extend video 1
cells = videoToCells(video);

squeezed = squeezeBrightnessContrastForCells(cells);

disp('Saving extended vid')

% save resized video to file
videoCellsToMp4(squeezed, video.Framerate, 'test_output/squeezeTest.mp4')
