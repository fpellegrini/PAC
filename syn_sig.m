function [xh, xl, pac] = syn_sig(N,fs,low,high)

[bl al] = butter(5, low/fs*2);
[bh ah] = butter(5, high/fs*2);

xl = randn(N, 1);
xl = filtfilt(bl, al, xl);

xh = randn(N, 1);
xh = filtfilt(bh, ah, xh);

xlh = hilbert(xl);
xlphase = angle(xlh);

xhh = hilbert(xh);
xhphase = angle(xhh);

xh = real((1-cos(xlphase)).*exp(1i*xhphase));

xh = xh./norm(xh,'fro');
xl = xl./norm(xl,'fro');

pac = xh + xl;
pac = pac./norm(pac,'fro');

end 