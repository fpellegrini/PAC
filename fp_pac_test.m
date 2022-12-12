function fp_pac_test

DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/';

DIROUT = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/normalized_bispecs/';
if ~exist(DIROUT); mkdir(DIROUT); end

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];

rois = [45,46,49,50]; %Regions of interest: postcentral l/r, precentral l/r

%%
isb = 1;
for isub = subs
    tic
    % load preprocessed EEG    
    sub = ['vp' num2str(isub)];
    EEG_left = pop_loadset('filename',['roi_' sub '_left.set'],'filepath',DIRIN) ;
    EEG_right = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN);
    
    %select data of rois 
    dl = EEG_left.roi.source_roi_data(rois,:,:); 
    dr = EEG_right.roi.source_roi_data(rois,:,:); 
    
    %calculate bispectra
    bol = nan(25,50,4,4);
    bal = nan(25,50,4,4);
    bor = nan(25,50,4,4);
    bar = nan(25,50,4,4);
   
    for ifl = 1:25
        for ifh = ifl:50
            if (ifh+ifl<50) 
                filt.low = [ifl];
                filt.high = [ifh];
%                 [bol(ifl,ifh,:,:), bal(ifl,ifh,:,:)] = fp_pac_bispec_red(dl,EEG_left.srate,filt);
%                 [bor(ifl,ifh,:,:), bar(ifl,ifh,:,:)] = fp_pac_bispec_red(dr,EEG_left.srate,filt);
                [bol(ifl,ifh,:,:), bal(ifl,ifh,:,:),boln(ifl,ifh,:,:), baln(ifl,ifh,:,:)] = fp_pac_bispec_red(dl,EEG_left.srate,filt);
                [bor(ifl,ifh,:,:), bar(ifl,ifh,:,:),born(ifl,ifh,:,:), barn(ifl,ifh,:,:)] = fp_pac_bispec_red(dr,EEG_left.srate,filt);
     
            end
        end
    end
    
    t=toc;
    save([DIROUT sub '_PAC.mat'],'bol','bal','bor','bar','boln','baln','born','barn','t','-v7.3')
    
%     BOR(isb,:,:,:,:)=bor;
%     BOL(isb,:,:,:,:)=bol; 
%     BAR(isb,:,:,:,:)=bar;
%     BAL(isb,:,:,:,:)=bal; 
%     isb = isb+1; 

end

% fp_plot_pac(DIRFIG,BOL,BAL,'left')
% fp_plot_pac(DIRFIG,BOR,BAR,'right')



