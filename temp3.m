
function fp_pac_control_harmonics

%FOIs
ifl = 10;
ifh = 60;
filt.low = ifl;
filt.high = ifh;

iband1 = 10 +[-2 2];
iband2 = 60 +[-2 2];

nshuf = 100;
isnr = 5;

%%

tic

%prevent array jobs to start at exactly the same time
for isb = 1:100
    
    N = 120000;
    
    nchan= 2;
    
    %Sampling frequency
    fs = 200;
    frqs = sfreqs(fs, fs);
    
    n_trials_s = 60;
    
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
    
    %% Case 1: true bivariate interaction
    %
    %     %generate signal
    %     X_1 = [high_osc low_osc];
    %     X_1 = X_1./norm(X_1(:),'fro');
    %     X_1 =  snr_v(isnr)*X_1 + (1-snr_v(isnr))*channels_noise;
    %     X_1 = reshape(X_1',nchan,[],n_trials_s);
    %     d_l = X_1;
    
    %% Case 3: two univariate pac signals
    
    %generate signal
    X_5 = [pac_0 pac_1];
    X_5 = X_5./norm(X_5(:),'fro');
    X_5 =  snr_v(isnr)*X_5 + (1-snr_v(isnr))*channels_noise;
    X_5 = reshape(X_5',nchan,[],n_trials_s);
    
    d_l = X_5;
    %%
    %MIM low
    %     npcs = [1 1];
    %     filt.band_inds = find(frqs >= iband1(1) & frqs <= iband1(2));
    %     MIM_s = fp_shuffle_MIM(d_l,npcs, fs, filt,nshuf);
    %     p_mim_l(isb) = sum(squeeze(MIM_s(1,2,2:end))>MIM_s(1,2,1))/(nshuf);
    %
    %     %MIM high
    %     npcs = [1 1];
    %     filt.band_inds = find(frqs >= iband2(1) & frqs <= iband2(2));
    %     MIM_s = fp_shuffle_MIM(d_l,npcs, fs, filt,nshuf);
    %     p_mim_h(isb) = sum(squeeze(MIM_s(1,2,2:end))>MIM_s(1,2,1))/(nshuf);
    
    %calculate PAC
    [~, bals] = fp_pac_bispec_uni(d_l,fs,filt, nshuf+1);
    p_pac(isb) = sum(squeeze(bals(1,2,2:end))>bals(1,2,1))/(nshuf);
    
end
t=toc;

%%
% figure
% subplot(1,3,1)
% hist(p_mim_l)
% title('MIM 10 Hz, RDE within hemis')
% xlabel('p value')
% 
% subplot(1,3,2)
% hist(p_mim_h)
% title('MIM 30 Hz, RDE within hemis')
% xlabel('p value')
% 
% subplot(1,3,3)
hist(p_pac)
title('no PAC simulation')
xlabel('p value')
