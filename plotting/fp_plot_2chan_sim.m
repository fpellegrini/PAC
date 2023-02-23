DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/2chan_sim9/';

nit =100;
u=[];
for iit = 1:nit
    try
        load([DIRIN 'pvals_' num2str(iit) '.mat'])
        
        for isnr = 1:size(p,2)
            for cse = 1:size(p,1)
                for imet = 1:length(p{cse,isnr})
                    
                    pval{isnr}(cse,imet,iit) = p{cse,isnr}(imet);
                    if cse<3
                        tpnr{isnr}(cse,imet,iit) =  p{cse,isnr}(imet)<0.05;
                    else
                        tpnr{isnr}(cse,imet,iit) =  p{cse,isnr}(imet)>0.05;
                    end
                end
            end
        end
    catch 
        u = [u iit];
    end
    
end

%%
nmet = length(p{1,1}); 
[ncse, nsnr] = size(p); 
mets = {'MI','Ortho','ICshuf','Bispec','ASB','0.05'};
snrs = {'0', '0.2', '0.4', '0.6', '0.8', '1'};
snrs1= 0.2:0.2:0.8;
snrs_dB = 20*log10(snrs1./(1-snrs1));
for ii = 1:numel(snrs_dB)
    SNR_dB{ii} = num2str(round(snrs_dB(ii)));
end
cses = {'Bivariate','Bivariate mixed','Univariate','Univariate mixed'};
% 
% for isnr = 1:nsnr
%     
%     figure
%     ii=1;
%     for icse = 1:ncse
%         for imet = 1:nmet
%             
%             subplot(size(p,1),length(p{1,1}),ii)
%             hist(squeeze(pval{isnr}(icse,imet,:)))
%             xlim([0 1])
%             xlabel('pvalues')
%             title([mets{imet} ' ' cses{icse} ' snr ' snrs{isnr}])
%             
%             ii=ii+1;
%             
%         end
%     end
%     
% end

%%

% figure
% ii=1;
% for icse = 1:ncse
%     for imet = 1:nmet
%         
%         subplot(size(p,1),length(p{1,1}),ii)
%         for isnr = 1:nsnr
%             a(isnr) = mean(squeeze(pval{isnr}(icse,imet,:)));
%         end
%         plot(a)
%         ylabel('pval')
%         xlabel('snr')
%         title([cses{icse} ' ' mets{imet} ])
%         ylim([0 1])
%         
%         ii=ii+1;
%         
%     end
% end

%%
% clear a
% figure
% ii=1;
% for icse = 1:ncse
%     subplot(3,2,ii)
%     
%     for imet = 1:nmet
%         for isnr = 1:nsnr-1
%             a(isnr) = mean(squeeze(pval{isnr}(icse,imet,:)));
%         end
%         plot(a,'LineWidth',1)
%         
%         hold on
%     end
%     yline(0.05,'--')
%     
%     legend(mets)
%     ylabel('pval')
%     xlabel('snr')
%     xticks = 1:nsnr-1; 
%     xTickLabels = snrs(1:end-1);
%     set(gca,'xtick',xticks,'xticklabels',xTickLabels);
%     ylim([0 1])
%     title([cses{icse} ])
%     ii=ii+1;
%     
%     
% end

%% TPR and TNR
cols = [[0 0 0.5];[0 0.8 0.7];[0.3 1 0.3];...
    [0.8 0.6 0.7];[0.8 0 0.2]];
cols = [[0 0 0.5];[0 0 0.5];[0 0 0.5];...
    [0.8 0 0.2];[0.8 0 0.2]];


clear a
figure
figone(9,18)
ii=1;
for icse = [1 2 5 6]
    
    subplot(2,2,ii)
    
    for imet = 1:nmet
        for isnr = 1:nsnr-1
            a(isnr) = mean(squeeze(tpnr{isnr}(icse,imet,:)));
        end
        switch imet 
            case 1
                plot(a,'LineWidth',1.5,'Color',cols(imet,:)')
            case 2
                plot(a,'--','LineWidth',1.5,'Color',cols(imet,:)')
            case 3
                plot(a,'-.','LineWidth',1.5,'Color',cols(imet,:)')
            case 4
                plot(a,'LineWidth',1.5,'Color',cols(imet,:)')
            case 5
                plot(a,'--','LineWidth',1.5,'Color',cols(imet,:)')
        end
        
        hold on
    end
    if ii ==2
        legend(mets,'Location','southeast')
    end
    if icse<3
        ylabel('TPR')
    else
        ylabel('TNR')
    end
    xlabel('SNR (dB)')
    xticks = 2:nsnr-1; 
    xTickLabels = SNR_dB(1:end);
    set(gca,'xtick',xticks,'xticklabels',xTickLabels);
    ylim([0 1])
    title([cses{ii} ])
    ii=ii+1;
end



