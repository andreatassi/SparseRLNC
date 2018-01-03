function [ p_i ] = piFunc(l, q, p, nCk_fn, rho_fn, piFunc_fn)
%     myStr = piFunc_strGen(l, N, q, p, nCk_fn, rho_fn);
%     str2func(myStr);
    if l == 1
        p_i = rho_fn(1,q,p);
    else
        tmpVal = 0;
        for s = (l-1):-1:1
            yy_ = nCk_fn(l-1,s);
            tmpVal = tmpVal + yy_ * rho_fn(s,q,p) * piFunc_fn(l-s,q,p,nCk_fn,rho_fn,piFunc_fn);
        end
        p_i = rho_fn(l,q,p) - tmpVal;
    end
end
% 
% function [ p_i ] = piFunc_strGen(l, N, q, p, nCk_fn, rho_fn)
%     if l == 1
%         p_i = 'rho_fn(1,q,p)';
%     else
%         tmpVal = '';
%         for s = 1:(l-1)
%             if s == 1
%                 tmpVal = strcat(tmpVal, 'nCk_fn(l-1,s) * rho_fn(s,q,p) * (', piFunc_strGen(l-s,N,q,p,nCk_fn,rho_fn), ')' );
%             else
%                 tmpVal = strcat(tmpVal, '+ nCk_fn(l-1,s) * rho_fn(s,q,p) * (', piFunc_strGen(l-s,N,q,p,nCk_fn,rho_fn), ')' );
%             end
%         end
%         p_i = strcat('rho_fn(l,q,p)', '-', tmpVal);
%     end
% end
