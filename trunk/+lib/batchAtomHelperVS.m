pFullRank_Sim = zeros(1,NmulMax * k);
pFullRank_Th = zeros(1,NmulMax * k);
pFullRank_ThTime = zeros(1,NmulMax * k);
pFullRank_soa = zeros(1,NmulMax * k);
pFullRankOp_Sim = zeros(1,NmulMax * k);

parfor n = k : (NmulMax + k)
    p = pStart * ones(1,n) - (0:n-1) * pStep;
    p(p < 1/q) = 1/q;
    fprintf('[Sim] q = %i, k = %i, n = %i, pStart = %f, pStep = %f, PEP = %f\n', q, k, n, pStart, pStep, pep);
    [pFullRank_Sim(n), pFullRankOp_Sim(n)] = simLib.getRank(k,n,q,p,false,pruneStatus,pep,it,seed);
end
save( strcat(fileTagSim, '_', ...
    num2str(k), '_', ...
    num2str(NmulMax), '_', ...
    num2str(pStart), '_', ...
    num2str(pStep), '_', ...
    num2str(q), '_', ...
    num2str(pep), '_', num2str(pruneStatus), '.mat'), 'pFullRank_Sim', 'pFullRankOp_Sim' );

parfor n = k : (NmulMax + k)
    fprintf('[Th] q = %i, k = %i, n = %i, pStart = %f, pStep = %f, PEP = %f\n', q, k, n, pStart, pStep, pep);
    fun = @(n_) lib.fullRankP_ts(n_, k, lib.pGen( pStart, pStep, n_, q ), q, mMax, tau, pruneStatus, nCk_fn, rho_fn, piFunc_fn);
    tic;
    pFullRank_Th(n) = lib.decP(n, k, pep, fun, nCk_fn);
    pFullRank_ThTime(n) = toc;
    
    fun = @(n_) lib.getAvgNumTx( k, n_, pStart, q, 0 );
    pFullRank_soa(n) = lib.decP(n, k, pep, fun, nCk_fn);
    %  lib.showMisses('nCk_fn', nCk_fn);
    %  lib.showMisses('rho_fn', rho_fn);
    %  lib.showMisses('piFunc_fn', piFunc_fn);
end
save( strcat(fileTagTh, '_', ...
    num2str(k), '_', ...
    num2str(NmulMax), '_', ...
    num2str(pStart), '_', ...
    num2str(pStep), '_', ...
    num2str(q), '_', ...
    num2str(pep), '_', num2str(pruneStatus), '.mat'), 'pFullRank_Th', 'pFullRank_ThTime', 'pFullRank_soa' );

try
    fileTagExpTh;
    pFullRank_ThApp = zeros(1,NmulMax + k);
    parfor n = k : (NmulMax * k)
        fprintf('[ThApp] q = %i, k = %i, n = %i, pStart = %f, pStep = %f, PEP = %f\n', q, k, n, pStart, pStep, pep);
        fun = @(n_) lib.fullRankP_appHeur(n_, k, lib.pGen( pStart, pStep, n_, q ), q, pruneStatus);
        pFullRank_ThApp(n) = lib.decP(n, k, pep, fun, nCk_fn);
    end
    save( strcat(fileTagExpTh, '_', ...
        num2str(k), '_', ...
        num2str(NmulMax), '_', ...
        num2str(pStart), '_', ...
        num2str(pStep), '_', ...
        num2str(q), '_', ...
        num2str(pep), '_', num2str(pruneStatus), '.mat'), 'pFullRank_ThApp' );
catch
end
