function img = color_enhancement(im)
%change to hsv color space
[h, s, v] = rgb2hsv(im);

%manipulate the saturation channel to increase the color
s = s * 1.3;

%change back to rgb color space
img = hsv2rgb(h, s, v);
figure(1), imshow(im);
figure(2), imshow(img);
pause;