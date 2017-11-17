
createScene6('videos/filtered/human1_3_out_100.mp4', ... %human video directory
            0.45, ... %childToParentRatio
            false, ...%horizontalFlipHuman
            -90, ... %rotationDegree 
            -70, ...  %xOffset
            -195, ... %yOffset
            100, ... %travelling right displacement. Because human1 and human 2 move differently
            200, ... %travelling down displacement. Because human1 and human2 move differently
            5, ...    %startFrame 
            8, ...    %endFrame
            'videos/results/human1/h1scene6.mp4', ... %outputDirectory
            false)    %blurOverlayEdges
createScene6('videos/filtered/swing_out_trimmed_t55_s28_e36_clean.mp4', ... %human video directory
             0.45, ... %childToParentRatio
             false, ...%horizontalFlipHuman
             -60, ...  %rotationDegree %originally
             50, ...   %xOffset
             100, ...  %yOffset
             15, ...   %travelling right displacement. Because human1 and human 2 move differently
             0, ...    %travelling down displacement. Because human1 and human2 move differently
             2, ...    %startFrame 
             3, ...    %endFrame
             'videos/results/human2/h2scene6.mp4', ... %outputDirectory
             false)    %blurOverlayEdges
