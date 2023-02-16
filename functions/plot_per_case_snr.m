function plot_per_case_snr(case_n_snr, iit, snr_v, n_shuffles, num_case)


for k=1:length(snr_v)
           
    figure;
    
    sgt = sgtitle([ ' Case ' num2str(num_case)  ' SNR:' num2str(snr_v(k)) ]);
    sgt.FontSize = 10;

    
    subplot(3,3,1);
    histogram(case_n_snr(k).case_tests(iit).tests_stand.shuffle_tort, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).stand.tort_true, case_n_snr(k).true_mi(iit).stand.tort_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' Method: Tort ']);
    ti.FontSize = 8;
    lgd = legend([' Standard shuffle Dist' ], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).stand.tort_true)]);
    lgd.FontSize = 6;
    
    subplot(3,3,2);
    histogram(case_n_snr(k).case_tests(iit).tests_sha.shuffle_tort, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).sha.tort_true, case_n_snr(k).true_mi(iit).sha.tort_true], ylim, 'LineWidth', 1, 'Color', 'r');
 
   %xlim([0 5e-3])
    ti = title([  ' Method: Tort ']);
    ti.FontSize = 8;
    lgd = legend([' Surrogate Dist'], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).sha.tort_true)]);
    lgd.FontSize = 6;
    
    subplot(3,3,3);
    histogram(case_n_snr(k).case_tests(iit).tests_ortho.shuffle_tort, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).ortho.tort_true, case_n_snr(k).true_mi(iit).ortho.tort_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' Method: Tort ']);
    ti.FontSize = 8;
    lgd = legend([' Ortho Shuffle Dist'], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).ortho.tort_true)]);
    lgd.FontSize = 6;
  %%  
      
    subplot(3,3,4);
    histogram(case_n_snr(k).case_tests(iit).tests_stand.shuffle_canolty, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).stand.canolty_true, case_n_snr(k).true_mi(iit).stand.canolty_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' Method: Canolty ']);
    ti.FontSize = 8;
    lgd = legend([' Standard shuffle Dist' ], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).stand.canolty_true)]);
    lgd.FontSize = 6;
    
    subplot(3,3,5);
    histogram(case_n_snr(k).case_tests(iit).tests_sha.shuffle_canolty, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).sha.canolty_true, case_n_snr(k).true_mi(iit).sha.canolty_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([  ' Method: Canolty ']);
    ti.FontSize = 8;
    lgd = legend([' Surrogate Dist'], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).sha.canolty_true)]);
    lgd.FontSize = 6;
    
    subplot(3,3,6);
    histogram(case_n_snr(k).case_tests(iit).tests_ortho.shuffle_canolty, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).ortho.canolty_true, case_n_snr(k).true_mi(iit).ortho.canolty_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' Method: Canolty ']);
    ti.FontSize = 8;
    lgd = legend([' Ortho Shuffle Dist'], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).ortho.canolty_true)]);
    lgd.FontSize = 6;
    
  %%
        
    subplot(3,3,7);
    histogram(case_n_snr(k).case_tests(iit).tests_stand.shuffle_ozkurt, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).stand.ozkurt_true, case_n_snr(k).true_mi(iit).stand.ozkurt_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' Method: Ozkurt ']);
    ti.FontSize = 8;
    lgd = legend([' Standard shuffle Dist' ], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).stand.ozkurt_true)]);
    lgd.FontSize = 6;
    
    subplot(3,3,8);
    histogram(case_n_snr(k).case_tests(iit).tests_sha.shuffle_ozkurt, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).sha.ozkurt_true, case_n_snr(k).true_mi(iit).sha.ozkurt_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' Method: Ozkurt ']);
    ti.FontSize = 8;
    lgd = legend([' Surrogate Dist'], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).sha.ozkurt_true)]);
    lgd.FontSize = 6;
    
    subplot(3,3,9);
    histogram(case_n_snr(k).case_tests(iit).tests_ortho.shuffle_ozkurt, n_shuffles) ; hold on;
    line([case_n_snr(k).true_mi(iit).ortho.ozkurt_true, case_n_snr(k).true_mi(iit).ortho.ozkurt_true], ylim, 'LineWidth', 1, 'Color', 'r');
    %xlim([0 5e-3])
    ti = title([ ' Method: Ozkurt ']);
    ti.FontSize = 8;
    lgd = legend([' Ortho Shuffle Dist'], ...
        ['True MI:'  num2str(case_n_snr(k).true_mi(iit).ortho.ozkurt_true)]);
    lgd.FontSize = 6;
    
  
end