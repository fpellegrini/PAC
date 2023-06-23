function fp_plot_2chan_sim_baseline 
% Plots results of fp_2chan_sim_baseline 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/2chan_sim9_baseline/';

nit =100;

for iit = 1:nit
    load([DIRIN 'pvals_' num2str(iit) '.mat'])
    
    for isnr = 1:size(p,2)
        for cse = 1:size(p,1)
            for imet = 1:length(p{cse,isnr})
                pval{isnr}(cse,imet,iit) = p{cse,isnr}(imet);
                tpr{isnr}(cse,imet,iit) =  p{cse,isnr}(imet)<0.05; %true positive rate 
            end
        end
    end
end



%% Plot TPR 

%set some plotting parameters 
legend_ = {'MI','Bispec','0.05'};

%xticks
[~, nsnr] = size(p);
snrs1 = [0.1 0.2 0.3 0.4];
snrs_dB = 20*log10(snrs1./(1-snrs1));
for ii = 1:numel(snrs_dB)
    SNR_dB{ii} = num2str(round(snrs_dB(ii)));
end
xticks = 2:nsnr;
xTickLabels = SNR_dB(1:end);

%colors
cols = [[0 0 0.5];[0 0 0.5];[0 0 0.5];...
    [0.8 0 0.2];[0.8 0 0.2]];

figure
figone(5,9)

for imet = [1 4]
    for isnr = 1:nsnr
        a(isnr) = mean(squeeze(tpr{isnr}(1,imet,:)));
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
legend(legend_,'Location','southeast')
ylabel('TPR')
xlabel('SNR (dB)')
set(gca,'xtick',xticks,'xticklabels',xTickLabels);
ylim([0 1])
title('Within-channel univariate')



