function [decode, intercept] = getInterceptProb(K, N, Q, p, PEP, forceInt)
    pepBob  = PEP(1);
    pepEve  = PEP(2);
    pepAck  = PEP(3);

    %---%
    clearAllMemoizedCaches;
    rPA = memoize(@lib.rankProbExact);
    rPA.CacheSize = 5e5;

    P  = genTransMatrix(K, Q, p, pepBob, pepEve, pepAck, rPA);
    PN = expomentiateMatrix(P,N);
    try
        forceInt;
        decode = sum( PN( end, (0:(K+1):(K+1)^2) + 1 ) );
        intercept = NaN;
    catch
        intercept = sum( PN( end, (0:(K+1):(K+1)^2) + 1 ) );
        decode = sum( PN( end, (1:2*(K+1)) ) );
    end
    
%     Pbob = genTransMatrixBob(K, Q, p, pepBob);
%     PN = Pbob^N;
%     decodeMRK = PN(K+1,1);
%     decodeTVT = simLib.fRPA(K, N, p, Q, pepBob);
%     assert(decode - decodeMRK < 1e-10);
end

function [Pbob] = genTransMatrixBob(K, Q, p, pepBob)
    Pbob = zeros(K+1,K+1);
    for k = K:-1:1
        dofBob_ = lib.rankProbExact(K-k,K,Q,p);
        NotBob = pepBob + (1-pepBob) * (1-dofBob_);
        Pbob(k+1,k+1) = NotBob;
        Pbob(k+1,k) = 1 - NotBob;
    end
    Pbob(1,1) = 1;
end

function [o] = getTrans_I(K, Q, p, pepBob, pepEve, dofB0, dofE0, dofB1, dofE1, rPA)
    if dofB0 == dofB1 && dofE0 + 1 == dofE1 % Move Horiz.
        if dofB0 <= dofE0
            o = pepBob * (1-pepEve) * rPA(dofE0,K,Q,p);
        else
            o = pepBob * (1-pepEve) * rPA(dofE0,K,Q,p) + ...
               (1-pepBob) * (1-pepEve) * (rPA(dofE0,K,Q,p) - rPA(dofB0,K,Q,p));
        end
    elseif dofB0 + 1 == dofB1 && dofE0 == dofE1 % Move Vert.
        if dofE0 <= dofB0
            o = pepEve * (1-pepBob) * rPA(dofB0,K,Q,p);
        else
            o = pepEve * (1-pepBob) * rPA(dofB0,K,Q,p) + ...
               (1-pepBob) * (1-pepEve) * (rPA(dofB0,K,Q,p) - rPA(dofE0,K,Q,p));
        end
    elseif dofB0 + 1 == dofB1 && dofE0 + 1 == dofE1 % Move Diag.
        o = (1-pepBob) * (1-pepEve) * rPA(max(dofB0,dofE0),K,Q,p);
    elseif dofB0 == dofB1 && dofE0 == dofE1 % Do not move
        o = NaN;
    end
end

function [Pfinal] = genTransMatrix(K, Q, p, pepBob, pepEve, pepAck, rPA)
    Rs = (K + 1)^2 + (K + 1);
    Cs = Rs;
    P = zeros(Rs, Cs);
    Pidx = zeros(K+2, K+1);
    tmp_ = 0;
    for i = fliplr((0:(K+1)) + 1)
        for j = fliplr((0:K) + 1)
            Pidx(i,j) = tmp_;
            tmp_ = tmp_ + 1;
        end
    end
    
    partI_ = Pidx(1:(K-1),1:K);
    for r_ = 1:(K-1)
        for c_ = 1:K
            r = partI_(r_,c_);
            c = [r - 1, r - (K + 1), r - 1 - (K + 1), r];
%             dofBob_ = ( 1 - lib.condRankP(K-state2def(r,K,1), K, p, Q, nCk, rho, piF) );
%             dofEve_ = ( 1 - lib.condRankP(K-state2def(r,K,2), K, p, Q, nCk, rho, piF) );
%             NotBob = pepBob + (1-pepBob) * dofBob_;
%             NotEve = pepEve + (1-pepEve) * dofEve_;
            for i_ = 1:4
                P(r+1,c(i_)+1) = getTrans_I(K, Q, p, pepBob, pepEve, ...
                                            K-state2def(r,K,1), K-state2def(r,K,2), ...
                                            K-state2def(c(i_),K,1), K-state2def(c(i_),K,2),rPA);
                if isnan(P(r+1,c(i_)+1))
                    P(r+1,c(i_)+1) = 1 - sum(P(r+1,c(1:3)+1));
                end
%                 if i_ == 1
%                     P(r+1,c(i_)+1) = NotBob * NotEve;
%                 elseif i_ == 2
%                     P(r+1,c(i_)+1) = NotBob * (1-NotEve);
%                 elseif i_ == 3
%                     P(r+1,c(i_)+1) = (1-NotBob) * NotEve;
%                 elseif i_ == 4
%                     P(r+1,c(i_)+1) = (1-NotBob) * (1-NotEve);
%                 end
            end
        end
    end
    
    partIa_ = Pidx(K,1:K);
    for r_ = partIa_
        c = [ r_-(K+1), r_-2*(K+1), r_-1, r_-(K+1)-1, r_-2*(K+1) - 1, r_];
                                        
