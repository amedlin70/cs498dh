function cut_mask = cut(M, template, patch, overlap, patchsize)
    is_top = false;
    is_side = false;
    
    % Top boundary
    top_mask = zeros(patchsize, patchsize);
    top_ssd = zeros(patchsize, overlap);
    
    if(M(overlap+1, 1) == 1)
        is_top = true;
        
        for i = 1:patchsize
            for j = 1:overlap
                % Create ssd of top boundary
                for k = 1:3
                    top_ssd(i,j) = top_ssd(i,j) + (template(i,j,k) - patch(i,j,k))^2;
                end
            end
        end

        % Find shortest path through the top boundary
        top_map = zeros(patchsize, overlap, 2);
        for i = 1:patchsize
            for j = 1:overlap
                if(i == 1)
                   % Set cost of first column 
                   top_map(i,j,1) = top_ssd(i,j);
                else
                    % Check right
                    if(top_ssd(i,j) + top_map(i-1,j,1) < top_map(i,j,1) | top_map(i,j,1) == 0)
                        top_map(i,j,1) = top_map(i-1,j,1) + top_ssd(i,j);
                        top_map(i,j,2) = j;
                    end
                    
                    % Check right and up
                    if(j ~= 1)
                        if(top_ssd(i,j) + top_map(i-1,j-1,1) < top_map(i,j,1) | top_map(i,j,1) == 0)
                            top_map(i,j,1) = top_ssd(i,j) + top_map(i-1,j-1,1);
                            top_map(i,j,2) = j-1;
                        end
                    end

                    % Check right and down
                    if(j ~= overlap)
                        if(top_ssd(i,j) + top_map(i-1,j+1,1) < top_map(i,j,1) | top_map(i,j,1) == 0)
                            top_map(i,j,1) = top_ssd(i,j) + top_map(i-1,j+1,1);
                            top_map(i,j,2) = j+1;
                        end
                    end
                end
            end
        end
        
        % Fill in the top_mask
        min_cost = 0;
        for j = 1:overlap
            if(top_map(patchsize,j,1) < min_cost | min_cost == 0)
                min_cost = top_map(patchsize,j,1);
                prev_node = top_map(patchsize,j,2);
                cur_node = j;
            end
        end
        
        for i = patchsize:-1:1
%             top_ssd(i, cur_node) = .5;
            for j = cur_node:patchsize
                top_mask(i,j) = 1;
            end
            cur_node = prev_node;
            if(i~=1)
                prev_node = top_map(i-1,prev_node,2);
            end
        end
        
%         figure(4), hold off, imagesc(top_ssd), axis image, colormap jet
        
    end
    
    % Side Boundary
    side_mask = zeros(patchsize, patchsize);
    side_ssd = zeros(overlap, patchsize);
    
    if(M(1, overlap+1) == 1)
        is_side = true;
        for i = 1:overlap
            for j = 1:patchsize
                % Create ssd of top boundary
                for k = 1:3
                    side_ssd(i,j) = side_ssd(i,j) + (template(i,j,k) - patch(i,j,k))^2;
                end
            end
        end
        
%         figure(5), imshow(patch(1:overlap, 1:patchsize))
%         figure(6), imshow(template(1:overlap,1:patchsize))
%         figure(7), hold off, imagesc(side_ssd), axis image, colormap jet
        
        % Find shortest path through the side boundary
        side_map = zeros(overlap, patchsize, 2);
        for i = 1:patchsize
            for j = 1:overlap
                if(i == 1)
                   % Set cost of first column 
                   side_map(j,i,1) = side_ssd(i,j);
                   side_map(j,i,2) = j;
                else
                    % Check down
                    if(side_ssd(j,i) + side_map(j,i-1,1) < side_map(j,i,1) | side_map(j,i,1) == 0)
                        side_map(j,i,1) = side_ssd(j,i) + side_map(j,i-1,1);
                        side_map(j,i,2) = j;
                    end
                    
                    % Check right and up
                    if(j ~= 1)
                        if(side_ssd(j,i) + side_map(j-1,i-1,1) < side_map(j,i,1) | side_map(j,i,1) == 0)
                            side_map(j,i,1) = side_ssd(j,i) + side_map(j-1,i-1,1);
                            side_map(j,i,2) = j-1;
                        end
                    end

                    % Check right and down
                    if(j ~= overlap)
                        if(side_ssd(j,i) + side_map(j+1,i-1,1) < side_map(j,i,1) | side_map(j,i,1) == 0)
                            side_map(j,i,1) = side_ssd(j,i) + side_map(j+1,i-1,1);
                            side_map(j,i,2) = j+1;
                        end
                    end
                end
            end
        end
       
        % Fill in the top_mask
        min_cost = 0;
        for j = 1:overlap 
            if(side_map(j,patchsize,1) < min_cost | min_cost == 0)
                min_cost = side_map(j,patchsize,1);
                prev_node = side_map(j,patchsize,2);
                cur_node = j;
            end
        end
        
        for i = patchsize:-1:1
%             side_ssd(cur_node,i) = .5;
            for j = cur_node:patchsize
                side_mask(j, i) = 1;
            end            
            
            cur_node = prev_node;
            if(i~=1)
                prev_node = side_map(prev_node,i-1,2);
            end
        end
        
%         figure(8), hold off, imagesc(side_ssd), axis image, colormap jet
%         pause;
    end
        
    if(is_top & is_side)
        cut_mask = top_mask & side_mask;
    elseif(is_top)
        cut_mask = top_mask;
    elseif(is_side)
        cut_mask = side_mask;
    end
end