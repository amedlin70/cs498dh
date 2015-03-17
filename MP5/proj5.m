USER_STITCH = true;
AUTO_STITCH = false;

% load images
im1 = im2double(imread('./website/laptop1.JPG'));
im2 = im2double(imread('./website/laptop2.JPG'));

% figure(1), imshow(im1)
% figure(2), imshow(im2)

if USER_STITCH
    mergedImage = userstitch(im1, im2);
    figure(5), hold off, imagesc(mergedImage), axis image;
    imwrite(mergedImage, 'mergedImage3.jpg');
end

if AUTO_STITCH
    mergedImage = autostitch(im1, im2);
    figure(5), hold off, imagesc(mergedImage), axis image;
    imwrite(mergedImage, 'autoMergedImage.jpg');
end