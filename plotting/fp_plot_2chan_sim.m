function fp_plot_2chan_sim
% Visualizes results of fp_2chan_sim
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/2chan_sim9/';
u=[];
nit =100;
for iit = [1:nit]
    try
        load([DIRIN 'pvals_' num2str(iit) '.mat'])
        
        for isnr = 1:size(p,2)
            cse=1;
            for cse_ = [1 2 5 6]
                for imet = 1:length(p{cse_,isnr})
                    
                    pval{isnr}(cse,imet,iit) = p{cse_,isnr}(imet);
                    if cse<3 %in case 1 and 2, we evaluate true positives
                        tpnr{isnr}(cse,imet,iit) =  p{cse_,isnr}(imet)<0.05;
                    else % in cases 3 and 4, we evaluate true negatives
                        tpnr{isnr}(cse,imet,iit) =  p{cse_,isnr}(imet)>0.05;
                    end
                end
                cse=cse+1;
            end
        end
    catch
        u=[u iit];
    end
end
for isnr = 1:size(p,2)
    tpnr{isnr}(:,:,u)=[];
end

%% Plotting

%set some plotting parameters
legend_ = {'MI','ORTH','ICSURR','BISPEC','ASB','0.05'};
nmet = length(p{cse,isnr});

%xticks
[~, nsnr] = size(p);
snrs1= 0.2:0.2:0.8;
snrs_dB = 20*log10(snrs1./(1-snrs1));
for ii = 1:numel(snrs_dB)
    SNR_dB{ii} = num2str(round(snrs_dB(ii)));
end

%cases
cses = {'2CHAN-BI-IND','2CHAN-BI-MIX','2CHAN-UNI-IND','2CHAN-UNI-MIX'};

%colors
cols = [[0 0 0.5];[0 0 0.5];[0 0 0.5];...
    [0.8 0 0.2];[0.8 0 0.2]];


%% TPR and TNR

figure
figone(9,18)

ii=1;
for icse = 1:4
    
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
        legend(legend_,'Location','southeast');
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
    grid on
    ii=ii+1;
end



