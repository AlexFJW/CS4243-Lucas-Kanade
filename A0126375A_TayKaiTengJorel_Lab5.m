diary on;
video = VideoReader('traffic.mp4');
length = video.Duration;
height = video.height;
width = video.width;
bitspp = video.BitsPerPixel;
format = video.VideoFormat;
rate = video.FrameRate;
frameno = ceil(rate*length);
cMatrix = double(zeros(height,width,3));
temp = double(zeros(height,width,3));
tempo = double(zeros(height,width,3));
div = 2;

for i=1:frameno
    if(i==1)
        cMatrix = double(readFrame(video));
    else
        curr = readFrame(video);
        temp = double(cMatrix);
        test = abs(((temp*(i-1))+ double(curr)));
        cMatrix = test/div;
        div=div+1;
    end
end

figH=figure;
imshow(uint8(cMatrix));
figName =  'backgroundextraction_results.jpg';
print(figH, '-djpeg', figName);

video = VideoReader('traffic.mp4');
temp = double(readFrame(video));
tempo = temp - cMatrix;
imshow(uint8(tempo));
figName =  'firstframemovingobj_results.jpg';
print(figH, '-djpeg', figName);

video = VideoReader('traffic.mp4');
for i=1:frameno
    temp = double(readFrame(video));
end
tempo = temp - cMatrix;
imshow(uint8(tempo));
figName =  'lastframemovingobj_results.jpg';
print(figH, '-djpeg', figName);
    
diary off;
