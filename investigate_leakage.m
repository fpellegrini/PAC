
DIRFIG = '/Users/franziskapellegrini/Dropbox/Franziska/PAC_AAC_estimation/figures/supplement/';
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
L_backward = L(:, D.ind_cortex, :);
A = fp_get_lcmv(signal_sensor,L_backward);
signal_roi = fp_dimred(signal_sensor,D,A,params.t);
[b_orig, b_anti, b_orig_norm,b_anti_norm] = fp_pac_bispec(signal_roi,fres,filt);


%% get neighboring structure

load('~/Dropbox/Franziska/Data_MEG_Project/processed_bs_wzb_90_2000/bs_results.mat')
iatl = 3; % DK atlas
neighbor_thresh = 10; % 10mm vicinity defines neighborhood between regions
[~, ~, nb, ~] = get_ROI_dist_full(cortex, iatl, neighbor_thresh);

%%

cnb = find(nb(:,iroi_phase)==0.5); 
cnb1 = setdiff(1:68,[cnb; iroi_phase]);



%%

high = mean(filt.high);
low = mean(filt.low); 

%filter bandwidth 
low_0= [-2 2];
high_0 = [-(low)-1 (low)+1];

[bl al] = butter(5, (low +low_0)/fres*2); 
[bh ah] = butter(5, (high + high_0)/fres*2);

seed = signal_roi(iroi_phase,:,:);
nbs = signal_roi(cnb,:,:); 
nnbs = signal_roi(cnb1,:,:);

sl = filtfilt(bl, al, seed);
sh = filtfilt(bh, ah, seed);

for ii = 1:numel(cnb)    
    nl(ii,:) = filtfilt(bl, al, nbs(ii,:));
    nh(ii,:) = filtfilt(bh, ah, nbs(ii,:));
    
end 

for ii = 1:numel(cnb1)    
    nnl(ii,:) = filtfilt(bl, al, nnbs(ii,:));
    nnh(ii,:) = filtfilt(bh, ah, nnbs(ii,:));   
end 

%%
ccl = corr(sl(:,:)',nl(:,:)');
cch = corr(sh(:,:)',nh(:,:)');
ccln = corr(sl(:,:)',nnl(:,:)');
cchn = corr(sh(:,:)',nnh(:,:)');
%%

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
outname = [DIRFIG 'nb_nnb_PAC.eps'];
print(outname,'-depsc');

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
outname = [DIRFIG 'nb_nnb_corr.eps'];
print(outname,'-depsc');


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

