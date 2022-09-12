
addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
addpath('/Users/franziskapellegrini/Dropbox/Franziska/MEG_Project/matlab/libs/emd_for_icoh/roi_connectivity_emd/');

DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim2/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim2_/univar/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%

ip =10;

clear PR
params = fp_get_params_pac(ip);

titles = {'MI','Ortho','Bispec Original','Bispec Anti','Shabazi'};

a=[];

for iit= [1:100]
    
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
        iroi(iit)=iroi_phase; 
        
        for ii = 1:5
            p(iit,ii) = sum(P{ii}(:))/((68*68)-68);
        end
        
    catch
        a=[a iit];
    end
    
    
end


%% get neighboring structure

load('~/Dropbox/Franziska/Data_MEG_Project/processed_bs_wzb_90_2000/bs_results.mat')
iatl = 3; % DK atlas
neighbor_thresh = 10; % 10mm vicinity defines neighborhood between regions
[~, ~, nb, ~] = get_ROI_dist_full(cortex, iatl, neighbor_thresh);

%%
for iit = 1:100
    
    cnb = find(nb(:,iroi(iit))==0.5);
    
    for im = 1:5
        
        u1 = P{im}(iroi(iit),cnb,iit);
        u2 = P{im}(cnb,iroi(iit),iit);
        m1(im,iit) = mean(u1(:));
        m2(im,iit) = mean(u2(:));
    end
end

%%
o=1;
figure
figone(6,20)

for im = [1:5]

    data1 = squeeze(m1(im,:));
    
    cl = [0.7 0.75 0.75];
    
    subplot(1,5,o)
    
    [h, u] = fp_raincloud_plot_a(data1, cl, 1,0.2, 'ks');
    view([-90 -90]);
    set(gca, 'Xdir', 'reverse');
    set(gca, 'XLim', [0 1]);
    
    htit = title(titles{o});
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
%%
outname = [DIRFIG 'neighbors_seedamp.png'];
print(outname,'-dpng');
close all

%% non-neighbouring regions

for iit = 1:100
    
    cnb = find(nb(:,iroi(iit))==0.5);
    cnb1 = setdiff(1:68,cnb);
    
    for im = 1:5
        
        u1 = P{im}(iroi(iit),cnb1,iit);
        u2 = P{im}(cnb1,iroi(iit),iit);
        mm1(im,iit) = mean(u1(:));
        mm2(im,iit) = mean(u2(:));
    end
end

%%
o=1;
figure
figone(6,20)

for im = [1:5]

    data1 = squeeze(mm1(im,:));
    
    cl = [0.7 0.75 0.75];
    
    subplot(1,5,o)
    
    [h, u] = fp_raincloud_plot_a(data1, cl, 1,0.2, 'ks');
    view([-90 -90]);
    set(gca, 'Xdir', 'reverse');
    set(gca, 'XLim', [0 1]);
    
    htit = title(titles{o});
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
outname = [DIRFIG 'non-neighbors_seedamp.png'];
print(outname,'-dpng');
close all