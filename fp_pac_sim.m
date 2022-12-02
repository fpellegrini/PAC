function fp_pac_sim(params)

% define folders for saving results
DIROUT = '/home/bbci/data/haufe/Franziska/data/pac_sim4/';
if ~exist(DIROUT);mkdir(DIROUT); end
DIROUT1 = '/home/bbci/data/haufe/Franziska/data/pac_save4/';
if ~exist(DIROUT1);mkdir(DIROUT1); end


if params.ip==9 % source localization is varied
    %reload data from ip1 to keep them constant and only vary the source
    %localization
    params_save = params;
    load(sprintf('%s/pac_sensorsig/%d.mat',DIROUT1,params.iit));
    params = params_save;
    clear params_save
else
    %% signal generation
    tic
    if params.ip == 3 %snr/ noise mix is varied
        %reload data from ip1 to keep them constant and only vary the snr
        %or noise mix
        params_save = params;
        load(sprintf('%s/pac_sig/%d.mat',DIROUT1,params.iit));
        params= params_save;
        clear params_save
    else
        
        % getting atlas, voxel and roi indices; active voxel of each region
        % is aleady selected here
        fprintf('Getting atlas positions... \n')
        D = fp_get_Desikan(params.iReg);
        
        %signal generation
        fprintf('Signal generation... \n')
        [sig,brain_noise,sensor_noise,L,iroi_phase, iroi_amplt,D, fres, n_trials,filt] = ...
            fp_pac_signal(params,D);
        
        if params.ip==1 %if ip1, save sig for ip3
            dir1 =  sprintf('%s/pac_sig/',DIROUT1);
            if ~exist(dir1); mkdir(dir1); end
            outname = sprintf('%s/pac_sig/%d.mat',DIROUT1,params.iit);
            save(outname,'-v7.3')
        end
        
    end
    
    %combine noise sources
    noise = params.iss*brain_noise + (1-params.iss)*sensor_noise;
    noise = noise ./ norm(noise(:),'fro');
    %combine signal and noise
    signal_sensor1 = params.isnr*sig + (1-params.isnr)*noise;
    signal_sensor1 = signal_sensor1 ./ norm(signal_sensor1(:), 'fro');
    
    %high-pass signal
    signal_sensor = (filtfilt(filt.bhigh, filt.ahigh, signal_sensor1'))';
    signal_sensor = signal_sensor / norm(signal_sensor, 'fro');
    
    %reshape
    signal_sensor = reshape(signal_sensor,[],size(signal_sensor,2)/n_trials,n_trials);
    [n_sensors, l_epoch, n_trials] = size(signal_sensor);
    
    t.signal = toc;
    
    if params.ip==1 %if ip1, save sig for ip9
        dir1 =  sprintf('%s/pac_sensorsig/',DIROUT1);
        if ~exist(dir1); mkdir(dir1); end
        outname = sprintf('%s/pac_sensorsig/%d.mat',DIROUT1,params.iit);
        save(outname,'-v7.3')
    end
end

%% Leadfield

%select only voxels that belong to any roi
L_backward = L(:, D.ind_cortex, :);

%% null distribution for shabazi method
if params.ip == 1 || params.ip==4 || params.ip == 5 || params.ip == 6 || params.ip == 9 || params.case == 1
    tic
    [W,~] = runica(signal_sensor(:,:));
    
    signal_unmixed = W*signal_sensor(:,:);
    signal_unmixed = reshape(signal_unmixed,n_sensors, l_epoch, n_trials);
    
    for ishuf = 1:params.nshuf
        %shuffling
        fprintf(['Shuffle '  num2str(ishuf) '\n'])
        signal_shuf = fp_shuffle_shab(W,signal_unmixed);
        
        %lcmv
        if strcmp(params.ifilt,'lf')
            A = fp_get_lcmv_filtered(signal_shuf,L_backward,filt);
        elseif strcmp(params.ifilt,'l')
            A = fp_get_lcmv(signal_shuf,L_backward);
        elseif strcmp(params.ifilt,'e')
            reg_param = fp_eloreta_crossval(signal_sensor,L_backward,5);
            A = squeeze(mkfilt_eloreta_v2(L_backward,reg_param));
            A = permute(A,[1, 3, 2]);
        else
            error('wrong filter parameter')
        end
        
        %dimesionality reduction
        signal_roi_shuf = fp_dimred(signal_shuf,D,A,params.t);
        
        %pac calculation
        pac_shuf(:,:,ishuf) = fp_pac_standard(signal_roi_shuf, filt.low, filt.high, fres);
        
        clear signal_shuf A signal_roi_shuf
    end
    t.shab = toc;
end

%%

%lcmv
if strcmp(params.ifilt,'lf')
    A = fp_get_lcmv_filtered(signal_sensor,L_backward,filt);
elseif strcmp(params.ifilt,'l')
    A = fp_get_lcmv(signal_sensor,L_backward);
elseif strcmp(params.ifilt,'e')
    reg_param = fp_eloreta_crossval(signal_sensor,L_backward,5);
    A = squeeze(mkfilt_eloreta_v2(L_backward,reg_param));
    A = permute(A,[1, 3, 2]);
else
    error('wrong filter parameter')
end

%Dimensionality reduction
signal_roi = fp_dimred(signal_sensor,D,A,params.t);

%%

if params.case == 1 %univariate case
    
    % bispectra
    fprintf(['Calculating bispectra \n'])
    nshuf = params.nshuf;
    tic
    [b_orig, b_anti] = fp_pac_bispec_uni(signal_roi,fres,filt,nshuf+1);
    t.bispec = toc;
    
    fprintf(['Calculating Tort and ortho \n'])
    tic
    for ishuf = 1:nshuf+1
        clear s_shuf
        for iroi = 1:D.nroi
            
            %shuffle trials
            if ishuf ==1 % first shuf is true value
                inds = 1:n_trials;
            else
                inds = randperm(n_trials);
            end
            s_shuf(iroi,:,:) = signal_roi(iroi,:,inds);
        end
        
        %shuffled Tort
        pac_standard(:,:,ishuf) = fp_pac_standard(s_shuf, filt.low, filt.high, fres);
        
        %shuffled ortho
        [signal_ortho, ~, ~, ~] = symmetric_orthogonalise(s_shuf(:,:)', 1);
        signal_ortho = reshape(signal_ortho',D.nroi,l_epoch,n_trials);
        pac_ortho(:,:,ishuf) = fp_pac_standard(signal_ortho, filt.low, filt.high, fres);
        
    end
    t.shufTort = toc;
    
    for proi = 1:D.nroi
        for aroi = 1:D.nroi
            p_orig(proi,aroi) = sum(squeeze(b_orig(proi,aroi,1))<squeeze(b_orig(proi,aroi,2:end)))/nshuf;
            p_anti(proi,aroi) = sum(squeeze(b_anti(proi,aroi,1))<squeeze(b_anti(proi,aroi,2:end)))/nshuf;
            p_standard(proi,aroi) = sum(squeeze(pac_standard(proi,aroi,1))<squeeze(pac_standard(proi,aroi,2:end)))/nshuf;
            p_ortho(proi,aroi) = sum(squeeze(pac_ortho(proi,aroi,1))<squeeze(pac_ortho(proi,aroi,2:end)))/nshuf;
            p_shahbazi(proi,aroi) = sum(squeeze(pac_standard(proi,aroi,1))<squeeze(pac_shuf(proi,aroi,:)))/nshuf;
            
        end
    end
    
    %save only evaluation parameters
    outname1 = sprintf('%spr_%s.mat',DIROUT,params.logname);
    save(outname1,...
        'p_standard','p_ortho','p_shahbazi','p_orig','p_anti','t','iroi_phase','iroi_amplt',...
        '-v7.3')
        
else
    
    %standard pac
    fprintf(['Calculating standard pac \n'])
    tic
    pac_standard = fp_pac_standard(signal_roi, filt.low, filt.high, fres);
    t.standard = toc;
    
    %ortho pac
    tic
    fprintf(['Calculating ortho pac \n'])
    [signal_ortho, ~, ~, ~] = symmetric_orthogonalise(signal_roi(:,:)', 1);
    signal_ortho = reshape(signal_ortho',D.nroi,l_epoch,n_trials);
    pac_ortho = fp_pac_standard(signal_ortho, filt.low, filt.high, fres);
    t.ortho = toc;
    
    %shabazi
    if params.ip == 1 || params.ip==4 || params.ip == 5 || params.ip == 6 || params.ip == 9
        pac_shahbazi = (pac_standard-mean(pac_shuf,3))/std(pac_shuf,[],3);
    end
    
    % bispectra
    fprintf(['Calculating bispectra \n'])
    tic
    [b_orig, b_anti, b_orig_norm,b_anti_norm] = fp_pac_bispec(signal_roi,fres,filt);
    t.bispec = toc;
    
    %% Evaluate
    
    if params.case==3
        %remove univariate interaction before calculating performance
        iroi_amplt_save = iroi_amplt;
        iroi_phase_save = iroi_phase;
        iroi_amplt(1:params.iInt(1))=[];
        iroi_phase(1:params.iInt(1))=[];
    end
    
    pr_shahbazi=[];
    if params.ip == 1 || params.ip==4 || params.ip == 5 || params.ip == 6 || params.ip == 9
        [pr_shahbazi] = fp_pr_pac(pac_shahbazi,iroi_amplt,iroi_phase);
    end
    [pr_standard] = fp_pr_pac(pac_standard,iroi_amplt,iroi_phase);
    [pr_ortho] = fp_pr_pac(pac_ortho,iroi_amplt,iroi_phase);
    [pr_bispec_o] = fp_pr_pac(b_orig,iroi_amplt,iroi_phase);
    [pr_bispec_a] = fp_pr_pac(b_anti,iroi_amplt,iroi_phase);
    [pr_bispec_o_norm] = fp_pr_pac(b_orig_norm,iroi_amplt,iroi_phase);
    [pr_bispec_a_norm] = fp_pr_pac(b_anti_norm,iroi_amplt,iroi_phase);
    
    %save only evaluation parameters
    outname1 = sprintf('%spr_%s.mat',DIROUT,params.logname);
    save(outname1,...
        'pr_standard','pr_ortho','pr_shahbazi','pr_bispec_o','pr_bispec_a',...
        'pr_bispec_o_norm','pr_bispec_a_norm','t',...
        '-v7.3')
    
end

%% Saving workspace

fprintf('Saving... \n')
%save all
outname = sprintf('%spac_%s.mat',DIROUT,params.logname);
save(outname,'-v7.3')

