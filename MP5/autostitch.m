function mergedImage  = autostitch(im1, im2)
    im1bw = rgb2gray(im1);
    im2bw = rgb2gray(im2);

%     % Find interest points
    [f1, d1] = sift(im1bw);
    [f2, d2] = sift(im2bw);

    display(d1, 'd1');
%     % Get x and y from the sift descriptors
%     x1 = 
%     y1 = 
%     
%     x2 = 
%     y2 = 
%     
%     [H, matches] = computeHomography_RANSAC(x1, y1, x2, y2);
%     
%     plotmatches(im1, im2, f1, f2, matches);
%     
%     mergedImage = stitchPlanar(im1, im2, H);
    mergedImage = im1;