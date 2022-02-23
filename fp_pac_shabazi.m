function pac = fp_pac_shabazi(unmixed_low, unmixed_high,Amix)

%back to original space
mixed_high = Amix*unmixed_high;
mixed_low = Amix*unmixed_low;

%get amplitude and phase
amplt = abs(mixed_high);
phase = angle(mixed_low);

%PAC calculation for all roi combinations
for aroi = 1:D.nroi %amplitude roi
    for proi = 1:D.nroi %phase roi
        [pac(aroi,proi),~,~] = fp_get_pac_values(squeeze(amplt(aroi,:,:)), squeeze(phase(proi,:,:)));
    end
end