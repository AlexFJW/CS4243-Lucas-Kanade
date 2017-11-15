% load video 1 into matrix
child = VideoReader('human/human1/human1_3_out_100.mp4');

% load vid 2 into matrix
parent = VideoReader('videos/shooting_stars.mp4');

% resize video 1
childCells = videoToCells(child);
resizedCells = resizeChild(childCells, parent.Height, parent.Width, 0.3);

disp('Saving resized vid')

% save resized video to file
outputVideo = VideoWriter('test_output/resizeTest.mp4', 'MPEG-4');
outputVideo.FrameRate = child.FrameRate;
open(outputVideo);

[~, numFrames] = size(resizedCells);
for i = 1 : numFrames
    currentFrame = resizedCells{i};
    writeVideo(outputVideo, currentFrame);
end

close(outputVideo);
