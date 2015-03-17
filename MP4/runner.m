disp('start');
ball = hdrread('./hdr3.hdr');
im_out = sphere2panoramic(ball,500,250);
disp('done');
figure(1), hold off, imshow(im_out)
mn = min(min(min(im_out)));
mx = max(max(max(im_out)));
hdrwrite(im_out,'./imout.hdr');