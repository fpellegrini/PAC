function fp_test_MI
%test motor imagery left vs right

DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/100Hz_srate/bispectra_5000/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/5000/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];

fs = 100;
f_nyq = fs/2; % Nyquist frequency in Hz
dr = 3; %we define PAC only when high freq is at least dr times higher than low freq
f_lm = floor(f_nyq/(dr+1)); %maximum freq for low frequencies in Hz
%%
isb = 1;
for isub = subs
    
    sub = ['vp' num2str(isub)];
    load([DIRIN sub '_PAC_shuf1-5000.mat'])
    
    BORN(isb,:,:,:,:)=born;
    BOLN(isb,:,:,:,:)=boln;
    BARN(isb,:,:,:,:)=barn;
    BALN(isb,:,:,:,:)=baln;
    
    BOR(isb,:,:,:,:)=bor;
    BOL(isb,:,:,:,:)=bol;
    BAR(isb,:,:,:,:)=bar;
    BAL(isb,:,:,:,:)=bal;
    
    isb = isb+1;
    
end

%%
fp_plot_pac(DIRFIG,BOL,BAL,'left')
fp_plot_pac(DIRFIG,BOR,BAR,'right')

fp_plot_pac(DIRFIG,BOLN,BALN,'left_norm')
fp_plot_pac(DIRFIG,BORN,BARN,'right_norm')

%%
pa = nan(size(squeeze(BAL(1,:,:,:,:))));
ta = nan(size(squeeze(BAL(1,:,:,:,:))));
po = nan(size(squeeze(BAL(1,:,:,:,:))));
to = nan(size(squeeze(BAL(1,:,:,:,:))));

nroi = size(BAR,4);
for ifq = 1:f_lm
    for jfq = ifq*dr:f_nyq
        if ifq+jfq < f_nyq
            for iroi=1:nroi
                for jroi = 1:nroi
                    
                    %                     [~, po(ifq,jfq,iroi,jroi), ~, stats] ...
                    %                         = ttest(squeeze(BOR(:,ifq,jfq,iroi,jroi)),squeeze(BOL(:,ifq,jfq,iroi,jroi)),...
                    %                         'alpha',0.05);
                    %                     to(ifq,jfq,iroi,jroi) = sign(stats.tstat);
                    %
                    %                     [~, pa(ifq,jfq,iroi,jroi), ~, stats] ...
                    %                         = ttest(squeeze(BAR(:,ifq,jfq,iroi,jroi)),squeeze(BAL(:,ifq,jfq,iroi,jroi)),...
                    %                         'alpha',0.05);
                    %                     ta(ifq,jfq,iroi,jroi) = sign(stats.tstat);
                    
                    data = squeeze(BOL(:,ifq,jfq,iroi,jroi))-squeeze(BOR(:,ifq,jfq,iroi,jroi));
                    [po(ifq,jfq,iroi,jroi), ~, stats]  = signrank(data);
                    to(ifq,jfq,iroi,jroi) = sign(stats.zval);
                    
                    data = squeeze(BAL(:,ifq,jfq,iroi,jroi))-squeeze(BAR(:,ifq,jfq,iroi,jroi));
                    [pa(ifq,jfq,iroi,jroi), ~, stats] = signrank(data);
                    ta(ifq,jfq,iroi,jroi) = sign(stats.zval);
                    
                    data = squeeze(BOLN(:,ifq,jfq,iroi,jroi))-squeeze(BORN(:,ifq,jfq,iroi,jroi));
                    [pon(ifq,jfq,iroi,jroi), ~, stats] = signrank(data);
                    ton(ifq,jfq,iroi,jroi) = sign(stats.zval);
                    
                    data=squeeze(BALN(:,ifq,jfq,iroi,jroi))-squeeze(BARN(:,ifq,jfq,iroi,jroi));
                    [pan(ifq,jfq,iroi,jroi), ~, stats] = signrank(data);
                    tan(ifq,jfq,iroi,jroi) = sign(stats.zval);
                    
                end
            end
        end
    end
end

%%

dirout = [DIRFIG 'normalized_fdr/'];
if ~exist(dirout); mkdir(dirout); end

fp_plot_pac_pvals(dirout,pon,pan,ton,tan)

%%
dirout = [DIRFIG 'unnormalized_fdr/'];
if ~exist(dirout); mkdir(dirout); end

fp_plot_pac_pvals(dirout,po,pa,to,ta)

