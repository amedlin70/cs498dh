% Load in the images

imStack1 =  im2double(imread('./images/circuit1/circuit1_1.jpg')); 
imStack2 =  im2double(imread('./images/circuit1/circuit1_2.jpg')); 
imStack3 =  im2double(imread('./images/circuit1/circuit1_3.jpg')); 
imStack4 =  im2double(imread('./images/circuit1/circuit1_4.jpg')); 
imStack = cat(4, imStack1, imStack2, imStack3, imStack4);


% imStack = cat(4, imStack1, imStack2);
region_size = 25;
beta = 1;
% Align the images to the first image
imStack = imAlign(imStack);

% Create the full depth of field image
result_gradient = focalStackGradient(imStack);
result_majority = focalStackMajority(imStack, region_size, beta);
result_HvS = focalStack(imStack, region_size, beta);

% Display and save the new image
figure(1), imshow(result_gradient)
figure(2), imshow(result_majority)
figure(3), imshow(result_HvS)

imwrite(result_gradient, 'result_gradient.jpg');
imwrite(result_majority, 'result_majority.jpg');
imwrite(result_HvS, 'result_HvS.jpg');

