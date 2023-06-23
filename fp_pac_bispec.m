function [b_orig, b_anti, b_orig_norm,b_anti_norm] = fp_pac_bispec(data,fs,filt)
% Estimates PAC using bispectra. 
% b_orig: uncorrected bispectrum 
% b_anti: anti-symmetrized bispectrum 
% b_orig_norm: uncorrected bicoherence
% b_anti_norm: anti-symmetrized bicoherence
% data is nchan x timepoints x ntrials 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

nroi = size(data,1); %number of regions
segleng = 2*fs; %2 sec
segshift = 2*fs; %2 sec
epleng = segleng; %2 sec

fres=fs;
frqs = sfreqs(fres, fs);
freqinds_low = [find(frqs==mean(filt.low)) find(frqs==(mean(filt.high)-mean(filt.low)))];
freqinds_up = [find(frqs==mean(filt.low)) find(frqs==mean(filt.high))];

for proi = 1:nroi
    for aroi = proi:nroi
        
        X = data([proi aroi],:,:); 
        
        %upper freqs (low, left side lobe, high)
        [bs_up,~] = data2bs_event(X(:,:)', segleng, segshift, epleng, freqinds_up);
        biv_orig_up = ([abs(bs_up(1, 2, 2)) abs(bs_up(2, 1, 1))]);
        xx = bs_up - permute(bs_up, [2 1 3]); % Anti-symmetrization: Bkmm - Bmkm
        biv_anti_up = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        %normalized by threenorm
        [RTP_up,~]=data2bs_threenorm(X(:,:)',segleng,segshift,epleng,freqinds_up);
        bicoh_up=bs_up./RTP_up;
        biv_orig_up_norm = ([abs(bicoh_up(1, 2, 2)) abs(bicoh_up(2, 1, 1))]);
        xx=bicoh_up-permute(bicoh_up, [2 1 3]);
        biv_anti_up_norm = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        %lower freqs (low, high, right side lobe)
        [bs_low,~] = data2bs_event(X(:,:)', segleng, segshift, epleng, freqinds_low);
        biv_orig_low = ([abs(bs_low(1, 2, 2)) abs(bs_low(2, 1, 1))]);
        xx = bs_low - permute(bs_low, [2 1 3]);
        biv_anti_low =([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        %normalized by threenorm
        [RTP_low,~]=data2bs_threenorm(X(:,:)',segleng,segshift,epleng,freqinds_low);
        bicoh_low=bs_low./RTP_low;
        biv_orig_low_norm = ([abs(bicoh_low(1, 2, 2)) abs(bicoh_low(2, 1, 1))]);
        xx=bicoh_low-permute(bicoh_low, [2 1 3]);
        biv_anti_low_norm = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        %mean across the two possible bispec combinations
        %shape: amplitude ROI x phase ROI 
        b_orig(aroi,proi) = mean([biv_orig_up(1) biv_orig_low(1)]); %mean across the two possible bispec combinations 
        b_orig(proi,aroi) = mean([biv_orig_up(2) biv_orig_low(2)]);
        b_anti(aroi,proi) = mean([biv_anti_up(1) biv_anti_low(1)]);  
        b_anti(proi,aroi) = mean([biv_anti_up(2) biv_anti_low(2)]);  
        
        %normalized versions
        b_orig_norm(aroi,proi) = mean([biv_orig_up_norm(1) biv_orig_low_norm(1)]);
        b_orig_norm(proi,aroi) = mean([biv_orig_up_norm(2) biv_orig_low_norm(2)]);
        b_anti_norm(aroi,proi) = mean([biv_anti_up_norm(1) biv_anti_low_norm(1)]);  
        b_anti_norm(proi,aroi) = mean([biv_anti_up_norm(2) biv_anti_low_norm(2)]);
    end
end