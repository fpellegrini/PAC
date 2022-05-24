
params. iInt = [1]; 
params.case = 2; 
params.isnr=0.7; 
params.t=0;

params.iReg=1; 
params.iss = 0.9; 
params.ifilt = 'l';
params.pips = 1;
params.nshuf = 100; 
%%
% addpath(genpath('~/Dropbox/Franziska/MEG_Project/matlab/libs/fieldtrip-20211001/external/fastica'))
addpath('~/Dropbox/Franziska/PAC_AAC_estimation/matlab/fp_pac/')
addpath('~/Dropbox/Franziska/PAC_AAC_estimation/matlab/simulations/test_PAC_cases/functions/')

