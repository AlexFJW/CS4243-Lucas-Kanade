video = VideoReader('3_40_to_3_42.mp4');
frameratepersec = video.FrameRate;
video.CurrentTime = ((3*60)+40);
firstframeyouwant = ((3*60)+40)*frameratepersec;
lastframeyouwant = ((3*60)+42)*frameratepersec;
for i = firstframeyouwant:lastframeyouwant
     curr = readFrame(video);
     imshow(curr);
 end



