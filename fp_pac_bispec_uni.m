function [b_orig, b_anti] = fp_pac_bispec_uni(data,fs,filt, nshuf)

nroi = size(data,1);
segleng = 2*fs;
segshift = 2*fs;
epleng = segleng;

fres=fs;
frqs = sfreqs(fres, fs);
freqinds = [find(frqs==mean(filt.low)) find(frqs==mean(filt.high))];

for proi = 1:nroi
    for aroi = proi:nroi
        
        X = data([proi aroi],:,:); 
        [bs,~] = fp_data2bs_event_uni(X(:,:)', segleng, segshift, epleng, freqinds,nshuf);
        xx = bs - permute(bs, [2 1 3 4 5]); %Bkmm - Bmkm
        
        %upper freqs
        biv_orig_up = squeeze(([abs(bs(1, 2, 2, 2,:)) abs(bs(2, 1, 1, 2,:))]));
        biv_anti_up = squeeze(([abs(xx(1, 2, 2, 2,:)) abs(xx(2, 1, 1, 2,:))]));
        
        %lower freqs
        biv_orig_low = squeeze(([abs(bs(1, 2, 2, 1,:)) abs(bs(2, 1, 1, 1,:))]));
        biv_anti_low = squeeze(([abs(xx(1, 2, 2, 1,:)) abs(xx(2, 1, 1, 1,:))]));
          
        b_orig(aroi,proi,:) = mean([biv_orig_up(1,:)' biv_orig_low(1,:)'],2); %mean across the two possible bispec combinations 
        b_orig(proi,aroi,:) = mean([biv_orig_up(2,:)' biv_orig_low(2,:)'],2);
        b_anti(aroi,proi,:) = mean([biv_anti_up(1,:)' biv_anti_low(1,:)'],2);  
        b_anti(proi,aroi,:) = mean([biv_anti_up(2,:)' biv_anti_low(2,:)'],2);  
    end
end