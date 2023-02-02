function  pac = fp_pac_standard(signal, low, high, fs )
[nroi, ~, ~] = size(signal); 

%get center frequencies 
low = mean(low);
high = mean(high);

for iroi = 1:nroi
    
    %low peak, left side lobe and high peak
    [high_signal1, low_signal1] = preproc_filt_sim(squeeze(signal(iroi,:,:)), fs, low, high-low); 
    %hilbert transform 
    amplt1(iroi,:,:) = abs(hilbert(high_signal1));
    phase1(iroi,:,:)  = angle(hilbert(low_signal1));
    
    %low peak, high peak and right side lobe 
    [high_signal2, low_signal2] = preproc_filt_sim(squeeze(signal(iroi,:,:)), fs, low, high); 
    %hilbert transform 
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
