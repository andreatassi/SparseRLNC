function [pOpt_th, decProbOpt_th, interceptProbOpt_th, decProbNOpt_th, interceptProbNOpt_th] = ...
          getOptIntercept(K, N, Q, pepBob, pepEve, pepACK, Rb, isLegacy, itNo)
      try
          isLegacy;
      catch
          isLegacy = 0;
      end
      if isLegacy == 0 % Olly's approx. (Markov)
          f = @(x)(lib.getInterceptProb(K, N, Q, x, [pepBob, pepEve, pepACK]) - Rb);
          if f(1/Q) >= 0
              pOpt_th = lib.bsct(1/Q, 0.999, 1e-10, f);
              [decProbOpt_th_, interceptProbOpt_th_] = lib.getInterceptProb(K, N, Q, pOpt_th, [pepBob, pepEve, pepACK]);
              fint = @(x)lib.getInterceptProb(K, N, Q, x, [pepBob, pepEve, pepACK], true);
              pOptEx_th = fminbnd(fint,1/Q,pOpt_th);
              [decProbOpt_th__, interceptProbOpt_th__] = lib.getInterceptProb(K, N, Q, pOptEx_th, [pepBob, pepEve, pepACK]);
              if interceptProbOpt_th_ <= interceptProbOpt_th__
                  decProbOpt_th = decProbOpt_th_;
                  interceptProbOpt_th = interceptProbOpt_th_;
              else
                  decProbOpt_th = decProbOpt_th__;
                  interceptProbOpt_th = interceptProbOpt_th__;
              end
              [decProbNOpt_th, interceptProbNOpt_th] = lib.getInterceptProb(K, N, Q, 1/Q, [pepBob, pepEve, pepACK]);
          else
              pOpt_th = NaN;
              interceptProbOpt_th = NaN;
              decProbOpt_th = NaN;
              interceptProbNOpt_th = NaN;
              decProbNOpt_th = NaN;
          end
      elseif isLegacy == 1 % Olly's approx. (Combinatorix)
          f = @(x)(simLib.fRPA(K, N, x, Q, pepBob) - Rb);
          if ( (1/Q)==0.5 && f(1/Q) >= 0 ) || ( (1/Q)<0.5 && f((1/Q) + 0.0001) >= 0 )
              if K > 20
                pp_ = 0.99;
              else
                pp_ = 0.999;
              end
              
              while f(pp_) > 0
                  pp_ = pp_ - 0.001;
              end 
              pOpt_th = lib.bsct(1/Q, pp_, 1e-5, f);
              decProbOpt_th_ = simLib.fRPA(K, N, pOpt_th, Q, pepBob);
              [~, interceptProbOpt_th_] = lib.getInterceptProb(K, N, Q, pOpt_th, [pepBob, pepEve, pepACK]);
              fint = @(x)lib.getInterceptProb(K, N, Q, x, [pepBob, pepEve, pepACK], true);
              pOptEx_th = fminbnd(fint,1/Q,pOpt_th);
              decProbOpt_th__ = simLib.fRPA(K, N, pOptEx_th, Q, pepBob);
              [~, interceptProbOpt_th__] = lib.getInterceptProb(K, N, Q, pOptEx_th, [pepBob, pepEve, pepACK]);
              if interceptProbOpt_th_ <= interceptProbOpt_th__
                  decProbOpt_th = decProbOpt_th_;
                  interceptProbOpt_th = interceptProbOpt_th_;
              else
                  pOpt_th = pOptEx_th;
                  decProbOpt_th = decProbOpt_th__;
                  interceptProbOpt_th = interceptProbOpt_th__;
              end
              decProbNOpt_th = simLib.fRPA(K, N, 1/Q, Q, pepBob);
              [~, interceptProbNOpt_th] = lib.getInterceptProb(K, N, Q, 1/Q, [pepBob, pepEve, pepACK]);
          else
              pOpt_th = NaN;
              interceptProbOpt_th = NaN;
              decProbOpt_th = NaN;
              interceptProbNOpt_th = NaN;
              decProbNOpt_th = NaN;
          end
      elseif isLegacy == 2 % Monte Carlo approx.
          if Q == 2
            sLineX = [0.5:0.1:0.9,0.95];
          elseif Q == 2^8
              sLineX = [2^(-8):0.1:0.9,0.9,0.95];
          end
          tmpDec = NaN * ones(1,length(sLineX));
          i = 0;
          for p = sLineX
            i = i + 1;
            [~, tmpDec(i)] = simLib.getRank2NodeBroadcast(K, N, Q, ones(1,N)*p, false, false, 2, [pepBob, pepEve, pepACK], itNo, 3, 1);
          end
          aa = spline(sLineX,tmpDec);
          f = @(x)(ppval(aa,x) - Rb);
          if f(1/Q) >= 0
              pOpt_th = lib.bsct(1/Q, 0.999, 1e-10, f);
              decProbOpt_th_ = ppval(aa,pOpt_th);
              [~, interceptProbOpt_th_] = lib.getInterceptProb(K, N, Q, pOpt_th, [pepBob, pepEve, pepACK]);
              fint = @(x)lib.getInterceptProb(K, N, Q, x, [pepBob, pepEve, pepACK], true);
              pOptEx_th = fminbnd(fint,1/Q,pOpt_th);
              decProbOpt_th__ = ppval(aa,pOptEx_th);
              [~, interceptProbOpt_th__] = lib.getInterceptProb(K, N, Q, pOptEx_th, [pepBob, pepEve, pepACK]);
              if interceptProbOpt_th_ <= interceptProbOpt_th__
                  decProbOpt_th = decProbOpt_th_;
                  %interceptProbOpt_th = interceptProbOpt_th_;
                  [interceptProbOpt_th, ~] = simLib.getRank2NodeBroadcast(K, N, Q, ones(1,N)*pOpt_th, false, false, 2, [pepBob, pepEve, pepACK], itNo, 3, 1);
              else
                  decProbOpt_th = decProbOpt_th__;
                  [interceptProbOpt_th, ~] = simLib.getRank2NodeBroadcast(K, N, Q, ones(1,N)*pOptEx_th, false, false, 2, [pepBob, pepEve, pepACK], itNo, 3, 1);
              end
              decProbNOpt_th = ppval(aa,1/Q);
              [~, interceptProbNOpt_th] = lib.getInterceptProb(K, N, Q, 1/Q, [pepBob, pepEve, pepACK]);
          else
              pOpt_th = NaN;
              interceptProbOpt_th = NaN;
              decProbOpt_th = NaN;
              interceptProbNOpt_th = NaN;
              decProbNOpt_th = NaN;
          end
      end
end
