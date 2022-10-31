function fp_pac_test_clus

fp_addpath_pac

DIRIN = '/home/bbci/data/haufe/Franziska/data/pac_rde/';

DIROUT = [DIRIN 'bispecs/'];
if ~exist(DIROUT); mkdir(DIROUT); end

DIRLOG = 'home/bbci/data/haufe/Franziska/log/pac_rde/';
if ~exist(DIRLOG); mkdir(DIRLOG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
rois = [45,46,49,50]; %Regions of interest: postcentral l/r, precentral l/r

%%

%prevent array jobs to start at exactly the same time
isb = str2num(getenv('SGE_TASK_ID'));
isub = subs(isb)
logname = num2str(isub);

%%
if ~exist(sprintf('%s%s_work',DIRLOG,logname)) & ~exist(sprintf('%s%s_done',DIRLOG,logname))
    
    eval(sprintf('!touch %s%s_work',DIRLOG,logname))
    tic
    % load preprocessed EEG
    sub = ['vp' num2str(isub)]
    EEG_left = pop_loadset('filename',['roi1_' sub '_left.set'],'filepath',DIRIN) ;
    EEG_right = pop_loadset('filename',['roi1_' sub '_right.set'],'filepath',DIRIN);
    
    %select data of rois
    dl = EEG_left.roi.source_roi_data(rois,:,:);
    dr = EEG_right.roi.source_roi_data(rois,:,:);
    
    %calculate bispectra
    bol = nan(25,50,4,4);
    bal = nan(25,50,4,4);
    bor = nan(25,50,4,4);
    bar = nan(25,50,4,4);
    boln = nan(25,50,4,4);
    baln = nan(25,50,4,4);
    born = nan(25,50,4,4);
    barn = nan(25,50,4,4);
    
    for ifl = 1:25
        for ifh = ifl:50
            if (ifh+ifl<50)
                filt.low = [ifl];
                filt.high = [ifh];
                [bol(ifl,ifh,:,:), bal(ifl,ifh,:,:),boln(ifl,ifh,:,:), baln(ifl,ifh,:,:)] = fp_pac_bispec_red(dl,EEG_left.srate,filt);
                [bor(ifl,ifh,:,:), bar(ifl,ifh,:,:),born(ifl,ifh,:,:), barn(ifl,ifh,:,:)] = fp_pac_bispec_red(dr,EEG_left.srate,filt);
                
            end
        end
    end
    
    t=toc;
    save([DIROUT sub '_PAC.mat'],'bol','bal','bor','bar','boln','baln','born','barn','t','-v7.3')
    eval(sprintf('!mv %s%s_work %s%s_done',DIRLOG,logname,DIRLOG,logname))
    
end




