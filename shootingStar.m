%video = VideoReader('videos/3_40_to_3_42_jumping.mp4');
video = VideoReader('videos/Bar swing FAIL.mp4');
%video.CurrentTime = 219.5; %lesser presence of ghost on the swing bars
video.CurrentTime = 4;
%video = VideoReader('videos/traffic.mp4');

currAxes = axes;
frameMatrix = zeros(video.height, video.width, 3);
firstFrame = zeros(video.height, video.width, 3);
movingObjects = zeros(video.height, video.width, 3);

counter = 2;
weightage = 1;

%if video.CurrentTime < 221.5
    if hasFrame(video)
        frameMatrix = readFrame(video);
        firstFrame = frameMatrix;
        while hasFrame(video)
            currentFrame = readFrame(video);
            currentMatrix = (cast(frameMatrix, 'double') * weightage) ...
                            + (cast(currentFrame, 'double'));
            averageMatrix = currentMatrix / counter;
            movingObjects = abs(cast(currentFrame, 'double') - averageMatrix);

            %if(mod(counter, 20) == 0)
            %    figure;
            %    imshow(cast(movingObjects, 'uint8'));
            %end
            frameMatrix = averageMatrix;
            counter = counter + 1;
            weightage = weightage + 1;
        end
    else
        disp('video is empty');
    end
%end

backgroundMatrix = frameMatrix;

video.CurrentTime = 4;
    if hasFrame(video)
        frameMatrix = readFrame(video);
        firstFrame = frameMatrix;
        while hasFrame(video)
            currentFrame = readFrame(video);
            currentMatrix = (cast(frameMatrix, 'double') * weightage) ...
                            + (cast(currentFrame, 'double'));
            averageMatrix = currentMatrix / counter;
            movingObjects = abs(cast(currentFrame, 'double') - backgroundMatrix);

            %if(mod(counter, 20) == 0)
            %    figure;
            %    imshow(cast(movingObjects, 'uint8'));
            %end
            frameMatrix = averageMatrix;
            counter = counter + 1;
            weightage = weightage + 1;
        end
    else
        disp('video is empty');
    end
    
firstMovingImage = abs(cast(firstFrame, 'double') - backgroundMatrix);

figH = figure;
title('firstFrame');
imshow(cast(firstFrame, 'uint8'));

figI = figure;
title('firstMovingImage');
imshow(cast(firstMovingImage, 'uint8'));

figJ = figure;
title('frameMatrix');
imshow(cast(frameMatrix, 'uint8'));

figK = figure;
title('MovingObjects');
imshow(cast(movingObjects, 'uint8'));

figL = figure;
title('Background');
imshow(cast(backgroundMatrix, 'uint8'));
