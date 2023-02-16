function  [tort_val, canolty_val, ozkurt_val] = get_pac_values(split_sig_1, split_sig_2, fs, n_trials, low, high)        

% the function filtfilt receives as input and NXdim matrix , in this case
% Nxn_trials
[high_sig_1_f, low_sig_1_f] = preproc_filt_sim(split_sig_1, fs, low, high);
[high_sig_2_f, low_sig_2_f] = preproc_filt_sim(split_sig_2, fs, low, high);

%hilbert as well works by column(each trial)
amplt_type = abs(hilbert(high_sig_1_f));
phase_type  = angle(hilbert(low_sig_2_f));

for i=1:n_trials   
    mi_tort_vec(i)= MI_tort(phase_type(:,i),amplt_type(:,i),18);
    mi_canolty_vec(i)= MI_canolty(phase_type(:,i),amplt_type(:,i));
    mi_ozkurt_vec(i)= MI_ozkurt(phase_type(:,i),amplt_type(:,i));
end

tort_val_0 = mean(mi_tort_vec);
canolty_val_0 = mean(mi_canolty_vec);
ozkurt_val_0 = mean(mi_ozkurt_vec);

%% 
amplt_type = abs(hilbert(high_sig_2_f));
phase_type  = angle(hilbert(low_sig_1_f));

for i=1:n_trials   
    mi_tort_vec(i)= MI_tort(phase_type(:,i),amplt_type(:,i),18);
    mi_canolty_vec(i)= MI_canolty(phase_type(:,i),amplt_type(:,i));
    mi_ozkurt_vec(i)= MI_ozkurt(phase_type(:,i),amplt_type(:,i));
end

tort_val_1 = mean(mi_tort_vec);
canolty_val_1 = mean(mi_canolty_vec);
ozkurt_val_1 = mean(mi_ozkurt_vec);


%%
tort_val = max(tort_val_0, tort_val_1);
canolty_val = max(canolty_val_0,canolty_val_1);
ozkurt_val =  max(ozkurt_val_0,ozkurt_val_1);

end