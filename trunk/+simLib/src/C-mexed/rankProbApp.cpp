#include "rankProbApp.hpp"
#include "mex.h"

#define MAX 100
double cache_nCk[MAX][MAX];
double cache_piF[MAX][MAX];

double condRankP(unsigned int r, unsigned int c, double p, unsigned int q) {
//     if (p == 1/(double)q) {
//         return 1 - pow((double)p,(double)r-(double)c);
//     }
//         
//     if (r == 0) {
//         return 1 - pow(p,(double)c);
//     } else if (r == 1) {
//         return 1 - rhoF(2,c,q,p);
//     }
    
    if (p == 1/(double)q) {
        return 1-pow(p,c-r);
    } else {
        double expTerm = 0;
        for (int s = 2; s <= r+1; s++) {
    //      expTerm = expTerm + nCkF(r,s-1) * pow(q-1,s) * piF(s, c, q, p) / pow((1-pow(p,c)),s);
            expTerm = expTerm + nCkF(r,s-1) * piF(s, c, q, p) / pow((1-pow(p,c)),s);
        }
        return exp(-expTerm) * (1-pow(p,c));
    }
}

double nCkF(unsigned int n, unsigned int k) {
    if ( cache_nCk[n][k] < 0 ) {
        cache_nCk[n][k] = boost::math::binomial_coefficient<double>(n, k);
    }
    return cache_nCk[n][k];
}

double rhoF(unsigned int l, unsigned int e, unsigned int q, double p) {
    return pow(( (1/(double)q) * ( 1 + ((double)q-1) * pow( 1 - ((double)q/((double)q-1)) * (1-p),l) )),e);
}

double piF(unsigned int l, unsigned int e, unsigned int q, double p) {
    if ( cache_piF[l][e] >= 0 ) {
        return cache_piF[l][e];
    }
    
    if ( l == 1 ) {
        cache_piF[l][e] = rhoF(1,e,q,p);
        return cache_piF[l][e];
    } else {
        double tmpVal = 0;
        for(int s=l-1; s >= 1; s--) {
                double yy_ = nCkF(l-1,s);
                tmpVal = tmpVal + yy_ * rhoF(s,e,q,p) * piF(l-s,e,q,p);
//                  mexPrintf("-------------------\n");
//                 mexPrintf("l-s: %u\n", l-s);
//                 mexPrintf("e: %u\n", e);
        }
        cache_piF[l][e] = rhoF(l,e,q,p) - tmpVal;
        return cache_piF[l][e];
    }
}

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[]) {
    
    for (int n = 0; n < MAX; n++) {
        for (int k = 0; k < MAX; k++) {
            cache_nCk[n][k] = -1;
            cache_piF[n][k] = -1;
        }
    }

    //mexPrintf("/*");
    
    unsigned int r = (unsigned int) mxGetScalar(prhs[0]);
    unsigned int c = (unsigned int) mxGetScalar(prhs[1]);
    double       p = (double) mxGetScalar(prhs[2]);
    unsigned int q = (unsigned int) mxGetScalar(prhs[3]);
    
    if(nlhs > 1) {
        mexErrMsgTxt("Too many output arguments.");
    }
    plhs[0] = mxCreateDoubleScalar(condRankP(r, c, p, q));
}
