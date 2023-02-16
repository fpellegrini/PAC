function [orig_mi, split_sig_1, split_sig_2 ] = original_mi(sig_1, sig_2, fs, n_trials, decor, low, high, type)
   
trial_length = (length(sig_1)/n_trials);


    switch type

        case 'stand'           
                        
            split_sig_1 = reshape(sig_1, trial_length, n_trials)';
            split_sig_2 = reshape(sig_2, trial_length, n_trials)';
            
            [high_sig_1_f, low_sig_1_f] = preproc_filt_sim(split_sig_1, fs, low, high);
            [high_sig_2_f, low_sig_2_f] = preproc_filt_sim(split_sig_2, fs, low, high);

            if decor == 1
                phase_type  = angle(hilbert(low_sig_2_f));
                amplt_type = abs(hilbert(high_sig_1_f));
            else
                phase_type  = angle(hilbert(low_sig_1_f));
                amplt_type = abs(hilbert(high_sig_2_f));
            end

            %true
            for i=1:n_trials
                mi_tort_vec(i)= MI_tort(phase_type(i,:),amplt_type(i,:),18);
                mi_canolty_vec(i)= MI_canolty(phase_type(i,:),amplt_type(i,:));
                mi_ozkurt_vec(i)= MI_ozkurt(phase_type(i,:),amplt_type(i,:));
            end

            orig_mi.tort_true = mean(mi_tort_vec);
            orig_mi.canolty_true = mean(mi_canolty_vec);
            orig_mi.ozkurt_true = mean(mi_ozkurt_vec);

        case 'ortho'

                
            X_ortho = [ sig_1, sig_2 ];
            [L, ~, ~, W] = symmetric_orthogonalise(X_ortho, 1);
            sig_1_ortho = L(:,1);
            sig_2_ortho = L(:,2);

            split_sig_1 = reshape(sig_1_ortho, trial_length, n_trials)';
            split_sig_2 = reshape(sig_2_ortho, trial_length, n_trials)';

            [high_sig_1_f, low_sig_1_f] = preproc_filt_sim(split_sig_1, fs, low, high);
            [high_sig_2_f, low_sig_2_f] = preproc_filt_sim(split_sig_2, fs, low, high);

            if decor == 1
                phase_type  = angle(hilbert(low_sig_2_f));
                amplt_type = abs(hilbert(high_sig_1_f));
            else
                phase_type  = angle(hilbert(low_sig_1_f));
                amplt_type = abs(hilbert(high_sig_2_f));
            end

            for i=1:n_trials

            mi_tort_vec(i)= MI_tort(phase_type(i,:),amplt_type(i,:),18);
            mi_canolty_vec(i)= MI_canolty(phase_type(i,:),amplt_type(i,:));
            mi_ozkurt_vec(i)= MI_ozkurt(phase_type(i,:),amplt_type(i,:));

            end    

            orig_mi.tort_true = mean(mi_tort_vec);
            orig_mi.canolty_true = mean(mi_canolty_vec);
            orig_mi.ozkurt_true = mean(mi_ozkurt_vec);
    end
    
end