function [ o ] = getAvgNumTx( K, n, pZero, q, PER, isLB )
    try
        isLB;
    catch
        isLB = false;
    end
    P = zeros(K+1,K+1);
    for i = 0:K
        for j = 0:K
            if i-j == 1
                P(i+1,j+1) = (1-lib.getNDofs( K, K-i, pZero, q, isLB )) * (1 - PER);
            elseif i == j
                P(i+1,j+1) = lib.getNDofs( K, K-i, pZero, q, isLB ) * (1 - PER) + PER;
            end
        end
    end
    
    Pn = P^n;
    if n <= K
        vv = zeros(1,K+1);
        vv(end) = 1;
        tmp = vv * Pn;
        o = tmp(end-n);
    else
        vv = zeros(1,K+1);
        vv(end) = 1;
        tmp = vv * Pn;
        o = tmp(1);
    end
    
    Q = P(2:(K+1),2:(K+1));
    N = inv(eye(K) - Q);
    
    t = sum(N, 2);
    t = t(end);
end
