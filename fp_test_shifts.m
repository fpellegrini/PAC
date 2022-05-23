
params. iInt = [2]; %2 bivariate interactions
params.iReg=1; % one voxel per region

%%
%total number of samples
N = 120000; %10 minutes

%Sampling frequency
fs = 200;
fres = fs;
frqs = sfreqs(fres, fs); % freqs in Hz

%number of trails
n_trials = 60;

%interacting bands in Hz
low = [9 11];
high = [58 62];
band_inds_low = find(frqs >= low(1) & frqs <= low(2)); % indices of interacting low frequencies
band_inds_high = find(frqs >= high(1) & frqs <= high(2)); % indices of interacting high frequencies

% filters for band and highpass
[bband_low, aband_low] = butter(5, low/(fs/2));
[bband_high, aband_high] = butter(5, high/(fs/2));

filt.aband_low = aband_low;
filt.bband_low = bband_low;
filt.aband_high = aband_high;
filt.bband_high = bband_high;
filt.band_inds_low = band_inds_low;
filt.band_inds_high = band_inds_high;
filt.low = low;
filt.high = high;

%coupling strength = SNR in interacting frequency band
coupling_snr = 0.6;

%% generate signal low and high

xl = randn(N,  sum(params.iInt)*params.iReg);
for ii = 1:  sum(params.iInt)*params.iReg
    xl(:,ii) = filtfilt(bband_low, aband_low, xl(:,ii));
end

xh = randn(N,  sum(params.iInt)*params.iReg);
for ii = 1: sum(params.iInt)*params.iReg
    xh(:,ii) = filtfilt(bband_high, aband_high, xh(:,ii));
end

xlh = hilbert(xl);
xlphase = angle(xlh);

xhh = hilbert(xh);
xhphase = angle(xhh);

xh = real((1-cos(xlphase)).*exp(1i*xhphase));


%% normalize low and high freq signal to 1/f shape

xh = xh./norm(xh,'fro');
xl = xl./norm(xl,'fro');

%1/f transformation of the signal
for ii = 1:size(xl,2)
    xl(:,ii) = fp_pinknorm(xl(:,ii));
    xh(:,ii) = fp_pinknorm(xh(:,ii));
end

xl_save = xl;

%%
for ii = 1:100
    
    xl = circshift(xl_save,ii-1,1);
    %% generate interacting sources
    
    %concatenate low and high signals
    %s1 has shape of N x 4
    %interaction happens between first and third, and between second and fourth
    %signal
    s1 = cat(2,xl,xh);
    s1 = s1./norm(s1(:),'fro');
    
    %pink background noise
    backg = mkpinknoise(N, size(s1,2), 1);
    backg = backg ./ norm(backg, 'fro');
    
    %combine signal and background noise
    signal_sources = coupling_snr*s1 + (1-coupling_snr)*backg;
    s = reshape((signal_sources ./ norm(signal_sources(:),'fro'))',4,[],n_trials);
    
    %% calculation of pac
    
    %Bispectrum
    [b_orig(:,:,ii), b_anti(:,:,ii),~,~] = fp_pac_bispec(s,fres,filt);
    
    %Tort
    pac_standard(:,:,ii) = fp_pac_standard(s, filt.low, filt.high, fres);
    
end

%%
figure
subplot(2,2,1)
plot(squeeze(pac_standard(3,1,:)))
title('Tort 3->1')
xlabel('shift in samples')
ylabel('pac score')
ylim([0 5*10^-4])
subplot(2,2,2)
plot(squeeze(b_orig(3,1,:)))
title('Bispec 3->1')
xlabel('shift in samples')
ylabel('pac score')
% ylim([0 10^-5])
subplot(2,2,3)
plot(squeeze(pac_standard(4,2,:)))
title('Tort 4->2')
xlabel('shift in samples')
ylabel('pac score')
ylim([0 5*10^-4])
subplot(2,2,4)
plot(squeeze(b_orig(4,2,:)))
title('Bispec 4->2')
xlabel('shift in samples')
ylabel('pac score')
% ylim([0 10^-5])

figure
subplot(2,2,1)
plot(squeeze(pac_standard(4,1,:)))
title('Tort 4->1')
xlabel('shift in samples')
ylabel('pac score')
ylim([0 5*10^-4])
subplot(2,2,2)
plot(squeeze(b_orig(4,1,:)))
title('Bispec 4->1')
xlabel('shift in samples')
ylabel('pac score')
% ylim([0 10^-5])
subplot(2,2,3)
plot(squeeze(pac_standard(3,2,:)))
title('Tort 3->2')
xlabel('shift in samples')
ylabel('pac score')
ylim([0 5*10^-4])
subplot(2,2,4)
plot(squeeze(b_orig(3,2,:)))
title('Bispec 3->2')
xlabel('shift in samples')
ylabel('pac score')
% ylim([0 10^-5])




