function fp_plot_pac_bivar_default

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim4/';
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim4/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%

for ip =[1]
    
    clear PR
    params = fp_get_params_pac(ip);
    
    titles = {'MI','Ortho','Bispec Original','Bispec Anti','ICshuf'};
    
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
            PR{5}(iit) = pr_shahbazi;
        catch
            a=[a iit];
        end
        
    end
    
    % for ii = 1:4
    %     PR{ii}(a)=[];
    % end
    
    %%
    figure
    figone(6,20)
    o=1;
    for icon = [1 2 5 3 4]
        
        data1 = PR{icon};
        mean_pr(o) = mean(data1);
        imlab = 'PR';
        imlab1 = 'PR';
        
        cl = [0.7 0.75 0.75];
        
        subplot(1,length(PR),o)
        
        [h, u] = fp_raincloud_plot_a(data1, cl, 1,0.2, 'ks');
        view([-90 -90]);
        set(gca, 'Xdir', 'reverse');
        set(gca, 'XLim', [0 1]);
        
        htit = title(titles{icon});

        htit.Position(1) = -0.12;
        set(gca,'ytick',[])
        ylim([-0.75 2])
        box off
        
        if o==1
            xlabel('PR')
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
    outname = [DIRFIG inname(1:end-8) '.png'];
    print(outname,'-dpng');
%     
    outname = [DIRFIG inname(1:end-8) '.eps'];
    print(outname,'-depsc');
    
%     close all
end





