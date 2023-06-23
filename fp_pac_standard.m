function  pac = fp_pac_standard(signal, low, high, fs )
% Calculates mean vector length modulation index.
% Signal should contain one time series per region. 
% "low" and "high" correspond to phase and amplitude frequencies in Hz 
% fs is sampling frequency in Hz 
% Note that the filter settings here correspond to the recommendations made
% in Zandvoort 2021. I.e., PAC is estimated once between the low peak and
% the high peak and the left side lobe, and once between the low peak and
% the high peak and the right side lobe. Both estimates are averaged in the end. 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

[nroi, ~, ~] = size(signal); 

% Get center frequencies: low and high can be a single number in Hz, or two
% numbers indicating a band. In the latter case PAC is only calculated for
% the center frequencies. 
low = mean(low);
high = mean(high);

for iroi = 1:nroi
    
    %low peak, left side lobe and high peak
    [high_signal1, low_signal1] = preproc_filt_sim(squeeze(signal(iroi,:,:)), fs, low, high-low);     
    %hilbert transform  to extract phase and amplitude 
    amplt1(iroi,:,:) = abs(hilbert(high_signal1));
    phase1(iroi,:,:)  = angle(hilbert(low_signal1));
    
    %low peak, high peak and right side lobe 
    [high_signal2, low_signal2] = preproc_filt_sim(squeeze(signal(iroi,:,:)), fs, low, high); 
    %hilbert transform to extract phase and amplitude 
    amplt2(iroi,:,:) = abs(hilbert(high_signal2));
    phase2(iroi,:,:)  = angle(hilbert(low_signal2));
    
end 

for aroi = 1:nroi %amplitude roi    
    for proi = 1:nroi %phase roi 
        
        [pac1(aroi,proi),~,~] = fp_get_pac_values(squeeze(amplt1(aroi,:,:)), squeeze(phase1(proi,:,:)));
        [pac2(aroi,proi),~,~] = fp_get_pac_values(squeeze(amplt2(aroi,:,:)), squeeze(phase2(proi,:,:)));
    end
end

pac = mean(cat(3,pac1,pac2),3);
