function [b_orig, b_anti] = fp_pac_bispec(data,fs,filt)

nroi = size(data,1);
segleng = 2*fs;
segshift = 2*fs;
epleng = segleng;

fres=fs;
frqs = sfreqs(fres, fs);
freqinds_low = [find(frqs==mean(filt.low)) find(frqs==(mean(filt.high)-mean(filt.low)))];
freqinds_up = [find(frqs==mean(filt.low)) find(frqs==mean(filt.high))];

for proi = 1:nroi
    for aroi = proi:nroi
        
        X = data([proi aroi],:,:); 
        [bs_up,~] = data2bs_event(X(:,:)', segleng, segshift, epleng, freqinds_up);
        biv_orig_up = ([abs(bs_up(1, 2, 2)) abs(bs_up(2, 1, 1))]);
        xx = bs_up - permute(bs_up, [2 1 3]); %Bkmm - Bmkm
        biv_anti_up = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        [bs_low,~] = data2bs_event(X(:,:)', segleng, segshift, epleng, freqinds_low);
        biv_orig_low = ([abs(bs_low(1, 2, 2)) abs(bs_low(2, 1, 1))]);
        xx = bs_low - permute(bs_low, [2 1 3]);
        biv_anti_low =([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        b_orig(aroi,proi) = mean([biv_orig_up(1) biv_orig_low(1)]); %mean across the two possible bispec combinations 
        b_orig(proi,aroi) = mean([biv_orig_up(2) biv_orig_low(2)]);
        b_anti(aroi,proi) = mean([biv_anti_up(1) biv_anti_low(1)]);  
        b_anti(proi,aroi) = mean([biv_anti_up(2) biv_anti_low(2)]);  
    end
end