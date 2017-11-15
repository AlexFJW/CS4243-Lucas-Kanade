human = VideoReader('videos/filtered/swing_out_trimmed_t55_s28_e36.mp4');
length = human.Duration;
rate = human.FrameRate;
frameno = ceil(rate*length);
startingposx = 500;
startingposy = -400;

writer = VideoWriter('swingermove');
writer.FrameRate = hrate;
open(writer);

for i = 1:frameno
    humany = readFrame(human);
    move = imtranslate(humany,[startingposx, startingposy]);
    startingposx = startingposx - 20;
    startingposy = startingposy + 20;
    writeVideo(writer,move);
end

close(writer);

mergingVideo('swingermove.avi','videos/background/galaxy.mp4');

