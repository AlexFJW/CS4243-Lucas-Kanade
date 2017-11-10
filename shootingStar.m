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
        

        frameMatrix = averageMatrix;
        counter = counter + 1;
        weightage = weightage + 1;
    end
else
    disp('video is empty');
end

counter = 2;
video = VideoReader('videos/Bar swing FAIL.mp4');
if hasFrame(video)
    while hasFrame(video)
        currentFrame = cast(readFrame(video), 'double');
        movingObjects = abs(cast(currentFrame, 'double') - averageMatrix);
        
        if(mod(counter, 20) == 0)
            figure;
            imshow(cast(255 - abs(currentFrame-averageMatrix), 'uint8'))

        end
        counter = counter + 1;
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