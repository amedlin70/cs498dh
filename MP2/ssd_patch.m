function ssd_img = ssd_patch( sample, patchsize, mask, template )
    % Initialize the ssd_img
    sample_size = size(sample);
    ssd_img = zeros(sample_size(1)-2*floor(patchsize/2),sample_size(2)-2*floor(patchsize/2));
    M = mask;
    T = template;
    I = sample;

    a = imfilter(I(:,:,1).^2, M);           
    b = 2*imfilter(I(:,:,1), M.*T(:,:,1));
    c = sum(sum((M.*T(:,:,1)).^2));
    
    for i = 2:3
        a = a + imfilter(I(:,:,i).^2, M);           
        b = b + 2*imfilter(I(:,:,i), M.*T(:,:,i));
        c = c + sum(sum((M.*T(:,:,i)).^2));
    end
    
    %loop through all valid pixels, setting the ssd for each portion of the
    %sample
    x_off = floor(patchsize/2);
    y_off = floor(patchsize/2);
    
    for i = 1:sample_size(1)-2*x_off
        for j = 1:sample_size(2)-2*y_off
            ssd_img(i, j) = a(i+x_off,j+y_off) - b(i+x_off,j+y_off) + c;
        end
    end
end