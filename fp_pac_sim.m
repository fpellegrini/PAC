function fp_pac_sim(params)

% define folders for saving results
DIROUT = '/home/bbci/data/haufe/Franziska/data/pac_sim1/';
if ~exist(DIROUT);mkdir(DIROUT); end
DIROUT1 = '/home/bbci/data/haufe/Franziska/data/pac_save1/';
if ~exist(DIROUT1);mkdir(DIROUT1); end


%% signal generation
tic
% getting atlas, voxel and roi indices; active voxel of each region
% is aleady selected here
fprintf('Getting atlas positions... \n')
D = fp_get_Desikan(params.iReg);

%signal generation
fprintf('Signal generation... \n')
[sig,brain_noise,sensor_noise,L,iroi_phase, iroi_amplt,D, fres, n_trials,filt] = ...
    fp_pac_signal(params,D);

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

t.signal = toc;

%% Leadfield 

%select only voxels that belong to any roi
L_backward = L(:, D.ind_cortex, :);

%% null distribution for shabazi method 

% tic
% [W] = jader(signal_sensor(:,:));
% signal_unmixed = W*signal_sensor(:,:);
% signal_unmixed = reshape(signal_unmixed,n_sensors, l_epoch, n_trials);
% 
% for ishuf = 1:params.nshuf    
%     %shuffling
%     fprintf(['Shuffle '  num2str(ishuf) '\n'])
%     signal_shuf = fp_shuffle_shab(W,signal_unmixed);
%     
%     %lcmv
%     A = fp_get_lcmv(signal_shuf,L_backward);
%     
%     %dimesionality reduction
%     signal_roi_shuf = fp_dimred(signal_shuf,D,A);
%     
%     %pac calculation 
%     pac_shuf(:,:,ishuf) = fp_pac_standard(signal_roi_shuf, filt.low, filt.high, fres);
%     
%     clear signal_shuf A signal_roi_shuf 
% end
% t.shab = toc;

%% true pac scores 

%lcmv
A = fp_get_lcmv(signal_sensor,L_backward);

%Dimensionality reduction 
signal_roi = fp_dimred(signal_sensor,D,A);

%standard pac
tic
pac_standard = fp_pac_standard(signal_roi, filt.low, filt.high, fres);
t.standard = toc;

%ortho pac
tic
[signal_ortho, ~, ~, ~] = symmetric_orthogonalise(signal_roi(:,:)', 1);
signal_ortho = reshape(signal_ortho',D.nroi,l_epoch,n_trials);
pac_ortho = fp_pac_standard(signal_ortho, filt.low, filt.high, fres);
t.ortho = toc;

%shabazi
% pac_shabazi = (pac_standard-mean(pac_shuf,3))/std(pac_shuf,[],3);

% bispectra 
tic
[b_orig, b_anti] = fp_pac_bispec(signal_roi,fres,filt);
t.bispec = toc;

%% Evaluate

[pr_standard] = fp_pr_pac(pac_standard,iroi_amplt,iroi_phase);
[pr_ortho] = fp_pr_pac(pac_ortho,iroi_amplt,iroi_phase);
% [pr_shabazi] = fp_pr_pac(pac_shab,iroi_amplt,iroi_phase);
[pr_bispec_o] = fp_pr_pac(b_orig,iroi_amplt,iroi_phase);
[pr_bispec_a] = fp_pr_pac(b_anti,iroi_amplt,iroi_phase);

ratio_standard = fp_diag_ratio(pac_standard);
ratio_ortho = fp_diag_ratio(pac_ortho);
% ratio_shabazi = fp_diag_ratio(pac_shabazi);
ratio_bispec_o = fp_diag_ratio(b_orig);
ratio_bispec_a = fp_diag_ratio(b_anti);

pr_shabazi = []; 
ratio_shabazi = []; 
%% Saving
fprintf('Saving... \n')
%save all
outname = sprintf('%spac_%s.mat',DIROUT,params.logname);
save(outname,'-v7.3')

%save only evaluation parameters
outname1 = sprintf('%spr_%s.mat',DIROUT,params.logname);
save(outname1,...
    'pr_standard','pr_ortho','pr_shabazi','pr_bispec_o','pr_bispec_a','t',...
    'ratio_standard','ratio_ortho','ratio_shabazi','ratio_bispec_o','ratio_bispec_a',...
    '-v7.3')

