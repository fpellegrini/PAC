function fp_plot_pac_ints

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim2/';
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim2_/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%
clear PR
ip = 2;
params = fp_get_params_pac(ip);

titles = {'2 interactions','3 interactions','4 interactions','5 interactions'};
mets = {'Tort','Ortho','Borig','Banti','Borignorm','Bantinorm','Shah'};

for iInt = 1:length(params.iInt)
    
    for iit= [1:45 47:57 59:100]
        
        if params.case == 1
            inname = sprintf('pr_univar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt(iInt),params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        elseif params.case == 2
            inname = sprintf('pr_bivar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt(iInt),params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        end
        
        load([DIRDATA inname '.mat'])
        
        PR{1}(iInt,iit) = pr_standard;
        PR{2}(iInt,iit) = pr_ortho;
        PR{3}(iInt,iit) = pr_bispec_o;
        PR{4}(iInt,iit) = pr_bispec_a;
        PR{5}(iInt,iit) = pr_bispec_o_norm;
        PR{6}(iInt,iit) = pr_bispec_a_norm;
        if ip == 1
            PR{7}(iInt,iit) = pr_shabazi;
        end
        
        
    end
end


%%

for icon = [1:4]
    figure
    figone(6,16)
    o=1;
    for iInt = 1:length(params.iInt)
        
        data1 = squeeze(PR{icon}(iInt,:));
        %     mean_pr(o) = mean(data1);
        
        cl = [0.7 0.75 0.75];
        
        subplot(1,length(params.iInt),o)
        
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
            xlabel('PR')
            set(gca,'Clipping','Off')
            xt = xticks;
            for ix = xt
                hu = line([ix ix],[2 -10]);
                set(hu, 'color',[0.9 0.9 0.9])
                uistack(hu,'bottom')
            end
            hu1 = line([0 0],[2 -10]);
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
    outname = [DIRFIG 'Ints_' mets{icon} '.png'];
    print(outname,'-dpng');
    
    close all
end