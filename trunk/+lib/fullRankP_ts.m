function [ o, mOpt, piTime ] = fullRankP_ts( N, K, p, q, mMax, tau, pruneStatus, nCk_fn, rho_fn, piFunc_fn )
    m = min(mMax, K);
    expTerm = 0;
    diffTerm = 0;
    piTime = 0;
    mOpt = NaN;
    for s = 2:m
        if ~isnan(tau)
            prevDiffTerm = diffTerm;
            prevExp = expTerm;
            tic;
            ttt_ = piFunc_fn(s, q, p, nCk_fn, rho_fn, piFunc_fn);
            piTime = piTime + toc;
            aa_ = ttt_ / (1-prod(p))^s;
            expTerm = expTerm - nCk_fn(K,s) * aa_;
            if pruneStatus
                diffTerm = exp(prevExp) - exp(expTerm);
            else
                diffTerm = ( exp(prevExp) - exp(expTerm) ) * (1-prod(p))^K;
            end
            
            %(exp(expTerm) ) * (1-prod(p))^K
            
            mOpt = s;
            if diffTerm <= 1e-10
                diffTerm = 0;
            end
            %vv_(s) = diffTerm;
            if prevDiffTerm > diffTerm && diffTerm <= tau && tau ~=0
                break;
            end
        else
            mOpt = s;
            tic;
            ttt_ = piFunc_fn(s, q, p, nCk_fn, rho_fn, piFunc_fn);
            piTime = piTime + toc;
            expTerm = expTerm - nCk_fn(K,s) * ttt_ / (1-prod(p))^s;
        end        
    end
    
    if pruneStatus
        o = exp(expTerm);
    else
        o = exp(expTerm) * (1-prod(p))^K;
    end
end
