function  [tort_true_sha, canolty_true_sha, ozkurt_true_sha] = get_pac_values_sha(X_null_1, X_null_2, n_trials, trial_length)        

X_sha_amplt_type_1 = abs(X_null_1(1,:));
X_sha_phase_type_1  = angle(X_null_1(2,:));
X_sha_amplt_type_2 = abs(X_null_2(1,:));
X_sha_phase_type_2  = angle(X_null_2(2,:));

sha_split_sig_1_1 = reshape(X_sha_amplt_type_1, trial_length, n_trials);
sha_split_sig_2_1 = reshape(X_sha_phase_type_1, trial_length, n_trials);

sha_split_sig_1_2 = reshape(X_sha_amplt_type_2, trial_length, n_trials);
sha_split_sig_2_2 = reshape(X_sha_phase_type_2, trial_length, n_trials);

X_sha_amplt_type_1 = abs(sha_split_sig_1_1);
X_sha_phase_type_1  = angle(sha_split_sig_2_1);

X_sha_amplt_type_2 = abs(sha_split_sig_1_2);
X_sha_phase_type_2  = angle(sha_split_sig_2_2);

for i=1:n_trials   
    mi_tort_vec_1(i)= MI_tort(sha_split_sig_2_1(:,i),sha_split_sig_1_1(:,i),18);%phase,amp
    mi_canolty_vec_1(i)= MI_canolty(sha_split_sig_2_1(:,i),sha_split_sig_1_1(:,i));
    mi_ozkurt_vec_1(i)= MI_ozkurt(sha_split_sig_2_1(:,i),sha_split_sig_1_1(:,i));
    
    mi_tort_vec_2(i)= MI_tort(sha_split_sig_2_2(:,i),sha_split_sig_1_2(:,i),18);%phase,amp
    mi_canolty_vec_2(i)= MI_canolty(sha_split_sig_2_2(:,i),sha_split_sig_1_2(:,i));
    mi_ozkurt_vec_2(i)= MI_ozkurt(sha_split_sig_2_2(:,i),sha_split_sig_1_2(:,i));
end

tort_true_sha = max(mean(mi_tort_vec_1),mean(mi_tort_vec_2));
canolty_true_sha = max( mean(mi_canolty_vec_1), mean(mi_canolty_vec_2));
ozkurt_true_sha = max(mean(mi_ozkurt_vec_1),mean(mi_ozkurt_vec_2));

end