
addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
addpath('/Users/franziskapellegrini/Dropbox/Franziska/MEG_Project/matlab/libs/emd_for_icoh/roi_connectivity_emd/');

DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim5/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim5/univar/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%
cols = [[0 0 0.5];[0 0 0.5];...
    [0.8 0 0.2];[0.8 0 0.2];[0 0 0.5]];

for ip = [10]
    
    clearvars -except ip DIRFIG DIRDATA cols
    params = fp_get_params_pac(ip);
    
    titles = {'MI','Ortho','Bispec','ASB','ICshuf'};
    
    a=[];
    
    for iit= 1:100
        
        try
            if params.case == 1
                inname = sprintf('pr_univar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                    ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
            elseif params.case == 2
                inname = sprintf('pr_bivar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                    ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
            elseif params.case == 3
                inname = sprintf('pr_mixed_iInt%d%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                    ,params.iInt(1),params.iInt(2),params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
            end
            
            load([DIRDATA inname '.mat'])
            P{1}(:,:,iit) = p_standard<0.05;
            P{2}(:,:,iit) = p_ortho<0.05;
            P{3}(:,:,iit) = p_orig<0.05;
            P{4}(:,:,iit) = p_anti<0.05;
            P{5}(:,:,iit) = p_shahbazi<0.05;
            iroi(:,iit)=iroi_phase;
            
        catch
            a=[a iit];
            iit_ = setdiff(1:100,a); 
        end
        
        
    end
    %%
     iroi(:,a(a<=size(P{5},3)))=[];
    for ii =1:5
        P{ii}(:,:,a(a<=size(P{5},3)))=[];
        
    end
   
    
    %% get neighboring structure
    
    load('~/Dropbox/Franziska/Data_MEG_Project/processed_bs_wzb_90_2000/bs_results.mat')
    iatl = 3; % DK atlas
    neighbor_thresh = 10; % 10mm vicinity defines neighborhood between regions
    [~, ~, nb, ~] = get_ROI_dist_full(cortex, iatl, neighbor_thresh);
    
    %%
    for iit = 1:size(iroi,2)
        for im = 1:5
            
            u1=[];
            u2=[];
            for ir = 1:size(iroi,1)
                cnb = find(nb(:,iroi(iit))==0.5);
                
                u3= P{im}(iroi(ir,iit),cnb,iit);
                u1 = [u1 mean(u3(:))];
                u3= P{im}(cnb,iroi(ir,iit),iit)';
                u2 = [u2 mean(u3(:))];
            end
            m1(im,iit) = mean(u1(:));
            m2(im,iit) = mean(u2(:));
        end
    end
    
    %%
    o=1;
    figure
    figone(6,12)
    
    for im = [1 2 5 3 4]
        
        data1 = squeeze(m1(im,:));
        
        cl = [0.7 0.75 0.75];
        
        subplot(1,5,o)
        
        [h, u] = fp_raincloud_plot_c(data1, cols(im,:), 1,0.2, 'ks');
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        
        htit = title(titles{im});
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
    %
    outname = [DIRFIG 'neighbors_seedamp_iInt' num2str(params.iInt) '_filt' params.ifilt '.eps'];
    print(outname,'-depsc');
    outname = [DIRFIG 'neighbors_seedamp_iInt' num2str(params.iInt) '_filt' params.ifilt '.png'];
    print(outname,'-dpng');
    close all
    %%
    o=1;
    figure
    figone(6,12)
    
    for im = [1 2 5 3 4]
        
        data1 = squeeze(m2(im,:));
        
        cl = [0.7 0.75 0.75];
        
        subplot(1,5,o)
        
        [h, u] = fp_raincloud_plot_c(data1, cols(im,:), 1,0.2, 'ks');
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        
        htit = title(titles{im});
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
    %
    outname = [DIRFIG 'neighbors_seedphase_iInt' num2str(params.iInt) '_filt' params.ifilt '.eps'];
    print(outname,'-depsc');
    outname = [DIRFIG 'neighbors_seedphase_iInt' num2str(params.iInt) '_filt' params.ifilt '.png'];
    print(outname,'-dpng');
    close all
    
    %% non-neighbouring regions
    
    for iit = 1:size(iroi,2)
        
        for im = 1:5
            u1=[];
            u2=[];
            for ir = 1:size(iroi,1)
                cnb = find(nb(:,iroi(ir,iit))==0.5);
                cnb1 = setdiff(1:68,cnb);
                
                u3 = P{im}(iroi(ir,iit),cnb1,iit);
                u1 = [u1 mean(u3(:))];
                u3 = P{im}(cnb1,iroi(ir,iit),iit)';
                u2 = [u2 mean(u3(:))];
            end
            
            mm1(im,iit) = mean(u1(:));
            mm2(im,iit) = mean(u2(:));
        end
    end
    
    %%
    o=1;
    figure
    figone(6,12)
    
    for im = [1 2 5 3 4]
        
        data1 = squeeze(mm1(im,:));
        data1(end-1:end)=[];
        cl = [0.7 0.75 0.75];
        
        subplot(1,5,o)
        
        [h, u] = fp_raincloud_plot_c(data1, cols(im,:), 1,0.2, 'ks');
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        
        htit = title(titles{im});
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
    
    %
    outname = [DIRFIG 'non-neighbors_seedamp_iInt' num2str(params.iInt) '_filt' params.ifilt '.png'];
    print(outname,'-dpng');
    outname = [DIRFIG 'non-neighbors_seedamp_iInt' num2str(params.iInt) '_filt' params.ifilt '2.eps'];
    print(outname,'-depsc');
    close all
    
    %%
    o=1;
    figure
    figone(6,12)
    
    for im = [1 2 5 3 4]
        
        data1 = squeeze(mm2(im,:));
        
        cl = [0.7 0.75 0.75];
        
        subplot(1,5,o)
        
        [h, u] = fp_raincloud_plot_c(data1, cols(im,:), 1,0.2, 'ks');
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        
        htit = title(titles{im});
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
    
    %
    outname = [DIRFIG 'non-neighbors_seedphase_iInt' num2str(params.iInt) '_filt' params.ifilt '.png'];
    print(outname,'-dpng');
    outname = [DIRFIG 'non-neighbors_seedphase_iInt' num2str(params.iInt) '_filt' params.ifilt '.eps'];
    print(outname,'-depsc');
    close all
    
end