function fp_plot_pac

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim1/';
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim1/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%

clearvars -except iname name DIRDATA DIRFIG labs o im icon ipip titles xt mean_pr

its = [1:100];
case1 = 1;
iInt = 2;
isnr = 0.3;
iReg = 1;
iss = 0.5;
ifilt = 'l';
titles = {'Standard','Ortho','Bispec Original','Bispec Anti'};
a=[];

for iit= [1:100]
    
    try
        if case1 == 1
            inname = sprintf('pr_univar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_iter%d'...
                ,iInt,iReg,isnr*10,iss*10,ifilt, iit);
        else
            inname = sprintf('pr_bivar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_iter%d'...
                ,iInt,iReg,isnr*10,iss*10,ifilt, iit);
        end
        
        load([DIRDATA inname '.mat'])
        
        PR{1}(iit) = pr_standard;
        PR{2}(iit) = pr_ortho;
        PR{3}(iit) = pr_bispec_o;
        PR{4}(iit) = pr_bispec_a;
        
        RT{1}(iit) = ratio_standard;
        RT{2}(iit) = ratio_ortho;
        RT{3}(iit) = ratio_bispec_o;
    catch
        a=[a iit];
    end
    
end

for ii = 1:4 
    PR{ii}(a)=[];
end

%%
figure
figone(8,18)
o=1;
for icon = 1:4
    
    data1 = PR{icon};
    mean_pr(o) = mean(data1);
    imlab = 'PR';
    imlab1 = 'PR';
    
    cl = [0.8 0.7 0.6];
    
    subplot(1,4,o)
    
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
if case1 == 1
    outname = [DIRFIG 'univariate_iInt' num2str(iInt) '_snr0' num2str(isnr*10) '.png'];
else
    outname = [DIRFIG 'bivariate_iInt' num2str(iInt) '_snr0' num2str(isnr*10) '.png'];
end
print(outname,'-dpng');

close all


%%

figure
% figone(8,18)
o=1;
for icon = 1:3
    
    data1 = RT{icon};
    data1(33)=[];
    mean_rt(o) = mean(data1);
    
    cl = [0.8 0.7 0.6];
    
    subplot(1,3,o)
    
    hist(data1)
    xlim([0.6 1.4])
    xlabel('Diag/Off-diag')
    htit = title(titles{o});
    
    o=o+1;
end






