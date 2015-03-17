function im_out = sphere2panoramic(im_in,w,h)
    [imh,imw,imd] = size(im_in);
    im_out = zeros(h,w,3);
    for i=1:imd
    phis = zeros(imh*imw,1);
    thetas = zeros(imh*imw,1);
    vs = zeros(imh*imw,1);
    count = 0;
    for y=1:imh
        for x=1:imw
            norm = getnorm((x/imw)*2-1,(y/imh)*2-1);
            ref = getref(norm,[0 0 -1]);
            phitheta = getpt(ref);
            if dot(phitheta,phitheta) == 0
                continue;
            end
            count = count + 1;
            phis(count) = phitheta(1);
            thetas(count) = phitheta(2);
            vs(count) = im_in(y,x,i);
            if x < w/20
                count = count + 1;
                phis(count) = phitheta(1);
                thetas(count) = phitheta(2) + 2*pi;
                vs(count) = im_in(y,x,i);
            end
            if x>19*w/20
                count = count + 1;
                phis(count) = phitheta(1);
                thetas(count) = phitheta(2) - 2*pi;
                vs(count) = im_in(y,x,i);
            end
        end
    end
    phis = phis(1:count);
    thetas = thetas(1:count);
    vs = vs(1:count);
    F = scatteredInterpolant(phis, thetas, vs); %replace with scatteredInterpolant?
    for y=1:h
        for x=1:w
            p = (y/h - .5) * pi;
            t = (x/(w/2) - 1) * pi;
            im_out(y,x,i) = F(t,p);
        end
    end
    disp('...');
    end
end

function norm = getnorm(x,y)
    if x*x+y*y < 1
        xn = x;
        yn = y;
        zn = sqrt(1-x*x-y*y);
        norm = [xn yn zn];
        return;
    end
    xn = 0;
    yn = 0;
    zn = 0;
    norm = [xn yn zn];
end

function ref = getref(norm,view)
    if dot(norm, norm) == 0
        ref = norm;
        return;
    end
    ref = view - 2.*dot(view, norm) .* norm;
end

function phitheta = getpt(ref)
    if dot(ref, ref) == 0
        phitheta = ref;
        return;
    end
    [phi theta r] = cart2sph(-ref(3),ref(1),ref(2));
    %phitheta = (([phi theta 0]/pi) + [1 .5 0]) .* [.5 1 0];
    phitheta = [phi theta 0];
end