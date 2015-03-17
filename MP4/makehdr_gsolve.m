function hdr = makehdr_gsolve(ldrs, exposures)
    % ldrs is an m x n x 3 x k matrix which can be created with ldrs = cat(4, ldr1, ldr2, ...);
    % exposures is a vector of exposure times (in seconds) corresponding to ldrs
    [exposures,sortexp] = sort(reshape(exposures,1,1,1,[]));
    ldrs = ldrs(:,:,:,sortexp); %Sort exposures from dark to light

    [im_width,im_height,d,k] = size(ldrs(:,:,:,:));
    hdr = zeros(im_width,im_height,d);
    
    % Create a mask for the high and low pixels, -1 is low, 1 is high
    mask = zeros(im_width, im_height,3);
    
    %Generate 100 random locations that are inside of the image
    i = 100;
    for ii = 1:i
       x = randi(im_width);
       y = randi(im_height);
      
       for kk = 1:k
           Zr(ii,kk) = ldrs(x,y,1,kk);
           Zg(ii,kk) = ldrs(x,y,2,kk);
           Zb(ii,kk) = ldrs(x,y,3,kk);
       end
    end
    
    % create a 1xk array containing the log of exposure times
    for i = 1:k
        B(i) = log(exposures(:,:,1,i));
    end
   
    l = 50;
    w = @(z) double(128-abs(z-128));
    
    [g_r,lEr] = gsolve(Zr,B,l,w);
    [g_g,lEg] = gsolve(Zg,B,l,w);
    [g_b,lEb] = gsolve(Zb,B,l,w);
    
    figure(5), plot(1:255, g_r(1:255), 1:255, g_g(1:255), 1:255, g_b(1:255));
    
    for i = 1:im_width
        for j = 1:im_height
            t_sum_r = 0; b_sum_r = 0;
            t_sum_g = 0; b_sum_g = 0;
            t_sum_b = 0; b_sum_b = 0;
            
            for kk = 1:k
                t_sum_r = t_sum_r + (w(ldrs(i,j,1,kk))*(g_r(ldrs(i,j,1,kk)+1)-(B(kk))));
                b_sum_r = b_sum_r + w(ldrs(i,j,1,kk));
                
                t_sum_g = t_sum_g + (w(ldrs(i,j,2,kk))*(g_g(ldrs(i,j,2,kk)+1)-(B(kk))));
                b_sum_g = b_sum_g + w(ldrs(i,j,2,kk));
                
                t_sum_b = t_sum_b + (w(ldrs(i,j,3,kk))*(g_b(ldrs(i,j,3,kk)+1)-(B(kk))));
                b_sum_b = b_sum_b + w(ldrs(i,j,3,kk));
            end
            
            threshold = 5*k;            
            if b_sum_r < threshold
                if ldrs(i,j,1,1) < 128 
                    mask(i,j,1) = -1;
                else
                    mask(i,j,1) = 1;
                end
            end
            if b_sum_g < threshold
                if ldrs(i,j,2,1) < 128 
                    mask(i,j,2) = -1;
                else
                    mask(i,j,2) = 1;
                end
            end
            if b_sum_b < threshold
                if ldrs(i,j,3,1) < 128
                    mask(i,j,3) = -1;
                else
                    mask(i,j,3) = 1;
                end
            end
                    
            
            
            hdr(i,j,1) = exp(t_sum_r/b_sum_r);
            hdr(i,j,2) = exp(t_sum_g/b_sum_g);
            hdr(i,j,3) = exp(t_sum_b/b_sum_b);
        end
    end
    
    mn = min(min(min(hdr)));
    mx = max(max(max(hdr)));
    
    % Replace out of scope pixel values with min/max
    for kk = 1:3
        for xx = 1:im_width
            for yy = 1:im_height
                if mask(xx,yy,kk) == -1
                    hdr(xx,yy,kk) = mn;
                end
                if mask(xx,yy,kk) == 1
                    hdr(xx,yy,kk) = mx;
                end
            end
        end
    end
end
