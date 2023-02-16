 function [xh, xl]= preproc_filt_sim(sim_sig,fs, low, high)

%shift high center frequency according to Zandvoort 2021
% high = high + (low/2);

%filter bandwidth 
low_0= [-2 2];
high_0 = [-(low/2)-1 (low/2)+1]; %set bandwidth according to Zandvoort 2021


[bl al] = butter(5, (low +low_0)/fs*2); 
[bh ah] = butter(5, (high + high_0)/fs*2);

xl = filtfilt(bl, al, sim_sig);
xh = filtfilt(bh, ah, sim_sig);

