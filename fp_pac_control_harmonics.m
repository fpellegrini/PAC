
function fp_pac_control_harmonics


% DIRIN = '/home/bbci/data/haufe/Franziska/data/MIMrealdata/';
% 
% DIROUT = [DIRIN 'control/'];
% if ~exist(DIROUT); mkdir(DIROUT); end

DIRIN = './';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
rois = [50, 46]; %Regions of interest:  precentral r, postcentral r

%FOIs
ifl = 3;
ifh = 12;
filt.low = ifl;
filt.high = ifh;

nshuf = 100; 

%%
tic

%prevent array jobs to start at exactly the same time
for isb = 1:numel(subs)
    
    isub = subs(isb)
    
    % load preprocessed EEG
    sub = ['vp' num2str(isub)];
    EEG_left = pop_loadset('filename',['roi1_' sub '_right.set'],'filepath',DIRIN) ;
    fs = EEG_left.srate;
    
    %select data of rois
    d_l = EEG_left.roi.source_roi_data(rois,:,:);
    
    %calculate PAC        
    [~, bals] = fp_pac_bispec_uni(d_l,EEG_left.srate,filt, nshuf+1);
    p_pac(isb) = sum(squeeze(bals(1,2,2:end))>bals(1,2,1))/(nshuf);
        
    % harmonics    
    sig = squeeze(d_l(2,:,:));    

    %between 2 and 12 Hz at second region  
    p_2_12(isb) = fp_control_harmonics(sig,fs,2,12,1,6,nshuf);

    %between 3 and 12 Hz at second region  
    p_3_12(isb) = fp_control_harmonics(sig,fs,3,12,1,4,nshuf);

    %between 4 and 12 Hz at second region  
    p_4_12(isb) = fp_control_harmonics(sig,fs,4,12,1,3,nshuf);

    %between 6 and 12 Hz at second region  
    p_6_12(isb) = fp_control_harmonics(sig,fs,6,12,1,2,nshuf);
    
    %icoh 3 to 3 Hz between two regions 
    p_3_3(isb) = fp_control_harmonics_icoh(d_l, fs, 3, nshuf);
      
end
t=toc;

%%
p_pac_s = fp_stouffer(p_pac)
p_2_12_s = fp_stouffer(p_2_12)
p_3_12_s = fp_stouffer(p_3_12)
p_4_12_s = fp_stouffer(p_4_12)
p_6_12_s = fp_stouffer(p_6_12)
p_3_3_s = fp_stouffer(p_3_3)

%%

[pr_fdr, ~] = fdr([p_pac_s,p_2_12_s,p_3_12_s,p_4_12_s,p_6_12_s,p_3_3_s], 0.05);


