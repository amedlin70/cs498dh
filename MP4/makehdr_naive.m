function hdr = makehdr_naive(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    [x,y,d,k] = size(ldrs(:,:,:,:));
    hdr = zeros(x,y,d);
    
    % Normalize the images
    for kk = 1:k
        ldrs(:,:,:,kk) = ldrs(:,:,:,kk)./exposures(:,:,1,kk);
    end
    
    %Create naive HDR here
    for dd = 1:d
        for xx = 1:x
            for yy = 1:y
                for kk = 1:k
                    hdr(yy,xx,dd) = hdr(yy,xx,dd) + ldrs(yy,xx,dd,kk);
                end
                hdr(yy,xx,dd) = hdr(yy,xx,dd)/k;
            end
        end
    end
end
