cd('jorelvideo/human1');
tmp = dir('*.mp4');        % all .avi video clips
videolist = {tmp.name}';   % sort this list if necessary! sort(videoList) might work

mergeScene(videolist,'mergeAll.mp4');