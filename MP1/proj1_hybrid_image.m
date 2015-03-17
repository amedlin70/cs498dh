%load images
im1 = im2single(imread('./flower1.jpg'));
im2 = im2single(imread('./spider3.jpg'));

%convert images to grayscal
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

%align images
[im2, im1] = align_images(im2, im1);

%choose the cutoff frequencies and compute the hybrid image
arbitrary_value = 100;
cutoff_low = arbitrary_value;
cutoff_high = arbitrary_value;
im12 = hybridImage(im1, im2, cutoff_low, cutoff_high);

% %Crop resulting image
figure(1), hold off, imagesc(im12), axis image, colormap gray 
disp('input crop points');
[x, y] = ginput(2);
x = round(x);
y = round(y);
im12 = im12(min(y):max(y), min(x):max(x), :);
figure(1), hold off, imagesc(im12), axis image, colormap gray
pause;

%Compute and display the Gaussian and Laplacian Pyramids
N =5;
pyramids(im12, N);


