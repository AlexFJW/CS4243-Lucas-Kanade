video = VideoReader('videos/trimmed/human1_1.mp4');

currAxes = axes;
frameMatrix = zeros(video.height, video.width, 3);
firstFrame = zeros(video.height, video.width, 3);
movingObjects = zeros(video.height, video.width, 3);

counter = 2;
weightage = 1;

if hasFrame(video)
    frameMatrix = readFrame(video);
    firstFrame = frameMatrix;
    while hasFrame(video)
        currentFrame = readFrame(video);
        currentMatrix = (double(frameMatrix) * weightage) + double(currentFrame);
        averageMatrix = currentMatrix / counter;
        movingObjects = abs(double(currentFrame) - averageMatrix);

        frameMatrix = averageMatrix;
        counter = counter + 1;
        weightage = weightage + 1;
    end
else
    disp('video is empty');
end

counter = 2;
threshold = 60;
video = VideoReader('videos/trimmed/human1_1.mp4');

outputVideo = VideoWriter('videos/filtered/human1_1_out_60.mp4', 'MPEG-4');
outputVideo.FrameRate = video.FrameRate;
open(outputVideo)

if hasFrame(video)
    while hasFrame(video)
        currentFrame = double(readFrame(video));
        diff = abs(double(currentFrame) - averageMatrix);
        
        isPixel = sum(diff,3);
        isPixel(isPixel <= threshold) = 0;
        isPixel(isPixel > threshold) = 1;
        isPixel = repmat(isPixel, [1 1 3]);

        movingObjects = currentFrame .* isPixel ;

        writeVideo(outputVideo, uint8(movingObjects));
        counter = counter + 1;
    end
else
    disp('video is empty');
end

close(outputVideo);