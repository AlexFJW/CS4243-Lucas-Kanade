function [ rsImg ] = colorHistEq( img )
    % Convert rgb image to hsv 
    hsv = rgb2hsv(img);
    % Perform histogram equalization on image intensity
    eq = histeq(hsv(:,:,3));
    rs = hsv;
    rs(:,:,3) = eq;
    rsImg = hsv2rgb(rs);
    imshow(rsImg)
end

