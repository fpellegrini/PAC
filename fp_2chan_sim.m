function fp_2chan_sim

fp_addpath_pac

DIRLOG ='/home/bbci/data/haufe/Franziska/log/2chan_sim5/';
if ~exist(DIRLOG); mkdir(DIRLOG); end

DIROUT = '/home/bbci/data/haufe/Franziska/data/2chan_sim5/';
if ~exist(DIROUT);mkdir(DIROUT); end

iit = str2num(getenv('SGE_TASK_ID'));

logname=num2str(iit);

if ~exist(sprintf('%s%s_work',DIRLOG,logname)) & ~exist(sprintf('%s%s_done',DIRLOG,logname))    
    eval(sprintf('!touch %s%s_work',DIRLOG,logname))
    tic
    
    %% Parameters
    
    N = 1000000;
%     N = 120000;
    
    nchan= 2;
    
    %Sampling frequency
    fs = 200;
    
%     n_trials_s = 60;
    n_trials_s = 500;
    
    n_shuffles = 1000;
    n_iter = 500;
    
    %BW
    low = [9 11];
    high = [58 62];
    filt.low = low;
    filt.high = high;
    
    %SNR
%     snr_v = [0 0.2 0.4 0.6 0.8 1]; %in sim 3 
    snr_v = [0 0.2 0.4 0.5 0.6 0.8 1];
    
    %% Signal generation
    
    [high_osc, low_osc, pac_0] = syn_sig(N,fs, low, high);
    [~,~, pac_1] = syn_sig(N,fs, low, high);
    
    channels_noise = randn(N,2);
    channels_noise = channels_noise./ norm(channels_noise(:),'fro');
    
    rand_sig = randn(N, 1);
    rand_sig = rand_sig./norm(rand_sig,'fro');
    
    mixing_matrix = eye(2);
    mixing_matrix(1,2)=2*(rand-.5);
    mixing_matrix(2,1)=2*(rand-.5);
    
    
    %% Loop through snrs 
    
    for isnr = 1:length(snr_v)
        
        
        %% Case 1: true bivariate interaction (formerly case 3)
        
        cse = 1;
        fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n'])        
        
        %generate signal
        X_1 = [high_osc low_osc];
        X_1 = X_1./norm(X_1(:),'fro');
        X_1 =  snr_v(isnr)*X_1 + (1-snr_v(isnr))*channels_noise;
        X_1 = reshape(X_1',nchan,[],n_trials_s);
        
        [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_1, fs, filt, n_shuffles);
        
        
%         %% Case 2: true bivariate pac + mixing (formerly case 4)
%         
%         cse=2;
%         fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n']) 
%         
%         %generate signal with mixing
%         X_2 = [high_osc low_osc];
%         X_2 = X_2*mixing_matrix;
%         X_2 = X_2./norm(X_2(:),'fro');
%         X_2 =  snr_v(isnr)*X_2 + (1-snr_v(isnr))*channels_noise;
%         X_2 = reshape(X_2',nchan,[],n_trials_s);
%         
%         [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_2, fs, filt, n_shuffles);
%         
%         
%         %% Case 3: univariate pac + random signal (formerly case 5)
%         
%         cse = 3;
%         fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n']) 
%         
%         %generate signal
%         X_3 = [pac_0 rand_sig];
%         X_3 = X_3./norm(X_3(:),'fro');
%         X_3 =  snr_v(isnr)*X_3 + (1-snr_v(isnr))*channels_noise;
%         X_3 = reshape(X_3',nchan,[],n_trials_s);
%         
%         [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_3, fs, filt, n_shuffles);
%         
%         
        %% Case 4: univariate pac + random signal + mixing (formerly case 6)
        
        cse = 4;
        fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n']) 
        
        %generate signal with mixing
        X_4 = [pac_0 rand_sig];
        X_4 = X_4*mixing_matrix;
        X_4 = X_4./norm(X_4(:),'fro');
        X_4 =  snr_v(isnr)*X_4 + (1-snr_v(isnr))*channels_noise;
        X_4 = reshape(X_4',nchan,[],n_trials_s);
        
        [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_4, fs, filt, n_shuffles);
        
        
%         %% Case 5: two univariate pac signals  (formerly case 7)
%         
%         cse = 5;
%         fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n']) 
%         
%         %generate signal
%         X_5 = [pac_0 pac_1];
%         X_5 = X_5./norm(X_5(:),'fro');
%         X_5 =  snr_v(isnr)*X_5 + (1-snr_v(isnr))*channels_noise;
%         X_5 = reshape(X_5',nchan,[],n_trials_s);
%         
%         [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_5, fs, filt, n_shuffles);
%         
%         
%         %% Case 6: two univariate pac signals + mixing (formerly case 8)
%         
%         cse = 6;
%         fprintf(['SNR '  num2str(isnr) ', case ' num2str(cse) '\n']) 
%         
%         %generate signal with mixing
%         X_6 = [pac_0 pac_1];
%         X_6 = X_6*mixing_matrix;
%         X_6 = X_6./norm(X_6(:),'fro');
%         X_6 = snr_v(isnr)*X_6 + (1-snr_v(isnr))*channels_noise;
%         X_6 = reshape(X_6',nchan,[],n_trials_s);
%         
%         [pac{cse,isnr}, p{cse,isnr}] = fp_get_all_pac(X_6, fs, filt, n_shuffles);
        
    end
    
    
    %% Save
    
    t = toc;
    save([DIROUT logname '.mat'],'-v7.3')
    save([DIROUT 'pvals_' logname '.mat'],'p','-v7.3')
    eval(sprintf('!mv %s%s_work %s%s_done',DIRLOG,logname,DIRLOG,logname))
end