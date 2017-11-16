% load video 1 into matrix
video = VideoReader('videos/filtered/human1_3_out_100.mp4');

resizeAmount = 2;
% resize video 1
cells = videoToCells(video);
resizedCells = resizeOverTime(cells, resizeAmount);

% not all frames are the same size, pad all to same size as frame 1.
% code below works only if resize is smaller or eq 1.
[frame1Height, frame1Width, channels] = size(resizedCells{end});
[~, numFrames] = size(cells);

% check size of last frame
lastResizedFrame = resizedCells{numFrames};
[lastHeight, lastWidth, ~]  = size(lastResizedFrame);

for i = 1:numFrames
    currentFrame = resizedCells{i};
    [currentHeight, currentWidth, ~] = size(currentFrame);

    heightToPad = abs(frame1Height - currentHeight);
    widthToPad = abs(frame1Width - currentWidth);

    paddedFrame = padarray(currentFrame, ...
                            [heightToPad widthToPad], ...
                            0,'pre');
    resizedCells{i} = paddedFrame;
end

disp('Saving resized vid')
% save resized video to file
videoCellsToMp4(resizedCells, video.Framerate, 'test_output/resizeOverTime.mp4')
