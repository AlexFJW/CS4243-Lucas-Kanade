video = VideoReader('videos/3_40_to_3_42_jumping.mp4');

disp('Length:');
video.Duration

disp('Height:');
video.Height

disp('Width');
video.Width

disp('Bits per pixel');
video.BitsPerPixel

disp('Video format:');
video.VideoFormat

disp('Frame rate:');
video.FrameRate

% Apply running average over the frames %
avg = read(video,1);

frames = video.NumberOfFrames;

threshold = 40;

for i = 2 : frames
    frame = read(video,i);
    avg = ((i-1)/i).*avg + (1/i).*frame;
end

movingFirst = abs(double(read(video,1))-double(avg));
movingFirst(movingFirst <= threshold) = 0;
movingFirst = uint8(movingFirst);

movingLast = abs(double(read(video,frames))-double(avg));
movingLast(movingLast <= threshold) = 0;
movingLast = uint8(movingLast);

figH = figure;

subplot(2,2,1), imshow(avg, [0 255]);
title('background image');

subplot(2,2,2), imshow(movingFirst, [0 255]);
title('moving objects in first frame');

subplot(2,2,3), imshow(movingLast, [0 255]);
title('moving objects in last frame');

figName = 'lab5.jpg';

print(figH, '-djpeg', figName);
