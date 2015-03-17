function [ result ] = quilt_simple( sample, outsize, patchsize, overlap, tol )
    % Create a canvas that is >= outsize.  It should be patchsize plus a
    % multiple of (patchsize - overlap), with an buffer on top and bottom of size overlap.
    % This result will be cropped for the final result
    
    size_x = overlap + patchsize + (patchsize-overlap)*ceil(((outsize(1)-patchsize)/(patchsize-overlap)));
    size_y = overlap + patchsize + (patchsize-overlap)*ceil(((outsize(2)-patchsize)/(patchsize-overlap)));
    
    %create the masks
    mask = ones(patchsize, patchsize);
    for i = overlap+1:patchsize
        for j = overlap+1:patchsize
            mask(i,j) = 0;
        end
    end
    mask_top = ones(patchsize, patchsize);
    mask_side = ones(patchsize, patchsize);
    for i = overlap+1:patchsize
        for j = 1:patchsize
            mask_top(j,i) = 0;
            mask_side(i,j) = 0;
        end
    end
    
    result = ones(size_x + (2 * overlap), size_y + (2 * overlap), 3);
    sample_size = size(sample);

    for i = overlap:patchsize-overlap:size_x+overlap-patchsize
        for j = overlap:patchsize-overlap:size_y+overlap-patchsize
            %create the template
            template = result(i+1:i+patchsize, j+1:j+patchsize, :);

            if(i == overlap & j == overlap)
                % find random location in sample
                patch_pos(1) = randi(sample_size(1) - patchsize);
                patch_pos(2) = randi(sample_size(2) - patchsize);

%                 patch_pos(1) = 1;
%                 patch_pos(2) = 1;
            else
                if(i == overlap)
                    M = mask_top;
                elseif(j == overlap)
                    M = mask_side;
                else
                    M = mask;
                end
                
                ssd_res = ssd_patch(sample, patchsize, M, template);
%                 figure(3), hold off, imagesc(ssd_res), axis image, colormap jet
%                 figure(4), hold off, imagesc(result), axis image, colormap jet
%                 pause;
%                 
%                 patch_pos(1) = randi(sample_size(1) - patchsize);
%                 patch_pos(2) = randi(sample_size(2) - patchsize);

                % Locate a valid patch
                patch_pos = choose_sample(ssd_res, tol);
            end
            
            % copy sample to current location
            for ii  = 1:patchsize
                for jj = 1:patchsize
                    result(i + ii, j + jj, :) = sample(patch_pos(1) + ii - 1, patch_pos(2) + jj - 1, :);
                end
            end
        end
    end
    
%     %sanity checks...
%     result_size = size(result);
%     disp(result_size);
%     
    %crop image down to specified size
    result = imcrop(result,[overlap+1 overlap+1 outsize(2) outsize(1)]);
%     
%     result_size = size(result);
%     disp(result_size);
end