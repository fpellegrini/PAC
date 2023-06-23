function fp_investigate_leakage
% Function that plots correlation between source-reconstructed time series 
% at seed region containing univariate PAC and other regions (for
% Supplementary Figure S3)
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

DIRFIG = './';

%%

rng(1) %fix rng seed
ip= 10;%univariate PAC case 
params = fp_get_params_pac(ip);

% get atlas, voxel and roi indices
D = fp_get_Desikan(params.iReg);

%signal generation
fprintf('Signal generation... \n')
[sig,brain_noise,sensor_noise,L,iroi_phase, ~,D, fres, n_trials,filt] = ...
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

%% Source projection, dimensionality reduction, and PAC estimation 

L_backward = L(:, D.ind_cortex, :);
A = fp_get_lcmv(signal_sensor,L_backward); %calculate inverse filter 
signal_roi = fp_dimred(signal_sensor,D,A,params.t); %source projection and dim reduction 

%estimation of PAC with uncorrected bispectrum 
[b_orig, ~, ~,~] = fp_pac_bispec(signal_roi,fres,filt);


%% get neighboring structure

load('~/Dropbox/Franziska/Data_MEG_Project/processed_bs_wzb_90_2000/bs_results.mat')
iatl = 3; % DK atlas
neighbor_thresh = 10; % 10mm vicinity defines neighborhood between regions
[~, ~, nb, ~] = get_ROI_dist_full(cortex, iatl, neighbor_thresh);

cnb = find(nb(:,iroi_phase)==0.5); %neighbors
cnb1 = setdiff(1:68,[cnb; iroi_phase]); %non-neighbors 



%% filter signals in low and high freq band 

high = mean(filt.high);
low = mean(filt.low); 

%filter bandwidth 
low_0= [-2 2];
high_0 = [-(low)-1 (low)+1];

[bl al] = butter(5, (low +low_0)/fres*2); 
%for this visualization we choose a broad bandwidth for high freq band 
[bh ah] = butter(5, (high + high_0)/fres*2);

seed = signal_roi(iroi_phase,:,:); %seed region with univariate PAC
nbs = signal_roi(cnb,:,:); %neighbors
nnbs = signal_roi(cnb1,:,:); %non-neighbors 

%filters 
sl = filtfilt(bl, al, seed);
sh = filtfilt(bh, ah, seed);

for ii = 1:numel(cnb)    
    nl(ii,:) = filtfilt(bl, al, nbs(ii,:)); %neighbors in low freq band 
    nh(ii,:) = filtfilt(bh, ah, nbs(ii,:)); %neighbors in high freq band 
    
end 

for ii = 1:numel(cnb1)    
    nnl(ii,:) = filtfilt(bl, al, nnbs(ii,:)); %non-neighbors in low freq band
    nnh(ii,:) = filtfilt(bh, ah, nnbs(ii,:)); %non-neighbors in high freq band 
end 

%% Pearson correlations

ccl = corr(sl(:,:)',nl(:,:)'); %seed low to nighbors low 
cch = corr(sh(:,:)',nh(:,:)'); %seed high to neighbors high 
ccln = corr(sl(:,:)',nnl(:,:)'); %seed low to non-neighbors low 
cchn = corr(sh(:,:)',nnh(:,:)'); %see high to non-neighbors high 

%% Plotting 

figure
figone(6,18)
subplot(1,2,1)
u1= b_orig(iroi_phase,cnb);
u2= b_orig(cnb,iroi_phase)';
bar(u1); hold on; bar(u2)
% title('PAC score between seed and 4 neighboring regions')
legend('Seed Amplitude','Seed Phase')
ylim([0 6*(10^-5)])
ylabel('PAC score','FontSize',15)
xlabel('Region number','FontSize',15)
% outname = [DIRFIG 'nb_PAC.eps'];
% print(outname,'-depsc');

% figure
subplot(1,2,2)
u3= b_orig(iroi_phase,cnb1);
u4= b_orig(cnb1,iroi_phase)';
bar(u3); hold on; bar(u4)
% title('PAC score between seed and 63 non-neighboring regions')
legend('Seed Amplitude','Seed Phase')
ylim([0 6*(10^-5)])
ylabel('PAC score','FontSize',15)
xlabel('Region number','FontSize',15)
% outname = [DIRFIG 'nb_nnb_PAC.eps'];
% print(outname,'-depsc');

%%
figure
figone(6,18)
subplot(1,2,1)
bar(ccl)
hold on 
bar(cch)
legend('Low freq','High freq')
ylim([-0.7 0.7])
% title('Correlation between seed and 4 neighbors')
grid on 
ylabel('Pearson r','FontSize',15)
xlabel('Region number','FontSize',15)
% outname = [DIRFIG 'nb_corr.eps'];
% print(outname,'-depsc');


% figure
% figone(6,10)
subplot(1,2,2)
bar(ccln)
hold on 
bar(cchn)
% title('High freq correlation between seed and 63 non-neighbors')
ylim([-0.7 0.7])
grid on 
legend('Low freq','High freq')
% title('Correlation between seed and 63 non-neighbors')
ylabel('Pearson r','FontSize',15)
xlabel('Region number','FontSize',15)
% outname = [DIRFIG 'nb_nnb_corr.eps'];
% print(outname,'-depsc');


%%
%PAC scores measured with original bispec 
mean(u1)%seed amp neigh
mean(u2)%seed phase neigh
mean(u3)%seed amp non-neigh
mean(u4)%seed phase non-neigh

%correlations 
mean(abs(ccl))
mean(abs(cch))
mean(abs(ccln))
mean(abs(cchn))

