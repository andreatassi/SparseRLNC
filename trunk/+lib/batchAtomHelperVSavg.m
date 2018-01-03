p = pStart;
fprintf('[Sim] q = %i, k = %i, pStart = %f, PEP = %f\n', q, k, pStart, pep);
[avgRX_Sim, ~] = simLib.getAvgNumTxSim(k,p,pep,it,seed,q,false,1);
% save( strcat(fileTagSim, '_', ...
%     num2str(k), '_', ...
%     num2str(NmulMax), '_', ...
%     num2str(pStart), '_', ...
%     num2str(pStep), '_', ...
%     num2str(q), '_', ...
%     num2str(pep), '_', num2str(pruneStatus), '.mat'), 'avgRX_Sim' );

avgRX_Th = 0;
n        = k;
fun      = @(n_) lib.fullRankP_ts(n_, k, lib.pGen( pStart, pStep, n_, q ), q, mMax, tau, pruneStatus, nCk_fn, rho_fn, piFunc_fn);
w_       = lib.decP(n, k, pep, fun, nCk_fn);
while w_ <= 1 - 1e-3
    fprintf('[Th] q = %i, k = %i, pStart = %f, PEP = %f\n', q, k, pStart, pep);
    fun = @(n_) lib.fullRankP_ts(n_, k, lib.pGen( pStart, pStep, n_, q ), q, mMax, tau, pruneStatus, nCk_fn, rho_fn, piFunc_fn);
    if n == K
        cond_ = w_;
        avgRX_Th = avgRX_Th + n * cond_;
    else
        w_ = lib.decP(n, k, pep, fun, nCk_fn)
        cond_ = ( w_ - lib.decP(n-1, k, pep, fun, nCk_fn) );
        avgRX_Th = avgRX_Th + n * cond_;
    end
    n = n + 1;
end

% avgRX_soa = 0;
% n        = k;
% fun      = @(n_) max( lib.getAvgNumTx( k, n_, pStart, q, 0, true ), lib.bIB( n_, k, pStart, nCk_fn ));
% w_       = lib.decP(n, k, pep, fun, nCk_fn);
% while w_ <= 1 - 1e-3
%     fprintf('[Thsoa] q = %i, k = %i, pStart = %f, PEP = %f\n', q, k, pStart, pep);
%     fun = @(n_) max( lib.getAvgNumTx( k, n_, pStart, q, 0, true ), lib.bIB( n_, k, pStart, nCk_fn ));
%     if n == K
%         cond_ = w_;
%         avgRX_soa = avgRX_soa + n * cond_;
%     else
%         w_ = lib.decP(n, k, pep, fun, nCk_fn)
%         cond_ = ( w_ - lib.decP(n-1, k, pep, fun, nCk_fn) );
%         avgRX_soa = avgRX_soa + n * cond_;
%     end
%     n = n + 1;
% end
% save( strcat(fileTagTh, '_', ...
%     num2str(k), '_', ...
%     num2str(NmulMax), '_', ...
%     num2str(pStart), '_', ...
%     num2str(pStep), '_', ...
%     num2str(q), '_', ...
%     num2str(pep), '_', num2str(pruneStatus), '.mat'), 'avgRX_Th', 'avgRX_soa' );
