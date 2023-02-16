function [case_n_snr] = get_p_val(case_n_snr, isnr, iit, n_shuffles)

orig_mi = case_n_snr(isnr).true_mi(iit).stand;
orig_mi_ortho = case_n_snr(isnr).true_mi(iit).ortho;
orig_mi_sha = case_n_snr(isnr).true_mi(iit).sha;


stand_shuffle_total = case_n_snr(isnr).case_tests(iit).tests_stand;
sha_surr_total = case_n_snr(isnr).case_tests(iit).tests_sha;
ortho_method_total = case_n_snr(isnr).case_tests(iit).tests_ortho;

case_n_snr(isnr).case_p_dist.p_dist_stand.p_val_tort(iit)  = sum(stand_shuffle_total.shuffle_tort > orig_mi.tort_true)/n_shuffles;
case_n_snr(isnr).case_p_dist.p_dist_stand.p_val_canolty(iit) = sum(stand_shuffle_total.shuffle_canolty> orig_mi.canolty_true)/n_shuffles;
case_n_snr(isnr).case_p_dist.p_dist_stand.p_val_ozkurt(iit) = sum(stand_shuffle_total.shuffle_ozkurt > orig_mi.ozkurt_true)/n_shuffles;

case_n_snr(isnr).case_p_dist.p_dist_sha.p_val_tort(iit) = sum(sha_surr_total.shuffle_tort > orig_mi_sha.tort_true)/n_shuffles;
case_n_snr(isnr).case_p_dist.p_dist_sha.p_val_canolty(iit) = sum(sha_surr_total.shuffle_canolty> orig_mi_sha.canolty_true)/n_shuffles;
case_n_snr(isnr).case_p_dist.p_dist_sha.p_val_ozkurt(iit) = sum(sha_surr_total.shuffle_ozkurt > orig_mi_sha.ozkurt_true)/n_shuffles;

case_n_snr(isnr).case_p_dist.p_dist_ortho.p_val_tort(iit) = sum(ortho_method_total.shuffle_tort > orig_mi_ortho.tort_true)/n_shuffles;
case_n_snr(isnr).case_p_dist.p_dist_ortho.p_val_canolty(iit) = sum(ortho_method_total.shuffle_canolty> orig_mi_ortho.canolty_true)/n_shuffles;
case_n_snr(isnr).case_p_dist.p_dist_ortho.p_val_ozkurt(iit) = sum(ortho_method_total.shuffle_ozkurt > orig_mi_ortho.ozkurt_true)/n_shuffles;

