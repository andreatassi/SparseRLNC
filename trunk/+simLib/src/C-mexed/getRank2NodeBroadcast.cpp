#include "getRank2NodeBroadcast.hpp"
#include "mex.h"
#include "matrix.h"

template<class Encoder, class Decoder, class Decoder_an>
struct simRes simMex(unsigned int K, unsigned int N, double * p, bool isSystematic, bool pruneZeros,
                     unsigned int no_of_users, double * pep, unsigned int iterations, unsigned int seed)
{
    srand(seed);
    
    uint32_t symbols = K;
    uint32_t symbol_size = 1;
    
    int * decIt = new int [no_of_users];
    decIt[0] = 0;
    if (no_of_users > 1)
        decIt[1] = 0;
    int pTransitionCount = 0;
    unsigned long long int pOpCount = 0;
    kodo::operations_counter tmpOpt;

    Encoder encoder_factory(symbols, symbol_size);
    auto encoder = encoder_factory.build();
    
    Decoder decoder_factory(symbols, symbol_size);
    std::shared_ptr<Decoder_an> * decoders = new std::shared_ptr<Decoder_an> [no_of_users];
    for (unsigned int user_id = 0; user_id < no_of_users; user_id++) {
        auto tmp_decoder = decoder_factory.build();
        decoders[user_id] = tmp_decoder;
    }
    
    for (unsigned int it = 0; it < iterations; it++)
    {
        encoder->initialize(encoder_factory);
        
        if (pruneZeros)
        {
            encoder->set_density( -(1-p[0]) );
        } else {
            encoder->set_density( 1-p[0] );
        }
        encoder->seed(seed + it);

        for (unsigned int user_id = 0; user_id < no_of_users; user_id++) {
            decoders[user_id]->initialize(decoder_factory);
        }

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
            for (unsigned int user_id = 0; user_id < no_of_users; user_id++) {
                if ( (rand()/double(RAND_MAX)) > pep[user_id] ) {
                    decoders[user_id]->decode(payload.data());
                }
            }
            if(decoders[0]->is_complete() && (rand()/double(RAND_MAX)) > pep[no_of_users]) {
                break;
            }            
        }        
        if(decoders[1]->is_complete()) {
            decIt[1]++;
        }
        if(decoders[0]->is_complete()) {
            decIt[0]++;
        }
    }
    struct simRes mySimRes;
    mySimRes.decProb = double(decIt[0])/double(iterations);
    mySimRes.interceptProb = double(decIt[1])/double(iterations);
    return mySimRes;
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
    unsigned int no_of_users = (unsigned int) mxGetScalar(prhs[6]);
    double * pep = mxGetPr(prhs[7]);
    unsigned int iterations = (unsigned int) mxGetScalar(prhs[8]);
    unsigned int seed = (unsigned int) mxGetScalar(prhs[9]);
    unsigned int replicas = (unsigned int) mxGetScalar(prhs[10]);
    
    if(nlhs > 2) {
        mexErrMsgTxt("Too many output arguments.");
    }
       
    if ( !(q == 2 || q == 16 || q == 256 || q == 65536) ) {
        mexErrMsgTxt("The GF size is not valid.");
    }
    if ( N == 0 || K == 0 || N < K ) {
        mexErrMsgTxt("Error!");
    }
    
    plhs[0] = mxCreateNumericMatrix(replicas, 1, mxDOUBLE_CLASS, mxREAL);
    plhs[1] = mxCreateNumericMatrix(replicas, 1, mxDOUBLE_CLASS, mxREAL);
    double * outputMatrixInterc = (double *)mxGetData(plhs[0]);
    double * outputMatrixDec = (double *)mxGetData(plhs[1]);
    struct simRes tmpRVal;
    for (int rep = 0; rep < replicas; rep++) {
        if ( q == 2 )
            tmpRVal = simMex<Encoder1, Decoder1, Decoder1_an>(K, N, p, isSystematic, pruneZeros, no_of_users, pep, iterations, seed);
        else if ( q == 16 )
            tmpRVal = simMex<Encoder4, Decoder4, Decoder4_an>(K, N, p, isSystematic, pruneZeros, no_of_users, pep, iterations, seed);
        else if ( q == 256 )
            tmpRVal = simMex<Encoder8, Decoder8, Decoder8_an>(K, N, p, isSystematic, pruneZeros, no_of_users, pep, iterations, seed);
        else if ( q == 65536 )
            tmpRVal = simMex<Encoder16, Decoder16, Decoder16_an>(K, N, p, isSystematic, pruneZeros, no_of_users, pep, iterations, seed);
        
        outputMatrixInterc[rep] = tmpRVal.interceptProb;
        outputMatrixDec[rep] = tmpRVal.decProb;
        seed = seed + 10;
    }
}
