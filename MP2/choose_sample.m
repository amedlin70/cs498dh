function pos = choose_sample( ssd_res, tol )  
    not_done = true;
    minc = min(min(ssd_res));
    minc = max(minc, .25);
    
    while(not_done)
        [x,y] = find(ssd_res < minc * (1 + tol));

        if(~isempty(x))
            x_size = size(x);
            if(x_size(1)>1)
                rand_pos = randi(x_size(1));
                pos(1) = x(rand_pos);
                pos(2) = y(rand_pos);
            else
                pos(1) = x(1);
                pos(2) = y(1);
            end
            not_done = false;
        end
        tol = tol * 1.25;
    end
end