function img = less_yellow(im)
[L, A, B] = rgb2lab(im);

B = B-32;

img = lab2rgb(L, A, B);