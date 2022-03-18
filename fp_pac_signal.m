function [sig,brain_noise,sensor_noise, L_save,iroi_phase,iroi_amplt,D, fres, n_trials,filt] = fp_pac_signal...
    (params,D)

%% set parameters

%total number of samples 
N = 1000000;

%Sampling frequency
fs = 200;
fres = fs; 
frqs = sfreqs(fres, fs); % freqs in Hz

%number of trails and epoch length
n_trials = 500;
Lepo = N/n_trials; 

%interacting bands 
low = [9 11];
high = [58 62];
band_inds_low = find(frqs >= low(1) & frqs <= low(2)); % indices of interacting low frequencies
band_inds_high = find(frqs >= high(1) & frqs <= high(2)); % indices of interacting high frequencies

%coupling strength = SNR in interacting frequency band 
coupling_snr = 0.6; 


%%

% filters for band and highpass
[bband_low, aband_low] = butter(5, low/(fs/2));
[bband_high, aband_high] = butter(5, high/(fs/2));
[bhigh, ahigh] = butter(5, 1/(fs/2), 'high');
  
filt.aband_low = aband_low;
filt.bband_low = bband_low;
filt.aband_high = aband_high;
filt.bband_high = bband_high;
filt.ahigh = ahigh;
filt.bhigh = bhigh;
filt.band_inds_low = band_inds_low;
filt.band_inds_high = band_inds_high;
filt.low = low; 
filt.high = high;
 
%% randomly select seed and in bivariate case also target 

%set seed and target regions
iroi_phase = randperm(D.nroi,params.iInt)';

if params.case==2 % in bivariate case 
    iroi_amplt = randperm(D.nroi,params.iInt)';

    %be sure that no region is selected twice
    for ii = 1:params.iInt
        while any(iroi_phase==iroi_amplt(ii))
            iroi_amplt(ii) = randi(D.nroi,1,1);
        end
    end
else 
    iroi_amplt = []; 
end

%% indices of signal and noise 

sig_ind = [];
for ii = 1:params.iReg
    if params.case==1 %univariate 
        sig_ind = [sig_ind; (iroi_phase.*params.iReg)-(ii-1)];
        iroi_amplt = iroi_phase; 
    elseif params.case==2 %bivariate 
        sig_ind = [sig_ind; (iroi_phase.*params.iReg)-(ii-1), (iroi_amplt.*params.iReg)-(ii-1)];
    end
end

noise_ind = setdiff(1:params.iReg*D.nroi,sig_ind(:));

%% generate signal low and high 

xl = randn(N,  params.iInt*params.iReg);
for ii = 1:  params.iInt*params.iReg
    xl(:,ii) = filtfilt(bband_low, aband_low, xl(:,ii));
end

xh = randn(N,  params.iInt*params.iReg);
for ii = 1: params.iInt*params.iReg
    xh(:,ii) = filtfilt(bband_high, aband_high, xh(:,ii));
end

xlh = hilbert(xl);
xlphase = angle(xlh);

xhh = hilbert(xh);
xhphase = angle(xhh);

xh = real((1-cos(xlphase)).*exp(1i*xhphase));


%% normalize low and high freq signal to 1/f shape 
% 
xh = xh./norm(xh,'fro');
xl = xl./norm(xl,'fro');

for ii = 1:size(xl,2)
    xl(:,ii) = fp_pinknorm(xl(:,ii));
    xh(:,ii) = fp_pinknorm(xh(:,ii));
end

%% generate interacting sources 

%concenate seed and target voxel activity
if params.case==1 %univariate case 
    %one region contains univariate pac 
    uni_pac = xh + xl;
    uni_pac = uni_pac./norm(uni_pac,'fro');
    %concatenate
    s1 = uni_pac;
    
elseif params.case==2 %bivariate case 
    %one region contains low signal, the other the modulated high signal 
    s1 = cat(2,xl,xh);
    s1 = s1./norm(s1(:),'fro');
end

% add pink background noise
backg = mkpinknoise(N, size(s1,2), 1);
backg = backg ./ norm(backg, 'fro');

%combine signal and background noise 
signal_sources = coupling_snr*s1 + (1-coupling_snr)*backg;

%% non-interacting sources

%activity at all voxels but the seed and target voxels
noise_sources = mkpinknoise(N, params.iReg*D.nroi-size(s1,2), 1);

%% leadfield for forward model

L_save = D.leadfield;
L3 = L_save(:, D.sub_ind_cortex, :); % select only voxels that belong to a region 

% multiply with normal direction to get from three to one dipole dimension 
normals = D.normals(D.sub_ind_cortex,:)'; 
for is = 1:numel(D.sub_ind_cortex)
    L_mix(:,is) = squeeze(L3(:,is,:))*squeeze(normals(:,is));
end

%select signal L and noise L 
L_sig = L_mix(:,sig_ind);
L_noise = L_mix(:,noise_ind);

%% project to sensors and generate white noise 

%signal on sensor level 
sig = L_sig * signal_sources';
sig = sig ./ norm(sig(:), 'fro');

%brain noise on sensor level 
try
    brain_noise = L_noise * noise_sources';
    brain_noise = brain_noise ./ norm(brain_noise(:), 'fro');
catch
    error('Something went wrong with seed or target selection.')
end

%white noise on sensor level (sensor noise)
sensor_noise = randn(size(sig));
sensor_noise = sensor_noise ./ norm(sensor_noise(:), 'fro');