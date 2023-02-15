
rng(1)
ip= 10;
params = fp_get_params_pac(ip);

D = fp_get_Desikan(params.iReg);

%signal generation
fprintf('Signal generation... \n')
[sig,brain_noise,sensor_noise,L,iroi_phase, iroi_amplt,D, fres, n_trials,filt] = ...
    fp_pac_signal_fixregs(params,D);

%combine noise sources
noise = params.iss*brain_noise + (1-params.iss)*sensor_noise;
noise = noise ./ norm(noise(:),'fro');
%combine signal and noise
signal_sensor1 = params.isnr*sig + (1-params.isnr)*noise;
signal_sensor1 = signal_sensor1 ./ norm(signal_sensor1(:), 'fro');

%high-pass signal
signal_sensor = (filtfilt(filt.bhigh, filt.ahigh, signal_sensor1'))';
signal_sensor = signal_sensor / norm(signal_sensor, 'fro');

%reshape
signal_sensor = reshape(signal_sensor,[],size(signal_sensor,2)/n_trials,n_trials);
[n_sensors, l_epoch, n_trials] = size(signal_sensor);
%%
[W,~] = runica(signal_sensor(:,:),'verbose','off');

signal_unmixed = W*signal_sensor(:,:);
signal_unmixed = reshape(signal_unmixed,n_sensors, l_epoch, n_trials);

%%
fs = fres; 

figure
[pxx,f] = pwelch(signal_sensor(:,:)',2*fs,fs,2*fs,fs)
title('97 channels')
a = pxx(find(f==10),:);

figure;
pwelch(signal_unmixed(:,:)',2*fs,fs,2*fs,fs)
title('Independent components') 

%% 

topoplot(a,EEG.chanlocs)
