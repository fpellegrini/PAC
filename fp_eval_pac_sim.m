function fp_eval_pac_sim(ip,seed,iit)
% Calls fpp_pac_sim in structured way 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

rng('default')
rng(seed)

%define parameters for the current experiment 
params1 = fp_get_params_pac(ip);
params = params1;

for isnr = params1.isnr %signal-to-noise ratio
    params.isnr = isnr;
    
    for iInt = params1.iInt %number of interactions 
        if params.case<3
            params.iInt = iInt;
        else
            params.iInt = params1.iInt;
        end
        
        %create logfile for parallelization
        if params.case == 1
            logname = sprintf('univar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        elseif params.case == 2
            logname = sprintf('bivar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        elseif params.case == 3
            logname = sprintf('mixed_iInt%d%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt(1),params.iInt(2),params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        end
        
        fprintf('Working on %s. \n',logname)
        
        params.iit = iit;
        params.ip = ip;
        params.logname = logname;
        
        fp_pac_sim(params)
        
    end
end



