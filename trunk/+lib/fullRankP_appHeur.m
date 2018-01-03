function [ o ] = fullRankP_appHeur( N, K, p, q, pruneStatus )
    expTerm = -q^(K-N);
    if pruneStatus
        o = exp(expTerm);
    else
        o = exp(expTerm) * (1-prod(p))^K;
    end
end
