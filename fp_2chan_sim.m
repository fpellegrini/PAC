function fp_2chan_sim(seed,iit)

rng('default')
rng(seed)
DIROUT = './';

logname = num2str(iit);

%% Parameters

N = 120000;
nchan= 2;

%Sampling frequency
fs = 200;
n_trials_s = 60; 
n_shuffles = 1000;

%BW
low = [9 11];
high = [58 62];
filt.low = low;
filt.high = high;

%SNR
snr_v = [0 0.2 0.4 0.6 0.8 1]; %in sim 3

%% Signal generation

[high_osc, low_osc, pac_0] = syn_sig(N,fs, low, high);
[~,~, pac_1] = syn_sig(N,fs, low, high);

channels_noise = randn(N,2);
channels_noise = channels_noise./ norm(channels_noise(:),'fro');

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
    
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_2, fs, filt, n_shuffles);
    
    %% Case 3: two univariate pac signals
    
    cse = 5;
    fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n'])
    
    %generate signal
    X_5 = [pac_0 pac_1];
    X_5 = X_5./norm(X_5(:),'fro');
    X_5 =  snr_v(isnr)*X_5 + (1-snr_v(isnr))*channels_noise;
    X_5 = reshape(X_5',nchan,[],n_trials_s);
    
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_5, fs, filt, n_shuffles);
    
    
    %% Case 4: two univariate pac signals + mixing
    
    cse = 6;
    fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n'])
    
    %generate signal with mixing
    X_6 = [pac_0 pac_1];
    X_6 = X_6*mixing_matrix;
    X_6 = X_6./norm(X_6(:),'fro');
    X_6 = snr_v(isnr)*X_6 + (1-snr_v(isnr))*channels_noise;
    X_6 = reshape(X_6',nchan,[],n_trials_s);
    
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_6, fs, filt, n_shuffles);
    
end


%% Save
%         save([DIROUT logname '.mat'],'-v7.3')
save([DIROUT 'pvals_' logname '.mat'],'p','-v7.3')
