function img = histogram_equalization(im)
% Balance histogram
[hue, sat, val] = rgb2hsv(im);
h = hist(val(:), 0:1/255:1);

c = cumsum(h);
val2 = c(uint16(val*255)+1)/numel(val);
img = hsv2rgb(hue, sat, val2*0.5+val*0.5);