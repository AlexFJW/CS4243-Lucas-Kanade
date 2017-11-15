% load video
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
hlength = human.Duration;
hrate = human.FrameRate;
hframeno = ceil(hrate*hlength);

%move pos x direction
moving = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[moving, 0]);
    moving = moving + 20;
    %imshow(move);
end

%move neg x direction
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
moving = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[moving, 0]);
    moving = moving - 20;
    %imshow(move);
end

%move pos y direction
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
moving = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[0, moving]);
    moving = moving - 20;
    %imshow(move);
end

%move neg y direction
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
moving = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[0, moving]);
    moving = moving + 20;
    %imshow(move);
end

%move diagonal direction 2 oclock
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
movingx = 0;
movingy = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[movingx, movingy]);
    movingx = movingx + 20;
    movingy = movingy - 20; 
    %imshow(move);
end

%move diagonal direction 4 oclock
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
movingx = 0;
movingy = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[movingx, movingy]);
    movingx = movingx + 20;
    movingy = movingy + 20; 
    %imshow(move);
end

%move diagonal direction 8 oclock
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
movingx = 0;
movingy = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[movingx, movingy]);
    movingx = movingx - 20;
    movingy = movingy + 20; 
    %imshow(move);
end

%move diagonal direction 10 oclock
human = VideoReader('videos/filtered/human1_3_out_100.mp4');
movingx = 0;
movingy = 0;
for i = 1:hframeno
    humany = readFrame(human);
    move = imtranslate(humany,[movingx, movingy]);
    movingx = movingx - 20;
    movingy = movingy - 20; 
    %imshow(move);
end



