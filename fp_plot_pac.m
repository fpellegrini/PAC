function fp_plot_pac

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim2/';
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim2_/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%

for ip =[8]
    
    clear PR
    params = fp_get_params_pac(ip);
    
    titles1 = {'Standard','Ortho','Bispec Original','Bispec Anti','Bispec O. Norm','Bispec A. Norm','Shabazi'};
    titles2 = {'Standard','Ortho','Bispec Original','Bispec Anti','Shabazi'};
    
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
            
            PR{1}(iit) = pr_standard;
            PR{2}(iit) = pr_ortho;
            PR{3}(iit) = pr_bispec_o;
            PR{4}(iit) = pr_bispec_a;
            if ip == 1
                PR{5}(iit) = pr_bispec_o_norm;
                PR{6}(iit) = pr_bispec_a_norm;
            end
            if ip == 1
                PR{7}(iit) = pr_shahbazi;
            elseif ip==4 || ip == 5 || ip == 6 || ip == 9 || ip == 10
                PR{5}(iit) = pr_shahbazi;
            end
        catch
            a=[a iit];
        end
        
    end
    
    % for ii = 1:4
    %     PR{ii}(a)=[];
    % end
    
    %%
    figure
    figone(8,30)
    o=1;
    for icon = 1:length(PR)
        
        data1 = PR{icon};
        mean_pr(o) = mean(data1);
        imlab = 'PR';
        imlab1 = 'PR';
        
        cl = [0.8 0.7 0.6];
        
        subplot(1,length(PR),o)
        
        [h, u] = fp_raincloud_plot_a(data1, cl, 1,0.2, 'ks');
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        
        if ip==1
            htit = title(titles1{o});
        else
            htit = title(titles2{o});
        end
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
    
    %
    outname = [DIRFIG inname(1:end-8) '.png'];
    print(outname,'-dpng');
    
    close all
end





