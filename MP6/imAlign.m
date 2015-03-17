function imStack = imAlign(imStack)
    % Align each image in imStack
    [im_width,im_height,d,k] = size(imStack(:,:,:,:));
    
%     im1 = imStack(:,:,:,1);
%     im1 = rgb2gray(im1);
%     pts1 = detectSURFFeatures(im1);
%     [features1, validPts1] = extractFeatures(im1, pts1);
    
    for i = 1:k-1   
        disp(['Aligning image #', num2str(i)]);
        
        % Compute the points of interest
        im1 = imStack(:,:,:,i);
        im2 = imStack(:,:,:,i+1);

        im1 = rgb2gray(im1);
        im2 = rgb2gray(im2);

        pts1 = detectSURFFeatures(im1);
        pts2 = detectSURFFeatures(im2);

        % Extract the feature descriptors
        [features1, validPts1] = extractFeatures(im1, pts1);
        [features2, validPts2] = extractFeatures(im2, pts2);

        % Match features with their descripters
        indexPairs = matchFeatures(features1, features2);

        % Get the corresponding points of each image
        matched1 = validPts1(indexPairs(:,1));
        matched2 = validPts2(indexPairs(:,2));

        % Calculate the Homography based off of the matching points
        [tform, inlier2, inlier1] = estimateGeometricTransform(matched2, matched1, 'similarity');
               
        outputView = imref2d(size(im2));
        im2 = imwarp(im2, tform, 'OutputView', outputView);
        imStack(:,:,:,i+1) = im2(:,:,:);
    end
    
    
    