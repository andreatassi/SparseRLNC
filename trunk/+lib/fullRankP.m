function [ o, mOpt ] = fullRankP( N, K, p, q, mMax, tau )
%function [ o ] = fullRankP( N, K, p, q, mMax, cacheBasePath )
m = min(mMax, K);
%     syms w t;
%     rho = ( (1/q) * ( 1 + (q-1) * ( 1 - (q/(q-1)) * (1-p) ).^w ) ).^N;
%     Gu = symsum(rho/factorial(w) .* t^w, w, [0, N]);
%     Gp = -p^N*t/(1-p^N) + log( subs(Gu, t, (t/(1-p^N))) );
%     dataName = strcat(cacheBasePath,'/', num2str(m), '_', num2str(K),'_',num2str(N),'_',num2str(p), '_', num2str(q), '.mat');
%     try
%         load(dataName);
%     catch
%         for s = 2:m
%             if s == 2
%                 tmp(s) = diff(Gp, s);
%             else
%                 tmp(s) = diff(tmp(s-1), 1);
%             end
%         end
%         save(dataName, 'tmp');
%     end

global NcK;
load('data/NcK.mat');
%NcK_h = matfile('/mnt/ramdisk/NcK.mat','Writable',true);
%try
%    NcK_h.NcK;
%catch
%    NcK = nan * ones(3*80,80);
%    save('/mnt/ramdisk/NcK.mat', 'NcK', '-v7.3');
%end

expTerm = 0;
for s = 2:m
    fprintf('-----------------> H-%i of H-%i\n', s,m);
    %       expTerm = expTerm - nchoosek(K,s) * subs(tmp(s), t, 0);
    if isnan(NcK(K,s))
        NcK(K,s) = nchoosek(K,s);
    end
    
    try
        tau;
        tmp1 = expTerm - NcK(K,s) * piFunc(s, N, q, p) / (1-p^N)^s;
        if double(exp(expTerm) * (1-p^N)^K) - double(exp(tmp1) * (1-p^N)^K) <= tau
            mOpt = s;
        else
            mOpt = NaN;
        end
    catch
        mOpt = NaN;
    end
    
    expTerm = expTerm - NcK(K,s) * piFunc(s, N, q, p) / (1-p^N)^s;
end
o = double(exp(expTerm) * (1-p^N)^K);
save('data/NcK.mat', 'NcK')
end

function [ rho ] = rhoFunc(w, N, q, p)
rho = ( (1/q) * ( 1 + (q-1) * ( 1 - (q/(q-1)) * (1-p) ).^w ) ).^N;
end

function [ p_i ] = piFunc(l, N, q, p)
global NcK;

if l == 1
    p_i = rhoFunc(1,N,q,p);
else
    tmpVal = 0;
    for s = 1:(l-1)
        yy_ = NcK(l-1,s);
        if isnan(yy_)
            yy_ = nchoosek(l-1,s);
            NcK(l-1,s) = yy_;
        end
        tmpVal = tmpVal + yy_ * rhoFunc(s,N,q,p) * piFunc(l-s,N,q,p);
    end
    p_i = rhoFunc(l,N,q,p) - tmpVal;
end
end