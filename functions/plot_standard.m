function plot_standard(case_n_snr, iit, snr_v, n_shuffles, num_case)

n = length(snr_v);
figure;
sgt = sgtitle([ ' Case ' num2str(num_case)  ' Standard Surrogates' ]);
sgt.FontSize = 10;

for k = 1 : n

    subplot(3,n,k);
    histogram(case_n_snr(k).case_tests.tests_stand(iit).shuffle_tort, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).stand.tort_true, case_n_snr(k).true_mi(iit).stand.tort_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' SNR: ' num2str(snr_v(k)) ' Method: Tort ']);
    ti.FontSize = 8;
    lgd = legend([' Standard shuffle Dist' ], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).stand.tort_true)]);
    lgd.FontSize = 6;

    
    subplot(3,n,k+n);
    histogram(case_n_snr(k).case_tests.tests_stand(iit).shuffle_canolty, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).stand.canolty_true, case_n_snr(k).true_mi(iit).stand.canolty_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' SNR: ' num2str(snr_v(k)) ' Method: Canolty ']);
    ti.FontSize = 8;
    lgd = legend([' Standard shuffle Dist' ], ...
    ['True MI:'  num2str(case_n_snr(k).true_mi(iit).stand.canolty_true)]);
    lgd.FontSize = 6;

    
    subplot(3,n,k+2*n);
    histogram(case_n_snr(k).case_tests.tests_stand(iit).shuffle_ozkurt, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).stand.ozkurt_true, case_n_snr(k).true_mi(iit).stand.ozkurt_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' SNR: ' num2str(snr_v(k))  ' Method: Ozkurt ']);
    ti.FontSize = 8;
    lgd = legend([' Standard shuffle  Dist' ], ...
       ['True MI:'  num2str(case_n_snr(k).true_mi(iit).stand.ozkurt_true)], 'Fontsize', 6);

end