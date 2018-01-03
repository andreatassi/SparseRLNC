function [ rho ] = rhoFunc_ia(w, q, p)
    rho = q^-1 + (1 - q^-1) * ( 1 - ( (1-p)/(1-q^-1) ) )^w;
end
