function [ oA ] = bIA( N, K, q, p, nCk_fn, rho_fn )
    oA = 0;
    for w = 1:K
        oA = oA + nCk_fn(K,w) * (q - 1)^(w-1) * (rho_fn(w, q, p))^N;
    end
end