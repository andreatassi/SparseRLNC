pFullRank_Sim = 0;
pFullRank_Th = 0;
pFullRank_ThTime = 0;
pFullRankOp_Sim = 0;

try
    doNotSave;
catch
    doNotSave = false;
end

for n = floor(NmulMax * k)
    p = pStart * ones(1,n) - (0:n-1) * pStep;
    p(p < 1/q) = 1/q;
    fprintf('[Sim] q = %i, k = %i, n = %i, pStart = %f, pStep = %f, PEP = %f\n', q, k, n, pStart, pStep, pep);
    [pFullRank_Sim, pFullRankOp_Sim] = simLib.getRank(k,n,q,p,false,pruneStatus,pep,it,seed);
end
if ~doNotSave
save( strcat(fileTagSim, '_', ...
    num2str(k), '_', ...
    num2str(NmulMax), '_', ...
    num2str(pStart), '_', ...
    num2str(pStep), '_', ...
    num2str(q), '_', ...
    num2str(pep), '_', num2str(pruneStatus), '.mat'), 'pFullRank_Sim', 'pFullRankOp_Sim' );
end

for n = floor(NmulMax * k)
    fprintf('[Th] q = %i, k = %i, n = %i, pStart = %f, pStep = %f, PEP = %f\n', q, k, n, pStart, pStep, pep);
    fun = @(n_) lib.fullRankP_ts(n_, k, lib.pGen( pStart, pStep, n_, q ), q, mMax, tau, pruneStatus, nCk_fn, rho_fn, piFunc_fn);
    tic;
    pFullRank_Th = lib.decP(n, k, pep, fun, nCk_fn);
    pFullRank_ThTime = toc;
    %  lib.showMisses('nCk_fn', nCk_fn);
    %  lib.showMisses('rho_fn', rho_fn);
    %  lib.showMisses('piFunc_fn', piFunc_fn);
    
    %fun = @(n_) lib.getAvgNumTx( k, n_, pStart, q, 0 );
    %pFullRank_soa = lib.decP(n, k, pep, fun, nCk_fn);
    fun = @(n_) 1-min( 1-lib.getAvgNumTx( k, n_, pStart, q, 0, false ), lib.bIA( n_, k, q, pStart, nCk_fn, rho_fn_ia ));
    pFullRank_soa_LB = lib.decP(n, k, pep, fun, nCk_fn);
    fun = @(n_) 1-max( 1-lib.getAvgNumTx( k, n_, pStart, q, 0, true ), lib.bIB( n_, k, pStart, nCk_fn ));
    pFullRank_soa_UB = lib.decP(n, k, pep, fun, nCk_fn);
end
if ~doNotSave
save( strcat(fileTagTh, '_', ...
    num2str(k), '_', ...
    num2str(NmulMax), '_', ...
    num2str(pStart), '_', ...
    num2str(pStep), '_', ...
    num2str(q), '_', ...
    num2str(pep), '_', num2str(pruneStatus), '.mat'), 'pFullRank_Th', 'pFullRank_ThTime' );
end

try
    fileTagExpTh;
    pFullRank_ThApp = zeros(1,NmulMax * k);
    for n = floor(NmulMax * k)
        fprintf('[ThApp] q = %i, k = %i, n = %i, pStart = %f, pStep = %f, PEP = %f\n', q, k, n, pStart, pStep, pep);
        fun = @(n_) lib.fullRankP_appHeur(n_, k, lib.pGen( pStart, pStep, n_, q ), q, pruneStatus);
        pFullRank_ThApp = lib.decP(n, k, pep, fun, nCk_fn);
    end
    if ~doNotSave
    save( strcat(fileTagExpTh, '_', ...
        num2str(k), '_', ...
        num2str(NmulMax), '_', ...
        num2str(pStart), '_', ...
        num2str(pStep), '_', ...
        num2str(q), '_', ...
        num2str(pep), '_', num2str(pruneStatus), '.mat'), 'pFullRank_ThApp' );
    end
catch
end
