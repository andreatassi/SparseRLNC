%% Fig. 1
clearAllMemoizedCaches;
clearvars;
tau         = 1e-4;
k           = 20;
q           = 2;
p           = 0.8;
NmulMax     = 3;
mMax        = 2:k;
P_Heur = NaN * zeros(k * NmulMax, k);
mOpt = NaN * zeros(1,k * NmulMax);
dataFileName = strcat('data/tV00_',num2str(k),'_', num2str(p),'_',num2str(q),'.mat');
nCk_fn = memoize(@lib.nCk);
nCk_fn.CacheSize = 5e5;
rho_fn = memoize(@lib.rhoFunc);
rho_fn.CacheSize = 5e5;
piFunc_fn = memoize(@lib.piFunc);
piFunc_fn.CacheSize = 5e5;
for m = mMax
    stopHeur = false;
    for n = k : (k * NmulMax)
        fprintf('[TH-00] q = %i, m = %i, p = %f, k = %i, n = %i\n', q, m, p, k, n);
        if stopHeur == false
            [ P_Heur(n, m), ~, ~ ] = lib.fullRankP_ts( n, k, lib.pGen( p, 0, n, q ), q, m, NaN, false, nCk_fn, rho_fn, piFunc_fn );
            if P_Heur(n) >= 1-(1e-4)
                stopHeur = true;
            end
        else
            P_Heur(n) = 1;
        end
    end
end
for n = k : (k * NmulMax)
    fprintf('[TH-00] q = %i, m = %i, p = %f, k = %i, n = %i\n', q, max(mMax), p, k, n);
    [ ~, mOpt(n), ~ ] = lib.fullRankP_ts( n, k, lib.pGen( p, 0, n, q ), q, max(mMax), tau, false, nCk_fn, rho_fn, piFunc_fn );
end
save(dataFileName, 'P_Heur', 'mOpt');

%% Data for Figs. 2 and 3
try
    simLib.getRank(3,3,2,0.5*ones(1,3),false,false,0,10,3);
catch
    simLib.mexGen;
end
clearAllMemoizedCaches;
clearvars;
fileTagSim    = 'data/V01';
fileTagTh     = 'data/tV01';
K           = [10 20 50];
Q           = [2, 2^4];
pSTART      = [0.7, 0.9];
pSTEP       = 0;
PEP         = 0.1;
PRUNEme     = false;
NmulMax     = 30;
it          = 1e5;
seed        = 3;
tau         = 1e-10;

nCk_fn = memoize(@lib.nCk);
nCk_fn.CacheSize = 5e5;
rho_fn = memoize(@lib.rhoFunc);
rho_fn.CacheSize = 5e5;
piFunc_fn = memoize(@lib.piFunc);
piFunc_fn.CacheSize = 5e5;
for q = Q
    for k = K
        mMax      = ceil(3*k/4);
        for pStart = pSTART
            for pStep = pSTEP
                for pep = PEP
                    for pruneStatus = PRUNEme
                        lib.batchAtomHelperVS
                    end
                end
            end
        end
    end
end

% Data for Figs. 2 and 3 (IA)
clearAllMemoizedCaches;
clearvars;
nCk_fn = memoize(@lib.nCk);
nCk_fn.CacheSize = 5e5;
rho_fn_ia = memoize(@lib.rhoFunc_ia);
rho_fn_ia.CacheSize = 5e5;
fileTagTh_soa    = 'data/iaV01';
K           = [10 20 50];
Q           = [2 2^4];
pSTART      = [0.7, 0.9];
pSTEP       = 0;
PEP         = 0.1;
NmulMax     = 30;
pruneStatus = false;

nCk_fn = memoize(@lib.nCk);
nCk_fn.CacheSize = 5e5;
rho_fn = memoize(@lib.rhoFunc);
rho_fn.CacheSize = 5e5;
for q = Q
    for k = K
        for pStart = pSTART
            for pStep = pSTEP
                for pep = PEP
                    lib.batchAtomHelperIA
                end
            end
        end
    end
end

%% Data for Fig. 4
try
    simLib.getRank(3,3,2,0.5*ones(1,3),false,false,0,10,3);
catch
    simLib.mexGen;
end
clearAllMemoizedCaches;
clearvars;
fileTag    = 'data/V02';
K           = [20, 50];
Q           = [2, 2^4];
pSTART      = 0.6:0.05:0.85;
pSTEP       = 0;
PEP         = 0.1;
PRUNEme     = false;
it          = 1e5;
seed        = 3;
tau         = 1e-10;

