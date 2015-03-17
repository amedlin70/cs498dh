function [ result ] = quilt_random(sample, outsize, patchsize)
    % Create a canvas that is >= outsize, and is a multiple of patchsize.
    % This result will be cropped for the final result
    size_x = patchsize * ceil(outsize(1) / patchsize);
    size_y = patchsize * ceil(outsize(2) / patchsize);
    
    result = zeros(size_x, size_y, 3);
    sample_size = size(sample);

    for i = 1:patchsize:size_x
        for j = 1:patchsize:size_y
            % find random location in sample
            rand_x = randi(sample_size(1) - patchsize);
            rand_y = randi(sample_size(2) - patchsize);
            
            % copy random sample to current location
            for ii  = 1:patchsize
                for jj = 1:patchsize
                    result(i + ii, j + jj, :) = sample(rand_x + ii, rand_y + jj, :);
                end
            end
        end
    end
    
    result_size = size(result);
    
    %crop image down to specified size
    result = imcrop(result,[0 0 outsize(2) outsize(1)]);
    
    result_size = size(result);
end

