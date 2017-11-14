% Function videoToCells
% converts a video (from video reader) into an array of matrices in cells
% note: cell has size of (1, N) where N is the total nubmer of frames
function [ cells ] = videoToCells( video )
    numFrames = video.FrameRate * video.Duration;
    cells = cell(1, numFrames);

    counter1 = 1;
    if hasFrame(video)
        while hasFrame(video)
            currentFrame = readFrame(video);
            cells{counter1} = currentFrame;
            counter1 = counter1 + 1;
        end
    end
end
