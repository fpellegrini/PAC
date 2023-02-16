function [mean_tort_it, mean_canolty_it, mean_ozkurt_it ] = stand_test(n_trials, split_sig_1, split_sig_2,fs, low,high, decor)

ind = randperm(n_trials)';
split_sig_ind = split_sig_2(ind,:);

[high_sig_1_f, low_sig_1_f] = preproc_filt_sim(split_sig_1, fs, low, high);
[high_sig_shuf_f, low_sig_shuf_f] = preproc_filt_sim(split_sig_ind, fs, low, high);

if decor == 1
    phase_type  = angle(hilbert(low_sig_shuf_f));
    amplt_type = abs(hilbert(high_sig_1_f));
else
    phase_type  = angle(hilbert(low_sig_1_f));
    amplt_type = abs(hilbert(high_sig_shuf_f));
end

for i=1:n_trials
    mi_tort_vec(i)= MI_tort(phase_type(i,:),amplt_type(i,:),18);
    mi_canolty_vec(i)= MI_canolty(phase_type(i,:),amplt_type(i,:));
    mi_ozkurt_vec(i)= MI_ozkurt(phase_type(i,:),amplt_type(i,:));
end

mean_tort_it = mean(mi_tort_vec);
mean_canolty_it = mean(mi_canolty_vec);    
mean_ozkurt_it = mean(mi_ozkurt_vec);

end