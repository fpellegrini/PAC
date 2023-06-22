DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/-1-2sec/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/-1-2sec/right/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
rois = [43,44,49,50]; %Regions of interest: pericalcarine l/r, precentral l/r
regions = {'pericalc l','pericalc r','pre l','pre r'};
%%
for isb = 1:numel(subs)
    
    sub = ['vp' num2str(subs(isb))]
    EEG = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN);
    
    data = EEG.roi.source_roi_data(rois,1:300,:);
    
    [nchan,np,nep]=size(data);
    
    fs = EEG.srate;
    high = [15 20];
    low = 3;
    
    [bl al] = butter(4, (low)/fs*2,'low');
    [bh ah] = butter(3, (high)/fs*2);
    
    for iroi = 1:4
        xl(iroi,:) = filtfilt(bl, al, double(data(iroi,:)));
        amp(iroi,:) = abs(hilbert(filtfilt(bh, ah, double(data(iroi,:)))));
    end
    
    lf = reshape(xl,[4,np,nep]);
    hf = reshape(amp,[4,np,nep]);
    
    %%
    
    for iroi = 1:4
        bl_hf = mean(squeeze(mean(hf(iroi,50:100,:),3))');
        max_hf(isb,iroi) = (max(squeeze(mean(hf(iroi,101:end,:),3)))-bl_hf)/bl_hf;
        min_hf(isb,iroi) = (min(squeeze(mean(hf(iroi,101:end,:),3)))-bl_hf)/bl_hf;
        
        range_lf(isb, iroi) = max(squeeze(mean(lf(iroi,101:end,:),3)))-min(squeeze(mean(lf(iroi,101:end,:),3)));
        range_hf(isb, iroi) = max(squeeze(mean(hf(iroi,101:end,:),3)))-min(squeeze(mean(hf(iroi,101:end,:),3)));
    end
    
    %%
    if 0
        figure
        figone(20,30)
        for iroi=1:4
            subplot(4,4,iroi)
            plot(-100:200-1,squeeze(mean(lf(iroi,:,:),3)))
            hold on
            xline(0,'r')
            title(['Phase ' regions{iroi}])
            %         ylim([-0.003 0.003])
        end
        
        for iroi = 1:4
            subplot(4,4,4+iroi)
            plot(-100:200-1,squeeze(lf(iroi,:,:)))
            hold on
            xline(0,'r')
        end
        
        for iroi=1:4
            subplot(4,4,8+iroi)
            plot(-100:200-1,squeeze(mean(hf(iroi,:,:),3)))
            hold on
            xline(0,'r')
            title(['Envelope ' regions{iroi}])
            %         ylim([-0.003 0.003])
        end
        
        for iroi = 1:4
            subplot(4,4,12+iroi)
            plot(-100:200-1,squeeze(hf(iroi,:,:)))
            hold on
            xline(0,'r')
        end
        %%
        %         outname = [DIRFIG num2str(isb) '.png'];
        %         print(outname,'-dpng');
        %         close all
        %
    end
    
    if 0
        regions = {'Pericalc left','Pericalc right','Precentral left','Precentral right'};
        rc = [[3 2];[2 3];[4 1];[1 4];[3 1];[1 3];[4 2];[2 4]];
        
        figure
        figone(20,30)
        for u = 1:size(rc,1)
            iroi = rc(u,1);
            jroi = rc(u,2);
            subplot(4,2,u)
            lf1 = squeeze(mean(lf(iroi,:,:),3));
            lf2= lf1-mean(lf1);
            plot(-100:200-1,lf2./std(lf2))
            hold on
            hf1 = squeeze(mean(hf(jroi,:,:),3));
            hf2 = hf1-mean(hf1);
            plot(-100:200-1,hf2./std(hf2))
            hold on
            xline(0,'r')
            title([regions{iroi} '--' regions{jroi}])
            legend('Phase','Envelope')
            %         ylim([-0.003 0.003])
        end
        
        
        %%
        %         outname = [DIRFIG num2str(isb) '.png'];
        %         print(outname,'-dpng');
        %         close all
        %
    end
    
end
%%
figure;
imagesc(min_hf(:,1:2))
title('min hf')
colorbar

figure;
imagesc(range_lf)
title('range lf')
colorbar

figure;
imagesc(range_hf)
title('range hf')
colorbar
