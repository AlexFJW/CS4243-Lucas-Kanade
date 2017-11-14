function [ matrix ] = videoToMatrix( video )
    numFrames = video.FrameRate * video.Duration;
    matrix = zeros(numFrames, height, width, 3);

    counter = 1;
    if hasFrame(video)
        while hasFrame(video)
            currentFrame = readFrame(video);
            matrix(counter) = currentFrame;
            counter += 1;
        end
    end
end
