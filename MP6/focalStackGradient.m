function result = focalStackGradient(imStack)
    result = imStack(:,:,:,1);
    [im_width, im_height, d, k] = size(imStack(:,:,:,:));
    
    disp(['im_width ', num2str(im_width), '  im_height ', num2str(im_height)]);
    
    for i = 2:k  
        tmp_im = imStack(:,:,:,i);
        fil1 = [-1; 1; 0];
        fil2 = [-1, 1, 0];
        % Calculate the gradient of the result
        dx1 = imfilter(result, fil1, 'symmetric');
        dy1 = imfilter(result, fil2, 'symmetric');
        % Calculate the gradient of the next image in the stack
        dx2 = imfilter(tmp_im, fil1, 'symmetric');
        dy2 = imfilter(tmp_im, fil2, 'symmetric');
        
        G1 = abs(dx1) + abs(dy1);
        G2 = abs(dx2) + abs(dy2);
        
        % Check which gradient is larger, seting the pixel at that location
        % to the pixel with the largest gradient
        for j = 1:d
            for x = 1:im_width
                for y = 1:im_height
                    if G1(x,y,j) - G2(x,y,j) < 0
                        result(x,y,j) = tmp_im(x,y,j);
                    end
                end
            end
        end
       
     end