if strcmp(computer, 'MACI64')
    mex -v '-I+simLib/src/kodo-20.0.0/build/darwin/src' ...
        '-I+simLib/src/kodo-20.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/fifi-8960fd/15.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/fifi-8960fd/15.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/cpuid-4d8071/3.3.1/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/cpuid-4d8071/3.3.1/src' ...
        '-I+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/platform-bccd32/1.1.0/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/platform-bccd32/1.1.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/sak-1bdcea/13.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/sak-1bdcea/13.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/boost-abe3de/1.7.0' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/boost-abe3de/1.11.0' ...
        '-I+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/recycle-b2469b/1.0.1/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/recycle-b2469b/1.2.0/src' ...
        '-DBOOST_ALL_NO_LIB=1' '-DBOOST_DETAIL_NO_CONTAINER_FWD' '-DBOOST_NO_CXX11_NOEXCEPT' ...
        '-L+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/fifi-8960fd/15.0.0/src/fifi' ...
        '-L+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/cpuid-4d8071/3.3.1/src/cpuid' ...
        '-L+simLib/src/kodo-20.0.0/build/darwin/bundle_dependencies/sak-1bdcea/13.0.0/src/sak'...
        '-lfifi' '-lcpuid' '-lsak' '-lc++' '-compatibleArrayDims'...
        +simLib/src/C-mexed/getRank2NodeBroadcast.cpp -output +simLib/getRank2NodeBroadcast
else
    mex -v '-I+simLib/src/kodo-20.0.0/build/linux/src' ...
        '-I+simLib/src/kodo-20.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/fifi-8960fd/15.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/fifi-8960fd/15.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/cpuid-4d8071/3.3.1/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/cpuid-4d8071/3.3.1/src' ...
        '-I+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/platform-bccd32/1.3.0/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/platform-bccd32/1.3.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/sak-1bdcea/13.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/sak-1bdcea/13.0.0/src' ...
        '-I+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/boost-abe3de/1.10.0' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/boost-abe3de/1.11.0' ...
        '-I+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/recycle-b2469b/1.2.0/src' ...
        '-I+simLib/src/kodo-20.0.0/bundle_dependencies/recycle-b2469b/1.2.0/src' ...
        '-DBOOST_ALL_NO_LIB=1' '-DBOOST_DETAIL_NO_CONTAINER_FWD' '-DBOOST_NO_CXX11_NOEXCEPT' ...
        '-L+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/fifi-8960fd/15.0.0/src/fifi' ...
        '-L+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/cpuid-4d8071/3.3.1/src/cpuid' ...
        '-L+simLib/src/kodo-20.0.0/build/linux/bundle_dependencies/sak-1bdcea/13.0.0/src/sak'...
        '-lfifi' '-lcpuid' '-lsak' '-compatibleArrayDims'...
        +simLib/src/C-mexed/getRank2NodeBroadcast.cpp -output +simLib/getRank2NodeBroadcast
end