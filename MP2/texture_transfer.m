function [ result ] = texture_transfer( sample, patchsize, overlap, tol, source )
    % Create a canvas that is >= outsize.  It should be patchsize plus a
    % multiple of (patchsize - overlap), with an buffer on top and bottom of size overlap.
    % This result will be cropped for the final result
    
    outsize = size(source);
    lsource = zeros(outsize(1)+patchsize, outsize(2)+patchsize);
    
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
    
    % Calculate a = a + imfilter(sample(:,:,i).^2, M); for each of the masks
    a1 = 0;
    a2 = 0;
    a3 = 0;
    for i = 1:3
        a1 = a1 + imfilter(sample(:,:,i).^2,mask_side);  
        a2 = a2 + imfilter(sample(:,:,i).^2,mask_top);
        a3 = a3 + imfilter(sample(:,:,i).^2, mask);
    end
    
    result = ones(size_x + (2 * overlap), size_y + (2 * overlap), 3);
    sample_size = size(sample);
    
    % Create the luminance table for the sample and the source
    lsample = zeros(sample_size(1), sample_size(2));
    for i = 1:sample_size(1)
        for j = 1:sample_size(2)
            lsample(i,j) = (2*sample(i,j,1)+sample(i,j,2)+3*sample(i,j,3))/6;
        end
    end
    for i = 1:outsize(1)
        for j = 1:outsize(2)
            lsource(i,j) = (2*source(i,j,1)+source(i,j,2)+3*source(i,j,3))/6;
        end
    end

    for i = overlap:patchsize-overlap:size_x+overlap-patchsize
        for j = overlap:patchsize-overlap:size_y+overlap-patchsize
            %create the template
            template = result(i+1:i+patchsize, j+1:j+patchsize, :);
            
            %create the source
            S = lsource(i+1:i+patchsize, j+1:j+patchsize);

            if(i == overlap & j == overlap)
                % find first patch
                M = zeros(patchsize, patchsize);
                A = zeros(sample_size(1), sample_size(2));
                ssd_res = ssd_tt(sample, lsample, patchsize, M, template, S, A);
                
                % set the cut_mask to all ones so that all pixels are
                % copied
                cut_mask = ones(patchsize, patchsize);
                patch_pos = choose_sample(ssd_res, tol);
                cut_mask(:,1) = 1;
            else
                if(i == overlap)
                    M = mask_top;
                    A = a1;
                elseif(j == overlap)
                    M = mask_side;
                    A = a2;
                else
                    M = mask;
                    A = a3;
                end
                
                ssd_res = ssd_tt(sample, lsample, patchsize, M, template, S, A);

                % Locate a valid patch
                patch_pos = choose_sample(ssd_res, tol);
                
                %Set up seam find
                patch = sample(patch_pos(1):patch_pos(1)+patchsize - 1, patch_pos(2):patch_pos(2)+patchsize - 1, :);
                cut_mask = cut(M, template, patch, overlap, patchsize);
            end
            
            % copy sample to current location
            for ii  = 1:patchsize
                for jj = 1:patchsize
                    if(cut_mask(ii,jj) == 1)
                       result(i + ii, j + jj, :) = sample(patch_pos(1) + ii - 1, patch_pos(2) + jj - 1, :);
                    end
                end
            end
        end
        figure(1), imshow(result);
    end

    result = imcrop(result,[overlap+1 overlap+1 outsize(2) outsize(1)]);
end