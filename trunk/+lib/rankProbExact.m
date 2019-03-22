function [o] = rankProbExact(R,C,q,p)
    i = R;
    n = C;
    %p0 = p;

    %--
    %f = @(k,p) p * (0.5 * (1+(1-2*(1-p)).^k)) + (1-p) * (0.5 * (1-(1-2*(1-p)).^k));
    %f1 = @(n) (n.*(n-1) .* (2.*n+5) / 6) + (n.*(n.^2 + 3.*n - 1) / 3 );
    %p = f(ceil(f1(R)/(C^2)),p);
    %assert(p <= p0 && p >= 1/q )
    %--
    
    %--
    %o = lib.rankProbApp(R,C,q,p);
    o = simLib.rPA(R, C, p, q);    
    %--
    
%     o = 1 - ( p/q * (1+(q-1) * (1 - (q*(1-p)^2)/(q-1))^i ) + ...
%         (1-p)/q * ( 1 + (-1)*(1 - (q*(1-p)^2)/(q-1) )^i ) )^(n-i);
end
