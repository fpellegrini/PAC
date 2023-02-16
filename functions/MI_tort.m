function [MI, mean_amp_bin] = MI_tort(phase, amp, nbins)

%Phase bins
phase_bins = linspace(-pi, pi, nbins+1);


%Mean amplitude per bin
for i=1:nbins
	mean_amp_bin(i) = mean( amp( find( phase >= phase_bins(i) & phase< phase_bins(i+1) )));
end
%%%%% Check NANs  if there are no amp in this bin phases


%Normalize mean amplitudes
sum_bins= sum(mean_amp_bin);

%P(j)
P_j = mean_amp_bin/sum_bins;

%Distance KL
D_kl = log(nbins) - (-sum(P_j.*log(P_j)));

%MI
MI = D_kl/log(nbins);


