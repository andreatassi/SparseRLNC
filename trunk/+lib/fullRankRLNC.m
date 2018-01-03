function [ o ] = fullRankRLNC( N, K, q )
    t = 1:(K-1);
    tmp = q.^(t-N);
    o = prod(1 - tmp);
end