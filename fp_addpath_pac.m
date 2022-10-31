function fp_addpath_pac

% restoredefaultpath
% rehash toolboxcache

addpath(genpath('/home/bbci/data/haufe/Franziska/pac*/'))
addpath(genpath('~/matlab/fp/'))
addpath(genpath('~/matlab/matgrid/'))
addpath(genpath('~/matlab/libs/Daniele_ARMA/'))
addpath(genpath('~/matlab/libs/haufe/'))
addpath(genpath('~/matlab/libs/nolte/'))
addpath(genpath('~/matlab/libs/mvgc_v1.0/'))
addpath(genpath('~/matlab/libs/pac_lib/'))
addpath('~/matlab/libs/eeglab-develop/functions/sigprocfunc/')

cd ~/matlab/libs/eeglab-develop 
eeglab
close all
cd '/home/bbci/data/haufe/Franziska/data/'