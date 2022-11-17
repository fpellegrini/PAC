
DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/bispectra/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/shuffled_test/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with high performance classification
% subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
subs = [3 4 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 29 30 31 33 34 35 37];
regions = {'post l','post r','pre l','pre r'};
%%
isb = 1;
for isub = subs
    
    sub = ['vp' num2str(isub)];
    load([DIRIN sub '_PAC_shuf.mat'])
    
    BORS(isb,:,:,:,:,:)=bors;
    BOLS(isb,:,:,:,:,:)=bols;
    BARS(isb,:,:,:,:,:)=bars;
    BALS(isb,:,:,:,:,:)=bals;
    
    BOR(isb,:,:,:,:)=bor;
    BOL(isb,:,:,:,:)=bol;
    BAR(isb,:,:,:,:)=bar;
    BAL(isb,:,:,:,:)=bal;
    
    isb = isb+1;
    
end


%%
[nsub, nf1, nf2, nr1, nr2,nshuf] = size(BORS);

par = nan(isb,ifq,jfq,iroi,jroi);
pal = nan(isb,ifq,jfq,iroi,jroi);

for isb = 1:nsub
    for ifq = 1:nf1
        for jfq=ifq:nf2
            if (ifq+jfq<50)
                for iroi = 1:nr1
                    for jroi = 1:nr2
                        
                        if (iroi~=jroi)
                            par(isb,ifq,jfq,iroi,jroi)= sum(BAR(isb,ifq,jfq,iroi,jroi)< BARS(isb,ifq,jfq,iroi,jroi,:))/nshuf;
                            pal(isb,ifq,jfq,iroi,jroi) = sum(BAL(isb,ifq,jfq,iroi,jroi)< BALS(isb,ifq,jfq,iroi,jroi,:))/nshuf;
                        end
                    end
                end
            else
                par(isb,ifq,jfq,iroi,jroi)= nan;
                pal(isb,ifq,jfq,iroi,jroi) = nan;
                
            end
        end
    end
end

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
                subplot(5,5,isb)
                imagesc((squeeze(par1(isb,:,:,iroi,jroi))))
                %                 colorbar
                caxis([-1 3])
                title(['subject ' num2str(subs(isb))])
                xlabel('amplitude freqs')
                ylabel('phase freqs')
                axis equal
                ylim([0 25])
                if isb == nsub
                    colorbar
                end
            end
            outname = [DIRFIG 'right_' regions{jroi} '--' regions{iroi} '.png'];
            print(outname,'-dpng');
            close all
            
            figure
            figone(30,40)
            for isb = 1:nsub
                subplot(5,5,isb)
                imagesc((squeeze(pal1(isb,:,:,iroi,jroi))))
                %                 colorbar
                caxis([-1 3])
                title(['subject ' num2str(subs(isb))])
                xlabel('amplitude freqs')
                ylabel('phase freqs')
                axis equal
                ylim([0 25])
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

par1 = par;
par1(par>0.05)=0;
par1(par<0.05)=1;

pal1 = pal;
pal1(pal>0.05)=0;
pal1(pal<0.05)=1;

hr = squeeze(sum(par1,1));
hl = squeeze(sum(pal1,1)); 


figure
figone(30,40)
u=1;
for iroi = 1:nr1
    for jroi = 1:nr2        
        if iroi ~= jroi
            
                subplot(4,4,u)
                imagesc((squeeze(hr(:,:,iroi,jroi))))
                colorbar
                caxis([0 8])
                xlabel('amplitude freqs')
                ylabel('phase freqs')
                axis equal
                title([regions{jroi} '--' regions{iroi}])
                ylim([0 25])
        end 
        u = u+1;
    end
end

outname = [DIRFIG 'right_sum_pvals.png'];
print(outname,'-dpng');
% close all


figure
figone(30,40)
u=1;
for iroi = 1:nr1
    for jroi = 1:nr2        
        if iroi ~= jroi
            
                subplot(4,4,u)
                imagesc((squeeze(hl(:,:,iroi,jroi))))
                colorbar
                caxis([0 8])
                xlabel('amplitude freqs')
                ylabel('phase freqs')
                axis equal
                title([regions{jroi} '--' regions{iroi}])
                ylim([0 25])
        end 
        u = u+1;
    end
end

outname = [DIRFIG 'left_sum_pvals.png'];
print(outname,'-dpng');
% close all




