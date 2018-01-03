function [ rho ] = rhoFunc(w, q, p)
    rho = prod((1/q) * ( 1 + (q-1) * ( 1 - (q/(q-1)) * (1-p) ).^w ));
end
