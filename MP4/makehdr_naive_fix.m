function hdr = makehdr_naive_fix(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light
    
    [x,y,d,k] = size(ldrs(:,:,:,:));
    hdr = zeros(x,y,d);
    
    % Create a mask for the high and low pixels, -1 is low, 1 is high
    mask = zeros(x,y,d);
    
    % Normalize the images
    ldrs_scaled = zeros(x,y,d,k);
    for kk = 1:k
        ldrs_scaled(:,:,:,kk) = ldrs(:,:,:,kk)./exposures(:,:,1,kk);
    end
    
    % Weight function
    w = @(z) double(128-abs(z-128));
    
    %Create fixed naive HDR here
    for dd = 1:d
        for xx = 1:x
            for yy = 1:y
                weight = 0;
                for kk = 1:k
                    v = ldrs(yy,xx,dd,kk);
                    weight = weight + w(floor(v));
                    hdr(yy,xx,dd) = hdr(yy,xx,dd) + w(v)*ldrs_scaled(yy,xx,dd,kk);
                end
                
                % if the weight is very low, this means that that pixel is over or under exposed in every picture
                % so we replace that pixel with either the max or min value
                if weight <= 0.5*k    
                    if ldrs(yy,xx,dd,1) < 128 
                        mask(yy,xx,dd) = -1;
                        display('out of range: low');
                    else
                        mask(yy,xx,dd) = 1;
                        display('out of range: high');
                    end
                end
                
                hdr(yy,xx,dd) = hdr(yy,xx,dd)/weight;
            end
        end
    end
    
    mn = min(min(min(hdr)));
    mx = max(max(max(hdr)));    
    
    % Replace out of scope pixel values with min/max
    for kk = 1:3
        for xx = 1:x
            for yy = 1:y
                if mask(yy,xx,kk) == -1
                    hdr(yy,xx,kk) = mn;
                end
                if mask(yy,xx,kk) == 1
                    hdr(yy,xx,kk) = mx;
                end
            end
        end
    end
end
