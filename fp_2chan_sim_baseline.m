function fp_2chan_sim_baseline(seed,iit)
% Two-channel baseline simulation (for Supplementary Figure S1 in Pellegrini 2023) 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

rng('default')
rng(seed)
DIROUT = './';

logname = num2str(iit);

%% Parameters

N = 120000; % total number of samples 
nchan= 2; %two channels 
fs = 200; %sampling frequency
n_trials_s = 60; % number of trials for MI-based methods 
n_shuffles = 1000; % number of shuffles 

% interacting frequency bands for simulating signal
low = [9 11]; %low freq band 
high = [58 62]; % high freq band 
filt.low = low;
filt.high = high;

%SNR
snr_v = [0 0.1 0.2 0.3 0.4];

%% Signal generation

%generate univariate PAC signal 
[~, ~, pac_0] = syn_sig(N,fs, low, high);

%white noise 
channels_noise1 = randn(N,1);
channels_noise = [channels_noise1 channels_noise1];
channels_noise = channels_noise./ norm(channels_noise(:),'fro');

for isnr = 1:length(snr_v)
    isnr
    %Calculate PAC within single signal 
    X_3 = [pac_0 pac_0];
    X_3 = X_3./norm(X_3(:),'fro');
    X_3 =  snr_v(isnr)*X_3 + (1-snr_v(isnr))*channels_noise;
    X_3 = reshape(X_3',nchan,[],n_trials_s);
    
    %estimate within-channel PAC 
    [pac{1,isnr}, p{1,isnr}] = fp_get_all_pac_baseline(X_3, fs, filt, n_shuffles);
end


%% Save

save([DIROUT 'pvals_' logname '.mat'],'p','-v7.3')
