function img = more_red(im)
[L, A, B] = rgb2lab(im);

A = A+30;

img = lab2rgb(L, A, B);