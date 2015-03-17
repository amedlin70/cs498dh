function result = focalStack(imStack, region_size, beta)
    result = imStack(:,:,:,1);
    [im_width, im_height, d, k] = size(imStack(:,:,:,:));
    
    disp(['im_width ', num2str(im_width), '  im_height ', num2str(im_height)]);
    
    for i = 2:k  
        tmp_im = imStack(:,:,:,i);
        fil1 = [-1;1;0];
        fil2 = [-1, 1, 0];
        % Calculate the gradient of the result
        dx1 = imfilter(result, fil1, 'symmetric');
        dy1 = imfilter(result, fil2, 'symmetric');
        % Calculate the gradient of the next image in the stack
        dx2 = imfilter(tmp_im, fil1, 'symmetric');
        dy2 = imfilter(tmp_im, fil2, 'symmetric');
        
        G1 = abs(dx1) + abs(dy1);
        G2 = abs(dx2) + abs(dy2);
        
        M = G1 - G2;
        fil3 = ones(region_size, region_size);
        M_tilde = imfilter(M, fil3, 'symmetric');
                
        % Compute the decision map M_hat
        M_hat = zeros(im_width, im_height, d);
        for j = 1:d
            for x = 1:im_width
                for y = 1:im_height
                    M_hat(x,y,j) = 1/(1 + exp(- beta * M_tilde(x,y,j)));
                end
            end
        end
        
        % Smooth the decision map
        fil4 = fspecial('gaussian', [30,1], 5);
        M_hat = imfilter(M_hat, fil4, 'symmetric');
        M_hat = imfilter(M_hat, fil4', 'symmetric');
        
        % Copy the infocus area into the result
        for j = 1:d
            for x = 1:im_width
                for y = 1:im_height
                    result(x,y,j) = M_hat(x,y,j)*result(x,y,j) + (1 - M_hat(x,y,j)) * tmp_im(x,y,j);
                end
            end
        end
       
     end