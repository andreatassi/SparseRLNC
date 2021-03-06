function [ x ] = optCode( n, k, q, pep, mMax, tau, nCk_fn, seed )
    lb = (1/q) * ones(n,1);
    ub = ones(n,1);
    
    A = [];
    b = [];
    nlConst = [];
    
    %   4. the GA solver is executed.
    localObj = @(p)objFun(n, k, q, p, pep, mMax, tau, nCk_fn);
    rng(seed,'twister')
    noVars = n;
    intVarsIdx = [];
    [x, ~, exitflag] = ga( localObj, ...
        noVars, ...
        A, b, ...
        [], [], ...
        lb, ub, ...
        nlConst, ...
        intVarsIdx, ...
        gaoptimset( 'Generations', 3000, ... 'PopulationSize', min(max(10*noVars,40),100), ...
        'TolFun', 10^-10, ...
        'TolCon', 10^-10, ... 'PopulationType', 'doubleVector', ...
        'UseParallel', 'never', ...
        'Display','iter' ...
        ) );

    if exitflag ~= 1
        error('GA error!');
    end    
end

function f = objFun(n, k, q, p, pep, mMax, tau, nCk_fn)
    fun_srlnc = @(n_) lib.fullRankP_ts(n_, k, p, q, mMax, tau, nCk_fn);
    fun_rlnc = @(n_) lib.fullRankRLNC(n_, k, q);
    SRLNC = lib.decP(n, k, pep, fun_srlnc, nCk_fn);
    RLNC = lib.decP(n, k, pep, fun_rlnc, nCk_fn);
    f = RLNC - SRLNC;
end
