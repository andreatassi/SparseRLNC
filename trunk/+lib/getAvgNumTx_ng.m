function [ o ] = getAvgNumTx_ng( K, n, pZero, q, PER )
    o = 1;
    for t = 0:(K-1)
        BB = max(pZero, (1-pZero)/(q-1));
        o = o * ( 1 - (BB)^(n-t) );
    end
end
