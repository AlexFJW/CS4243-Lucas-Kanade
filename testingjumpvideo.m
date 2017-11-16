video = VideoReader('videos/3_40_to_3_42_jumping.mp4');
frameratepersec = video.FrameRate;
video.CurrentTime = ((3*60)+40);
firstframeyouwant = ((3*60)+40)*frameratepersec;
lastframeyouwant = ((3*60)+42)*frameratepersec;
height = video.height;
width = video.width;
cMatrix = double(zeros(height,width,3));
temp = double(zeros(height,width,3));
div = 2;

for i = firstframeyouwant:lastframeyouwant
%     curr = readFrame(video);
%     imshow(curr);
    if(i==firstframeyouwant)
        cMatrix = double(readFrame(video));
    else
        curr = double(readFrame(video));
        temp = double(cMatrix);
        test = abs(((temp*(i-1))+ double(curr)));
        cMatrix = test/div;
        div=div+1;
    end
end
imshow(uint8(cMatrix));

