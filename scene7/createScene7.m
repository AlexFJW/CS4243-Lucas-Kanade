% creates scene 7 in sceneVideos directory
% horizontal flip human => bool,
function [] = createScene7(humanVideoDirectory, flipHuman, outputDirectory)
    % load bg video cells
    bgVid = VideoReader('videos/background/antman2.mp4');
    bgCells = videoToCells(bgVid);
    [~, totalNumFrames] = size(bgCells);

    % convert human video to cells
    humanVid = VideoReader(humanVideoDirectory);
    humanCells = videoToCells(humanVid);

    % extend human vid
    humanCells = extendVideo(humanCells, totalNumFrames);
    % flip if needed
    if (flipHuman)
        humanCells = horizontalFlipCells(humanCells);
    end

    % split human video into parts, by frames.
    % should have 8 parts

    % do enlarge operation on parts requiring it
    % 1, enlarge by 1.2x
    % 3, enlarge by 3


    % TODO: write fn for cross fade, fade in

    % TODO: write fn for overlayWithTranslation

end
