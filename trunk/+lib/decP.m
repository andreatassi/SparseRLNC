function [ o ] = decP( N, K, epsilon, fun, nCk_fn )
    if epsilon == 0
        o = fun(N);
    else
        o = 0;
        for n = K:N
            tmp = nCk_fn(N,n) * (1-epsilon)^n * epsilon^(N-n) * fun(n);
            o = o + tmp;
        end
    end
end