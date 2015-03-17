function [H, matches] = computeHomography_RANSAC(x1, y1, x2, y2)

    %initialise variables
    max_dist = 3;
    max_inliers = 0;
    num_points = size(x1);

    for i=1:100
       inliers = 0;
       % choose 4 random points
       
       % Compute H
       H = computeHomography(x1, y1, x2, y2);
       
       % Apply H to all points, calculating distance between points
       for j = 1:num_points
            
           
           % if distance < max_dist, consider it an inlier
       end
       
       % check if this is the best match
       if inliers > max_inliers
            % save these results
            max_inliers = inliers;
            best_H = H;
       end
    end
    H = best_H;
    
    % Calculate the matches matrix for use in plotmatches
%     for j = 1:num_points
%         
%         if(
%         matches(
%         end
%     end
    matches = 0;