nCk_fn = memoize(@lib.nCk);
nCk_fn.CacheSize = 5e5;
rho_fn = memoize(@lib.rhoFunc);
rho_fn.CacheSize = 5e5;
rho_fn_ia = memoize(@lib.rhoFunc_ia);
rho_fn_ia.CacheSize = 5e5;
piFunc_fn = memoize(@lib.piFunc);
piFunc_fn.CacheSize = 5e5;
for q = Q
    for k = K
        mMax      = ceil(3*k/4);
        if k == 20
            NmulMax = 25/20;
        else
            NmulMax = 110/100;
        end
        pStartIdx = 1;
        for pStart = pSTART
            for pStep = pSTEP
                pepIdx = 1;
                for pep = PEP
                    for pruneStatus = PRUNEme
                        doNotSave = true;
                        lib.batchAtomHelperVSsp
                        pRXSim(q,k,pStartIdx,pepIdx) = pFullRank_Sim;
                        pRXTh(q,k,pStartIdx,pepIdx) = pFullRank_Th;
                        pRXsoa_UB(q,k,pStartIdx,pepIdx) = pFullRank_soa_UB;
                        pRXsoa_LB(q,k,pStartIdx,pepIdx) = pFullRank_soa_LB;
                    end
                    pepIdx = pepIdx + 1;
                end
            end
            pStartIdx = pStartIdx + 1;
        end
    end
end
save( strcat(fileTag, '.mat'), 'pRXSim', 'pRXTh', 'pRXsoa_UB', 'pRXsoa_LB' );

%% Data for Tab. 1
try
    simLib.getRank(3,3,2,0.5*ones(1,3),false,false,0,10,3);
catch
    simLib.mexGen;
end
clearAllMemoizedCaches;
clearvars;
fileTag    = 'data/T00';
K           = [10, 20, 50, 100];
Q           = 2;
pSTART      = 0.8;
pSTEP       = 0;
PRUNEme     = false;
it          = 1e5;
seed        = 3;
tau         = 0;
runs        = 10;

nCk_fn = memoize(@lib.nCk);
nCk_fn.CacheSize = 9e20;
rho_fn = memoize(@lib.rhoFunc);
rho_fn.CacheSize = 9e20;
piFunc_fn = memoize(@lib.piFunc);
piFunc_fn.CacheSize = 1e30;
kIdx = 1;
for k = K
    mMax      = k;
    rr_(kIdx) = 0;
    for run = 1:runs
        clearAllMemoizedCaches;
        N = k + k/2;
        [~,m_,tt_] = lib.fullRankP_ts( N, k, lib.pGen( pSTART, pSTEP, N, Q ), Q, mMax, tau, PRUNEme, nCk_fn, rho_fn, piFunc_fn );
        rr_(kIdx) = rr_(kIdx) + tt_;
    end
    mm_(kIdx) = m_;
    mm_(kIdx)
    rr_(kIdx) = (rr_(kIdx) / runs) / m_;
    rr_(kIdx)
    kIdx = kIdx + 1;
end
save( strcat(fileTag, '.mat'), 'mm_', 'rr_' );

%% Data for Fig. 5
try
    simLib.getRank(3,3,2,0.5*ones(1,3),false,false,0,10,3);
catch
    simLib.mexGen;
end
clearAllMemoizedCaches;
clearvars;
fileTag    = 'data/V04';
K           = [20, 50, 100];
Q           = 2;
pSTART      = [0.7, 0.9];
pSTEP       = 0;
pruneStatus = false;
it          = 1e5;
seed        = 3;
tau         = 1e-10;
erasure_prob  = [0.01, 0.05:0.05:0.25];

nCk_fn = memoize(@lib.nCk);
nCk_fn.CacheSize = 5e5;
rho_fn = memoize(@lib.rhoFunc);
rho_fn.CacheSize = 5e5;
piFunc_fn = memoize(@lib.piFunc);
piFunc_fn.CacheSize = 5e5;
pStep = pSTEP;
for k = K
    for q = Q
        mMax      = ceil(3*k/4);
        pStartIdx = 1;
        for pStart = pSTART
            pepIdx = 1;
            for pep = erasure_prob
                lib.batchAtomHelperVSavg
                avgRXSim(q,k,pStartIdx,pepIdx) = avgRX_Sim;
                avgRXTh(q,k,pStartIdx,pepIdx) = avgRX_Th;
                pepIdx = pepIdx + 1;
                save( strcat(fileTag, '.mat'), 'avgRXSim', 'avgRXTh' );
            end
            pStartIdx = pStartIdx + 1;
        end
    end
end
save( strcat(fileTag, '.mat'), 'avgRXSim', 'avgRXTh' );
