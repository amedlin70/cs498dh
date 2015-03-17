function mergedImage = stitchPlanar(im1, im2, H)
    
    % create x and y
    [x, y, z] = size(im2);

%     %find max x position
%     tmp1 = (H * [x, 1, 1]');
%     tmp1 = tmp1 / tmp1(3);
%     
%     tmp2 = (H * [x, y, 1]');
%     tmp2 = tmp2 / tmp2(3);
%     
%     max_x = max(tmp1(1), tmp2(1));
%     display(max_x, 'max_x');
    
    im2b = zeros(x,y*2,3);
    im1b = zeros(x,y*2,3);
    mask = zeros(x,y*2,1);
    for i = 1:3
        for j = 1:x
            for k = 1:y
                im1b(j,k,i) = im1(j,k,i);
                im2b(j,k,i) = im2(j,k,i);
            end
        end
    end
    
    for j = 1:x
        for k = 1:y
            mask(j,k) = 1;
        end
    end
    
    figure(4), hold off, imagesc(im2b), axis image;
    
    % Calculate xi and yi, the result of multiplying by H
    [X, Y] = meshgrid(1:y*2,1:x);

    for i = 1:x
        for j = 1:y*2
            tmp = (H * [X(i,j), Y(i,j), 1]');
            tmp = tmp / tmp(3);
            Xi(i,j) = tmp(1);
            Yi(i,j) = tmp(2);
        end
    end
    
    display('400, 400');
    display([Xi(400,400), Yi(400,400)]);
    
    % Call interp on the second image
    %im2w = zeros(2*x, 2*y, 3);
    for i = 1:3
        im2w(:,:,i) = interp2(X, Y, im2b(:,:,i), Xi, Yi);
    end
    mask2 = interp2(X,Y,mask(:,:,1),Xi,Yi);    
    
    figure(3), hold off, imagesc(im2w), axis image;

    mid_y = floor(y/2);
    
    for i = 1:3
        for j = 1:x
            for k = mid_y:y*2
                if mask2(j,k,1) == 1
                    if k < y
                        blend_percent = 1 - ((k - mid_y)/mid_y);
                        im1b(j,k,i) = blend_percent * im1b(j,k,i) + (1-blend_percent) * im2w(j,k,i);
                    else
                        im1b(j,k,i) = im2w(j,k,i);
                    end
                end
            end
        end
    end
    mergedImage = im1b;
    % project im2 onto new image plane using H
    
    