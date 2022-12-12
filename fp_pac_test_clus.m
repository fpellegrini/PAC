function fp_pac_test_clus

fp_addpath_pac

DIRIN = '/home/bbci/data/haufe/Franziska/data/pac_rde/';

DIROUT = [DIRIN 'bispecs3/'];
if ~exist(DIROUT); mkdir(DIROUT); end

DIRLOG = '/home/bbci/data/haufe/Franziska/log/pac_rde_shuf3/';
if ~exist(DIRLOG); mkdir(DIRLOG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
rois = [45,46,49,50]; %Regions of interest: postcentral l/r, precentral l/r
nshuf = 100; 

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
    EEG_left = pop_loadset('filename',['roi_' sub '_left.set'],'filepath',DIRIN) ;
    EEG_right = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN);
    
    f_nyq = EEG_left.srate/2;
    
    %select data of rois
    dl = EEG_left.roi.source_roi_data(rois,:,:);
    dr = EEG_right.roi.source_roi_data(rois,:,:);
    
    %calculate bispectra
    bol =  nan(f_nyq/4,f_nyq,4,4);
    bal =  nan(f_nyq/4,f_nyq,4,4);
    bor =  nan(f_nyq/4,f_nyq,4,4);
    bar =  nan(f_nyq/4,f_nyq,4,4);
    boln = nan(f_nyq/4,f_nyq,4,4);
    baln = nan(f_nyq/4,f_nyq,4,4);
    born = nan(f_nyq/4,f_nyq,4,4);
    barn = nan(f_nyq/4,f_nyq,4,4);
    bols = nan(f_nyq/4,f_nyq,4,4,nshuf);
    bals = nan(f_nyq/4,f_nyq,4,4,nshuf);
    bors = nan(f_nyq/4,f_nyq,4,4,nshuf);
    bars = nan(f_nyq/4,f_nyq,4,4,nshuf);
    
    for ifl = 1:25
        for ifh = ifl*3:f_nyq
            if (ifh+ifl<f_nyq)
                tic
                filt.low = [ifl];
                filt.high = [ifh]
                [bol(ifl,ifh,:,:), bal(ifl,ifh,:,:),boln(ifl,ifh,:,:), baln(ifl,ifh,:,:)] ...
                    = fp_pac_bispec(dl,EEG_left.srate,filt);
                [bor(ifl,ifh,:,:), bar(ifl,ifh,:,:),born(ifl,ifh,:,:), barn(ifl,ifh,:,:)]...
                    = fp_pac_bispec(dr,EEG_left.srate,filt);
                
                [bols(ifl,ifh,:,:,:), bals(ifl,ifh,:,:,:)] = fp_pac_bispec_uni(dl,EEG_left.srate,filt, nshuf);
                [bors(ifl,ifh,:,:,:), bars(ifl,ifh,:,:,:)] = fp_pac_bispec_uni(dr,EEG_left.srate,filt, nshuf);
                toc
            end
        end
    end
    
    t=toc;
    save([DIROUT sub '_PAC_shuf.mat'],'bol','bal','bor','bar','boln','baln','born','barn',...
        'bols','bals','bors','bars','t','-v7.3')
    eval(sprintf('!mv %s%s_work %s%s_done',DIRLOG,logname,DIRLOG,logname))
    
end




