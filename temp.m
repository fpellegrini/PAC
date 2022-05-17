segleng = 2*fs;
segshift = 2*fs;
epleng = segleng;
frqs = sfreqs(200, fs);
frqs = frqs(1:end-1);
freqpairs_low = [21 101];
freqpairs_up = [21 121];

for iroi = 1:4
    for jroi = 1:4
        
        X = signal_roi([iroi,jroi],:)';
        [cs_up,nave] = data2bs_event(X, segleng, segshift, epleng, freqpairs_up);
        biv_orig_up = ([abs(cs_up(1, 2, 2)) abs(cs_up(2, 1, 1))]);
        xx = cs_up - permute(cs_up, [2 1 3]);
        biv_anti_up = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        [cs_low,nave] = data2bs_event(X, segleng, segshift, epleng, freqpairs_low);
        biv_orig_low = ([abs(cs_low(1, 2, 2)) abs(cs_low(2, 1, 1))]);
        xx = cs_low - permute(cs_low, [2 1 3]);
        biv_anti_low = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
        
        b_orig(jroi,iroi) = mean([biv_orig_up(1) biv_orig_low(1)]); %mean across the two possible bispec combinations
        b_orig(iroi,jroi) = mean([biv_orig_up(2) biv_orig_low(2)]);
        
        b_anti(jroi,iroi) = mean([biv_anti_up(1) biv_anti_low(1)]);
        b_anti(iroi,jroi) = mean([biv_anti_up(2) biv_anti_low(2)]);
        
        % null distribution bispectra
        split_sig_bi = reshape(X(:,2), size(X,1)/n_trials, n_trials);
        
        for ishuff = 1:n_shuffles
            
            ind = randperm(n_trials)';
            
            split_s = split_sig_bi(:,ind);
            
            X_shuff = [ X(:,1), split_s(:) ];
            
            [cs_up,nave] = data2bs_event(X_shuff, segleng, segshift, epleng, freqpairs_up);
            biv_orig_ups = ([abs(cs_up(1, 2, 2)) abs(cs_up(2, 1, 1))]);
            xx = cs_up - permute(cs_up, [2 1 3]);
            biv_anti_ups = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
            
            [cs_low,nave] = data2bs_event(X_shuff, segleng, segshift, epleng, freqpairs_low);
            biv_orig_lows = ([abs(cs_low(1, 2, 2)) abs(cs_low(2, 1, 1))]);
            xx = cs_low - permute(cs_low, [2 1 3]);
            biv_anti_lows = ([abs(xx(1, 2, 2)) abs(xx(2, 1, 1))]);
            
            b_orig_s(jroi,iroi,ishuff) = mean([biv_orig_ups(1) biv_orig_lows(1)]); %mean across the two possible bispec combinations
            b_orig_s(iroi,jroi,ishuff) = mean([biv_orig_ups(2) biv_orig_lows(2)]);
            
            b_anti_s(jroi,iroi,ishuff) = mean([biv_anti_ups(1) biv_anti_lows(1)]);
            b_anti_s(iroi,jroi,ishuff) = mean([biv_anti_ups(2) biv_anti_lows(2)]);
            
        end
        
        
        %p_values bispectra
        p_bi(iroi,jroi) = sum(b_orig_s(iroi,jroi,:)>b_orig(iroi,jroi))/n_shuffles;
        p_bi(jroi,iroi) = sum(b_orig_s(jroi,iroi,:)>b_orig(jroi,iroi))/n_shuffles;
        p_anti(iroi,jroi) = sum(b_anti_s(iroi,jroi,:)>b_anti(iroi,jroi))/n_shuffles;
        p_anti(jroi,iroi) = sum(b_anti_s(jroi,iroi,:)>b_anti(jroi,iroi))/n_shuffles;
        
    end
end
