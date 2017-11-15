function [] = mergingVideo(humanVideoPath, bgVideoPath)
    bg = VideoReader(bgVideoPath);
    length = bg.Duration;
    height = bg.height;
    width = bg.width;
    bitspp = bg.BitsPerPixel;
    format = bg.VideoFormat;
    rate = bg.FrameRate;
    frameno = ceil(rate*length);

    human = VideoReader(humanVideoPath);
    hlength = human.Duration;
    hheight = human.height;
    hwidth = human.width;
    hbitspp = human.BitsPerPixel;
    hformat = human.VideoFormat;
    hrate = human.FrameRate;
    hframeno = ceil(hrate*hlength);
    
    writer = VideoWriter('meger');
    writer.FrameRate = hrate;
    open(writer);

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
        writeVideo(writer,humany);
    end
    close(writer);
end
