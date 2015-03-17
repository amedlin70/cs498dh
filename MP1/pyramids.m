function pyramids(im12, N)
curIm = im12;
%outIm = im12;
scale = 0.5;
[h, w] = size(curIm);

fil = fspecial('gaussian', [12,12], 2);

blur = imfilter(curIm, fil);
lap = curIm - blur;
curIm = imresize(curIm, scale, 'bilinear');
outIm = cat(1, blur, lap);

for i = 1:N-1
    %blur image
    blur = imfilter(curIm, fil);
    %subtract
    lap = curIm - blur;
    %downsize image
    curIm = imresize(curIm, scale, 'bilinear');

    %add gausian blur and laplaccian to the output image
    tmp = cat(1, imresize(blur, [h, w]), imresize(lap, [h w]));
    outIm = cat(2, outIm, tmp);
end

imshow(mat2gray(outIm));
imsave();
