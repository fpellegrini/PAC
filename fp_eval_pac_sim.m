function fp_eval_pac_sim(ip)

fp_addpath_pac

DIRLOG ='/home/bbci/data/haufe/Franziska/log/pac_sim2/';
if ~exist(DIRLOG); mkdir(DIRLOG); end

rng('shuffle')

%%
%prevent array jobs to start at exactly the same time
iit = str2num(getenv('SGE_TASK_ID'))

params1 = fp_get_params_pac(ip);
params = params1;

for iInt = params1.iInt
    params.iInt = iInt;
    for isnr = params1.isnr
        params.isnr = isnr;
        
        %create logfile for parallelization
        if params.case == 1
            logname = sprintf('univar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        elseif params.case == 2
            logname = sprintf('bivar_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        elseif params.case == 3
            logname = sprintf('mixed_iInt%d_iReg%d_snr0%d_iss0%d_filt%s_pip%d_iter%d'...
                ,params.iInt,params.iReg,params.isnr*10,params.iss*10,params.ifilt,params.t,iit);
        end
        
        if ~exist(sprintf('%s%s_work',DIRLOG,logname)) & ~exist(sprintf('%s%s_done',DIRLOG,logname))
            
            eval(sprintf('!touch %s%s_work',DIRLOG,logname))
            fprintf('Working on %s. \n',logname)
            
            params.iit = iit;
            params.ip = ip;
            params.logname = logname;
            
            fp_pac_sim(params)
            
            eval(sprintf('!mv %s%s_work %s%s_done',DIRLOG,logname,DIRLOG,logname))
            
        end  %work_done
    end
end



