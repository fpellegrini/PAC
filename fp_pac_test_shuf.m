
DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/0-2sec/bispectra/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/0-2sec/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
nsub = numel(subs);
regions = {'pericalc l','pericalc r','pre l','pre r'};

fs = 100;
f_nyq = fs/2; % Nyquist frequency in Hz
dr = 3; %we define PAC only when high freq is at least three times higher than low freq
f_lm = floor(f_nyq/(dr+1)); %maximum freq for low frequencies in Hz

pa = nan(nsub,f_lm,f_nyq,numel(regions),numel(regions));
%%
u = [];
for isb = 1:nsub
    isb
    sub = ['vp' num2str(subs(isb))];
    load([DIRIN sub '_PAC_shuf_right.mat'])
    [~,~,nr1, nr2,nshuf] = size(bas);
    
    for ifq = 1:f_lm
        for jfq=ifq*dr:f_nyq
            if (ifq+jfq<f_nyq)
                for iroi = 1:nr1
                    for jroi = 1:nr2
                        
                        if (iroi~=jroi)
                            pa(isb,ifq,jfq,iroi,jroi)= sum(bas(ifq,jfq,iroi,jroi,1)< bas(ifq,jfq,iroi,jroi,2:end))/(nshuf-1);
%                             pal(isb,ifq,jfq,iroi,jroi) = sum(bal(ifq,jfq,iroi,jroi)< bals(ifq,jfq,iroi,jroi,:))/nshuf;
                        end
                    end
                end              
            end
        end
    end
end
pa(pa==0)=1/(nshuf-1);
pa(u,:,:,:,:)=[];

% smooth 
% pas = smoothdata(smoothdata(pa,2,'gaussian',2.5),3,'gaussian',2.5);
pas = pa;

%% Stouffer's method

pl = fp_stouffer(pas,nshuf);
ind = find(~isnan(pl));

%we are not interested in inter-hemispheric coupling of the same region 
pl1=pl;
pl1(:,:,:,1,2)=nan;
pl1(:,:,:,2,1)=nan;
pl1(:,:,:,3,4)=nan;
pl1(:,:,:,4,3)=nan;
[pl_fdr, ~] = fdr(pl1(ind), 0.05);
pl(pl>pl_fdr)=1;

fp_plot_rdefig1(-log10(pl),[0 4])
outname = [DIRFIG 'left_stouffer.png'];
print(outname,'-dpng');
outname = [DIRFIG 'left_stouffer.eps'];
print(outname,'-depsc');
% close all

%%
figure; 
caxis([0 3]) 
cb = colorbar;
cb.Label.String = '-log10(p)';
cb.FontSize = 18;
outname = [DIRFIG 'cb_singlesub.png'];
print(outname,'-dpng');
% close all

%% subject-wise fdr 

for isb = 1: nsub
    pl = squeeze(pas(isb,:,:,:,:));
    ind = find(~isnan(pl));
    
    %we are not interested in inter-hemispheric coupling of the same region
%     pl1=pl;
%     pl1(:,:,:,1,2)=nan;
%     pl1(:,:,:,2,1)=nan;
%     pl1(:,:,:,3,4)=nan;
%     pl1(:,:,:,4,3)=nan;
%     [pl_fdr, ~] = fdr(pl1(ind), 0.05);
    pl(pl>0.05)=1;

    fp_plot_rdefig1(-log10(pl),[0 3])

    
    outname = [DIRFIG 'right_' num2str(isb) '_05.png'];
    print(outname,'-dpng');
    close all
    
end

%% subject-wise cluster perm mask 

DIRIN1 = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/0-2sec/clusterpermstats/';

for isb = [12 14 15 16 24 25]
    
    a=load([DIRIN1 num2str(isb) '.mat']);
    
    pl = squeeze(pas(isb,:,:,:,:));

    fp_plot_rdefig2(-log10(pl),[0 3],a.mask)

    
    outname = [DIRFIG 'right_' num2str(isb) '_clustmask.png'];
    print(outname,'-dpng');
    close all
    
end


