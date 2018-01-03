function [ oB ] = bIB( N, K, p, nCk_fn )
    oB = 0;
    for w = 1:K
        oB = oB + nCk_fn(K,w) * p^(N*w) * (1-p^N)^(K-w);
    end
end