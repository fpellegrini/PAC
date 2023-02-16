function [mi_tort_it, mi_canolty_it, mi_ozkurt_it ] = sha_surr(n_shuffles, ishuff, decor, A, S_unmixed, fs, low, high)

S_decor = shift_timeseries(S_unmixed, ishuff, n_shuffles);

X_null = A*S_decor;

sig_1 = X_null(1,:);
sig_2 = X_null(2,:);

[high_sig_1_f, low_sig_1_f] = preproc_filt_sim(sig_1, fs, low, high);

[high_sig_2_f, low_sig_2_f] = preproc_filt_sim(sig_2, fs, low, high);

if decor == 1
    phase_type  = angle(hilbert(low_sig_2_f));
    amplt_type = abs(hilbert(high_sig_1_f));
else
    phase_type  = angle(hilbert(low_sig_1_f));
    amplt_type = abs(hilbert(high_sig_2_f));
end


mi_tort_it = MI_tort(phase_type, amplt_type, 18);
mi_canolty_it = MI_canolty(phase_type, amplt_type);
mi_ozkurt_it = MI_ozkurt(phase_type, amplt_type);    


end