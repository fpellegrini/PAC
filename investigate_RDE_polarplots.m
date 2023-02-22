clear all
DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/100Hz_srate/';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
rois = [45,46,49,50]; %Regions of interest: postcentral l/r, precentral l/r
lroi = 2;
hroi = 3;
    
    
low = 3;
high = 28;

isb = 1;
for isub = subs
    
    %%
    % load preprocessed EEG
    sub = ['vp' num2str(isub)];
    EEG_left = pop_loadset('filename',['roi1_' sub '_left.set'],'filepath',DIRIN) ;
    d_l = EEG_left.roi.source_roi_data(rois,:,:);
    fs = EEG_left.srate;
    
    %% polar plot
    
    low_0= [-2 2];
    high_0 = [-(low+1) (low+1)];
    
    [bl al] = butter(3, (low +low_0)/fs*2);
    [bh ah] = butter(3, (high + high_0)/fs*2);
    
    xl = filtfilt(bl, al, d_l(lroi,:));
    xh = filtfilt(bh, ah, d_l(hroi,:));
    
    amp = abs(hilbert(xh));
    phase  = angle(hilbert(xl));
    
    z(isb,:) = amp.*exp(1i*phase);
    
    isb = isb +1;
end
%%

figure
figone(30,60)
for ii = 1:26-1
    subplot(5,5,ii)
    polarplot(z(ii,:)','.')
    rlim([0 0.015])
end






