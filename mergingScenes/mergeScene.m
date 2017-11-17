function [] = mergeScene(vlist,destination)
    outputVideo = VideoWriter(destination, 'MPEG-4');
    open(outputVideo);
    for i = 1:size(vlist)
        inputVideo = VideoReader(vlist{i});
        while hasFrame(inputVideo)
            writeVideo(outputVideo, readFrame(inputVideo));
        end
    end
    close(outputVideo);
end