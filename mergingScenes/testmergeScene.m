tmp = dir('videos/results/human1/*.mp4');        % retrieve .mp4 files
videolist = {tmp.name}';   % sort this list if necessary! sort(videoList) might work
mergeScene(videolist,'videos/results/shooting_star_1.mp4');

temp = dir('videos/results/human2/*.mp4');        % retrieve .mp4 files
videolist = {temp.name}';   % sort this list if necessary! sort(videoList) might work
mergeScene(videolist,'videos/results/shooting_star_2.mp4');