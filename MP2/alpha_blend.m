function result = alpha_blend(T, IT, over)
    % center the inner_toast image on the toast
    tsize = size(T);
    itsize = size(IT);
    
    off = floor((tsize-itsize)./2);
    
    % blend the left and right
    for i = 1:(itsize(1)-2*over)
        for j = 1:over
            a = j/over;
            for k=1:3
                T(i+off(1)+over-1,j+off(2),k) = a * IT(i+over,j,k) + (1-a) * T(i+off(1)+over-1, j + off(2),k);
                T(i+off(1)+over-1,1+off(2)+itsize(2)-j,k) = a * IT(i+over,itsize(2)-j+1,k) + (1-a) * T(i+off(1)+over-1, 1+off(2)+itsize(2)-j,k);
            end
        end
    end
    
    % blend the top and bottom
    for i = 1:over
        for j = 1:(itsize(2)-2*over)
            a = i/over;
            for k=1:3
                T(i+off(1),j+off(2)+over,k) = a * IT(i,j+over,k) + (1-a) * T(i+off(1),j+off(2)+over,k);
                T(1+off(1)+itsize(1)-i,j+off(2)+over,k) = a * IT(itsize(1)-i+1,j+over,k) + (1-a) * T(1+off(1)+itsize(1)-i,j+off(2)+over,k);
            end
        end
    end
    
    % blend the corners
    for i = 1:over-1
        for j = over:-1:over-i
            a = (j+i-over)/over;
            for k=1:3
                T(i+off(1), j+off(2),k) = a * IT(i,j,k) + (1-a) * T(i+off(1), j+off(2),k);
                T(i+off(1), 1+off(2)+itsize(2)-j,k) = a * IT(i, 1+itsize(2)-j,k) + (1-a) * T(i+off(1), 1+off(2)+itsize(2)-j,k);
                T(off(1)+itsize(1)-i-1, j+off(2),k) = a*IT(i,j,k)+(1-a)*T(off(1)+itsize(1)-i-1, j+off(2),k);
                T(off(1)+itsize(1)-i-1, 1+off(2)+itsize(2)-j,k) = a*IT(i,j,k)+(1-a)*T(off(1)+itsize(1)-i-1, 1+off(2)+itsize(2)-j,k);
            end
        end
    end
                
    % fill in the center
    T(off(1)+over:off(1)+itsize(1)-over, off(2)+over:off(2)+itsize(2)-over,:) = IT(over:itsize(1)-over, over:itsize(2)-over,:);
    
    result = T;
end