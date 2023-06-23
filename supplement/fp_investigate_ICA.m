function fp_investigate_ICA 
% Function that plots sensor-level power spectra and power spectra of
% corresponding independent components (Supplementary Figure S2 in
% Pellegrini 2023) 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

rng(1) %fix rng seed
ip= 10; %univariate PAC case 
params = fp_get_params_pac(ip);

% get atlas, voxel and roi indices
D = fp_get_Desikan(params.iReg);

%signal generation
fprintf('Signal generation... \n')
[sig,brain_noise,sensor_noise,~,~, ~,~, fres, n_trials,filt] = ...
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

%% ICA
[W,~] = runica(signal_sensor(:,:),'verbose','off');

signal_unmixed = W*signal_sensor(:,:);
signal_unmixed = reshape(signal_unmixed,n_sensors, l_epoch, n_trials);

%% Plotting 

figure
figone(5,18)
subplot(1,2,1)
pwelch(signal_sensor(:,:)',2*fres,fres,2*fres,fres);
title('97 channels')

subplot(1,2,2)
pwelch(signal_unmixed(:,:)',2*fres,fres,2*fres,fres)
title('Independent components') 

