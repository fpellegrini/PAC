function plot_spec_sen(case_n_snr, snr_v, n_iter, num_case)

for i =1 :length(snr_v)
    sensitivity_canolty_3(i) = sum( a > case_3_shab_final.noise(i).canolty  )/n_iter_test;
    sensitivity_ozkurt_3(i) = sum( a > case_3_shab_final.noise(i).ozkurt  )/n_iter_test;
    sensitivity_tort_3(i) = sum( a > case_3_shab_final.noise(i).tort  )/n_iter_test;
end
    
end