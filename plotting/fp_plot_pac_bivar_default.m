function fp_plot_pac_bivar_default
% Function that plots results of bivariate whole-brain simulation with
% default parameters

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim5/';
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim5/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%% set some parameters 

%default parameter setting
ip = 1;
params = fp_get_params_pac(ip);


%colors for plotting 
cols = [[0 0 0.5];[0 0 0.5];...
    [0.8 0 0.2];[0.8 0 0.2];[0 0 0.5]];

titles = {'MI','Ortho','Bispec','ASB','ICshuf'};

%% load data 
a=[];
for iit= 1:100
    
    try
        inname = sprintf('pr_bivar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
            ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        
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

%in case some iteration is missing, remove that iteration from all
%conditions 
for ii = 1:5
    PR{ii}(a)=[];
end

%% Plotting 

figure
figone(6,20)
o=1;
for icon = [1 2 5 3 4] %loop over metrics 
    
    data1 = PR{icon};
    mean_pr(o) = mean(data1);
    
    subplot(1,length(PR),o)
    
    %raincloud plot with logarithmic y axis 
    [h, ~] = fp_raincloud_plot_a(data1, cols(icon,:), 1,0.2, 'ks');
    
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


outname = [DIRFIG inname(1:end-8) '.png'];
print(outname,'-dpng');

outname = [DIRFIG inname(1:end-8) '.eps'];
print(outname,'-depsc');






