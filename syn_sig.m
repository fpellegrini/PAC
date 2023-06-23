function [xh, xl, pac] = syn_sig(N,fs,low,high)
% Generates slow (xl) and fast (xh) oscillations with PAC. 
% N -> total number of samples 
% fs -> sampling rate 
% low -> low freq band 
% high -> high freq band
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

%% Generate slow and fast oscillations 

[bl al] = butter(5, low/fs*2);
[bh ah] = butter(5, high/fs*2);

xl = randn(N, 1);
xl = filtfilt(bl, al, xl);

xh = randn(N, 1);
xh = filtfilt(bh, ah, xh);

%% Extract phase of slow and fast oscillations 
xlh = hilbert(xl);
xlphase = angle(xlh);

xhh = hilbert(xh);
xhphase = angle(xhh);

%% Amplitude of fast oscillation is modulated by phase of slow oscillation 
xh = real((1-cos(xlphase)).*exp(1i*xhphase));

%% normalize 
xh = xh./norm(xh,'fro');
xl = xl./norm(xl,'fro');

%% Univariate PAC signal 

pac = xh + xl;
pac = pac./norm(pac,'fro');
