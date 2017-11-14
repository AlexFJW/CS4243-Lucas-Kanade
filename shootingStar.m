video = VideoReader('videos/Bar swing FAIL.mp4');
video.CurrentTime = 4.5; %lesser presence of ghost on the swing bars
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
        currentMatrix = (cast(frameMatrix, 'double') * weightage) ...
                        + (cast(currentFrame, 'double'));
        averageMatrix = currentMatrix / counter;
        movingObjects = abs(cast(currentFrame, 'double') - averageMatrix);
        %movingObjects = cast(currentFrame, 'double') - averageMatrix;

        %if(mod(counter, 5) == 0)
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

firstMovingImage = abs(cast(firstFrame, 'double') - frameMatrix);

figH = figure;
imshow(cast(firstFrame, 'uint8'));
figI = figure;
imshow(cast(firstMovingImage, 'uint8'));

figJ = figure;
imshow(cast(frameMatrix, 'uint8'));
figK = figure;
imshow(cast(movingObjects, 'uint8'));