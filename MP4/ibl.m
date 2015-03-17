M = im2double(imread('./rendered_mask.png'));
R = im2double(imread('./rendered_scene.png'));
E = im2double(imread('./rendered_empty.png'));
I = im2double(imread('./Images/I.jpg'));
c = 2;

composite = M.*R + (1-M).*I + (1-M).*(R-E).*c;

imshow(composite);
imwrite(composite, 'composite.jpg');