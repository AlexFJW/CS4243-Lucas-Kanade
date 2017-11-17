function [] = mergeScene(videolist,destination)
    outputVideo = VideoWriter(destination, 'MPEG-4');
    open(outputVideo);
    for i = 1:2
        inputVideo = VideoReader(videolist{i});
        while hasFrame(inputVideo)
            writeVideo(outputVideo, readFrame(inputVideo));
        end
    end
    close(outputVideo);
end