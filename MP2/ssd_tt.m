function ssd_img = ssd_tt( sample, lsample, patchsize, mask, template, source, A )
    % Initialize the ssd_img
    x_off = floor(patchsize/2);
    y_off = floor(patchsize/2);
    
    sample_size = size(sample);
    ssd_img = zeros(sample_size(1)-2*floor(patchsize/2),sample_size(2)-2*floor(patchsize/2));
    M = mask;
    T = template;
    I = sample;
    S = source;
    diff = zeros(sample_size(1)-2*x_off, sample_size(2)-2*y_off);
    
    alpha = 0.15;

    a = A;
    b = 0;
    c = 0;
    
    for i = 1:3
        b = b + 2*imfilter(I(:,:,i), M.*T(:,:,i));
        c = c + sum(sum((M.*T(:,:,i)).^2));
    end
    
    % Find the sum of squared difference between the source and the sample
    for i = 1:sample_size(1)-2*x_off
        for j = 1:sample_size(2)-2*y_off
                diff(i,j) = sum(sum((lsample(i:i+patchsize-1,j:j+patchsize-1) - S(:,:)).^2));
        end
    end
    
%     figure(1), hold off, imagesc(l_sample), axis image, colormap jet
%     figure(2), hold off, imagesc(S(:,:,2)), axis image, colormap jet
%     figure(3), hold off, imagesc(diff), axis image, colormap jet
%     pause;
    
    % Set the ssd of each pixel location
    for i = 1:sample_size(1)-2*x_off
        for j = 1:sample_size(2)-2*y_off
            ssd_img(i,j) = a(i+x_off,j+y_off) - b(i+x_off,j+y_off) + c;
            ssd_img(i,j) = ssd_img(i,j) * alpha + (1-alpha) * diff(i,j);
        end
    end
end