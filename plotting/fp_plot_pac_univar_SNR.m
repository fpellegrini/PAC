function fp_plot_pac_univar_SNR
% Function that plots results of univariate whole-brain simulation
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
addpath('/Users/franziskapellegrini/Dropbox/Franziska/MEG_Project/matlab/libs/emd_for_icoh/roi_connectivity_emd/');

DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/pacsim5/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim5/univar/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%% set some parameters

%colors for plotting
cols = [[0 0 0.5];[0.8 0 0.2];[0.8 0 0.2]];

titles = {'0 dB', '7.4 dB','12 dB'};
mets = {'MI','BISPEC','ASB-PAC'};

%% load data
a=[];

for iit= 1:100
    try
        isnr = 1;
        for ip = [14 15 10]
            params = fp_get_params_pac(ip);
            
            inname = sprintf('pr_univar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
            load([DIRDATA inname '.mat'])
            
            %false positives
            P{1}(:,:,iit,isnr) = p_standard<0.05;
            P{2}(:,:,iit,isnr) = p_orig<0.05;
            P{3}(:,:,iit,isnr) = p_anti<0.05;
            
            %seed region
            iroi(:,iit,isnr)=iroi_phase;  
            isnr = isnr+1;
        end        
        
    catch
        a=[a iit];
    end
end

%% in case some iteration is missing, remove that iteration from all
%conditions
iroi(:,a(a<=size(P{3},3)),:)=[];
for ii =1:3
    P{ii}(:,:,a(a<=size(P{3},3)),:)=[];    
end


%% get neighboring structure

load('./bs_results.mat')
iatl = 3; % DK atlas
neighbor_thresh = 10; % 10mm vicinity defines neighborhood between regions
[~, ~, nb, ~] = get_ROI_dist_full(cortex, iatl, neighbor_thresh);

%% Calculate global false positive rate for neighboring regions
for isnr = 1:3
    for iit = 1:size(iroi,2)%loop over iterations
        for im = 1:numel(P) %loop over metrics
            u1=[];
            u2=[];
            for ir = 1:size(iroi,1) %loop over seed regions
                cnb = find(nb(:,iroi(ir,iit,isnr))==0.5); %find neighbors of current seed region
                
                %collect false positives of neighboring regions at current seed region in current iteration
                
                %direction 1: between amplitude of seed region and phase of
                %neighbors
                temp= P{im}(iroi(ir,iit,isnr),cnb,iit,isnr);
                u1 = [u1 mean(temp(:))]; %mean over neighbors
                
                %direction 2: between phase of seed region and amplitude of
                %neighbors
                temp= P{im}(cnb,iroi(ir,iit,isnr),iit,isnr)';
                u2 = [u2 mean(temp(:))]; %mean over neighbors
            end
            
            %mean over seed regions
            m1(im,iit,isnr) = mean(u1(:));
            m2(im,iit,isnr) = mean(u2(:));
        end
    end
end

%% Plotting FPR between phase of neighboring regions and amplitude of seed region

for im = 1:3
    figure
    figone(6,10)
    
    o=1;
    for isnr=1:3
        
        data1 = squeeze(m1(im,:,isnr));
        
        subplot(1,3,o)
        
        %raincloud plot with linear y axis
        [h, ~] = fp_raincloud_plot_c(data1, cols(im,:), 1,0.2, 'ks');
        
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        htit = title(titles{isnr});
        htit.Position(1) = -0.12;
        set(gca,'ytick',[])
        ylim([-0.75 2])
        box off
        
        if o==1
            xlabel('FPR')
            set(gca,'Clipping','Off')
            xt = xticks;
            for ix = xt
                hu = line([ix ix],[2 -15]);
                set(hu, 'color',[0.9 0.9 0.9])
                uistack(hu,'bottom')
            end
            hu1 = line([0 0],[2 -15]);
            set(hu1, 'color',[0 0 0])
        else
            set(gca,'xticklabel',{[]})
            set(gca,'XColor','none','YColor','none','TickDir','out')
            set(gca,'Clipping','Off')
            for ix = xt
                hu = line([ix ix],[2.2 -0.75]);
                set(hu, 'color',[0.9 0.9 0.9])
                uistack(hu,'bottom')
            end
            hu = line([0 0],[2.2 -0.75]);
            set(hu, 'color',[0 0 0])
        end
        
        o=o+1;
    end
    
    hp = suptitle(mets{im});
    hp.Position = [0.5 -0.16 0];
    
    %%
    outname = [DIRFIG 'SNR_' mets{im} '_uni_seedamp.eps'];
    print(outname,'-depsc');
%     outname = [DIRFIG 'neighbors_seedamp_filt' params.ifilt '_' mets{im} '_SNR.png'];
%     print(outname,'-dpng');
    close all
    
end

%% Plotting FPR between phase of seed region and amplitude of neighboring regions

for im = 1:3
    figure
    figone(6,10)
    
    o=1;
    for isnr=1:3
        
        data1 = squeeze(m2(im,:,isnr));
        
        subplot(1,3,o)
        
        %raincloud plot with linear y axis
        [h, u] = fp_raincloud_plot_c(data1, cols(im,:), 1,0.2, 'ks');
        
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        htit = title(titles{isnr});
        htit.Position(1) = -0.12;
        set(gca,'ytick',[])
        ylim([-0.75 2])
        box off
        
        if o==1
            xlabel('FPR')
            set(gca,'Clipping','Off')
            xt = xticks;
            for ix = xt
                hu = line([ix ix],[2 -15]);
                set(hu, 'color',[0.9 0.9 0.9])
                uistack(hu,'bottom')
            end
            hu1 = line([0 0],[2 -15]);
            set(hu1, 'color',[0 0 0])
        else
            set(gca,'xticklabel',{[]})
            set(gca,'XColor','none','YColor','none','TickDir','out')
            set(gca,'Clipping','Off')
            for ix = xt
                hu = line([ix ix],[2.2 -0.75]);
                set(hu, 'color',[0.9 0.9 0.9])
                uistack(hu,'bottom')
            end
            hu = line([0 0],[2.2 -0.75]);
            set(hu, 'color',[0 0 0])
        end
        
        o=o+1;
    end
    hp = suptitle(mets{im});
    hp.Position = [0.5 -0.16 0];
    %%
    
    outname = [DIRFIG 'SNR_' mets{im} '_uni_seedphase.eps'];
    print(outname,'-depsc');
%     outname = [DIRFIG 'neighbors_seedphase_filt' params.ifilt '_' mets{im} '_SNR.png'];
%     print(outname,'-dpng');
    close all
end
