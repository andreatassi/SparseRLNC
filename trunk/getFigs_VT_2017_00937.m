%% Fig. 2  %
close all
clearvars
filename = {'./doc/img/pdf/fig1.pdf', './doc/img/eps/fig1.eps'};
helpers.getFig1('data/tV00_20_0.8_2.mat', 0.03, filename);
% ---------%

%% Fig. 2-zoom  %
close all
clearvars
filename = {'./doc/img/pdf/fig1z.pdf', './doc/img/eps/fig1z.eps'};
helpers.getFig1('data/tV00_20_0.8_2.mat', 0.005, filename);
% ---------%

%% Fig. 3a  %
close all
clearvars
filename = {'./doc/img/pdf/fig2a.pdf', './doc/img/eps/fig2a.eps'};
helpers.getFig23('data/V01_10_30_0.7_0_2_0.1_0.mat', 'data/V01_20_30_0.7_0_2_0.1_0.mat', 'data/V01_50_30_0.7_0_2_0.1_0.mat', ...
                 'data/tV01_10_30_0.7_0_2_0.1_0.mat', 'data/tV01_20_30_0.7_0_2_0.1_0.mat', 'data/tV01_50_30_0.7_0_2_0.1_0.mat', ...
                 'data/iaV01_10_30_0.7_0_2_0.1_0.mat','data/iaV01_20_30_0.7_0_2_0.1_0.mat', 'data/iaV01_50_30_0.7_0_2_0.1_0.mat', ... 
                  [0, 15], [0 1], 5:5:35, [0:0.2:1], [10, 20, 50], true, filename, false);
% ---------%

%% Fig. 3b  %
close all
clearvars
filename = {'./doc/img/pdf/fig2b.pdf', './doc/img/eps/fig2b.eps'};
helpers.getFig23('data/V01_10_30_0.9_0_2_0.1_0.mat', 'data/V01_20_30_0.9_0_2_0.1_0.mat', 'data/V01_50_30_0.9_0_2_0.1_0.mat', ...
                  'data/tV01_10_30_0.9_0_2_0.1_0.mat', 'data/tV01_20_30_0.9_0_2_0.1_0.mat', 'data/tV01_50_30_0.9_0_2_0.1_0.mat', ...
                  'data/iaV01_10_30_0.9_0_2_0.1_0.mat','data/iaV01_20_30_0.9_0_2_0.1_0.mat', 'data/iaV01_50_30_0.9_0_2_0.1_0.mat', ... 
                  [0, 20], [0 1], 5:5:35, [0:0.2:1], [10, 20, 50], false, filename, false);
% ---------%

%% Fig. 4  %
close all
clearvars
filename = {'./doc/img/pdf/fig3.pdf', './doc/img/eps/fig3.eps'};
helpers.getFig3( 'data/V01_20_30_0.7_0_16_0.1_0.mat', 'data/V01_50_30_0.7_0_16_0.1_0.mat', 'data/V01_20_30_0.9_0_16_0.1_0.mat', 'data/V01_50_30_0.9_0_16_0.1_0.mat', ...
                  'data/tV01_20_30_0.7_0_16_0.1_0.mat', 'data/tV01_50_30_0.7_0_16_0.1_0.mat', 'data/tV01_20_30_0.9_0_16_0.1_0.mat', 'data/tV01_50_30_0.9_0_16_0.1_0.mat', ...
                  'data/iaV01_20_30_0.7_0_16_0.1_0.mat', 'data/iaV01_50_30_0.7_0_16_0.1_0.mat', 'data/iaV01_20_30_0.9_0_16_0.1_0.mat', 'data/iaV01_50_30_0.9_0_16_0.1_0.mat', ... 
                  [0, 30], [0 1], 5:5:35, [0:0.2:1], [20, 50], true, filename, false);
% ---------%

%% Fig. 5 %
close all
clearvars
filename = {'./doc/img/pdf/fig4.pdf', './doc/img/eps/fig4.eps'};
helpers.getFig4( 'data/V02.mat', [0.6, 0.85], [0 1], 0.6:0.05:0.9, 0:0.2:1, filename);
% ---------%

%% Fig. 6  %
close all
clearvars
filename = {'./doc/img/pdf/fig5a.pdf', './doc/img/eps/fig5a.eps'};
helpers.getFig5( 'data/V04.mat', [0.01, 0.25], [0 30], [0.01, 0.05:0.05:0.25], 0:5:30, [20, 50, 100], true, filename, true);
clearvars
filename = {'./doc/img/pdf/fig5b.pdf', './doc/img/eps/fig5b.eps'};
helpers.getFig5( 'data/V04.mat', [0.01, 0.25], [0 30], [0.01, 0.05:0.05:0.25], 0:5:30, [20, 50, 100], false, filename, false);
% ---------%

%%
close all
