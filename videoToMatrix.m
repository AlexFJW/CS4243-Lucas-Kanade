function [ matrix ] = videoToMatrix( video )
    numFrames = video.FrameRate * video.Duration;
    matrix = zeros(uint8(numFrames), video.Height, video.Width, 3);

    counter1 = 1;
    if hasFrame(video)
        while hasFrame(video)
            currentFrame = readFrame(video);
            matrix(counter1,:,:,:) = currentFrame;
            counter1 = counter1 + 1;
        end
    end
end
