function [] = mergingVideo(humanVideoPath, bgVideoPath)
    bg = VideoReader(bgVideoPath);

    human = VideoReader(humanVideoPath);
    hlength = human.Duration;
    hrate = human.FrameRate;
    hframeno = ceil(hrate*hlength);

    for i = 1:hframeno
        background = readFrame(bg);
        humany = readFrame(human);
        [Ny, Nx, Nz] = size(humany);
        dSize = Ny*Nx;
        % Get the location of the black pixels:
        bR = humany(:,:,1) == 0;
        bG = humany(:,:,2) == 0;
        bB = humany(:,:,3) == 0;
        blackPixels = find(bR & bG & bB);
        humany(blackPixels) = background(blackPixels);
        humany(blackPixels + dSize) = background(blackPixels+dSize);
        humany(blackPixels + 2*dSize) = background(blackPixels+dSize*2);
    end
end
