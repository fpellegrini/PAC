function [mean_tort_it, mean_canolty_it, mean_ozkurt_it ] = ortho_test(n_trials, split_sig_1, split_sig_2,fs, low,high, decor)

ind = randperm(n_trials)';
split_sig_ind = split_sig_2(ind,:);

for i=1:n_trials

    X_ortho = [ split_sig_1(i,:); split_sig_ind(i,:) ]';
    [L, ~, ~, W] = symmetric_orthogonalise(X_ortho, 1);
    sig_1_ortho = L(:,1);
    sig_2_ortho = L(:,2);

    [high_sig_1_f, low_sig_1_f] = preproc_filt_sim(sig_1_ortho, fs, low, high);
    [high_sig_2_f, low_sig_2_f] = preproc_filt_sim(sig_2_ortho, fs, low, high);

    if decor == 1
        phase_type  = angle(hilbert(low_sig_2_f));
        amplt_type = abs(hilbert(high_sig_1_f));
    else
        phase_type  = angle(hilbert(low_sig_1_f));
        amplt_type = abs(hilbert(high_sig_2_f));
    end

    mi_tort_vec(i)= MI_tort(phase_type,amplt_type,18);
    mi_canolty_vec(i)= MI_canolty(phase_type,amplt_type);
    mi_ozkurt_vec(i)= MI_ozkurt(phase_type,amplt_type);

end    

mean_tort_it = mean(mi_tort_vec);
mean_canolty_it = mean(mi_canolty_vec);    
mean_ozkurt_it = mean(mi_ozkurt_vec);

end