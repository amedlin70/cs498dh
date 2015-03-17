function [im12] = hybridImage(im1, im2, cutoff_low, cutoff_high)
%Display fourier transform of the original images
figure(1), hold off, imagesc(im1), axis off, colormap gray, axis image
figure(2), hold off, imagesc(log(abs(fftshift(fft2(im1))))), axis off, colormap jet, axis image
title('fft im1');
pause;
imagesc(log(abs(fftshift(fft2(im2)))));
figure(1), hold off, imagesc(im2), axis off, colormap gray, axis image
figure(2), hold off, imagesc(log(abs(fftshift(fft2(im2))))), axis off, colormap jet, axis image
title('fft im2');
pause;

%Remove low frequencies from im2
fil = fspecial('gaussian', [30,1], 5);
imHigh = imfilter(im2, fil);
imHigh = imfilter(imHigh, fil');
imHigh = im2 - imHigh;
figure(1), hold off, imagesc(imHigh), axis off, colormap gray, axis image
title('imHigh');
figure(2), hold off, imagesc(log(abs(fftshift(fft2(imHigh))))), axis off, colormap jet, axis image
title('fft im1 High Frequency');
pause;

%Remove high frequencies from im1
imLow = imfilter(im1, fil);
imLow = imfilter(imLow, fil');
figure(1), hold off, imagesc(imLow), axis off, colormap gray, axis image
title('imLow');
figure(2), hold off, imagesc(log(abs(fftshift(fft2(imLow))))), axis off, colormap jet, axis image
title('fft im2 gaussian');
pause;

%Combine the images into im12
im12 = (imLow/2) + (imHigh/2);
figure(1), hold off, imagesc(im12), axis off, colormap gray, axis image
title('im12');
figure(2), hold off, imagesc(log(abs(fftshift(fft2(im12))))), axis off, colormap jet, axis image
title('fft im12');
pause;