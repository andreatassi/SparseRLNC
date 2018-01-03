%% MEX Generation. MEX file 'getFR' is only needed to run Monte Carlo simulations
try
    mex -v +simLib/src/C-mexed/getRank.cpp -output +simLib/getRank
catch
    warning('This step failed because kodo-20.0.0 is not accesible by the MEX compiler.');
    warning('As a fallback, we provided the pre-built MEX file getFR suitable to be run');
    warning('in OS X 10.11.6 and Ubuntu 14.04 LTS');
end

%% Generate results
batchRunner_VT_2017_00937;

%% Generate all the figures
getFigs_VT_2017_00937;
