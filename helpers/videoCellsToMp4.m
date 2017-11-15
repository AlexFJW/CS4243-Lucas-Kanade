% Function videoCellsToMp4
% saves video cells into a video file

% params videoCells: cells, each containing a frame in matrix form
% params frameRate: framerate of destination video
% params destination: string, destination location. include '.mp4' extension
function videoCellsToMp4(videoCells, frameRate, destination)
    disp('Saving vid')
    outputVideo = VideoWriter(destination, 'MPEG-4');
    outputVideo.FrameRate = frameRate;
    open(outputVideo);

    [~, numFrames] = size(videoCells);
    for i = 1 : numFrames
        currentFrame = videoCells{i};
        writeVideo(outputVideo, currentFrame);
    end

    close(outputVideo);
end
