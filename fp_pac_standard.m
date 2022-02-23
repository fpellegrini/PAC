function  pac = fp_pac_standard(signal, low, high, fs )

[nroi, ~, ~] = size(signal); 

for iroi = 1:nroi
    
    %get filtered signal in high and low band 
    [high_signal, low_signal] = preproc_filt_sim(squeeze(signal(iroi,:,:)), fs, low, high);
    
    %hilbert transform 
    amplt(iroi,:,:) = abs(hilbert(high_signal));
    phase(iroi,:,:)  = angle(hilbert(low_signal));
    
end 

for aroi = 1:nroi %amplitude roi    
    for proi = 1:nroi %phase roi 
        
        [pac(aroi,proi),~,~] = fp_get_pac_values(squeeze(amplt(aroi,:,:)), squeeze(phase(proi,:,:)));
        
    end
end
