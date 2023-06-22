


DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/0-2sec/bispectra/';

DIROUT = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/0-2sec/clusterpermstats/';
if ~exist(DIROUT); mkdir(DIROUT); end

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/0-2sec/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
nsub = numel(subs);
regions = {'pericalc l','pericalc r','pre l','pre r'};
nr1 = length(regions);
nr2 = length(regions);

alpha = 0.05;

%%

for isb = [12 14 15 16 24 25]
    clear p_clust mask t 
    sub = ['vp' num2str(subs(isb))];
    load([DIRIN sub '_PAC_shuf_right.mat'])
        
    for iroi = 1:nr1
        for jroi = 1:nr2            
            if (iroi~=jroi)&& ~(iroi==1 && jroi==2) && ~(iroi==2 && jroi==1) && ~(iroi==3 && jroi==4) && ~(iroi==4 && jroi==3)
                fprintf(['Subject ' num2str(isb) ', iroi ' num2str(iroi) ', jroi ' num2str(jroi) '\n' ])
                data = squeeze(bas(:,:,iroi,jroi,:));
                tic
                [p_clust(iroi,jroi), mask(:,:,iroi,jroi)]= fp_clust_correction(data,alpha);
                t(iroi,jroi) = toc
                
                imagesc(squeeze(mask(:,:,iroi,jroi)))
                title([num2str(isb) '-' regions{iroi} '--' regions{jroi}])
                outname = [DIRFIG 'right_' num2str(isb) '_' regions{iroi} '--' regions{jroi} '_clustmask.png'];
                print(outname,'-dpng');
                close all
            end
        end
    end
    if sum(mask(:)>0)
        save([DIROUT num2str(isb) '.mat'],'p_clust','mask','t','-v7.3')
    end
end
    
    
    