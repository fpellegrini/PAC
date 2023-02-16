function plot_p_dist_sha(case_n_snr, snr_v, n_iter, num_case)

for k = 1 :length(snr_v)

    figure; subplot(3,1,1);
    histogram(case_n_snr(k).case_p_dist.p_dist_sha.p_val_tort, n_iter) ; hold on;
    title([ ' Method: Tort '])
    
    subplot(3,1,2);
    histogram(case_n_snr(k).case_p_dist.p_dist_sha.p_val_canolty, n_iter) ; hold on;
    title([ ' Method: Canolty '])
    
    subplot(3,1,3);
    histogram(case_n_snr(k).case_p_dist.p_dist_sha.p_val_ozkurt, n_iter) ; hold on;
    title([ ' Method: Ozkurt '])

    suptitle([ ' Case ' num2str(num_case) ' SNR: ' num2str(snr_v(k)) ' p-value distribution tdsep surrogates'])


end

end