
DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/100Hz_srate/bispectra_5000/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/5000/shuffled_test/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
nsub = numel(subs);
regions = {'post l','post r','pre l','pre r'};

fs = 100;
f_nyq = fs/2; % Nyquist frequency in Hz
dr = 3; %we define PAC only when high freq is at least dr times higher than low freq
f_lm = floor(f_nyq/(dr+1)); %maximum freq for low frequencies in Hz

par = nan(nsub,f_lm,f_nyq,numel(regions),numel(regions));
pal = nan(nsub,f_lm,f_nyq,numel(regions),numel(regions));
%%
isb = 1;
for isub = subs
    isb
    sub = ['vp' num2str(isub)];
    load([DIRIN sub '_PAC_shuf1-5000.mat'])
    [~,~,nr1, nr2,nshuf] = size(bars);
    
    for ifq = 1:f_lm
        for jfq=ifq*dr:f_nyq
            if (ifq+jfq<f_nyq)
                for iroi = 1:nr1
                    for jroi = 1:nr2
                        
                        if (iroi~=jroi)
                            par(isb,ifq,jfq,iroi,jroi)= sum(bar(ifq,jfq,iroi,jroi)< bars(ifq,jfq,iroi,jroi,:))/nshuf;
                            pal(isb,ifq,jfq,iroi,jroi) = sum(bal(ifq,jfq,iroi,jroi)< bals(ifq,jfq,iroi,jroi,:))/nshuf;
                        end
                    end
                end
            else
                par(isb,ifq,jfq,iroi,jroi)= nan;
                pal(isb,ifq,jfq,iroi,jroi) = nan;               
            end
        end
    end
    isb = isb+1;
end
par(par==0)=1/(nshuf-1);
pal(pal==0)=1/(nshuf-1);
%%
par1 = par;
par1(par1>0.05)=1;
par1 = -log10(par1);
par1(isnan(par))=-1;

pal1 = pal;
pal1(pal1>0.05)=1;
pal1 = -log10(pal1);
pal1(isnan(pal))=-1;


for iroi = 1:nr1
    for jroi = 1:nr2
        
        if iroi ~= jroi
            figure
            figone(30,40)
            for isb = 1:nsub
                subplot(4,6,isb)
                imagesc((squeeze(par1(isb,:,:,iroi,jroi))))
                %                 colorbar
                caxis([-1 4])
                title(['subject ' num2str(subs(isb))])
                xlabel('amplitude freqs')
                ylabel('phase freqs')
                axis equal
                ylim([0 12])
                if isb == nsub
                    colorbar
                end
            end
            outname = [DIRFIG 'right_' regions{jroi} '--' regions{iroi} '.png'];
            print(outname,'-dpng');
            close all
            
            figure
            figone(30,40)
            for isb = 1:nsub-1
                subplot(5,5,isb)
                imagesc((squeeze(pal1(isb,:,:,iroi,jroi))))
                %                 colorbar
                caxis([-1 4])
                title(['subject ' num2str(subs(isb))])
                xlabel('amplitude freqs')
                ylabel('phase freqs')
                axis equal
                ylim([0 12])
                if isb == nsub
                    colorbar
                end
                
            end
            outname = [DIRFIG 'left_' regions{jroi} '--' regions{iroi} '.png'];
            print(outname,'-dpng');
            close all
        end
        
    end
end


%%
%fdr
for isb = 1:nsub
    par1 = par(isb,:,:,:,:);
    pal1 = pal(isb,:,:,:,:);
    ind = find(~isnan(par1));
    [par_fdr, ~] = fdr(par1(ind), 0.05);
    [pal_fdr, ~] = fdr(pal1(ind), 0.05);
    
    par2 = par1;
    pal2 = pal1;
    
    par1(par2>par_fdr)=0;
    par1(par2<par_fdr)=1;
    pal1(pal2>pal_fdr)=0;
    pal1(pal2<pal_fdr)=1;
    
    PAR1(isb,:,:,:,:)=par1;
    PAL1(isb,:,:,:,:)=pal1;
    
end
ur = squeeze(nansum(PAR1,1));
ul = squeeze(nansum(PAL1,1));
hr = nan(size(ur));
hl = nan(size(ul));
hr(ind) = ur(ind);
hl(ind)= ul(ind); 


fp_plot_rdefig(hr,[0 3])
outname = [DIRFIG 'right_sum_pvals_fdr.png'];
print(outname,'-dpng');
close all

%%
fp_plot_rdefig(hl,[0 3])
outname = [DIRFIG 'left_sum_pvals_fdr.png'];
print(outname,'-dpng');
close all


%% Stouffer's method

zsr= norminv(par);
zr = squeeze(sum(zsr,1)./sqrt(nsub));
pr = normpdf(zr);
ind = find(~isnan(pr));
[pr_fdr, ~] = fdr(pr(ind), 0.05);
pr(pr>pr_fdr)=1;
fp_plot_rdefig(-log10(pr),[0 10])
outname = [DIRFIG 'right_stouffer.png'];
print(outname,'-dpng');
outname = [DIRFIG 'right_stouffer.eps'];
print(outname,'-depsc');
close all

zsl= norminv(pal);
zl = squeeze(sum(zsl,1)./sqrt(nsub));
pl = normpdf(zl);
[pl_fdr, ~] = fdr(pl(ind), 0.05);
pl(pl>pl_fdr)=1;
fp_plot_rdefig(-log10(pl),[0 10])
outname = [DIRFIG 'left_stouffer.png'];
print(outname,'-dpng');
outname = [DIRFIG 'left_stouffer.eps'];
print(outname,'-depsc');
close all

%%

figure; 
caxis([0 10]) 
cb = colorbar;
cb.Label.String = '-log10(p)';
cb.FontSize = 18;
outname = [DIRFIG 'cb_stouffer.eps'];
print(outname,'-depsc');
close all

