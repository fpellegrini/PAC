function fp_plot_pac_ints

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim5/';
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim5/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%
clear PR
ip = 2;
params = fp_get_params_pac(ip);
a=[];

titles = {'1 interaction','3 interactions','5 interactions'};
mets = {'MI','Ortho','Borig','Banti','Borignorm','Bantinorm','Shah'};
cols = [[0 0 0.5];[0 0 0.5];...
    [0.8 0 0.2];[0.8 0 0.2]];

for iInt = [1 0 2]
    if iInt ==0
        ip = 1; %iInt = 3
        iInt1 = 1;
        iInt2 = 2;
    else
        ip = 2;
        iInt1 = iInt;
        if iInt == 2
            iInt2 = 3;
        else
            iInt2 = 1;
        end
    end
    params = fp_get_params_pac(ip);
    
    for iit= 1:100
        try
            if params.case == 1
                inname = sprintf('pr_univar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                    ,params.iInt(iInt1),params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
            elseif params.case == 2
                inname = sprintf('pr_bivar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                    ,params.iInt(iInt1),params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
            end
            
            load([DIRDATA inname '.mat'])
            
            PR{1}(iInt2,iit) = pr_standard;
            PR{2}(iInt2,iit) = pr_ortho;
            PR{3}(iInt2,iit) = pr_bispec_o;
            PR{4}(iInt2,iit) = pr_bispec_a;
            PR{5}(iInt2,iit) = pr_bispec_o_norm;
            PR{6}(iInt2,iit) = pr_bispec_a_norm;
            
        catch
            a=[a iit];
        end
    end
end
for ii = 1:6
    PR{ii}(:,unique(a))=[];
end
%%

for icon = [1:4]
    figure
    figone(6,10)
    o=1;
    for iInt = 1:3
        
        data1 = squeeze(PR{icon}(iInt,:));
        mean_pr(o) = mean(data1);
        
        %         cl = [0.7 0.75 0.75];
        
        subplot(1,3,o)
        
        [h, u] = fp_raincloud_plot_a(data1, cols(icon,:), 1,0.2, 'ks');
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
    
    outname = [DIRFIG 'Ints_' mets{icon} '.eps'];
    print(outname,'-depsc');
    
    %     close all
end