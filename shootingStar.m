video = VideoReader('videos/trimmed/human6.mp4');
% video = VideoReader('videos/trimmed/jumping_bg.mp4');
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
threshold = 90;
video = VideoReader('videos/trimmed/human6.mp4');
% video = VideoReader('videos/trimmed/jumping_new.mp4');
% video = VideoReader('videos/trimmed/playground.mp4');

outputVideo = VideoWriter('human/human6_out_90.mp4', 'MPEG-4');
% outputVideo = VideoWriter('jumping/jumping_out_bg_50.mp4', 'MPEG-4');
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
%         figure;
%         pic = imshow(uint8(movingObjects));

        % using frame 23 to 39 for swing_bg.mp4 %
%         if (counter >= 23 && counter <= 34)
            writeVideo(outputVideo, uint8(movingObjects));
%         end
        counter = counter + 1;
    end
else
    disp('video is empty');
end

close(outputVideo);