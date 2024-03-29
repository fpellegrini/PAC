function fp_2chan_sim(seed,iit)
% Two-channel simulation published in Pellegrini (2023) 
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
snr_v = [0 0.2 0.4 0.6 0.8]; 

%% Signal generation

%generate slow and fast oscillation with PAC, and univariate PAC signal 
[high_osc, low_osc, pac_0] = syn_sig(N,fs, low, high);

%second univariate PAC signal for case 3 and 4
[~,~, pac_1] = syn_sig(N,fs, low, high);

%white noise 
channels_noise = randn(N,2);
channels_noise = channels_noise./ norm(channels_noise(:),'fro');

%mixing matrix for case 2 and 4
mixing_matrix = eye(2);
mixing_matrix(1,2)=2*(rand-.5);
mixing_matrix(2,1)=2*(rand-.5);

%% Loop through snrs

for isnr = 1:length(snr_v)
    
    
    %% Case 1: true bivariate interaction
    
    cse = 1;
    fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n'])
    
    %generate signal
    X_1 = [high_osc low_osc];
    X_1 = X_1./norm(X_1(:),'fro');
    X_1 =  snr_v(isnr)*X_1 + (1-snr_v(isnr))*channels_noise;
    X_1 = reshape(X_1',nchan,[],n_trials_s);
    
    %PAC estimation 
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_1, fs, filt, n_shuffles);
    
    
    %% Case 2: true bivariate pac + mixing
    
    cse=2;
    fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n'])
    
    %generate signal with mixing
    X_2 = [high_osc low_osc];
    X_2 = X_2*mixing_matrix;
    X_2 = X_2./norm(X_2(:),'fro');
    X_2 =  snr_v(isnr)*X_2 + (1-snr_v(isnr))*channels_noise;
    X_2 = reshape(X_2',nchan,[],n_trials_s);
    
    %PAC estimation 
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_2, fs, filt, n_shuffles);
    
    %% Case 3: two univariate pac signals
    
    cse = 3;
    fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n'])
    
    %generate signal
    X_5 = [pac_0 pac_1];
    X_5 = X_5./norm(X_5(:),'fro');
    X_5 =  snr_v(isnr)*X_5 + (1-snr_v(isnr))*channels_noise;
    X_5 = reshape(X_5',nchan,[],n_trials_s);
    
    %PAC estimation 
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_5, fs, filt, n_shuffles);
    
    
    %% Case 4: two univariate pac signals + mixing
    
    cse = 4;
    fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n'])
    
    %generate signal with mixing
    X_6 = [pac_0 pac_1];
    X_6 = X_6*mixing_matrix;
    X_6 = X_6./norm(X_6(:),'fro');
    X_6 = snr_v(isnr)*X_6 + (1-snr_v(isnr))*channels_noise;
    X_6 = reshape(X_6',nchan,[],n_trials_s);
    
    %PAC estimation 
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_6, fs, filt, n_shuffles);
    
end

%% Save
save([DIROUT 'pvals_' logname '.mat'],'p','-v7.3')
