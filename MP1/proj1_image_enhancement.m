%load images
im1 = im2double(imread('./bird4.jpg'));
im2 = imread('./flower1.jpg');
im3 = imread('./fireworks.jpg');

%Contrast Enhancement
img1 = histogram_equalization(im1);
figure(1), imshow([im1 img1]);
pause;

%Color Enhancement
img2 = color_enhancement(im2);

%Color Shift
img3 = less_yellow(im3);
img4 = more_red(im3);

figure(1), imshow([im3 img3 img4]);
pause;