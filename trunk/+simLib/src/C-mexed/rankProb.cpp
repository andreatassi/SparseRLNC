//mex -v '-I+simLib/src/kodo-20.0.0/bundle_dependencies/boost-abe3de/1.11.0/' +simLib/src/C-mexed/RankProb.cpp -output +simLib/pRlnc

#include "rankProb.hpp"
#include "mex.h"

#define MAX 100
double cache_nCk[MAX][MAX];

double condRankP(unsigned int n, unsigned int k, unsigned int q) {
    double o = 1;
    for(int t = 0; t <= k-1; t ++) {
        o = o * (1-pow(1/(double)q,n-t));
    }
    return o;
}

double nCkF(unsigned int n, unsigned int k) {
    if ( cache_nCk[n][k] < 0 ) {
        cache_nCk[n][k] = boost::math::binomial_coefficient<double>(n, k);
    }
    return cache_nCk[n][k];
}

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[]) {
    
    for (int n = 0; n < MAX; n++) {
        for (int k = 0; k < MAX; k++) {
            cache_nCk[n][k] = -1;
        }
    }
    
    unsigned int K = (unsigned int) mxGetScalar(prhs[0]);
    unsigned int N = (unsigned int) mxGetScalar(prhs[1]);
    unsigned int q = (unsigned int) mxGetScalar(prhs[2]);
    double     pep = (double) mxGetScalar(prhs[3]);
    
    if(nlhs > 1) {
        mexErrMsgTxt("Too many output arguments.");
    }
    
    double tmp_ = 0;
    for(int t_ = K; t_ <= N; t_++){
        tmp_ = tmp_ + nCkF(N,t_) * pow(1-pep,t_) * pow(pep,N-t_) * condRankP(t_, K, q);
    }
    
    plhs[0] = mxCreateDoubleScalar(tmp_);
}
