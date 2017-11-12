% video = VideoReader('videos/trimmed/swing_1.mp4');
video = VideoReader('videos/trimmed/jumping_new_2.mp4');
% video = VideoReader('videos/trimmed/playground.mp4');
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
        
        frameMatrix = averageMatrix;
        counter = counter + 1;
        weightage = weightage + 1;
    end
else
    disp('video is empty');
end

counter = 2;
threshold = 30;
% video = VideoReader('videos/trimmed/swing_1.mp4');
video = VideoReader('videos/trimmed/jumping_new_2.mp4');
% video = VideoReader('videos/trimmed/playground.mp4');

% outputVideo = VideoWriter('swing/swing_out_new_2_65.mp4', 'MPEG-4');
outputVideo = VideoWriter('jumping/jumping_out_new_2_30.mp4', 'MPEG-4');
% outputVideo = VideoWriter('playground/playground_40.mp4', 'MPEG-4');
outputVideo.FrameRate = video.FrameRate;
open(outputVideo)

if hasFrame(video)
    while hasFrame(video)
        currentFrame = double(readFrame(video));
        diff = abs(double(currentFrame) - averageMatrix);
        
        [x,y,z] = size(diff);
        
        for i = 1:x
            for j = 1:y
                if (sum(diff(i,j,:)) <= threshold)
                    diff(i,j,:) = 0;
                else
                    diff(i,j,:) = 1;
                end
            end
        end

        movingObjects = currentFrame .* double(diff);
        
        writeVideo(outputVideo, uint8(movingObjects));
        counter = counter + 1;
    end
else
    disp('video is empty');
end

close(outputVideo);