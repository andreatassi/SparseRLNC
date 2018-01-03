function [ p ] = pGen( pStart, pStep, n, q )
    p = pStart * ones(1,n) - (0:n-1) * pStep;
    p(p < 1/q) = 1/q;
end

