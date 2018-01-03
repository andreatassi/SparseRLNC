function [ pDof ] = getNDofs( K, dofs, p, q, isLB )
    try
        if isLB
            pDof = (min(p, (1-p)/(q-1)))^(K-dofs);
        else
            pDof = (max(p, (1-p)/(q-1)))^(K-dofs);
        end
    catch
        pDof = (max(p, (1-p)/(q-1)))^(K-dofs);
    end
end
