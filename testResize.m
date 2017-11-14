% load video 1 into matrix
child = VideoReader('/human/human1/human1_3_out_100.mp4')

% load vid 2 into matrix
parent = VideoReader('/videos/shooting_stars.mp4')

% resize video 1
childMatrix = videoToMatrix(child);
parentMatrix = videoToMatrix(parent);
outputMatrix = resizeAsChild(childMatrix, parentMatrix, 0.3);

% save video 1 to file
outputVideo = 