%         dofBob_ = ( 1 - lib.condRankP(K-state2def(r_,K,1), K, p, Q, nCk, rho, piF) );
%         dofEve_ = ( 1 - lib.condRankP(K-state2def(r_,K,2), K, p, Q, nCk, rho, piF) );
%         NotBob = pepBob + (1-pepBob) * dofBob_;
%         NotEve = pepEve + (1-pepEve) * dofEve_;
        for i_ = 1:6
            if i_ == 1
                P(r_+1,c(i_)+1) = pepAck * getTrans_I(K, Q, p, pepBob, pepEve, ...
                                                      K-state2def(r_,K,1), K-state2def(r_,K,2), ...
                                                      K-state2def(c(i_),K,1), K-state2def(c(i_),K,2),rPA);
            elseif i_ == 2
                P(r_+1,c(i_)+1) = (1-pepAck) * getTrans_I(K, Q, p, pepBob, pepEve, ...
                                                      K-state2def(r_,K,1), K-state2def(r_,K,2), ...
                                                      K-state2def(c(i_),K,1), K-state2def(c(i_),K,2),rPA);
            elseif i_ == 3
                P(r_+1,c(i_)+1) = getTrans_I(K, Q, p, pepBob, pepEve, ...
                                             K-state2def(r_,K,1), K-state2def(r_,K,2), ...
                                             K-state2def(c(i_),K,1), K-state2def(c(i_),K,2),rPA);
            elseif i_ == 4
                P(r_+1,c(i_)+1) = pepAck * getTrans_I(K, Q, p, pepBob, pepEve, ...
                                                      K-state2def(r_,K,1), K-state2def(r_,K,2), ...
                                                      K-state2def(c(i_),K,1), K-state2def(c(i_),K,2),rPA);
            elseif i_ == 5
                P(r_+1,c(i_)+1) = (1-pepAck) * getTrans_I(K, Q, p, pepBob, pepEve, ...
                                                          K-state2def(r_,K,1), K-state2def(r_,K,2), ...
                                                          K-state2def(c(i_),K,1), K-state2def(c(i_),K,2),rPA);
            elseif i_ == 6
                P(r_+1,c(i_)+1) = 1 - sum(P(r_+1,c(1:6)+1));
            end
        end
    end
    
    partIb_ = Pidx(K+1,1:K);
    for r_ = partIb_
        c = [ r_, r_-1,  r_-(K+1), r_-(K+1)-1];
        dofEve_ = rPA(K-state2def(r_,K,2),K,Q,p);
        NotEve = pepEve + (1-pepEve) * (1-dofEve_);
        for i_ = 1:4
            if i_ == 1
                P(r_+1,c(i_)+1) = NotEve * pepAck;
            elseif i_ == 2
                P(r_+1,c(i_)+1) = (1-NotEve) * pepAck;
            elseif i_ == 3
                P(r_+1,c(i_)+1) = NotEve * (1-pepAck);
            elseif i_ == 4
                P(r_+1,c(i_)+1) = (1-NotEve) * (1-pepAck);
            end
        end
    end
    
    for ab_ = 0:K
        P(ab_ + 1, ab_ + 1) = 1;
    end
    
    partIV_ = Pidx(1:(K-1),K+1);
    for r_ = 1:(K-1)
        dofBob_ = rPA(K-state2def(partIV_(r_),K,1),K,Q,p);
        NotBob = pepBob + (1-pepBob) * (1-dofBob_);
        P(partIV_(r_) + 1, partIV_(r_) + 1) = NotBob;
        P(partIV_(r_) + 1, partIV_(r_) - (K + 1) + 1 ) = (1-NotBob);
    end
    
    partIVa_ = Pidx(K,K+1);
    for r_ = partIVa_
        c = [ r_, r_-(K+1), r_-2*(K+1)];
        dofBob_ = rPA(K-state2def(r_,K,1),K,Q,p);
        NotBob = pepBob + (1-pepBob) * (1-dofBob_);
        for i_ = 1:3
            if i_ == 1
                P(r_+1,c(i_)+1) = NotBob;
            elseif i_ == 2
                P(r_+1,c(i_)+1) = (1-NotBob) * pepAck;
            elseif i_ == 3
                P(r_+1,c(i_)+1) = (1-NotBob) * (1-pepAck);
            end
        end
    end
    
    partIVb_ = Pidx(K+1,K+1);
    P(partIVb_+1,partIVb_+1) = pepAck;
    P(partIVb_+1,partIVb_ - (K+1) +1) = (1-pepAck);
    
    Pfinal = P;
%     Pfinal = [ zeros((K+1)^2,2), P ];
%     Pfinal((1:K)+1,2) = (1-pepAck);
%     Pfinal = [zeros(2,(K+1)^2 + 2); Pfinal];
%     Pfinal(1,1) = 1;
%     Pfinal(2,2) = 1;
%     Pfinal(3,1) = (1-pepAck);
    
    % ASSERT
    if abs(sum(sum(Pfinal,2) - ones(Rs,1))) > 1e-10
        error('P matrix not valid!');
    end
end

function [def] = state2def(stateId, K, idx)
    if idx == 1 % Bob
        def = floor(stateId/(K+1)) - 1;
        if def < 0
            def = 0;
        end
    else % Eve
        def = mod(stateId,K+1);
    end
end

function [PN] = expomentiateMatrix(P, N)
    PN = P^N;
end
