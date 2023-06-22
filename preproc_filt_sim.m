 function [xh, xl]= preproc_filt_sim(sim_sig,fs, low, high)
%Filters signal in low and high frequency bands. 

%shift high center frequency according to Zandvoort 2021
high = high + (low/2);

%filter bandwidth 
low_0= [-2 2];
high_0 = [-(low/2)-1 (low/2)+1]; %set bandwidth according to Zandvoort 2021


[bl al] = butter(5, (low +low_0)/fs*2); %low freq filter 
[bh ah] = butter(5, (high + high_0)/fs*2); %high freq filter 

xl = filtfilt(bl, al, sim_sig); %low freq signal 
xh = filtfilt(bh, ah, sim_sig);% high freq signal 

