function result = mixedBlend(im_s, mask_s, im_background)
% im_s is the new item to be blended into the background
% mask_s is the mask for im_s
% im_background is the background image

%Set up
[imh_b, imw_b, nb_b] = size(im_background);

s = im_s;
t = im_background;
result = im_background;

%Find the top, bottom, left, and right of the mask
mask_top = imh_b;
mask_bottom = 1;
mask_left = imw_b;
mask_right = 1;
count = 0;      %keep track of how many free variables there are
for x = 1:imw_b
    for y = 1:imh_b
        if(mask_s(y,x) == 1)
            count = count + 1;
            if(y > mask_bottom)
                mask_bottom = y;
            end
            if(y < mask_top)
                mask_top = y;
            end
            if(x > mask_right)
                mask_right = x;
            end
            if(x < mask_left)
                mask_left = x;
            end
        end
    end
end

mask_w = mask_right-mask_left;
mask_h = mask_bottom-mask_top;

x_off = mask_left-1;
y_off = mask_top-1;

%compute the map of the mask
im2var = zeros(imh_b, imw_b);
count = 1;
for x = 1:mask_w
    for y = 1:mask_h
        if(mask_s(y+y_off,x+x_off) == 1)
            im2var(y,x) = count;
            count = count + 1;
        end
    end
end

di = 0;
dj = 0;
dij = 0;

%loop through the image solving for each pixel
for i = 1:nb_b
    b = zeros(mask_w*mask_h+1, 1);
    A = sparse(mask_w*mask_h+1, mask_w*mask_h+1);
    e = 0;
    for x = 1:mask_w
        for y = 1:mask_h
            if(mask_s(y+y_off, x+x_off) == 1)  %Check if point is inside the mask
                e = e+1;
                A(e, im2var(y,x)) = 4;
                
                %check if the pixel is on the left of mask
                if(x == 1 || mask_s(y+y_off, x+x_off-1) == 0)
                    b(e) = b(e) + t(y+y_off, x+x_off-1, i);
                else
                    temp = im2var(y,x-1);
                    A(e, temp)= -1;
                    di = -s(y+y_off, x+x_off-1, i) + s(y+y_off, x+x_off, i);
                    dj = -t(y+y_off, x+x_off-1, i) + t(y+y_off, x+x_off, i);
                    if abs(di) > abs(dj)
                        dij = di;
                    else
                        dij = dj;
                    end
                    b(e) = b(e) + dij;
                end
                
                %check if the pixel is on the right of mask
                if(x == mask_w || mask_s(y+y_off, x+x_off+1) == 0)
                    b(e) = b(e) + t(y+y_off, x+x_off+1, i);
                else
                    temp = im2var(y,x+1);
                    A(e, temp) = -1;
                    di = -s(y+y_off, x+x_off+1, i) + s(y+y_off, x+x_off, i);
                    dj = -t(y+y_off, x+x_off+1, i) + t(y+y_off, x+x_off, i);
                    if abs(di) > abs(dj)
                        dij = di;
                    else
                        dij = dj;
                    end
                    b(e) = b(e) + dij;
                end
                
                %check if pixel is on the top of mask
                if(y == 1 || mask_s(y+y_off-1, x+x_off) == 0)
                    b(e) = b(e) + t(y+y_off-1, x+x_off, i);
                else
                    temp = im2var(y-1,x);
                    A(e, temp) = -1;
                    di = -s(y+y_off-1, x+x_off, i) + s(y+y_off, x+x_off, i);
                    dj = -t(y+y_off-1, x+x_off, i) + t(y+y_off, x+x_off, i);
                    if abs(di) > abs(dj)
                        dij = di;
                    else
                        dij = dj;
                    end
                    b(e) = b(e) + dij;
                end
                
                %check if pixel is on bottom of mask
                if(y == mask_h || mask_s(y+y_off+1, x+x_off) == 0)
                    b(e) = b(e) + t(y+y_off+1, x+x_off, i);
                else
                    temp = im2var(y+1,x);
                    A(e, temp) = -1;
                    di = -s(y+y_off+1, x+x_off, i) + s(y+y_off, x+x_off, i);
                    dj = -t(y+y_off+1, x+x_off, i) + t(y+y_off, x+x_off, i);
                    if abs(di) > abs(dj)
                        dij = di;
                    else
                        dij = dj;
                    end
                    b(e) = b(e) + dij;
                end
            end
        end
    end
    
    e = e+1;
    A(e, 1)=1;
    b(e) = t(y_off,x_off);
    
    %solve for v
    v = A\b;
    
    %set solved variable pixel in result
    e = 1;
    for x = 1:mask_w
        for y = 1:mask_h
            if(mask_s(y+y_off, x+x_off) == 1)
                result(y+y_off,x+x_off,i) = abs(v(e));
                e = e+1;
            end
        end
    end
end