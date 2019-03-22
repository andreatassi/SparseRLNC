%% Th [q = 2 and 2^4]
clearAllMemoizedCaches;
clearvars;

Kset           = [5, 20];
Nset           = 0:1:70;
Qset           = [2,2^4];
PEPbobSet      = [0.05, 0.1];
PEPeveSet      = [0.15,0.25];
PEPackSet      = [0.85:0.05:1];
RbSet          = 0.9;
profNo         = 1;
mSeed          = 3;
itNo           = 6e5;
mRep           = 1;

for Rb = RbSet
    for q = Qset
        for k = Kset
            for pepBob = PEPbobSet
                for pepEve = pepBob + PEPeveSet
                    Nset_tmp = k + Nset;
                    tmpLenN = length(Nset_tmp);
                    tmpLenAck = length(PEPackSet);
                    
                    pOpt_th = NaN * ones(tmpLenN,tmpLenAck);
                    decProbOpt_th = NaN * ones(tmpLenN,tmpLenAck);
                    decProbOpt_Sim = NaN * ones(tmpLenN,tmpLenAck);
                    interceptProbOpt_th = NaN * ones(tmpLenN,tmpLenAck);
                    interceptProbOpt_Sim = NaN * ones(tmpLenN,tmpLenAck);
                    decProbNOpt_th = NaN * ones(tmpLenN,tmpLenAck);
                    decProbNOpt_Sim = NaN * ones(tmpLenN,tmpLenAck);
                    interceptProbNOpt_th = NaN * ones(tmpLenN,tmpLenAck);
                    interceptProbNOpt_Sim = NaN * ones(tmpLenN,tmpLenAck);

                    pACK = 1;
                    for pepACK = PEPackSet
                        pIt = 1;
                        fprintf('\n[D00] q = %i, k = %i, pepBob = %f, pepEve = %f, pepACK = %f\n', q, k, pepBob, pepEve, pepACK);
                        fprintf('\t |---->> ');
                        parfor n = 1:tmpLenN
                            n_temp = Nset_tmp(n);
                            fprintf('%i of %i ... ', n_temp, Nset_tmp(tmpLenN));
                            try
                                [pOpt_th(n,pACK), decProbOpt_th(n,pACK), interceptProbOpt_th(n,pACK), decProbNOpt_th(n,pACK), interceptProbNOpt_th(n,pACK)] = lib.getOptIntercept(k, n_temp, q, pepBob, pepEve, pepACK, Rb, profNo, itNo);
                            catch
                            end
                        end 
                        fprintf('\n[S00] q = %i, k = %i, pepBob = %f, pepEve = %f, pepACK = %f\n', q, k, pepBob, pepEve, pepACK);
                        fprintf('\t |---->> ');
                        interceptProbOpt_Sim_loc = [];
                        decProbOpt_Sim_loc = [];
                        interceptProbNOpt_Sim_loc = [];
                        decProbNOpt_Sim_loc = [];
                        parfor n = 1:tmpLenN
                            n_temp = Nset_tmp(n);
                            fprintf('%i of %i ... ', n_temp, Nset_tmp(tmpLenN));
                            if ~isnan(pOpt_th(n,pACK))
                                [interceptProbOpt_Sim_loc_, decProbOpt_Sim_loc_] = simLib.getRank2NodeBroadcast(k, n_temp, q, ones(1,n_temp)*pOpt_th(n,pACK), false, false, 2, [pepBob, pepEve, pepACK], itNo, mSeed, mRep);
                                [interceptProbNOpt_Sim_loc_, decProbNOpt_Sim_loc_] = simLib.getRank2NodeBroadcast(k, n_temp, q, ones(1,n_temp)*(1/q), false, false, 2, [pepBob, pepEve, pepACK], itNo, mSeed, mRep);
                                interceptProbOpt_Sim_loc(n) = mean(interceptProbOpt_Sim_loc_);
                                interceptProbNOpt_Sim_loc(n) = mean(interceptProbNOpt_Sim_loc_);
                                decProbOpt_Sim_loc(n) = mean(decProbOpt_Sim_loc_);
                                decProbNOpt_Sim_loc(n) = mean(decProbNOpt_Sim_loc_);
                            end
                        end
                        interceptProbOpt_Sim(:,pACK) = interceptProbOpt_Sim_loc;
                        decProbOpt_Sim(:,pACK) = decProbOpt_Sim_loc;
                        interceptProbNOpt_Sim(:,pACK) = interceptProbNOpt_Sim_loc;
                        decProbNOpt_Sim(:,pACK) = decProbNOpt_Sim_loc;

                        fileTag = 'data/TH-';
                        fileTag = strcat( fileTag, num2str(profNo), '-', num2str(q), '-', num2str(k), '-', num2str(pepBob), '-', num2str(pepEve), '-', num2str(Rb) );
                        save( strcat(fileTag, '.mat'), 'pOpt_th', 'decProbOpt_th', 'interceptProbOpt_th', 'decProbNOpt_th', 'interceptProbNOpt_th', ...
                                                        'interceptProbOpt_Sim', 'decProbOpt_Sim', 'interceptProbNOpt_Sim', 'decProbNOpt_Sim');
                        pACK = pACK + 1;
                    end

                end
            end
        end
    end
end

