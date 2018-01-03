#include "getAvgNoOpDelProb.hpp"
#include "mex.h"

double unifRand()
{
    return rand() / double(RAND_MAX);
}

template<class Encoder, class Decoder>
struct _simRes simMex(bool isSystematic, unsigned int kl, unsigned int sSize, double pl, double per, unsigned int hatTaul, unsigned int iterations, unsigned int seed, bool pruneZeros )
{
    srand(seed);
    
    uint32_t symbols = kl;
    uint32_t symbol_size = sSize; // In Bytes
    
    int decIt = 0;
    int pTransitionCount = 0;
    int pOpCount = 0;
    kodo::operations_counter tmpOpt;
    
    bool decoded = false;
    
    Encoder encoder_factory(symbols, symbol_size);
    auto encoder = encoder_factory.build();
    Decoder decoder_factory(symbols, symbol_size);
    auto decoder = decoder_factory.build();
    for (unsigned int it = 0; it < iterations; it++)
    {
    	encoder->initialize(encoder_factory);
        
        if (pruneZeros)
        {
            encoder->set_density( -(1-pl) );
        } else {
            encoder->set_density( 1-pl );
            //mexPrintf("non-pruned\n");
        }
        encoder->seed(rand());
        
        decoder->initialize(decoder_factory);

        std::vector<uint8_t> payload(encoder->payload_size());
        std::vector<uint8_t> data_in(encoder->block_size());

        if(isSystematic)
        {
            kodo::set_systematic_on(encoder);
            //mexPrintf("ON\n");
        } else
         {
            kodo::set_systematic_off(encoder);
            //mexPrintf("OFF\n");
         }

        std::generate(data_in.begin(), data_in.end(), UniqueNumber);
        encoder->set_symbols(sak::storage(data_in));
        decIt = 0;
        decoded = false;
        while (!decoded && decIt < hatTaul)
        //while (!decoded)
        {
            decIt++;
            //mexPrintf("it %i\n", decIt);
            encoder->encode(payload.data());
            if (unifRand() <= per)
            {
                continue;
            }
            decoder->decode(payload.data());
            if (decoder->is_complete()) {
                decoded = true;
            }
        }
        if (decoded) {
            //mexPrintf("DEC!\n");
            pTransitionCount += 1;
        }
        
        tmpOpt = decoder->get_operations_counter();
        pOpCount += ( tmpOpt.m_multiply + 
                      tmpOpt.m_multiply_add +
                      tmpOpt.m_add +
                      tmpOpt.m_multiply_subtract +
                      tmpOpt.m_subtract +
                      tmpOpt.m_invert );
//         mexPrintf("%i\n", ( tmpOpt.m_multiply + 
//                       tmpOpt.m_multiply_add +
//                       tmpOpt.m_add +
//                       tmpOpt.m_multiply_subtract +
//                       tmpOpt.m_subtract +
//                       tmpOpt.m_invert ));
    }
    struct _simRes rVal;
    rVal.ccdfDec = double(pTransitionCount)/double(iterations);
    rVal.opCounter = double(pOpCount)/double(iterations);
    return rVal;
}

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{           
    if(nrhs != 10)
        mexErrMsgTxt("Not enough input arguments.");
    if(nlhs > 2)
        mexErrMsgTxt("Too many output arguments.");
    
    unsigned int kl = (unsigned int) mxGetScalar(prhs[0]);
    double pl = (mxGetScalar(prhs[1]));
    double per = (mxGetScalar(prhs[2]));
    unsigned int iterations = (unsigned int) mxGetScalar(prhs[3]);
    unsigned int seed = (unsigned int) mxGetScalar(prhs[4]);
    unsigned int q = (unsigned int) mxGetScalar(prhs[5]);
    bool isSystematic = (bool) mxGetScalar(prhs[6]);
    unsigned int sSize = (unsigned int) mxGetScalar(prhs[7]);
    unsigned int hatTaul = (unsigned int) mxGetScalar(prhs[8]);
    bool pruneZeros = (bool) mxGetScalar(prhs[9]);
    
    if ( !(q == 2 || q == 16 || q == 256 || q == 65536) )
        mexErrMsgTxt("The GF size is not valid.");
    
    struct _simRes tmpRVal;
    if ( q == 2 )
        tmpRVal = simMex<Encoder1, Decoder1>(isSystematic, kl, sSize, pl, per, hatTaul, iterations, seed, pruneZeros);
	else if ( q == 16 )
        tmpRVal = simMex<Encoder4, Decoder4>(isSystematic, kl, sSize, pl, per, hatTaul, iterations, seed, pruneZeros);
	else if ( q == 256 )
        tmpRVal = simMex<Encoder8, Decoder8>(isSystematic, kl, sSize, pl, per, hatTaul, iterations, seed, pruneZeros);
	else if ( q == 65536 )
        tmpRVal = simMex<Encoder16, Decoder16>(isSystematic, kl, sSize, pl, per, hatTaul, iterations, seed, pruneZeros);
    
    plhs[0] = mxCreateDoubleScalar(tmpRVal.ccdfDec);
    plhs[1] = mxCreateDoubleScalar(tmpRVal.opCounter);
}
