function H = computeHomography(x1,y1,x2,y2)
    n = size(x1);
    n = n(2);
    display(n, 'size(x1)');

%     % Compute T1 and T2 that translate and uniformly scale the points of 
%     % each image to have zero mean and unit norm
    T1 = uniform_translate(x1,y1);
    T2 = uniform_translate(x2,y2);
    
    % Compute A which is used to compute Hn
    A = [];
    for i = 1:n
       Ai1 = [-x1(i), -y1(i), -1, 0, 0, 0, x1(i)*x2(i), y1(i)*x2(i), x2(i)];
       Ai2 = [0, 0, 0, -x1(i), -y1(i), -1, x1(i)*y2(i), y1(i)*y2(i), y2(i)];
%        Ai1 = [-x2(i), -y2(i), -1, 0, 0, 0, x2(i)*x1(i), y2(i)*x1(i), x1(i)];
%        Ai2 = [0, 0, 0, -x2(i), -y2(i), -1, x2(i)*y1(i), y2(i)*y1(i), y1(i)];
       A = [A ; Ai1 ; Ai2];
    end
    
    % Compute Hn for the normalized points by solving a system of linear
    % equations using svd
    [U, S, V] = svd(A);
    Hn = reshape(V(:, 9), 3, 3)';
    Hn = Hn / Hn(3,3);
    H = inv(T2) * Hn * T1;
    
    H = Hn;
end

function T = uniform_translate(x,y)
    Tm = [1 0 -mean(x(:)) ; 0 1 -mean(y(:)) ; 0 0 1];
    Tstd = [1/std(x(:)) 0 0 ; 0 1/std(x(:)) 0 ; 0 0 1];
    T = Tstd * Tm;
end