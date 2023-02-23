function fp_2chan_sim_baseline

fp_addpath_pac

DIROUT = '/home/bbci/data/haufe/Franziska/data/2chan_sim_univar_baseline/shifted_filt1/';
if ~exist(DIROUT);mkdir(DIROUT); end


DIRLOG ='/home/bbci/data/haufe/Franziska/log/2chan_sim_univar_baseline/shifted_filt1/';
if ~exist(DIRLOG); mkdir(DIRLOG); end

stack_id = str2num(getenv('SGE_TASK_ID'))
rng(stack_id)

iit_ids = (stack_id*6)-5 :(stack_id*6);


for iit = iit_ids
    
    clearvars -except iit iit_ids DIROUT DIRLOG stack_id
    
    logname=num2str(iit);
    
    if ~exist(sprintf('%s%s_work',DIRLOG,logname)) & ~exist(sprintf('%s%s_done',DIRLOG,logname))
        eval(sprintf('!touch %s%s_work',DIRLOG,logname))
        
        %% Parameters
        
        N = 120000;
        
        nchan= 2;
        
        %Sampling frequency
        fs = 200;
        
        n_trials_s = 60;
        
        %BW
        low = [9 11];
        high = [58 62];
        filt.low = low;
        filt.high = high;
        
        %SNR
        snr_v = [0 0.1 0.2 0.3 0.4];
        n_shuffles = 100;
        cse = 1;
        
        %% Signal generation
        
        [~, ~, pac_0] = syn_sig(N,fs, low, high);
        
        channels_noise = randn(N,2);
        channels_noise = channels_noise./ norm(channels_noise(:),'fro');
        
        for isnr = 1:length(snr_v)
            
            X_3 = [pac_0 pac_0];
            X_3 = X_3./norm(X_3(:),'fro');
            X_3 =  snr_v(isnr)*X_3 + (1-snr_v(isnr))*channels_noise;
            X_3 = reshape(X_3',nchan,[],n_trials_s);
            
            [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_3, fs, filt, n_shuffles);
        end
        
        %% Save
        save([DIROUT logname '.mat'],'-v7.3')
        save([DIROUT 'pvals_' logname '.mat'],'p','-v7.3')
        eval(sprintf('!mv %s%s_work %s%s_done',DIRLOG,logname,DIRLOG,logname))
    end
end