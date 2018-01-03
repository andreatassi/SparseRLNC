P_Heur = NaN * zeros(1,k * NmulMax);
P_Heur_SotA = NaN * zeros(1,k * NmulMax);

stopHeur = false;
for n = k : (k * NmulMax)
    fprintf('[TH-00] q = %i, mMax = %i, p = %f, k = %i, n = %i\n', q, mMax, p, k, n);
    if stopHeur == false
        try
            epsilon;
            fun = @(n) lib.fullRankP(n, k, p, q, mMax, tau);
            P_Heur(n) = lib.decP(n, k, epsilon, fun);
        catch
            P_Heur(n) = lib.fullRankP(n, k, p, q, mMax, tau);
        end
        if P_Heur(n) >= 1-(1e-4)
            stopHeur = true;
        end
    else
        P_Heur(n) = 1;
    end
    try
        epsilon;
        fun = @(n) lib.getAvgNumTx( k, n, p, q, 0 );
        P_Heur_SotA(n) = lib.decP(n, k, epsilon, fun);
    catch
        P_Heur_SotA(n) = lib.getAvgNumTx( k, n, p, q, 0 );
    end
end
save(dataFileName, 'P_Heur', 'P_Heur_SotA');
