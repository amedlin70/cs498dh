% Set up some variables
sample = im2single(imread('./samples/_MG_0611.jpg'));    
outsize = [400, 400];      % size of the output image
patchsize = 35;   % size of the sample being patched
overlap = ceil(patchsize/6);           % size in pixels of the overlap in x direction
tol = .01;          % Tolerance
sample2 = im2single(imread('./samples/_MG_1963.jpg'));
source = im2single(imread('./samples/andy3.jpg'));

% % Part 1: Randomly Sampled Texture
% random_result = quilt_random(sample, outsize, patchsize);
% figure(1), imshow(sample);
% figure(2), imshow(random_result);
% 
% 
% % Part 2: Overlapping Patches
% simple_result = quilt_simple(sample, outsize, patchsize, overlap, tol);
% figure(3), imshow(simple_result);
% 
% 
% % Part 3: Seam Finding
% cut_result = quilt_cut(sample, outsize, patchsize, overlap, tol);
% figure(4), imshow(cut_result);


% % Part 4: Texture Transfer
tt_result = texture_transfer(sample2, patchsize, overlap, tol, source);
figure(5), imshow(tt_result);


% Bells and Whistles

% Toast
% overlap = 35;
% toast = im2single(imread('./samples/toast.jpg'));
% inner_toast = im2single(imread('./samples/toast_result2.jpg'));
% toast_result = alpha_blend(toast, inner_toast, overlap);
% figure(6), imshow(toast_result);