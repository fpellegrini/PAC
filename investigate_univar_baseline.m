
rng(5)
% Parameters

N = 120000;
nchan= 2;

%Sampling frequency
fs = 200;

n_trials_s = 60;
n_iter = 500;

%BW
low = [9 11];
high = [58 62];
filt.low = low;
filt.high = high;

%SNR
snr_v = [0 0.2 0.4 0.6 0.8];

n_shuffles = 100;
cse = 1;

%% Signal generation

[high_osc, low_osc, pac_0] = syn_sig(N,fs, low, high);
[~,~, pac_1] = syn_sig(N,fs, low, high);

channels_noise = randn(N,2);
channels_noise = channels_noise./ norm(channels_noise(:),'fro');

rand_sig = randn(N, 1);
rand_sig = rand_sig./norm(rand_sig,'fro');

for isnr = 1:length(snr_v)
    isnr
    X_3 = [pac_0 pac_0];
    X_3 = X_3./norm(X_3(:),'fro');
    X_3 =  snr_v(isnr)*X_3 + (1-snr_v(isnr))*channels_noise;
    X_3 = reshape(X_3',nchan,[],n_trials_s);
    
    [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_3, fs, filt, n_shuffles);
end
%%

for isnr = 1:5
    for imet = 1:2 
        if imet ==1
            pval(isnr,imet) = p{1,isnr}(imet);
        else
            pval(isnr,imet) = p{1,isnr}(4);
        end        
    end
end
plot(pval)
legend('MI','Bispec')