%% Th [Validation (q = 2 and 2^4)]
clearAllMemoizedCaches;
clearvars;

Kset           = [5, 15, 20];
Nset           = [0:1:20];
Qset           = [2,2^4];
PEPbobSet      = [0.01, 0.05, 0.1];
PEPeveSet      = [0, 0.15, 0.25];
PEPackSet      = 0:0.05:1;
Pset{Qset(1)}  = 0.5:0.01:0.9;
Pset{Qset(2)}  = [2^(-4):0.02:0.9, 0.9];
mSeed          = 3;
itNo           = 1e5;
mRep           = 1;

for q = Qset
    for k = Kset
        for pepBob = PEPbobSet
            for pepEve = pepBob + PEPeveSet
                Nset_tmp = k + Nset;
                tmpLenN = length(Nset_tmp);
                tmpLenP = length(Pset{q});
                tmpLenAck = length(PEPackSet);

                interceptProb_th = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                interceptProb_sim = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb_thMKV = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb_thTVT = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb_sim = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                                
                pACK = 1;
                for pepACK = PEPackSet
                    pIt = 1;
                    for p = Pset{q}
                        fprintf('\n[D00] q = %i, k = %i, pepBob = %f, pepEve = %f, pepACK = %f, p = %f\n', q, k, pepBob, pepEve, pepACK, p);
                        fprintf('\t |---->> ');
                        parfor n = 1:tmpLenN
                            n_temp = Nset_tmp(n);
                            fprintf('%i of %i ... ', n_temp, Nset_tmp(tmpLenN));
                            [decProb_thMKV(pIt,n,pACK), interceptProb_th(pIt,n,pACK)] = lib.getInterceptProb(k, n_temp, q, p, [pepBob, pepEve, pepACK]);
                            decProb_thTVT(pIt,n,pACK) = simLib.fRPA(k, n_temp, p, q, pepBob);
                            [interceptProb_sim(pIt,n,pACK), decProb_sim(pIt,n,pACK)] = simLib.getRank2NodeBroadcast(k, n_temp, q, ones(1,n_temp)*p, false, false, 2, [pepBob, pepEve, pepACK], itNo, mSeed, mRep);
                        end
                        pIt = pIt + 1;                        
                    end
                                        
                    fileTag = 'data/SIM-';
                    fileTag = strcat( fileTag, num2str(q), '-', num2str(k), '-', num2str(pepBob), '-', num2str(pepEve) );
                    save( strcat(fileTag, '.mat'), 'interceptProb_th', 'interceptProb_sim', 'decProb_thMKV', 'decProb_thTVT', 'decProb_sim');
                    pACK = pACK + 1;
                end
                
            end
        end
    end
end

%% Th [Validation (q = 2 and 2^4)]
clearAllMemoizedCaches;
clearvars;

Kset           = [5, 10];
Nset           = [10, 20];
Qset           = [2,2^4];
PEPbobSet      = [0.01, 0.05, 0.1];
PEPeveSet      = [0.15, 0.25];
PEPackSet      = 0:0.05:1;
Pset{Qset(1)}  = 0.5:0.01:0.9;
Pset{Qset(2)}  = [2^(-4):0.02:0.9, 0.9];
mSeed          = 3;
itNo           = 1e5;
mRep           = 1;

for q = Qset
    for k = Kset
        for pepBob = PEPbobSet
            for pepEve = pepBob + PEPeveSet
                Nset_tmp = k + Nset;
                tmpLenN = length(Nset_tmp);
                tmpLenP = length(Pset{q});
                tmpLenAck = length(PEPackSet);

                interceptProb_th = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                interceptProb_sim = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb_thMKV = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb_thTVT = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb_sim = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                                
                pACK = 1;
                for pepACK = PEPackSet
                    pIt = 1;
                    for p = Pset{q}
                        fprintf('\n[D00] q = %i, k = %i, pepBob = %f, pepEve = %f, pepACK = %f, p = %f\n', q, k, pepBob, pepEve, pepACK, p);
                        fprintf('\t |---->> ');
                        parfor n = 1:tmpLenN
                            n_temp = Nset_tmp(n);
                            fprintf('%i of %i ... ', n_temp, Nset_tmp(tmpLenN));
                            [decProb_thMKV(pIt,n,pACK), interceptProb_th(pIt,n,pACK)] = lib.getInterceptProb(k, n_temp, q, p, [pepBob, pepEve, pepACK]);
                            decProb_thTVT(pIt,n,pACK) = simLib.fRPA(k, n_temp, p, q, pepBob);
                            [interceptProb_sim(pIt,n,pACK), decProb_sim(pIt,n,pACK)] = simLib.getRank2NodeBroadcast(k, n_temp, q, ones(1,n_temp)*p, false, false, 2, [pepBob, pepEve, pepACK], itNo, mSeed, mRep);
                        end
                        pIt = pIt + 1;                        
                    end
                                        
                    fileTag = 'data/SIM-';
                    fileTag = strcat( fileTag, num2str(q), '-', num2str(k), '-', num2str(pepBob), '-', num2str(pepEve) );
                    save( strcat(fileTag, '.mat'), 'interceptProb_th', 'interceptProb_sim', 'decProb_thMKV', 'decProb_thTVT', 'decProb_sim');
                    pACK = pACK + 1;
                end
                
            end
        end
    end
end
