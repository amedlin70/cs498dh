function mergedImage  = userstitch(im1, im2)
     
    figure(1), hold off, imagesc(im1), axis image;
    figure(2), hold off, imagesc(im2), axis image;

    % collect points in first image
    count = 0;
    x1 = [];
    y1 = [];
    while 1
        figure(1)
        [x, y, b] = ginput(1);
        if b=='q'
            break;
        end
        x1(end+1) = x;
        y1(end+1) = y;
        hold on, plot(x1, y1, '*-');
        count = count + 1;
    end
    
    % collect points in second image
    x2 = [];
    y2 = [];
    while(count ~= 0)
        figure(2)
        [x, y, b] = ginput(1);
        x2(end+1) = x;
        y2(end+1) = y;
        hold on, plot(x2, y2, '*-');
        count = count - 1;
    end
    
    % create the transformation matrix    
    display(x1);
    display(y1);
    display(x2);
    display(y2);
    
    % compute the Homography bringing im2 into im1
    H = computeHomography(x1,y1,x2,y2);    
 
%     display(H, 'H');
%     
%     display([x1(5) y1(5)], 'x1,y1');
%     display([x2(5) y2(5)], 'x2,y2');
%     
%     tmp = (H*[x2(5), y2(5), 5]');
%     display(tmp, 'H*[x2(5), y2(5), 1]' );
%     tmp = tmp / tmp(3);
%     display(tmp, 'tmp / tmp(3)');
%     
%     tmp = (H*[600, 600, 1]');
%     display(tmp, 'H*[600, 600, 1]');
%     tmp = tmp / tmp(3);
%     display(tmp, 'tmp / tmp(3)');
    
    % stitch the images together
    mergedImage = stitchPlanar(im1, im2, H);
    