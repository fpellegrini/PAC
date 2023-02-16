
load('/datasabzi/taliana/perm_test/case_5.mat');

num_case = 3;
iit = 10; %number form 1 to n_shuffles

plot_standard(case_3_snr, iit, snr_v, n_shuffles, num_case)

plot_sha_surr(case_3_snr, iit, snr_v, n_shuffles, num_case)

plot_ortho(case_3_snr, iit, snr_v, n_shuffles, num_case)
%%
h = @(x,y) plot_standard(x, it_shuff, snr_v, n_shuffles, y);

h(case_5_snr,5)

%%
plot_sig_time_freq(high_osc,low_osc,pac_0, high_osc_noise,low_osc_noise ,pac_0_noise , snr_v(isnr))

plot_sig_time_freq(high_sig_1_f(1,:),low_sig_1_f(1,:),high_sig_2_f(1,:), low_sig_2_f(1,:),split_sig_1(1,:) ,split_sig_2(1,:) , 0.9)

%%
case_num = case_3_snr;
plot_per_case_snr(case_num, iit, snr_v, n_shuffles,3)

%%
plot_per_case_snr(case_7_snr, it_shuff, snr_v, n_shuffles,7)

plot_per_case_snr(case_4_snr, it_shuff, snr_v, n_shuffles,4)
