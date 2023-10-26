function [pac, p] = fp_get_all_pac_baseline(X, fs, filt, n_shuffles)
% Estimates PAC scores and its null distributions with the following metrics:
% modulation index (MI),MI+orthogonalization, MI+ICshuffling, bispectrum,
% anti-symmetrized bispectrum
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

[nchan, ~, n_trials_s] = size(X);

%% Bispectra

% use efficient implementation for bispec shuffling
% ishuf == 1 is the true bispec
[b_orig,~] = fp_pac_bispec_uni(X,fs,filt, n_shuffles);

%takes maximum of phase-amplitude vs amplitude-phase coupling between
%channels 1 and 2
pac(:,4) =  max([squeeze(b_orig(1,2,:)),squeeze(b_orig(2,1,:))]');

%% Modulation Index

%shuffling for null distributions
for ishuf = 1:n_shuffles
    %     fprintf(['Shuffle '  num2str(ishuf) '\n'])
    
    %first shuffle contains true pac
    if ishuf == 1
        ind = 1:n_trials_s;
    else
        ind = randperm(n_trials_s)';
    end
    X_shuf = cat(1,X(1,:,:),X(2,:,ind));
    
    %% standard MI (code taken from fp_pac_standard and extended by tort and Özkurt metrics)
    
    [nroi, ~, ~] = size(X_shuf);
    
    % Get center frequencies: low and high can be a single number in Hz, or two
    % numbers indicating a band. In the latter case PAC is only calculated for
    % the center frequencies.
    low = mean(filt.low);
    high = mean(filt.high);
    
    for iroi = 1:nroi
        
        %low peak, left side lobe and high peak
        [high_signal1, low_signal1] = preproc_filt_sim(squeeze(X_shuf(iroi,:,:)), fs, low, high-low);
        %hilbert transform  to extract phase and amplitude
        amplt1(iroi,:,:) = abs(hilbert(high_signal1));
        phase1(iroi,:,:)  = angle(hilbert(low_signal1));
        
        %low peak, high peak and right side lobe
        [high_signal2, low_signal2] = preproc_filt_sim(squeeze(X_shuf(iroi,:,:)), fs, low, high);
        %hilbert transform to extract phase and amplitude
        amplt2(iroi,:,:) = abs(hilbert(high_signal2));
        phase2(iroi,:,:)  = angle(hilbert(low_signal2));
        
    end
    
    for aroi = 1:nroi %amplitude roi
        for proi = 1:nroi %phase roi
            
        [canolty1(aroi,proi), tort1(aroi,proi), ozkurt1(aroi,proi)] = fp_get_pac_values(squeeze(amplt1(aroi,:,:)), squeeze(phase1(proi,:,:)));
        [canolty2(aroi,proi), tort2(aroi,proi), ozkurt2(aroi,proi)] = fp_get_pac_values(squeeze(amplt2(aroi,:,:)), squeeze(phase2(proi,:,:)));
  
        end
    end
    
    canolty = mean(cat(3,canolty1,canolty2),3);
    tort = mean(cat(3,tort1,tort2),3);
    ozkurt = mean(cat(3,ozkurt1,ozkurt2),3);
    
    
    %%
    %takes maximum of phase-amplitude vs amplitude-phase coupling between channels 1 and 2
    pac(ishuf,1) = max([canolty(1,2),canolty(2,1)]);
    pac(ishuf,2) = max([tort(1,2),tort(2,1)]);
    pac(ishuf,3) = max([ozkurt(1,2),ozkurt(2,1)]);
    
    
end

%% Calculate p-values
p(1) = fp_get_p_pac(pac(:,1)');%canolty MI
p(2) = fp_get_p_pac(pac(:,2)');%tort
p(3) = fp_get_p_pac(pac(:,3)');%ozkurt
p(4) = fp_get_p_pac(pac(:,4)');%bispec_orig

