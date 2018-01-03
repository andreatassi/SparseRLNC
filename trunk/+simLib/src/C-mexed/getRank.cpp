#include "getFR.hpp"
#include "mex.h"

template<class Encoder, class Decoder>
struct _simRes simMex(unsigned int K, unsigned int N, double * p, bool isSystematic, bool pruneZeros,
                      double pep, unsigned int iterations, unsigned int seed)
{
    srand(seed);
    
    uint32_t symbols = K;
    uint32_t symbol_size = 1;
    
    int decIt = 0;
    int pTransitionCount = 0;
    unsigned long long int pOpCount = 0;
    kodo::operations_counter tmpOpt;

    Encoder encoder_factory(symbols, symbol_size);
    auto encoder = encoder_factory.build();
    Decoder decoder_factory(symbols, symbol_size);
    auto decoder = decoder_factory.build();
    for (unsigned int it = 0; it < iterations; it++)
    {
        encoder->initialize(encoder_factory);
        
        if (pruneZeros)
        {
            encoder->set_density( -(1-p[0]) );
        } else {
            encoder->set_density( 1-p[0] );
        }
        encoder->seed(rand());

        decoder->initialize(decoder_factory);

        std::vector<uint8_t> payload(encoder->payload_size());
        std::vector<uint8_t> data_in(encoder->block_size());

        if(isSystematic)
        {
            kodo::set_systematic_on(encoder);
        } else
         {
            kodo::set_systematic_off(encoder);
         }

        std::generate(data_in.begin(), data_in.end(), UniqueNumber);
        encoder->set_symbols(sak::storage(data_in));
        for ( unsigned int nn_ = 0; nn_ < N; nn_++ ) {
            if (p[nn_] < 0 || p[nn_] > 1)
                mexErrMsgTxt("Error!");
            
            if (pruneZeros) {
                encoder->set_density( -(1-p[nn_]) );
            } else {
                encoder->set_density( 1-p[nn_] );
            }
            encoder->encode(payload.data());
            if ( (rand()/double(RAND_MAX)) <= pep ) {
                continue;
            }
            decoder->decode(payload.data());
        }
        if(decoder->is_complete()) {
            decIt = 1;
        } else {
            decIt = 0;
        }
        pTransitionCount += decIt;
        tmpOpt = decoder->get_operations_counter();
        if(decIt == 1) {
            pOpCount += ( tmpOpt.m_multiply + 
                          tmpOpt.m_multiply_add +
                          tmpOpt.m_add +
                          tmpOpt.m_multiply_subtract +
                          tmpOpt.m_subtract +
                          tmpOpt.m_invert );
        }
    }
    struct _simRes rVal;
    rVal.avgNumTx = double(pTransitionCount)/double(iterations);
    rVal.opCounter = double(pOpCount)/double(pTransitionCount);
    return rVal;
}

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[]) {   
    unsigned int K = (unsigned int) mxGetScalar(prhs[0]);
    unsigned int N = (unsigned int) mxGetScalar(prhs[1]);
    unsigned int q = (unsigned int) mxGetScalar(prhs[2]);
    double * p = mxGetPr(prhs[3]);
    bool isSystematic = (bool) mxGetScalar(prhs[4]);
    bool pruneZeros = (bool) mxGetScalar(prhs[5]);
    double pep = mxGetScalar(prhs[6]);
    unsigned int iterations = (unsigned int) mxGetScalar(prhs[7]);
    unsigned int seed = (unsigned int) mxGetScalar(prhs[8]);
    
    if(nlhs > 2) {
        mexErrMsgTxt("Too many output arguments.");
    }
       
    if ( !(q == 2 || q == 16 || q == 256 || q == 65536) ) {
        mexErrMsgTxt("The GF size is not valid.");
    }
    if ( N == 0 || K == 0 || N < K ) {
        mexErrMsgTxt("Error!");
    }
    
    struct _simRes tmpRVal;
    if ( q == 2 )
        tmpRVal = simMex<Encoder1, Decoder1>(K, N, p, isSystematic, pruneZeros, pep, iterations, seed);
	else if ( q == 16 )
        tmpRVal = simMex<Encoder4, Decoder4>(K, N, p, isSystematic, pruneZeros, pep, iterations, seed);
	else if ( q == 256 )
        tmpRVal = simMex<Encoder8, Decoder8>(K, N, p, isSystematic, pruneZeros, pep, iterations, seed);
	else if ( q == 65536 )
        tmpRVal = simMex<Encoder16, Decoder16>(K, N, p, isSystematic, pruneZeros, pep, iterations, seed);
    
    plhs[0] = mxCreateDoubleScalar(tmpRVal.avgNumTx);
    plhs[1] = mxCreateDoubleScalar(tmpRVal.opCounter);
}
