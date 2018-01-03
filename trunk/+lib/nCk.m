function [ r ] = nCk( n, k )
    warning off;
    r = nchoosek(n,k);
%     if n >= 2*k + 1
%         Num = prod((n-k+1):n);
%     else
%         Num = prod((k+1):n);
%     end
%     Den = prod(1:(n-k));
%     r = Num / Den;
end

