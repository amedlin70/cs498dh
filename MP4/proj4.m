ldr1 =  255 .* im2double(imread('./Images/sphere_1_0731.jpg')); 
ldr2 =  255 .* im2double(imread('./Images/sphere_1_0732.jpg'));
ldr3 =  255 .* im2double(imread('./Images/sphere_1_0733.jpg'));
ldr4 =  255 .* im2double(imread('./Images/sphere_1_0734.jpg'));
ldr5 =  255 .* im2double(imread('./Images/sphere_1_0735.jpg'));
ldr6 =  255 .* im2double(imread('./Images/sphere_1_0736.jpg'));
ldr7 =  255 .* im2double(imread('./Images/sphere_1_0737.jpg'));
ldr8 =  255 .* im2double(imread('./Images/sphere_1_0738.jpg'));
ldr9 =  255 .* im2double(imread('./Images/sphere_1_0739.jpg'));
ldrs = cat(4, ldr1, ldr2, ldr3, ldr4, ldr5, ldr6, ldr7, ldr8, ldr9);

exposures = zeros(1,9);
exposures(1) = 1/200;
exposures(2) = 1/400;
exposures(3) = 1/100;
exposures(4) = 1/25;
exposures(5) = 1/50;
exposures(6) = 1/13;
exposures(7) = 1/2;
exposures(8) = 1/4;
exposures(9) = 1;

hdr1 = makehdr_naive(ldrs, exposures);
hdrwrite(hdr1,'hdr1.hdr');
hdr1 = log(hdr1);
mn = min(min(min(hdr1)));
mx = max(max(max(hdr1)));
im1 = (hdr1-mn)/(mx-mn);
figure(1), imshow(im1);

hdr2 = makehdr_naive_fix(ldrs, exposures);
hdrwrite(hdr2,'hdr2.hdr');
hdr2 = log(hdr2);
mn = min(min(min(hdr2)));
mx = max(max(max(hdr2)));
im2 = (hdr2-mn)/(mx-mn);
figure(2), imshow(im2);

hdr3 = makehdr_gsolve(ldrs, exposures);
hdrwrite(hdr3,'hdr3.hdr');
im3 = log(hdr3); 
mn1 = min(min(min(im3)));
mx1 = max(max(max(im3)));
im3 = (im3-mn1)/(mx1-mn1);
figure(3), imshow(im3);
