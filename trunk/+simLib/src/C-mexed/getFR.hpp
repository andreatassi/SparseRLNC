#include <iostream>
#include <ctime>
#include <cassert>
#include <vector>

#include <kodo/rlnc/full_vector_codes.hpp>
#include <kodo/set_systematic_on.hpp>
#include <kodo/set_systematic_off.hpp>
#include <kodo/is_systematic_on.hpp>
#include <kodo/finite_field_counter.hpp>
#include <kodo/finite_field_counter.hpp>


namespace kodo
{
    namespace rlnc
    {
        template<class Field, class TraceTag = kodo::disable_trace>
        class full_vector_decoder_count : public
            // Payload API
            nested_payload_recoder<
            proxy_stack<proxy_args<>, full_vector_recoding_stack,
            payload_decoder<
            // Codec Header API
            systematic_decoder<
            symbol_id_decoder<
            // Symbol ID API
            plain_symbol_id_reader<
            // Decoder API
            common_decoder_layers<TraceTag,
            // Coefficient Storage API
            coefficient_storage_layers<
            // Storage API
            deep_storage_layers<TraceTag,
            // Finite Field API
            finite_field_counter<
            finite_field_math<typename fifi::default_field<Field>::type,
            finite_field_info<Field,
            // Final Layer
            final_layer
            > > > > > > > > > > > >
        {
        public:
            using factory = pool_factory<full_vector_decoder_count>;
        };    
    }
}


struct c_unique {
  int current;
  c_unique() {current=0;}
  int operator()() {return ++current;}
} UniqueNumber;

struct _simRes {
    double avgNumTx;
    double opCounter;
} simRes;

template<class Encoder, class Decoder> struct _simRes simMex(bool isSystematic, unsigned int kl, double pl, double per, unsigned int iterations, unsigned int seed, bool pruneZeros, unsigned int nl);

double unifRand();

typedef kodo::rlnc::sparse_full_vector_encoder<fifi::binary>::factory Encoder1;
typedef kodo::rlnc::full_vector_decoder_count<fifi::binary>::factory Decoder1;

typedef kodo::rlnc::sparse_full_vector_encoder<fifi::binary4>::factory Encoder4;
typedef kodo::rlnc::full_vector_decoder_count<fifi::binary4>::factory Decoder4;

typedef kodo::rlnc::sparse_full_vector_encoder<fifi::binary8>::factory Encoder8;
typedef kodo::rlnc::full_vector_decoder_count<fifi::binary8>::factory Decoder8;

typedef kodo::rlnc::sparse_full_vector_encoder<fifi::binary16>::factory Encoder16;
typedef kodo::rlnc::full_vector_decoder_count<fifi::binary16>::factory Decoder16;
