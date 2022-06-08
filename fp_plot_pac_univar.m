function fp_plot_pac_univar

addpath(genpath('~/Dropbox/Franziska/PAC_AAC_estimation/data/'))
DIRDATA = '~/Dropbox/Franziska/PAC_AAC_estimation/data/sim2/';
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/sim2_/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%

ip =10;

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
        P{1}(:,:,iit) = p_standard<0.05;
        P{2}(:,:,iit) = p_ortho<0.05;
        P{3}(:,:,iit) = p_orig<0.05;
        P{4}(:,:,iit) = p_anti<0.05;
        P{5}(:,:,iit) = p_shahbazi<0.05;
        iroi(iit)=iroi_phase; 
       
    catch
        a=[a iit];
    end
    
end


for ii = 1:5    
    p(ii) = sum(P{ii}(:))/(68*68); 
end


%%
outname = [DIRFIG inname(1:end-8) '.png'];
print(outname,'-dpng');

close all






