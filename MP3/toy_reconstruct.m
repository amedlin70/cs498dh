function result = toy_reconstruct(im)

%Set up
[imh, imw, nb] = size(im);
im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw;

s = im;
b = sparse(imh*imw*2+1,1);
A = sparse(imh*imw*2+1, imh*imw*2+1);
result = zeros(imh, imw, 1);
e = 0;

%loop through the image solving for each pixel
for x = 1:imw
    for y = 1:imh
        %objective 1  
        e = e+1;
        if(x ~= imw)
            A(e, im2var(y,x+1))=1;
            A(e, im2var(y,x))=-1;
            b(e) = s(y,x+1)-s(y,x);
        end
        if(y ~= imh)
            A(e, im2var(y+1,x))=1;
            A(e, im2var(y,x)) = A(e, im2var(y,x))-1;
            b(e) = b(e) + s(y+1,x)-s(y,x);
        end
    end
end

%objective 3
e = e+1;
A(e, im2var(1,1))=1;
b(e) = s(1,1);

%solve for v
v = A\b;

%set solved variable pixel in result
e = 1;
for x = 1:imw
    for y = 1:imh
        result(y,x,1) = v(e);
        e = e+1;
    end
end

imshow(result);
%figure(1), hold off, imagesc(result), axis image, colormap gray
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    