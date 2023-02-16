function p = fp_control_harmonics_icoh(sig, fs, ifreq_in, nshuf)

ifreq = ifreq_in * (size(sig,2)/fs); %freq index 

for ishuf = 1:nshuf 
    clearvars -except ishuf nshuf sig icoh fs ifreq 
    
    if ishuf ==1
        id_trials_1 = (1:size(sig,3))';
        id_trials_2 = (1:size(sig,3))';
    else
        id_trials_1 = (1:size(sig,3))';
        id_trials_2 = randperm(size(sig,3))';
    end

    CSs = fp_tsdata_to_cpsd(sig,fs,'WELCH',[1 2], [1 2], id_trials_1, id_trials_2);
    pows = real(diag(CSs(:,:,ifreq)));
    icoh1 = abs(imag(CSs(:,:,ifreq)./ sqrt(pows*pows')));
    icoh(ishuf) = icoh1(1,2);
end

%%

p = sum(icoh(2:end)>icoh(1))/(nshuf);

